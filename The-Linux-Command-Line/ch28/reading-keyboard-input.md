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