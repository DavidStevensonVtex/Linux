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