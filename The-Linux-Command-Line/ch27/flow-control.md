# The Linux Command Line, 2nd Edition, © 2019

## Chapter 27: Flow Control: Branching With If

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

### Using test

By far, the command used most frequently with _if_ is _test_. The _test_ command performs a variety of checks and comparisons. It has two equivalent forms. The first, shown here:

**test** _expression_

And the second, more popular form, here:

\[ _expression_ \]

In _bash_, they are builtins, but they also exist as programs in _/usr/bin_ for use with other shells.

#### File Expressions

**test File Expressions**

```
Expression            Is true if:

file1 -ef file2       file1 and file2 have the same inode numbers
file1 -nt file2       file1 is newer than file2
file1 -ot file2       file1 is older than file2
-b file               file exists and is a block-special (device) file
-c file               file exists and is a character-special (device) file
-d file               file exists and is a directory
-e file               file exists
-f file               file exists and is a regular file
-g file               file exists and is set-group-ID
-G file               file exists and is owned by the effective group ID.
-k file               file exists and has its "sticky bit" set.
-L file               file exists and is a symbolic link.
-O file               file exists and is owned by the effective user ID.
-p file               file exists and is a named pipe
-r file               file exists and is readable (has readable permission for the effective user)
-s file               file exists and has a length greater than zero
-S file               file exists and is a network socket
-t fd                 fd is a file descriptor directed to/from the terminal. This can be used to determine whether standard input/output/error is being redirected
-u file               file exists and is setuid
-w file               file exists and is writable (has write permission for the effective user)
-x file               file exists and is executable (has execute/search permission for the effective user)
```

```
#!/bin/bash

# test-file: Evaluate the status of a file
FILE=~/.bashrc

if [ -e "$FILE" ]; then
    if [ -f "$FILE" ]; then
        echo "$FILE is a regular file."
    fi
    if [ -d "$FILE" ]; then
        echo "$FILE is a directory."
    fi
    if [ -r "$FILE" ]; then
        echo "$FILE is readable."
    fi
    if [ -w "$FILE" ]; then
        echo "$FILE is writable."
    fi
    if [ -x "$FILE" ]; then
        echo "$FILE is executable."
    fi
else
    echo "$FILE does not exist"
    exit 1
fi

exit
```

```
$ ./test-file
/home/dstevenson/.bashrc is a regular file.
/home/dstevenson/.bashrc is readable.
/home/dstevenson/.bashrc is writable.
```

The _exit_ command accepts a single, optional argument, which becomes the script's exit status. When no argument is passed, the exit status defaults to the exit status of the last command executed. Using exit in this way allows the script to indicate failure if $FILE erxpands to the name of a non-existent file.

#### String Expressions

**test String Functions**

```
Expression             Is true if:

string                 string is not null
-n string              The length of string is greater than zero
-z string              The length of string is zero
string1 = string2      string1 and string2 are equal
string1 == string2     string1 and string2 are equal. The use of double equal signs is greatly preferred but is not POSIX compliant
string1 != string2     string1 and string2 are not equal
string1 > string2      string1 sorts after string2
string1 < string2      string2 sorts before string2
```

The \> and \< expression operators must be quoted (or escaped with a backslash) when used with _test_. If not, they will be interpreted by the shll as redirection operators, with potentially destructive results.

```
#!/bin/bash

# test-string: evaluate the value of a string

ANSWER=maybe

if [ -z "$ANSWER" ]; then
    echo "There is no answer." >&2
    exit 1
fi

if [ "$ANSWER" = "yes" ]; then
    echo "The answer is YES."
elif [ "$ANSWER" = "no" ]; then
    echo "The answer is NO."
elif [ "$ANSWER" = "maybe" ]; then
    echo "The answer is MAYBE."
else
    echo "The answer is UNKNOWN."
fi
```

```
$ chmod 744 test-string 
$ ./test-string
The answer is MAYBE.
```

#### Integer Expressions

**test Integer Expressions**

```
Expression               Is true if:

integer1 -eq integer2    integer1 is equal to integer2
integer1 -ne integer2    integer1 is not equal to integer2
integer1 -le integer2    integer1 is less than or equal to integer2
integer1 -lt integer2    integer1 is less than integer2
integer1 -ge integer2    integer1 is greater than or equal to integer2
integer1 -gt integer2    integer1 is greater than integer2
```

```
#!/bin/bash

# test-integer: evaluate the value of an integer

INT=-5

if [ -z "$INT" ]; then
    echo "INT is empty." >&2
    exit 1
fi

if [ $INT -eq 0 ]; then
    echo "INT is zero."
else
    if [ "$INT" -lt 0 ]; then
        echo "INT is negative."
    else
        echo "INT is positive."
    fi
    if [ $((INT % 2)) -eq 0 ]; then
        echo "INT is even."
    else
        echo "INT is odd."
    fi
fi
```

```
$ chmod 744 test-integer
$ ./test-integer
INT is negative.
INT is odd.
```