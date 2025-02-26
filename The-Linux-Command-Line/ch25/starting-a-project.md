# The Linux Command Line, 2nd Edition, © 2019

## Chapter 25: Starting a Project

We will write a report generator produces the report in HTML format.

### First Stage: Minimal Document

**sys_info_page**

```
#!/bin/bash

# Program to output a system information page

echo "<html>
   <head>
       <title>Page title</title>
   </head>
   <body>
        Page body.
   </body>
 </html>"
```

```
./sys_info_page > sys_info_page.html
google-chrome sys_info_page.html &
```

### Second Stage: Adding a Little Data

```
#!/bin/bash

# Program to output a system information page

echo "<html>
   <head>
       <title>System Information Report</title>
   </head>
   <body>
        <h1>System Information Report</h1>
   </body>
 </html>"
```

### Variables and Constants

```
#!/bin/bash

# Program to output a system information page

title="System Information Page"

echo "<html>
   <head>
       <title>$title</title>
   </head>
   <body>
        <h1>$title</h1>
   </body>
 </html>"
```

Some rules about variable names:

* Variable names may consist of alphanumeric characters (letters and numbers) and underscore characters.
* The first character of a variable name must be either a letter or an underscore.
* Spaces and punctuation symbols are not allowed.

A common convention is to use uppercase letters to designate constants and lolowercase letters for true variables.

```
#!/bin/bash

# Program to output a system information page

TITLE="System Information Page for $HOSTNAME"

echo "<html>
   <head>
       <title>$TITLE</title>
   </head>
   <body>
        <h1>$TITLE</h1>
   </body>
 </html>"
```

_The shell actually does provide a way to enforce the immutability of constants, through the use of the declare built-in command with the -r (read only) option._

`declare -r TITLE="Page Title"`

#### Assigning Values to Variables and Constants

_variable=value_

You can force the shell to restrict the assignment to integers by using the declare command with the -i option, but, like setting variables as read-only, this is rarely done.

```
a=z                    # Assign the string "z" to the variable a.
b="a string"           # Embedded spaces must be within quotes
c="a string an $b"     # Other expansions such as variables can be 
                       # expanded into the assignment
d="$(ls -l foo.txt)    # Results of a command
e=$((5 * 7))           # Arithmetic expansion
f="\t\ta string\n"     # Escape sequences such as tabs and newlines
```

```
$ filename="myfile"
$ touch "$filename"
$ mv "$filename" "$filename1"
mv: cannot move 'myfile' to '': No such file or directory

$ mv "$filename" "${filename}1"
$ ll my*
-rw-rw-r-- 1 dstevenson dstevenson 0 Feb 26 13:12 myfile1
```

**sys_info_page**

```
#!/bin/bash

# Program to output a system information page

TITLE="System Information Page for $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

echo "<html>
   <head>
       <title>$TITLE</title>
   </head>
   <body>
        <h1>$TITLE</h1>
        <p>$TIMESTAMP</p>
   </body>
 </html>"
```

```
$ ./sys_info_page > sys_info_page.html
$ google-chrome sys_info_page.html &
```