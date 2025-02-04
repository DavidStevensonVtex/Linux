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
