# The Linux Command Line, 2nd Edition, © 2019

## Chapter 24: Writing Your First Script

### What Are Shell Scripts?

A _shell script_ is a file containing a series of commands.

### How to Write a Shell Script

1. Write a script. Shell scripts are ordinary text files.
2. Make the script executable.
3. Put the script some where the shell can find it.

#### Script File Format

**helloworld**

```
#!/bin/bash

# This is our first script.

echo 'Hello World!'
```

The first line is called a _shebang_. The shebang is used to tell the kernel the name of the interpreter that should be used to execute the script.

#### Executable Permissions

```
ls -l hello_world
chmod 755 hello_world
ls -l hello_world
```

```
$ ./hello_world 
Hello World!
```

