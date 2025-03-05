# The Linux Command Line, 2nd Edition, © 2019

## Chapter 31: Flow Control: Branching with Case

### The case Command

```
#!/bin/bash

# read-menu: a menu driven system information program

clear
echo "
Please Select:

1. Display System Information
2. Display Disk Space
3. Display Home Space Utilization
0. Quit
"

read -p "Enter selection [0-3] > "

case "$REPLY" in
	0)	echo "Program terminated."
		exit
		;;
	1)	echo "Hostname: $HOSTNAME"
		uptime
		;;
	2)	df -h
		;;
	3)	if [[ "$(id -u)" -eq 0 ]]; then
			echo "Home Space Utilization (All Users)"
			du -sh /home/*
		else
			echo "Home Space Utilization ($USER)"
			du -sh "$HOME" 2>/dev/null
		fi
		;;
	*)	echo "Invalid entry." >&2
		exit 1
		;;
esac
```

#### Patterns

Patterns are terminated with a \) character.

**case Pattern Examples**

```
Pattern       Description
a)            Matches if word equals a.
[[:alpha:]]   Matches if word is a single alphabetic character.
???)          Matches if word is exactly three characters long.
*.txt)        Matches if word ends with the characters .txt.
*)            Matches any value of word. It is good practice to include this as the last pattern in a case command to catch any values of word that did not match a previous pattern, that is to catch any possible invalid values.
```

```
#!/bin/bash

# pattern-example

read -p "enter word > "

case "$REPLY" in
	[[:alpha:]]) 	echo "is a single alphabetic character." ;;
	[ABC][0-9])		echo "is A, B, or C followed by a digit." ;;
	???)			echo "is three characters long." ;;
	*.txt)			echo "is a word ending in '.txt'" ;;
	*)				echo "Invalid entry." >&2
					exit 1
					;;
esac
```

```
$ chmod 744 pattern-example 
$ ./pattern-example 
enter word > a
is a single alphabetic character.
$ ./pattern-example 
enter word > C5
is A, B, or C followed by a digit.
$ ./pattern-example 
enter word > xyz
is three characters long.
$ ./pattern-example 
enter word > file.txt
is a word ending in '.txt'
$ ./pattern-example 
enter word > this is an unexpected entry
Invalid entry.
$ echo $?
1
```

```
#!/bin/bash

# read-menu: a menu driven system information program

clear
echo "
Please Select:

A. Display System Information
B. Display Disk Space
C. Display Home Space Utilization
Q. Quit
"

read -p "Enter selection [A, B, C or Q] > "

case "$REPLY" in
	q|Q)	echo "Program terminated."
			exit
			;;
	a|A)	echo "Hostname: $HOSTNAME"
			uptime
			;;
	b|B)	df -h
			;;
	c|C)	if [[ "$(id -u)" -eq 0 ]]; then
				echo "Home Space Utilization (All Users)"
				du -sh /home/*
			else
				echo "Home Space Utilization ($USER)"
				du -sh "$HOME" 2>/dev/null
			fi
			;;
	*)		echo "Invalid entry." >&2
			exit 1
			;;
esac
```

### Performing Multiple Actions

In versions of _bash_ prior to 4.0, _case_ allowed only one action to be performed on a successful match. After a successful match, the command would terminate.

```
#!/bin/bash

# case-4-1: test a character

read -n 1 -p "Type a character > "
echo

case "$REPLY" in 
	[[:upper:]])		echo "'$REPLY' is upper case." ;;
	[[:lower:]])		echo "'$REPLY' is lower case." ;;
	[[:alpha:]])		echo "'$REPLY' is alphabetic." ;;
	[[:digit:]])		echo "'$REPLY' is a digit." ;;
	[[:graph:]])		echo "'$REPLY' is a visible character." ;;
	[[:punct:]])		echo "'$REPLY' is a punctuation symbol." ;;
	[[:space:]])		echo "'$REPLY' is whitespace character." ;;
	[[:xdigit:]])		echo "'$REPLY' is hexadecimal digit." ;;
esac
```

```
$ chmod 744 case-4-1 
$ ./case-4-1
Type a character > a
'a' is lower case.
```


Modern versions of _bash_ add the `;;&` notation to terminate each action, so now can do this:

```
#!/bin/bash

# case-4-1: test a character

read -n 1 -p "Type a character > "
echo

case "$REPLY" in 
	[[:upper:]])		echo "'$REPLY' is upper case." ;;&
	[[:lower:]])		echo "'$REPLY' is lower case." ;;&
	[[:alpha:]])		echo "'$REPLY' is alphabetic." ;;&
	[[:digit:]])		echo "'$REPLY' is a digit." ;;&
	[[:graph:]])		echo "'$REPLY' is a visible character." ;;&
	[[:punct:]])		echo "'$REPLY' is a punctuation symbol." ;;&
	[[:space:]])		echo "'$REPLY' is whitespace character." ;;&
	[[:xdigit:]])		echo "'$REPLY' is hexadecimal digit." ;;&
esac
```


```
$ ./case-4-1
Type a character > a
'a' is lower case.
'a' is alphabetic.
'a' is a visible character.
'a' is hexadecimal digit.
```