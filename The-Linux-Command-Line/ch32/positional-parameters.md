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