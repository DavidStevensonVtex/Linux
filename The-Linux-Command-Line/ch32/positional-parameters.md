# The Linux Command Line, 2nd Edition, © 2019

## Chapter 32: Positional Parameters

### Accessing the Command Line

The shell provides a set of variables called _positional parameters_ that contain the individual words on the command line. The variables are named 0 through 9.

```
#!/bin/bash

# posit-param: script to view command line parameters

echo "
\$0 = $0
\$1 = $1
\$2 = $2
\$3 = $3
\$4 = $4
\$5 = $5
\$6 = $6
\$7 = $7
\$8 = $8
\$9 = $9
"
```

```
$ chmod 744 posit-param
$ ./posit-param The rain in Spain falls mainly in the plain

$0 = ./posit-param
$1 = The
$2 = rain
$3 = in
$4 = Spain
$5 = falls
$6 = mainly
$7 = in
$8 = the
$9 = plain

```

You can actually access more than nine parameters using parameter expansion. To specify a number greater than nine, surround the number in braces, as in ${10}, ${55}, ${211}, and so on.

#### Determining the Number of Arguments

The shell also provides a variable, $\#, that contains the number of arguments on the command line.

```
#!/bin/bash

# posit-param: script to view command line parameters

echo "
Number of arguments: $#
\$0 = $0
\$1 = $1
\$2 = $2
\$3 = $3
\$4 = $4
\$5 = $5
\$6 = $6
\$7 = $7
\$8 = $8
\$9 = $9
"
```

```
$ ./posit-param The rain in Spain falls mainly in the plain generally speaking

Number of arguments: 11
$0 = ./posit-param
$1 = The
$2 = rain
$3 = in
$4 = Spain
$5 = falls
$6 = mainly
$7 = in
$8 = the
$9 = plain

```

#### shift -- Getting Access to Many Arguments

But what happens when we give the program a large number of arguments such as the following?

```
$ ./posit-param ~/*

Number of arguments: 40
$0 = ./posit-param
$1 = /home/dstevenson/abd
$2 = /home/dstevenson/AI
$3 = /home/dstevenson/archive
$4 = /home/dstevenson/bashtest
$5 = /home/dstevenson/Derby
$6 = /home/dstevenson/derby.log
$7 = /home/dstevenson/Desktop
$8 = /home/dstevenson/Discussion
$9 = /home/dstevenson/Documents

```

```
#!/bin/bash

# posit-param2: script to display all arguments

count=1

while (( $# > 0 )); do
    echo "Argument $count: $1"
    count=$((count + 1))
    shift
done
```

```
$ chmod 744 posit-param2
$ ./posit-param2 a b c d
Argument 1: a
Argument 2: b
Argument 3: c
Argument 4: d
```

#### Simple Applications

Even without shift, it's possible to write useful applications using positional parameters. By way of example, here is a simple file information program.

```
#!/bin/bash

# file-info: simple file information program

PROGNAME="$(basename "$0")"

if [[ -e "$1" ]]; then
    echo -e "\nFile Type:"
    file "$1"
    echo -e "\nFile Status:"
    stat "$1"
else
    echo "$PROGNAME: usage: $PROGNAME file" >&2
    exit 1
fi
```

```
$ chmod 744 file-info 
$ ./file-info *.md

File Type:
positional-parameters.md: UTF-8 Unicode text

File Status:
  File: positional-parameters.md
  Size: 2181            Blocks: 8          IO Block: 4096   regular file
Device: 802h/2050d      Inode: 51380392    Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/dstevenson)   Gid: ( 1000/dstevenson)
Access: 2025-03-06 10:30:43.602002825 -0500
Modify: 2025-03-06 10:30:43.562002739 -0500
Change: 2025-03-06 10:30:43.562002739 -0500
 Birth: -
```

#### Using Positional Parameters with Shell Functions

```
#!/bin/bash

# file-info: simple file information program

PROGNAME="$(basename "$0")"

if [[ -e "$1" ]]; then
    echo -e "\nFile Type:"
    file "$1"
    echo -e "\nFile Status:"
    stat "$1"
else
    echo "$FUNCNAME: usage: $FUNCNAME file" >&2
    exit 1
fi
```

```
$ chmod 744 file_info
$ source file_info
$ file_info *.md

File Type:
positional-parameters.md: UTF-8 Unicode text

File Status:
  File: positional-parameters.md
  Size: 3189            Blocks: 8          IO Block: 4096   regular file
Device: 802h/2050d      Inode: 51380392    Links: 1
Access: (0664/-rw-rw-r--)  Uid: ( 1000/dstevenson)   Gid: ( 1000/dstevenson)
Access: 2025-03-06 10:39:20.243238527 -0500
Modify: 2025-03-06 10:39:20.183238373 -0500
Change: 2025-03-06 10:39:20.183238373 -0500
 Birth: -
```

```
$ source file_info
$ file_info
file_info: usage: file_info file
```