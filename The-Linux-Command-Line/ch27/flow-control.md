# The Linux Command Line, 2nd Edition, © 2019

## Chapter 27: Flow Control: Branching Wit If

### if Statements

```
#!/bin/bash

x=5
if [ "$x" -eq 5 ]; then
    echo "x equals 5."
else
    echo "x does not equal 5."
fi
```

```
$ chmod 744 if-statements 
$ ./if-statements 
x equals 5.
```

```
if commands; then
    commands
[elif commands; then 
    commands...]
[else
    commands]
fi
```

### Exit Status

Commands (ncluding the scripts and shell functions we write) issue a value to the system when they terminate, called an _exit status_. This value, which is an integer in the range of 0 to 255, indicates the success or failure of the command's execution. By convention, a value of zero indicates success and any other failure indicates failure. The shell provides a parameter that we can use to examine the exit status:

```
$ ls -d /usr/bin
/usr/bin
$ echo $?
0
$ ls -d /bin/usr
ls: cannot access '/bin/usr': No such file or directory
$ echo $?
2
```

The shell provides two extremely simple builtin commands that do nothing except terminate with either a 0 or 1 exit status. The `true` command always executes successfully, and the `false` command always executes unsuccessfully.

```
$ true
$ echo $?
0
$ false
$ echo $?
1
$ which true
/bin/true
$ which false
/bin/false
```

```
$ if true; then echo "it's true." ; fi
it's true.
$ if false; then echo "It's true." ; else echo "It's false." ; fi
It's false.
```

```
$ if false; true; then echo "It's true." ; else echo "It's false." ; fi
It's true.
$ if true; false; then echo "It's true." ; else echo "It's false." ; fi
It's false.
```