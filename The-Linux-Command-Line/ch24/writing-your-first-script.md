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

#### Script File Location

With the permissions set, we can now execute our script.

For the script to run, we must precede the script name with an explicit path.

```
$ ./hello_world 
Hello World!
```

The list of searchable directories is held in an environment variable named PATH.

```
$ echo $PATH
/usr/lib/jvm/java-11-oracle:/usr/lib/jvm/java-11-oracle:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

Modifications to the PATH environment variable can be made in the .bashrc file.

#### Good Locations for Scripts

The ~/bin directory is a good place to put scripts intended for personal use.

If we write a script that everyone on a system is allowed to use, the traditional location is _/usr/local/bin_.

### More Formatting Tricks

#### Long Option Names

```
$ ls -ad
$ ls --all --directory
```

In the interests of reduced typing, short options are preferred when entering options on the command line, but when writing scripts, long options can provide improved readability.