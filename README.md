# A Virtual Machine for Ruby on Rails Development



## Introduction

__We want to make it easy for you to create Ruby on Rails web apps.__

One hurdle we have seen for Rails newcomers is installing and configuring Ruby on Rails on their computers. So we forked/copied the Rails Core Virtual Machine (VM). This project automates the setup of a development environment for Ruby on Rails development. This is the easiest way to build a Virtual Machine (VM) with everything ready to start hacking Ruby on Rails, all in an isolated virtual machine.



## Requirements

You'll need to have these packages installed on your machine.

* [Git](http://git-scm.com/) - [downloads page](http://git-scm.com/downloads)

* [VirtualBox](https://www.virtualbox.org) - [downloads page](https://www.virtualbox.org/wiki/Downloads)

* [Vagrant](http://vagrantup.com) - [downloads page](http://downloads.vagrantup.com/)



## How To Build The Virtual Machine

Building the virtual machine is this easy:

    host $ git clone git://github.com/railsmn/railsmn-dev-box.git
    host $ cd railsmn-dev-box
    host $ vagrant up

That's it.

If the base box is not present that command fetches it first. The setup itself takes about 3 minutes in my MacBook Air. After the installation has finished, you can access the virtual machine with

    host $ vagrant ssh
    Welcome to Ubuntu 12.04 LTS (GNU/Linux 3.2.0-23-generic-pae i686)
    ...
    vagrant@rails-dev-box:~$

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer.



## What's In The Box

* Git

* RVM

* Ruby 1.9.3 (binary RVM install)

* Bundler

* SQLite3, MySQL, and Postgres

* System dependencies for nokogiri, sqlite3, mysql, mysql2, and pg

* Databases and users needed to run the Active Record test suite

* Node.js for the asset pipeline

* Memcached



## Recommended Workflow

The recommended workflow is

* edit on the host computer

* test within the virtual machine

Just clone your Rails fork in the very directory of the Rails development box on the host computer:

    host $ ls
    README.md   Vagrantfile puppet
    host $ git clone git@github.com:<your username>/rails.git

Vagrant mounts that very directory as _/vagrant_ within the virtual machine:

    vagrant@rails-dev-box:~$ ls /vagrant
    puppet  rails  README.md  Vagrantfile

so we are ready to go to edit in the host, and test in the virtual machine.

This workflow is convenient because in the host computer you normally have your editor of choice fine-tuned, Git configured, and SSH keys in place.



## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://vagrantup.com/v1/docs/index.html) for more information on Vagrant.



## Credits 

This is a renamed fork of [rails-dev-box](https://github.com/rails/rails-dev-box). Big Thanks to [Xavier Noria](https://github.com/fxn) and other contributors for their efforts. You guys rock. Thanks!
