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

#### User-Defined Actions

We can invoke arbtrary commands. The traditional way of doing this is with the `-exec` action.
This command works like this:

`-exec command {} ;

{} is a symbolic representation of the current pathname, and the semicolon is a required delimiter indicating the end of the command.
Here's an example of using `-exec` to act like the `-delete` action discussed earlier.

`-exec rm '{}' ';'`

Again, because the brace and semicolon characters have special meaning to the shell, they must be quoted or escaped.

```
$ find ~ -type f -name 'foo*' -ok ls -l '{}' ';'
< ls ... /home/dstevenson/.vscode/extensions/ms-python.vscode-pylance-2025.2.1/dist/bundled/stubs/skimage/morphology/footprints.pyi > ? y
-rw-rw-r-- 1 dstevenson dstevenson 865 Feb  6 08:15 /home/dstevenson/.vscode/extensions/ms-python.vscode-pylance-2025.2.1/dist/bundled/stubs/skimage/morphology/footprints.pyi
< ls ... /home/dstevenson/.vscode/extensions/ms-python.vscode-pylance-2025.2.1/dist/typeshed-fallback/stubs/Markdown/markdown/extensions/footnotes.pyi > ? n
< ls ... /home/dstevenson/.vscode/extensions/ms-python.python-2024.22.2-linux-x64/python_files/lib/jedilsp/jedi/third_party/typeshed/third_party/2and3/markdown/extensions/footnotes.pyi > ? 
```

Actions which inhibit the default -print are -delete, -exec, -execdir, -ok, -okdir, -fls, -fprint, -fprintf, -ls, -print and -printf.

#### Improving Efficiency

```
ls -l file1
ls -l file2
```

`ls -l file1 file2`

This causes the command to be executed only one time rather than multiple times. There are two ways we can do this: the traditional way, using the external command `xargs`, and the alternate way, using a new feature in `find` itself.

By changing the trailing semicolon to a plus sign, we activate the capability of `find` to combine the results of the search into an argument list for a single execution of the desired command.

`find ~ -type f -name 'foo*' -exec ls -l '{}' ';'`

`find ~ -type f -name 'foo*' -exec ls -l '{}' +`

We get the same results, but the system has to execute the `ls` command only once.


#### xargs

The `xargs` command accepts input from the standard input and converts it into an argument list for a specified command.

`find ~ -type f -name 'foo*' -print | xargs ls -l`

While the number of arguments that can be placed into a command line is quite large, it's not unlimited. It is possible to create commands that are too long fro the shell to accept. When a command line exceeds the maximum length supported by the system, `xargs` executes the specified command with the maximum number of arguments possible and then repeats this process until standard input is exhausted. To see the maximum size of the command line, execute `xargs` with the --show-limits option.

```
$ xargs --show-limits
Your environment variables take up 3875 bytes
POSIX upper limit on argument length (this system): 2091229
POSIX smallest allowable upper limit on argument length (all systems): 4096
Maximum length of command we could actually use: 2087354
Size of command buffer we are actually using: 131072
Maximum parallelism (--max-procs must be no greater): 2147483647
```

##### Dealing With Funny Filenames

File names containing an embedded space will be treated as a separate argument.

To overcome this, `find` and `xargs` allow the optional use of a _null_ character as an argument separator. A null character is defined in ASCII as the character represented by the number zero. The `find` command provides the action `-print0` which produces a null separated output, and the `xargs` command has the `--null` (or `-0`) option, which accepts null separated input. 

`find ~ -name '*.jpg' -print0 | xargs --null ls -l`

### A Return to the Playground

The `-p` option for `mkdir` creates the parent directories.
If a non-existent file is specified for `touch`, touch creates the file.

```
$ mkdir -p playground/dir-{001..100}
$ touch playground/dir-{001..100}/file-{A..Z}
```

```
$ find playground -type f -name 'file-A' | wc -l
100
```

```
$ touch playground/timestamp
$ stat playground/timestamp
  File: playground/timestamp
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: 802h/2050d	Inode: 51010818    Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/dstevenson)   Gid: ( 1000/dstevenson)
Access: 2025-02-07 10:06:07.417824325 -0500
Modify: 2025-02-07 10:06:07.417824325 -0500
Change: 2025-02-07 10:06:07.417824325 -0500
```

Find all 'file-B' regular files that are newer than the playground/timestamp file.
```
$ find playground -type f -name 'file-B' -exec touch '{}' ';'
$ find playground -type f -newer playground/timestamp
playground/dir-076/file-B
playground/dir-052/file-B
...
```

`find playground \( -type f -not -perm 0600 \) -or \( -type d -not -perm 0700 \) | sort`

`find playground \( -type f -not -perm 0600 -exec chmod 0600 '{}' ';' \) -or \( -type d -not -perm 0700 -exec chmod 0700 '{}' ';'  \)`

### find Options

#### Commonly used `find` options

* -depth Direct `find` to process a directory's files before the directory itself. This option is automatically applied when the -delete action is specified.
* -maxdepth _levels_ Sets the maximum number of levels that `find` will descend into adirectory tree when performing tests and actions.
* -mindepth _levels_ Sets the minimum number of levels that find will descend into a diretory tree before applying tests and actions.
* -mount Direct find not to traverse directories that are mounted on other file systems.
* -nolead Direct find not to optimize its search based on the assumption that it is searching Unix-like file system. This is needed when scanning DOS/Windows file systems and CD-ROMs.
