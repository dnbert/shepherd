#!/usr/bin/perl

use Getopt::Long;
use Git::Repository;
use Net::OpenSSH;
use File::Path qw(remove_tree);
use File::Rsync;
use Parallel::ForkManager;

my ($url, $user, $repository, $release, $package, $result, $target);
GetOptions( 'user=s' => \$user, 'url=s' => \$url, 'repo=s' => \$repository, 'release=s' => \$release, 'package=s' => \$package, 'result=s' => \$result, 'target=s' => \$target);

my @targets = split(/,/, $target);

#Checkout shit
print "Checking out the repo, this really does take just a minute.\n";

my $tmp = "/$result/$repository/";

#Clean
remove_tree($tmp);

Git::Repository->run(clone => "ssh://$user\@$url/$repository.git", $tmp);
my $r = Git::Repository->new(work_tree => "/$result/$repository");
my $commitid = $r->run('rev-parse' => 'origin/latest-release');
chomp $commitid;

print "Finished checking out the repo, we're gonna package our content up now.\n";

#Create Package
system("/usr/sbin/fpm -x .git* -s dir -t $package -n $repository -v $commitid -a all /$result/$repository");

#Push Package To Targets
my $rsync = File::Rsync->new({archive => 1, compress => 1, rsh => '/usr/bin/ssh', 'rsync-path' => '/usr/bin/rsync'});
my $pm = new Parallel::ForkManager(30);


print "Rsyncing to target machines now\n";

foreach my $mac (@targets) {
	$pm->start and next;
	$rsync->exec({ src => "$repository\_$commitid\_all.$package", dest => "root\@$mac:/root/"});
	$ssh = Net::OpenSSH->new("root\@$mac");
	$ssh->system("dpkg --force-all -i --instdir=/ $repository\_$commitid\_all.deb");
	$pm->finish;
}
$pm->wait_all_children;

print "Rsync and install is finished, use your test skills to make sure everything is working\n";
