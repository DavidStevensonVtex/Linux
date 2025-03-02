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

#### for loop

```
#!/bin/bash

# for-loop-1

for fruit in apple banana cherry
do
  echo "I like $fruit"
done
```

```
$ chmod 744 for-loop-1 
$ ./for-loop-1
I like apple
I like banana
I like cherry
```

```
#!/bin/bash

# for-loop-2

for i in {1..5}
do
  echo "Number: $i"
done
```

```
$ chmod 744 for-loop-2
$ ./for-loop-2
Number: 1
Number: 2
Number: 3
Number: 4
Number: 5
```

### Reading Files with Loops

_while_ and _until_ can process standard input. This allows files to be processed with _while_ and _until_ loops.

To redirect a file to a loop, we place the redirection operator after the _done_ statement. The loop will use _read_ to input the fields from the redirected file.

```
#!/bin/bash

# while-read: read lines from a file

while read distro version release; do
	printf "Distro: %s\tVersion: %s\tReleased: %s\n" \
		"$distro" \
		"$version" \
		"$release"
done < distros.txt
```

```
$ chmod 744 while-read
$ ./while-read
Distro: SUSE    Version: 10.2   Released: 12/07/2006
Distro: Fedora  Version: 10     Released: 11/25/2008
Distro: SUSE    Version: 11.0   Released: 06/19/2008
Distro: Ubuntu  Version: 8.04   Released: 04/24/2008
Distro: Fedora  Version: 8      Released: 11/08/2007
Distro: SUSE    Version: 10.3   Released: 10/04/2007
Distro: Ubuntu  Version: 6.10   Released: 10/26/2006
Distro: Fedora  Version: 7      Released: 05/31/2007
Distro: Ubuntu  Version: 7.10   Released: 10/18/2007
Distro: Ubuntu  Version: 7.04   Released: 04/19/2007
Distro: SUSE    Version: 10.1   Released: 05/11/2006
Distro: Fedora  Version: 6      Released: 10/24/2006
Distro: Fedora  Version: 9      Released: 05/13/2008
Distro: Ubuntu  Version: 6.06   Released: 06/01/2006
Distro: Ubuntu  Version: 8.10   Released: 10/30/2008
```

```
#!/bin/bash

# while-read2: read lines from a file

sort -k 1,1 -k 2n distros.txt | while read distro version release; do
	printf "Distro: %s\tVersion: %s\tRelease: %s\n" \
		"$distro" \
		"$version" \
		"$release"
done
```

```
$ chmod 744 while-read2
$ ./while-read2
Distro: Fedora  Version: 5      Release: 03/20/2006
Distro: Fedora  Version: 6      Release: 10/24/2006
Distro: Fedora  Version: 7      Release: 05/31/2007
Distro: Fedora  Version: 8      Release: 11/08/2007
Distro: Fedora  Version: 9      Release: 05/13/2008
Distro: Fedora  Version: 10     Release: 11/25/2008
Distro: SUSE    Version: 10.1   Release: 05/11/2006
Distro: SUSE    Version: 10.2   Release: 12/07/2006
Distro: SUSE    Version: 10.3   Release: 10/04/2007
Distro: SUSE    Version: 11.0   Release: 06/19/2008
Distro: Ubuntu  Version: 6.06   Release: 06/01/2006
Distro: Ubuntu  Version: 6.10   Release: 10/26/2006
Distro: Ubuntu  Version: 7.04   Release: 04/19/2007
Distro: Ubuntu  Version: 7.10   Release: 10/18/2007
Distro: Ubuntu  Version: 8.04   Release: 04/24/2008
Distro: Ubuntu  Version: 8.10   Release: 10/30/2008
```