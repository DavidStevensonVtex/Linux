# The Linux Command Line, 2nd Edition, © 2019

## Chapter 17: Searching For Files

* locate Find files by name
* find Search for files in a directory hierarchy
* xargs Build and execute command lines from standard input
* touch Change file times
* stat Display file or file system status

### locate - Find Files the Easy Way

```
$ locate bin/zip
/snap/emacs/2504/usr/bin/zipdetails
/snap/gnome-42-2204/176/usr/bin/zipdetails
/snap/gnome-42-2204/202/usr/bin/zipdetails
/usr/bin/zip
/usr/bin/zipcloak
/usr/bin/zipdetails
/usr/bin/zipgrep
/usr/bin/zipinfo
/usr/bin/zipnote
/usr/bin/zipsplit
```

```
$ locate zip | grep bin | egrep -v "(snap|Apache|firmware)"
/bin/bunzip2
/bin/bzip2
/bin/bzip2recover
/bin/gunzip
/bin/gzip
/usr/bin/funzip
/usr/bin/gpg-zip
/usr/bin/mzip
/usr/bin/preunzip
/usr/bin/prezip
/usr/bin/prezip-bin
/usr/bin/unzip
/usr/bin/unzipsfx
/usr/bin/zip
/usr/bin/zipcloak
/usr/bin/zipdetails
/usr/bin/zipgrep
/usr/bin/zipinfo
/usr/bin/zipnote
/usr/bin/zipsplit
/usr/lib/klibc/bin/gunzip
/usr/lib/klibc/bin/gzip
/usr/share/man/man1/prezip-bin.1.gz
```

```
$ which slocate
$ which mlocate
/usr/bin/mlocate
```

The `locate` atabase is created by another program named `updatedb`.

### find - Find Files the Hard Way

To produce a listing of hour home directory and sub-directories:

`$ find ~`

Count the number of files

`$ find ~ | wc -l`

### Tests

Find the directories in our home directory and sub-directories.

`$ find ~ -type d | wc -l`

`$ find ~ -type f | wc -l`

#### File Types

* b Block special device file
* c Character special device file
* d Directory
* f Regular File
* l Symbolic link

`$ find ~ -type f -name "*.jpg" -size +1M | wc -l`

#### Find Size Units

* b 512-byte blocks. This is the default if no unit is specified
* c Bytes
* w 2-byte words
* k Kilobytes
* M Megabytes
* G Gigabytes

#### Find Tests

* -cmin n Match files or directories whose content or attributes were modified exact n minutes ago. To specify less than n minutes ago, use -n, and to specify more than n minutes ago, use +n.
* -cnewer file Match files or directories whose contents or attributes were last modified more recently than those of _file_.
* -ctime n Match files or directories whose contents or attributes were last moidified n*24 hours ago.
* -empty Match empty files and directories
* -group _name_ Match file or directories belonging to group _name_. _name_ may be expressed either as a group name or as a numeric group id.
* -iname _pattern_  Like the `-name` test but case-insensitive.
* -inum n Match files with inode number n. This is helpful for finding all the hard links to a particular node.
* -mmin n Match files or directories whose contents were last modified n minutes ago.
* -mtime n Match fiiles or directories whose contents were last modified n*24 hours.
* -newere file Match files and directories whose contents were modified more recently than specified _file_.
* -nouser Match file and directories that do not belong to a valid user.
* -nogroup Match file anddirectories that do not beong to a valid group.
* -perm mode Match files or directories that have permissiosn set to the specified _mode_. _mode_ can be expressed by either octal or symbolic notation.
* -samefile name Similar to the -inum test. Match files that share the same inode number as file _name_.
* -size n Match files of size n.
* -type c Match files of type c.
* -user name Match files or directories belonging to user _name_. The user may bexpressed by a username or by a numeric user ID.

#### Operators 

_logical relationships_

`$ find ~ \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \)`

##### Find Logical Operators

* -and 
* -or
* -not
* \( \)

##### Find AND/OR Logic

Results of `expr1`, Operator, `expr2` is...

* True -and Always Performed
* False -and Never Performed
* True -or Never performed
* False -or Always performed

#### Predefined Actions

* -delete Delete the currently matching file
* -ls Perform the equivalent of ls -dils on the matching file. Output is sent to standard output
* -print Output the full pathname of the matching file to standard output. This is the default action if no other action is specified.
* -quit Quit once a match has been made

Use caution when deleting files. Issue the command without the `-delete` option to determine what files will be deleted first.

`$ find -type f -name "*.bak" -delete`

`$ find -type f -name "*.bak" -print`

There is an implied `-and` between each test and action.

`find ~ -type f -and -name '*bak' -and -print`

Order of terms is important.

`find ~ -print -and -type f -and -name '*.bak'`

All files, regardless of file extension are printed.

