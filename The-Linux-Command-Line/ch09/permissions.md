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
