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