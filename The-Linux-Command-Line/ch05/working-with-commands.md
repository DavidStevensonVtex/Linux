# The Linux Command Line, 2nd Edition, © 2019

## Chapter 5: Working With Commands

* type Indicate how a command name is interpreted
* which Display which executable program will be executed
* help Get help for shell builtins
* man Display a comman's manual page
* apropos Display a list of appropriate commands
* info Display a command's info entry
* whatis Display one-line manual page descriptions
* alias Create an alias for a command

### What Exactly Are Commands?

* An executable program
* A command built into the shell itself. Example: cd
* A shell function
* An alias]

### Identifying Commands 

#### type - Display a Command's type

`type command`

```
$ type type
type is a shell builtin
$ type ls
ls is aliased to `ls --color=auto'
$ type cp
cp is /bin/cp
```

#### which - Display an Executable's location

```
$ which ls
/bin/ls
```

### Getting a Command's Documentation

#### help -- Get Help for Shell builtins

```
$ help cd
cd: cd [-L|[-P [-e]] [-@]] [dir]
    Change the shell working directory.
    
    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable.
    ...
```

#### --help - Display Usage Information

```
$ mkdir --help
Usage: mkdir [OPTION]... DIRECTORY...
Create the DIRECTORY(ies), if they do not already exist.

Mandatory arguments to long options are mandatory for short options too.
  -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask
  -p, --parents     no error if existing, make parent directories as needed
  -v, --verbose     print a message for each created directory
  -Z                   set SELinux security context of each created directory
                         to the default type
      --context[=CTX]  like -Z, or if CTX is specified then set the SELinux
                         or SMACK security context to CTX
      --help     display this help and exit
      --version  output version information and exit
```

#### man - Display a Program's Manual Page

```
man ls
LS(1)                                                       User Commands                                                      LS(1)

NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

DESCRIPTION
       List  information  about  the FILEs (the current directory by default).  Sort entries alphabetically if none of -cftuvSUX nor
       --sort is specified.
```

You can also specify a section number for the man page.
```
$ man 5 passwd
PASSWD(5)                                           File Formats and Conversions                                           PASSWD(5)

NAME
       passwd - the password file

DESCRIPTION
       /etc/passwd contains one line for each user account, with seven fields delimited by colons (“:”). These fields are:

       •   login name

       •   optional encrypted password

       •   numerical user ID

       •   numerical group ID
```

#### apropos  - Display Appropriate Commands

```
$ apropos partition
addpart (8)          - tell the kernel about the existence of a partition
cfdisk (8)           - display or manipulate a disk partition table
cgdisk (8)           - Curses-based GUID partition table (GPT) manipulator
delpart (8)          - tell the kernel to forget about a partition
fdisk (8)            - manipulate disk partition table
fixparts (8)         - MBR partition table repair utility
gdisk (8)            - Interactive GUID partition table (GPT) manipulator
gparted (8)          - GNOME Partition Editor for manipulating disk partitions.
mpartition (1)       - partition an MSDOS hard disk
...
```

#### whatis - Display One-line Manual Page Descriptions

The `whatis` program displays the name and a one-line description of a man page matching a specified keyword.
```
$ whatis ls
ls (1)               - list directory contents
```