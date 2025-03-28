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

### A More Modern Version of test

Modern versions of _bash_ include a compound command that acts as an enhanced replacement for test. It uses the following syntax:

`[[ expression ]]`

The `[[ ]]` command is similar to test (it supports all of its expressiosn) but adds an important new string expression.

`string1 =~ regex`

This returns true if string1 is matched by the extended regular expression _regex_.

```
#!/bin/bash

# test-integer2: evaluate the value of an integer

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
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
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

```
$ chmod 744 test-integer2 
$ ./test-integer2
INT is negative.
INT is odd.
```

Another added feature of `[[ ]]` is that the == operator supports pattern matching the samme way pathname expansion does.

```
$ if [[ "$FILE" == foo.* ]]; then echo "$FILE matches pattern 'foo.*'"; fi
foo.bar matches pattern 'foo.*'
```

### (( )) Designed for Integers

(( )) is used to perform arithmetic truth tests. An _arithmetic truth test_ results in true of the result of the arithmetic evaluation is non-zero.

Using (( )), we can slightly simplify the test-integer script like this:

```
#!/bin/bash

# test-integer2a: evaluate the value of an integer

INT=-5

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if (( INT == 0 )); then
        echo "INT is zero."
    else
        if (( INT < 0 )); then
            echo "INT is negative."
        else
            echo "INT is positive."
        fi
        if (( (( INT % 2 )) == 0 )); then
            echo "INT is even."
        else
            echo "INT is odd."
        fi
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

```
$ ./test-integer2a
INT is negative.
INT is odd.
```

### Combining Expressions

**Logical Operators**

```
Operation   test   [[ ]] and (( ))

AND         -a      &&
OR          -o      ||
NOT         !       !
```

```
#!/bin/bash

# test-integer3: evaluate the value of an integer

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if [[ "$INT" -ge "$MIN_VAL" && "$INT" -le "$MAX_VAL" ]]; then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

```
$ ./test-integer3
50 is within 1 to 100.
```

```
#!/bin/bash

# test-integer3a: evaluate the value of an integer

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if (( "$INT" >= "$MIN_VAL" && "$INT" <= "$MAX_VAL" )); then
        echo "$INT is within $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is out of range."
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

```
$ chmod 744 test-integer3a
$ ./test-integer3a
50 is within 1 to 100.
```

```
#!/bin/bash

# test-integer3a: evaluate the value of an integer

MIN_VAL=1
MAX_VAL=100

INT=50

if [[ "$INT" =~ ^-?[0-9]+$ ]]; then
    if (( ! ( "$INT" >= "$MIN_VAL" && "$INT" <= "$MAX_VAL") )); then
        echo "$INT is outside $MIN_VAL to $MAX_VAL."
    else
        echo "$INT is in range."
    fi
else
    echo "INT is not an integer." >&2
    exit 1
fi
```

```
$ ./test-integer4
50 is in range.
```

### Control Operators: Another Way to Branch

_bash_ provides two control operators that can perform branching. The && (AND) and || (OR) operators work like logical operators in the `[[ ]]` compound command.

`command1 && command2`

`command1 || command2`

With the && operator, _command1_ is executed, and _command2_ is executed if, and only if, _command1_ is successful.

With the || operator, command1 is executed and command2 is executed if, and only if, command1 is unsuccessful.

`mkdir temp && cd temp`

`[[ -d temp ]] || mkdir temp`

`[[ -d temp ]] || exit 1`

### Summing Up

```
report_home_space() {
	echo "id: $(id -u)"
	# if (( $(id -u) == 0)); then
	if [[ "$(id -u)" -eq 0 ]]; then
		cat <<- _EOF_
			<h2>Home Space Utilization (All Users)</h2>
			<pre>$(du -sh /home/*)</pre>
		_EOF_
	else
		cat <<- _EOF_
			<h2>Home Space Utilization ($USER)</h2>
			<pre>$(du -sh $HOME 2>/dev/null)</pre>
		_EOF_
	fi
	return
}
```