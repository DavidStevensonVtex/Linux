# The Linux Command Line, 2nd Edition, © 2019

## Chapter 28: Reading Keyboard Input

_Interactivity_ is the capability of a program to interact with the user.

### read -- Read Values from Standard Input

`read [-options] [variable...]`

```
#!/bin/bash

# read-integer: evaluate the value of an integer.

echo -n "Please enter an integer -> "
read int

if [[ "$int" =~ ^-?[0-9]+$ ]]; then
	if (( "$int" == 0 )); then
		echo "$int is zero."
	else
		if (( "$int" < 0 )); then
			echo "$int is negative."
		else
			echo "$int is positive."
		fi
		if (( "$int" % 2 == 0 )); then
			echo "$int is even."
		else
			echo "$int is odd."
		fi
	fi
else
	echo "Input value is not an integer."
	exit 1
fi
```

```
$ ./read-integer
Please enter an integer -> 42
42 is positive.
42 is even.
$ ./read-integer
Please enter an integer -> -3
-3 is negative.
-3 is odd.
```

`read` can assign input to multiple variables, as shown in this script.

```
#!/bin/bash

# read-multiple: read multiple values from keyboard

echo -n "Enter one or more values -> "
read var1 var2 var3 var4 var5

echo "var1 = '$var1'"
echo "var2 = '$var2'"
echo "var3 = '$var3'"
echo "var4 = '$var4'"
echo "var5 = '$var5'"
```

```
$ chmod 744 read-multiple
$ ./read-multiple
Enter one or more values -> a b c d e
var1 = 'a'
var2 = 'b'
var3 = 'c'
var4 = 'd'
var5 = 'e'
$ ./read-multiple
Enter one or more values -> a b c d e f g h i
var1 = 'a'
var2 = 'b'
var3 = 'c'
var4 = 'd'
var5 = 'e f g h i'
$ ./read-multiple
Enter one or more values -> a b c
var1 = 'a'
var2 = 'b'
var3 = 'c'
var4 = ''
var5 = ''
```

If no variables are listed after the read command, a shell variable, REPLY, will be assigned all the input.

```
#!/bin/bash

# read-single: read multiple values into default variable

echo -n "Enter one or more values -> "
read

echo "REPLY = '$REPLY'"
```

```
$ chmod 744 read-single
$ ./read-single
Enter one or more values -> a b c d
REPLY = 'a b c d'
```

#### Options

`read` supports the options described in the following table.

```
Option        Description
-a array      Assign the input to array, starting with index zero. Will cover arrays in Chapter 35.
-d delimiter  The first character in the string delimiter is used to indicate the end of input, rather than a newline character.
-e            Use Readline to handle input. This permits input editing in the same manner as the command line.
-i string     Use string as a default reply if the user simply presses ENTER. Requires the -e option.
-n num        Read num characters of input, rather than the entire line.
-p prompt     Display a prompt for input using the string prompt.
-r            Raw mode. Do not interpret backslash characters as escapes.
-s            Silent mode. Do not echo characters to the display as they are typed. This is useful when inputting passwords and other confidential information.
-t seconds    Timeout. Terminate input after seconds. read returns a non-zero exit status if an input times out.
-u fd         Use input from file descriptor fd, rather than standard input.
```

With the -t and -s options, we can write a script that reads "secret" input and times out if the input is not completed in a specified time.

```
#!/bin/bash

# read-secret: input a secret passphrase

if read -t 10 -sp "Enter secret passphrase -> " secret_pass ; then
	echo -e "\nSecret passphrase = '$secret_pass'"
else
	echo -e "\nInput timed out" >&2
	exit 1
fi
```

```
$ chmod 744 read-secret 
$ ./read-secret
Enter secret passphrase -> 
Secret passphrase = 'TheRainInSpain'
$ ./read-secret
Enter secret passphrase -> 
Input timed out
$ 
```

```
#!/bin/bash

# read-default: supply a default value if user presses Enter key.

read -e -p "What is your user name? " -i  $USER
echo "You answered: '$REPLY'"
```

```
$ chmod 744 read-default
$ ./read-default
What is your user name? abc
You answered: 'abc'
$ ./read-default
What is your user name? dstevenson
You answered: 'dstevenson'
```

### IFS (Internal Field Separator)

```
#!/bin/bash

# read-ifs: read fields from a file

FILE=/etc/passwd

read -p "Enter username > " user_name

file_info="$(grep "^$user_name:" $FILE)"

if [ -n "$file_info" ]; then
	IFS=":" read user pw uid gid name home shell <<< "$file_info"
	echo "User =        '$user'"
	echo "UID  =        '$uid'"
	echo "GID  =        '$gid'"
	echo "Full Name =   '$name'"
	echo "Home Dir. =   '$home'"
	echo "Shell =       '$shell'"
else
	echo "No such user '$user_name'"
	exit 1
fi
```

Note: "<<<" is a "here-string". "<<" is a here-document.

```
$ chmod 744 read-ifs
$ ./read-ifs
Enter username > dstevenson
User =        'dstevenson'
UID  =        '1000'
GID  =        '1000'
Full Name =   'dstevenson,,,'
Home Dir. =   '/home/dstevenson'
Shell =       '/bin/bash'
$ ./read-ifs
Enter username > root
User =        'root'
UID  =        '0'
GID  =        '0'
Full Name =   'root'
Home Dir. =   '/root'
Shell =       '/bin/bash'
```

### You Can't Pipe Read

You cannot do this:

`echo "foo" | read`

In bash (and other shells such as sh), pipelines create _subshells_. These are copies of the shell and its environment that are used to execute the command. In the previous example, _read_ is executed in a subshell.

Subshells in Unix-like systems create copies of the environment for the processes to use while they execute. When the processes finishes, the copy of the environment is destroyed. That means that a subshell can never alter the environment of its parent process. _read_ assigns variables, which then become part of the environment.

Using here strings is one way to work around this behavior. Another method is discussed in Chapter 36.