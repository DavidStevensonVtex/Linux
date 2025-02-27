# The Linux Command Line, 2nd Edition, © 2019

## Chapter 26: Top-Down Design

As with any large, complex project, it is often a good idea to break large, complex tasks into a series of small, simple tasks.

The process of identifying the top-level steps and developing increasingly detailed views of those steps is called _top-down design_.

### Shell Functions

Add new featuers:

* System uptime and load.
* Disk space.
* Home space.

```
#!/bin/bash

# Program to output a system information page

TITLE="System Information Page for $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

cat << _EOF_
<html>
   <head>
       <title>$TITLE</title>
   </head>
   <body>
        <h1>$TITLE</h1>
        <p>$TIMESTAMP</p>
        $(report_uptime)
        $(report_disk_space)
        $(report_home_space)
   </body>
 </html>
_EOF_
```

Shell functions have two syntactic forms. First, here is the more formal form:

```
function name {
    commands
    return
}
```

Here is the simpler (and generally preferred form):

```
name() {
    commands
    return
}
```

**shell-function-demo**

```
#!/bin/bash

# Shell function demo

function step2 {
    echo "Step 2"
    return
}

# Main program starts here

echo "Step 1"
step2
echo "Step 3"
```

```
$ ./shell-function-demo 
Step 1
Step 2
Step 3
```

**sys_info_page**

```
#!/bin/bash

# Program to output a system information page

TITLE="System Information Page for $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime() {
  return 
}

report_disk_space() {
  return
}

report_home_space() {
  return
}

cat << _EOF_
<html>
   <head>
       <title>$TITLE</title>
   </head>
   <body>
        <h1>$TITLE</h1>
        <p>$TIMESTAMP</p>
        $(report_uptime)
        $(report_disk_space)
        $(report_home_space)
   </body>
 </html>
_EOF_

```

Shell function names follow the same rules as variables. A function must contain at least one command.
The return command (which is optional) satisfies the requirement.

### Local Variables

Global variables maintain their existence throughout the program.

Local variables are acccessible only within the shell function in which they are defined and cease to exist once the shell function terminates.

```
#!/bin/bash

# local-vars: script to demonstrate local variables

foo=0       # global variable foo

funct_1 () {
    local foo       # variable foo local to funct_1
    foo=1
    echo "funct_1: foo = $foo"
}

funct_2() {
    local foo       # variable foo local to funct_2
    foo=2
    echo "funct_2: foo = $foo"
}

echo "global:  foo = $foo"
funct_1
echo "global:  foo = $foo"
funct_2
echo "global:  foo = $foo"
```

```
$ ./local-vars
global:  foo = 0
funct_1: foo = 1
global:  foo = 0
funct_2: foo = 2
global:  foo = 0
```

### Keep Scripts Running

```
#!/bin/bash

# Program to output a system information page

TITLE="System Information Page for $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIMESTAMP="Generated $CURRENT_TIME, by $USER"

report_uptime() {
  echo "Function report_uptime executed."
  return 
}

report_disk_space() {
  echo "Function report_disk_space executed."
  return
}

report_home_space() {
  echo "Function report_home_space executed."
  return
}

cat << _EOF_
<html>
   <head>
       <title>$TITLE</title>
   </head>
   <body>
        <h1>$TITLE</h1>
        <p>$TIMESTAMP</p>
        $(report_uptime)
        $(report_disk_space)
        $(report_home_space)
   </body>
 </html>
_EOF_
```

```
$ ./sys_info_page > sys_info_page.html
```

**sys_info_page.html**

```
<html>
   <head>
       <title>System Information Page for dstevensonlinux1</title>
   </head>
   <body>
        <h1>System Information Page for dstevensonlinux1</h1>
        <p>Generated 02/27/2025 02:14:09 PM EST, by dstevenson</p>
        Function report_uptime executed.
        Function report_disk_space executed.
        Function report_home_space executed.
   </body>
 </html>
```