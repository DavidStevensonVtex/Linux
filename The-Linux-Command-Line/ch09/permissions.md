# The Linux Command Line, 2nd Edition, © 2019

## Chapter 9: Permissions

* id Display user identity
* chmod Change a file's permissions
* umask Set the default file permissions
* su Run a shell as another user
* sudo Execute a command as another user
* chown Change a file's owner
* chgrp Change a file's group ownership
* passwd Change a user's passwd

### Owners, Group Members, and Everybody Else

```
$ ll /etc/shadow
-rw-r----- 1 root shadow 1464 Dec 26 10:07 /etc/shadow
$ less /etc/shadow
/etc/shadow: Permission denied
```

Regular users do not have permission to read this file, as the owner is root, and the group is shadow.

In Unix terms, everybody means _world_.

```
$ id
uid=1000(dstevenson) gid=1000(dstevenson) groups=1000(dstevenson),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),116(lpadmin),126(sambashare)
$ id -u
1000
$ id -g     # Group
1000
$ id -G     # Groups
1000 4 24 27 30 46 116 126
$ id -n -u      # User name
dstevenson
$ id -n -g      # Group names
dstevenson
$ id -n -G      # Groups names
dstevenson adm cdrom sudo dip plugdev lpadmin sambashare
```

User accounts are defined in the `/etc/passwd` file, and groups
are defined in the `/etc/group` file.

### Reading, Writing and Executing

Access rights to files and directories are defined in terms of read access, write access, and execution access.

```
$ > foo.txt
$ ls -l foo.txt
-rw-rw-r-- 1 dstevenson dstevenson 0 Jan 30 15:58 foo.txt
```

The first 10 characters of the listign are the _file attributes_. The first of these characters is the file type.

#### File Types

* \- A regular file
* d A directory
* l A symbolic link
* c A character special file. This file type refers to a device that handles data as a stream of bytes, such as a terminal or /dev/null.
* b A block special file. This file type refers to a device that handles data in blocks, such as a hard drive or DVD drive.

The remaining nine characters of the file attributes, called the file mode, represent the read, write, and execute permissions file's owner, the file's group owner, and everybody else.

* Owner rwx
* Group rwx
* World rwx

#### Permission Attributes

* r Allows a file to be opened and read
* w Allows a file to be written or truncated. This attribute does not allow files to be renamed or deleted. The ability to delete or rename files is determined by directory attributes.
* x Allows a file to be treated as a program and executed. Program files written in scripting languages must also be set as readable to be executed.


### chmod: Change File Mode (Permissions)

`chmod` supports two distinct ways of specifying mode changes.

* Octal number representation
* Symbolic representation

Octal is base 8.

0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 13, 14, 15, 16, 17, 20, 21, ...

Octal, Binary, File Mode

* 0 000 ---
* 1 001 --x
* 2 010 -w-
* 3 011 -wx
* 4 100 r--
* 5 101 r-x
* 6 110 rw-
* 7 111 rwx

```
$ ls -l foo.txt
-rw-rw-r-- 1 dstevenson dstevenson 0 Jan 30 16:11 foo.txt
$ chmod 600 foo.txt
$ ls -l foo.txt
-rw------- 1 dstevenson dstevenson 0 Jan 30 16:11 foo.txt
```

`chmod` als supports a symbolic notation for specifying file modes.
Symbolic notation is divided into 3 parts.

* Who the change will affect
* Which operation will be performed
* What permission will be set

chmod Symbolic Notation

Symbol Meaning
* u Short for user, but means the file or directory owner
* g Group owner
* o Short for others but means world.
* a Short for all. This is a combination of u, g and o.

chmod Symbolic Notation Examples
* u+x Add execute permission for the owner
* u-x Remove execute permission for the owner
* +x Add execute permission for the owner, group, and world. This is equivalent to a+x.
* o-rw Removethe read and write permissions for anyone besides the owner and group owner
* go=rw Set the group owner and world to have read and write permissions. If either the group owner or the world previously had execute permission, it is removed.
* u+x,go=rw Add execute permission for the owner and set the permissions for the group and others to read and eecute. Multiple specifications may be separated by commas.

### Setting File Mode with the GUI

The Files application (GUI) In GNOME allows changing permissions by right-clicking on the file and selecting permissions, and then selecting the Permissions tab.

