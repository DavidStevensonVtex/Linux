# The Linux Command Line, 2nd Edition, © 2019

## Chapter 29: Flow Control: Looping with While/Until

### while

```
#!/bin/bash

# while-count: display a series of numbers

count=1

while (( "$count" <= 5 )); do
	echo "$count"
	count=$((count + 1))
done
echo "Finished."
```

```
$ chmod 744 while-count
$ ./while-count
1
2
3
4
5
Finished.
```
`while commands; do commands; done`

Like _if_, _while_ evaluates the exit status of a list of commands. As long as the exit status is zero, it performs the commands inside the loop.

We can use a _while loop_ to improve the _read-menu _ program.

```
#!/bin/bash

# read-menu: a menu driven system information program

DELAY=3		# Number of seconds to display results.

while [[ "$REPLY" != 0 ]]; do
	clear
	echo "
	Please Select:

	1. Display System Information
	2. Display Disk Space
	3. Display Home Space Utilization
	0. Quit
	"

	read -p "Enter selection [0-3] > "

	if [[ "$REPLY" =~ ^[0-3]$ ]]; then
		if [[ "$REPLY" == 0 ]]; then
			echo "Program terminated."
			exit
		fi
		if [[ "$REPLY" == 1  ]]; then
			echo "Hostname: $HOSTNAME"
			uptime
		fi
		if [[ "$REPLY" == 2 ]]; then
			df -h
		fi
		if [[ "$REPLY" == 3 ]]; then
			if [[ "$(id -u)" -eq 0 ]]; then
				echo "Home Space Utilization (All Users)"
				du -sh /home/*
			else
				echo "Home Space Utilization ($USER)"
				du -sh "$HOME" 2>/dev/null
			fi
		fi
	else
		echo "Invalid entry." >&2
		exit 1
	fi
	sleep "$DELAY"
done
echo "Program terminated.
```

### Breaking Out of a Loop

```
#!/bin/bash

# while-menu2: a menu driven system information program

DELAY=3		# Number of seconds to display results.

while true; do
	clear
	echo "
	Please Select:

	1. Display System Information
	2. Display Disk Space
	3. Display Home Space Utilization
	0. Quit
	"

	read -p "Enter selection [0-3] > "

	if [[ "$REPLY" =~ ^[0-3]$ ]]; then
		if [[ "$REPLY" == 0 ]]; then
			echo "Program terminated."
			exit
		fi
		if [[ "$REPLY" == 1  ]]; then
			echo "Hostname: $HOSTNAME"
			uptime
			sleep "$DELAY"
			continue
		fi
		if [[ "$REPLY" == 2 ]]; then
			df -h
			sleep "$DELAY"
			continue
		fi
		if [[ "$REPLY" == 3 ]]; then
			if [[ "$(id -u)" -eq 0 ]]; then
				echo "Home Space Utilization (All Users)"
				du -sh /home/*
			else
				echo "Home Space Utilization ($USER)"
				du -sh "$HOME" 2>/dev/null
			fi
			sleep "$DELAY"
			continue
		fi
		if [[ "$REPLY" == 0 ]]; then
			break
		fi
	else
		echo "Invalid entry." >&2
		exit 1
	fi
done
echo "Program terminated.
```

#### until

The _until_ compound command is much like _while_, except instead of exiting a loop when a non-zero exit status is encountered, it does the opposite. An _until loop_ continues until it receives a zero exit status.

```
#!/bin/bash 

# until-count: display a series of numbers

count=1

until [[ "$count" -gt 5 ]]; do
	echo "$count"
	count=$((count + 1))
done
echo "Finished."
```

```
$ chmod 744 until-count
$ ./until-count
1
2
3
4
5
Finished.
```