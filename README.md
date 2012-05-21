Shepherd
========

Shepherd is a deployment utility designed to work with Jordan Sissil's FPM project. Shephred uses FPM to build packages from a newly cloned repository via git.


How To
=======

Shepherd uses command line switches to specify a plethora of values for deployment. Example:

perl shepherd.pl --user=brett --url=git.github.com --repo=my_project --package=deb --target=localhost --result=/

* --user 		: The user that will be used to clone the remote repository
* --url			: The remote repository's url
* --repo		: The remote repository name
* --package		: The end result package type (rpm, deb, zfs, etc) - Review FPM for the full list
* --target		: The host(s) that will be deployed to. Hosts are seperated by commas (host123,host125,host127,etc)
* --result		: A bit of a red herring, this is the resulting location that you want your packge deployed to. In the previous example, this would be the root fs.


Why Shepherd
=======

As a Systems Administrator I found the need to deploy code for agile development in a strategic format. Using packages to deploy code made sense to me, as it allows my development team to fail forward or backwards without much hassle on either end. Rewinding your push can be as simple as force installing a different package with a new commit and to the same effect, the same applies to new releases. Since the packages are versioned by commit id, its easy to go back and identify which release broke your environment.


Whats Next?
=======

I still have a lot of work to do on this. Here are a few things I want in the future:

* Specify users to ssh through
* Checkout specific commit's
* Incorporate more than just Debian packages (this will be done shortly)
* Refactor completely (possibly in Ruby)


Contact!
=======

If you have any comments, questions or concerns please contact me. This is designed to be used in part with Jenkins/Hudson to schedule new clones, if you happen to use this in another way, please drop me a line as I'd like to add more support for use cases. Pull requests are encouraged. 
