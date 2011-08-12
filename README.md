ABOUT CHEF JIT (JUST-IN-TIME) INSTALLER
=======================================

* Uses rvm, see http://rvm.beginrescueend.com

* Compiles Ruby 1.9.2-p180 on the fly
  - Installs chef-client and gems in a self-contained directory (/opt/chef)

* Follows the most recent stable version of chef-client by default
  - You should be able to override the default install by providing a version like so:
    ./chef-jit-installer.run -- 0.10.4

* Deprecating pre-compiled FAT installer in favor of a compile just-in-time installation
  - It only takes 3 to 5 minutes for the installer to run on my laptop.  So its
    really not a bad tradeoff, for not having to compile and bundle dynamic linked Ruby
    for different platforms.
  - If someone can build statically linked Ruby in RVM, and show me how they did this,
    then I may re-visit the FAT installer.  I could not get a static Ruby built, however.

USAGE NOTES
-----------

1. Checkout branch.

  * git clone git://github.com/atomic-penguin/chef-fat-installer.git
  * git checkout chef-jit-installer

2. Run build script, which should output a makeself .run file

  * ./build-installer

The makeself directory contains the makeself files necessary to build the .run file

The buildroot directory contains the files and installer script.  Everything
in this directory, buildroot, gets rolled up into the FAT installer.

INSTALLATION
------------

1. Simply execute the chef-jit-installer.run.

```code
wget -O /tmp/chef-jit http://opensource.marshall.edu/chef/chef-jit-installer-0.10.0.noarch.run && bash /tmp/chef-jit
```

WARNINGS
========

PERTINENT TO RVM
----------------

Chances are this deployment could be destructive to an existing rvm environment.
It shouldn't overwrite the default location of /usr/local/rvm, instead it installs
in /opt/chef.  However, the installer could override your default rvm installation.

I kept the installation in an alternate location to avoid conflict with default rvm
directory.  Files, and directories of interest.  If you have an existing rvm
installation, this distribution is not recommended for that machine.

 * /opt/chef - Installation path
 * /etc/rvm.sh - Profile script
 * /etc/rvmrc - exports rvm path for Chef

INIT.D SCRIPTS
--------------

The init scripts shipped with the Chef fat installer need to
source /etc/profile.d/rvm.sh to have the proper PATH environment variables to work
with Chef.  If your chef::client_service recipe overwrites the init scripts, then
consider adding the following code snippet to your init cookbook_file.

if [ -x /etc/profile.d/rvm.sh ]; then
  . /etc/profile.d/rvm.sh
fi

BUGS / FIXES
============

Pull requests welcome via github.

WEBSITE
=======

See https://github.com/atomic-penguin/chef-fat-installer/tree/chef-jit-installer
