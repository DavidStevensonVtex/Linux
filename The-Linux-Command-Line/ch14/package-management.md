# The Linux Command Line, 2nd Edition, © 2019

## Chapter 14: Package Management

Package management is a method of installing and maintaining software on the system. Today, most people can satisfy all of their software needs by installing _packages_ from their Linux distributor.

### Packaging Systems

Most distributions fall into one of two camps of packaging technologies: the Debian _\.deb_ camp and the Red Hat _\.rpm_ camp.

Important exceptoins: Gentoo, Slackware, and Arch.

#### Major Packaging System Families

Packaging System, Distributions (partial listing)

* Debian-style (.deb) Debian, Unbuntu, Linux Mint, Raspbian
* Red Hat-style (.rpm) Fedora, CentOS, Red Hat Enterprise Linux, OpenSUSE

### How a Package System Works

Most software will by provided by the distrubution vendor in the form of _package files_, and the rest will be available in source code form that can be installed manually.

#### Package Files

The basic unit of software in a packaging system is the _package file_. A package file is a compressed collection of files that comprise the software package.

Package files are created by a person known as a _package maintainer_.
The package maintainer gets the software in source code form from the _upstream provider_ (the author of the program), compiles it, and creates the package metadata and any necessary installation scripts.

#### Repositories 

Most packages today are created by the distribution vendors and interested third parties.

Packages are made available to the users of a distribution in central repositories that may contain many thousands of packages, each specially built and maintained for the distribution.

A distribution may maintain several different repositories for different stages of the software development life cycle.

#### Dependencies

Programs are seldom "stand alone": rather they rely on the presence of other software components to get their work done. These routines are stoerd in _shared libraries_, which provide essential services to more than one program. If a package requires a shared resource such as a shared library, it is said to have a _dependency_. Modern package managment systems all provide some method of _dependency resolution_ to ensure that when a package is installed, all its dependencies are installed, too.

#### High- and Low-Level Package Tools

* Low-level tools that handle tasks such as installing and removing package files.
* High-level tools that perform metadata searching and dependency resolution.

Packaging System tools

Distributions, Low-level tools, High-level tools

* Debian-style, dpkg apt-get, apt, aptitude
* Fedora, Red Hat Enterprise Linux, CentOS, rpm yum, dnf

### Common Package Management Tasks

The term _package\_name_ refers to the actual name of a package rather than the term _package\_file_, which is the name of the file that contains the package.

#### Finding a Package in a Repository

Using high-level tools to search repository metadata, a package can be located based on its name or description.

* Debian apt-get update, apt-cache search search_string
* Red Hat yum search search_string

Example 

`yum search emacs`

#### Installing a Package from a Repository

High-level tools permit a package to be downloaded from a repository and installed with full dependency resolution.

Package Installation Commands

Style, Command(s)
* Debian apt-get update, apt-get install _package\_name_
* Red Hat um install _package\_name_

Example

`apt-get update; apt-get install emacs`

### Installing a Package from a Package File

Low-Level Package Installation Commands

* Debian: `dpkg -i package_file`
* Red Hat: `rpm -i package_file`

Example

`rpm -i emacs-22.1.7.fc7-i386.rpm`

#### Removing a Package

Packages can be uninstalled using either the high-level or low-level tools.

Package Removal Commands

* Debian: `apt-get remove package_name`
* Red Hat: `yum erase package_name`

Example:

`apt-get remove emacs`

#### Updating Packages from a Repository

The most common package management task is keeping the system up-to-date with the latest versions of packages.This high-level tools can perform this vital task in a single step.

Package Update Commands

* Debian: apt-get update; apt-get upgrade
* Red Hat: yum update

Example

`sudo apt-get update && sudo apt-get upgrade`

#### Upgrading a Package from a Package File

If an updated version of a package has been downloaded from a non-repository source, it can be installed, replacing the previous version.

Low-Level Package Upgrade Commands

* Debian: `dpkg -i package_file`
* Red Hat: `rpm -U package_file`

Example

`rpm -U emacs-22.1.7.fc7-i386.rpm`

#### Listing Installed Packages

* Debian: dpkg -l
* Red Hat: rpm -qa
