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

#### info - Display a Program's Info Entry

To invoke `info`, type `info` followed optionally by the name of a program.

Info pages are _hyperlinked_ much like web pages.

```
info ls
Next: dir invocation,  Up: Directory listing

10.1 ‘ls’: List directory contents
==================================

The ‘ls’ program lists information about files (of any type, including
directories).  Options and file arguments can be intermixed arbitrarily,
as usual.

   For non-option command-line arguments that are directories, by
default ‘ls’ lists the contents of directories, not recursively, and
omitting files with names beginning with ‘.’.  For other non-option
arguments, by default ‘ls’ lists just the file name.  If no non-option
argument is specified, ‘ls’ operates on the current directory, acting as
if it had been invoked with a single argument of ‘.’.

   By default, the output is sorted alphabetically, according to the
locale settings in effect.(1)  If standard output is a terminal, the
output is in columns (sorted vertically) and control characters are
output as question marks; otherwise, the output is listed one per line
-----Info: (coreutils)ls invocation, 57 lines --Top-----------------------------------------------------------------------------------
Welcome to Info version 6.7.  Type H for help, h for tutorial.
```

#### README and Other Program Documentation Files

There is documentation in the `/usr/share/doc` directory.

Some files are in the HTML format and can be viewed with a browser.
Other files may have a .gz file extension.

`zless` can display the contents of .gzip compressed text files.

### Creating Our Own Commands with alias

A user defined command can be defined using the `alias` command.

It is possible to put more than one command on a line by separating
each command with a semicolon.

```
$ cd /usr; ls; cd -
bin  games  include  lib  libexec  local  sbin  share  src
/home/dstevenson/Linux/GitHub/Linux/The-Linux-Command-Line/ch05
```
You can determine if a command already exists, so as to not re-use an
existing command using alias.

```
$ type test
test is a shell builtin
```

```
$ alias foo='cd /usr ; ls; cd -'
$ foo
bin  games  include  lib  libexec  local  sbin  share  src
/home/dstevenson/Linux/GitHub/Linux/The-Linux-Command-Line/ch05
$ type foo
foo is aliased to `cd /usr ; ls; cd -'
$ unalias foo
$ type foo
bash: type: foo: not found
```

You can display existing aliases:

```
$ alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias rm='rm --preserve-root'
```