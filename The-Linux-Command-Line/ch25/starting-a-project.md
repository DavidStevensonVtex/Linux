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
google-chrome sys_info_page.html
```
