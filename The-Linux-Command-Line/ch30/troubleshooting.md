# The Linux Command Line, 2nd Edition, © 2019

## Chapter 30: Troubleshooting

### Syntactic Errors

One general class of errors is _syntactic_. Syntactic errors involve mistypign some element of shell syntax.

```
#!/bin/bash

# trouble: script to demonstrate common errors

number=1

if [ $number = 1 ]; then
	echo "Number is equal to 1."
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 trouble
$ ./trouble
Number is equal to 1.
```

#### Missing Quotes

```
#!/bin/bash

# missing-quotes: script to demonstrate common errors

number=1

if [ $number = 1 ]; then
	echo "Number is equal to 1.
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 missing-quotes 
$ ./missing-quotes 
./missing-quotes: line 10: unexpected EOF while looking for matching `"'
./missing-quotes: line 12: syntax error: unexpected end of file
```

Text editors like vim (:syntax on) or Visual Studio Code can indicate text it believes to be a part of a quote, and if the quote doesn't end where expected, it can indicate a missing quote character.

#### Missing or Unexpected Tokens

```
#!/bin/bash

# missing-or-unexpected-tokens: script to demonstrate common errors

number=1

if [ $number = 1 ] then
	echo "Number is equal to 1."
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 missing-or-unexpected-tokens 
$ ./missing-or-unexpected-tokens 
./missing-or-unexpected-tokens: line 9: syntax error near unexpected token `else'
./missing-or-unexpected-tokens: line 9: `else'
```

The error message points to a line that occurs later than the syntax error, which is the missing semi-colon before the "then" keyword.

#### Unanticipated Expansions

```
#!/bin/bash

# unanticipated-expansions: script to demonstrate common errors

number=

if [ $number = 1 ]; then
	echo "Number is equal to 1."
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 unanticipated-expansions 
$ ./unanticipated-expansions 
./unanticipated-expansions: line 7: [: =: unary operator expected
Number is not equal to 1.
```

This problem can be corrected by adding quotes around the first argument in the _test_ command.

`if [ "$number" = 1 ]; then`

This corrects the syntax error, but the missing number assignment produces unuseful results.

```
$ ./unanticipated-expansions 
Number is not equal to 1.
```

Make it a rule to always enclose variables and command substitutions in double quotes unless word splitting is needed.

### Logical Errors

Unlike synactical errors, _logical errors_ do not prevent a script from running.
The script will run, but will produce incorrect results.

* Incorrect conditional expressions
* "Off by one" errors.
* Unanticipated situations.

#### Defensive Programming

It is important to verify assumptions when programming.

The following script works, as long as the directory named in the variable, _dir\_name_ exists.

```
cd $dir_name
rm *
```

`cd "$_dir_name" && rm *`

This way, if the _cd_ command fails, the _rm_ command is not carried out.
This is better but still leaves open the possibility that the variable, _dir\_name_ is unset or empty, which would result in the files in the user's home directory being deleted. This could also be avoided by checking to see that _dir\_name_ actually contains the name of an existing directory.

`[[ -d "$dir_name" ]] && cd "$dir_name" && rm *`

Oten it is best to include logic to terminate the script and report an error when a situation such as the one show previously occurs.

```
#!/bin/bash

# safely-delete-files

# Delete files in directory $dir_name

if [[ ! -d "$dir_name" ]]; then
	echo "No such directory: '$dir_name'" >&2
	exit 1
fi
if ! cd "$dir_name"; then
	echo "Cannot cd to '$dir_name'" >&2
	exit 1
fi
if ! rm *; then
	echo "File deletion failed. Check results" >&2
	exit 1
fi
```

#### Watch Out for Filenames

Unix is extremely permissive about file names.

Everything except slash (/) and a null byte (a zero byte) is permissible in file names, including spaces, tabs, line feeds, leading hyphens, carriage returns, and so on.

Change:

`rm *`

to:

`rm ./*`

This will prevent a filename starting with a hyphen from being interpreted as a command option.

As a general rule, always precede wildcards (such as \* and \?) with `./` to prevent misinterpretation by commands.

#### Verifying Input

A general rule of good programming is that if a program accepts input, it must be able to deal with anything it receives. This means input must be carefully screened to ensure that only valid input is accepted for further processing.

One script contained the following test to verify a menu selection:

`[[ $REPLY =~ ^[0-3]$ ]]`

### Testing

Testing is an important step in every kind of software development, including scripts. There is a saying in the open source world, "release early, release often," that reflects this fact.

```
#!/bin/bash

# test-rm: echo rm * to test before actually executing statement

dir_name=$1
if [[ -d "$dir_name" ]]; then
	if cd "$dir_name"; then
		echo rm *	# TESTING
	else
		echo "cannot cd to '$dir_name'" >&2
		exit 1
	fi
else
	echo "no such directory: '$dir_name'" >&2
	exit 1
fi
exit # TESTING
```

```
$ chmod 744 test-rm
$ ./test-rm ".."
no such directory: ''
$ ./test-rm ..
no such directory: ''
$ ./test-rm ".."
rm ch01 ch02 ch03 ch04 ch05 ch06 ch07 ch08 ch09 ch10 ch11 ch12 ch13 ch14 ch15 ch16 ch17 ch18 ch19 ch20 ch21 ch22 ch23 ch24 ch25 ch26 ch27 ch28 ch29 ch30
```

#### Test Cases

To perform useful testing, it's important to develop and apply good _test cases_. This is done by carefully choosing input data or operating conditions that reflect _edge_ and _corner_ cases.

* dir\_name contains the name of an existing directory.
* dir\_name contains the name of a non-existent directory.
* dir\_name is empty.

```
$ ./test-rm "../ch30"
rm missing-or-unexpected-tokens missing-quotes safely-delete-files test-rm trouble troubleshooting.md unanticipated-expansions
$ ./test-rm "../non-existent-directory"
no such directory: '../non-existent-directory'
$ ./test-rm ""
no such directory: ''
```

### Debugging

#### Finding the Problem Area

In some scripts, particularly long ones, it is sometimes useful to isolate the area of the script that is related to the problem.

One technique that can be used to isolate code is "commeting out" sectiosn of a script.

```
#!/bin/bash

# test-rm: echo rm * to test before actually executing statement

dir_name=$1
if [[ -d "$dir_name" ]]; then
	if cd "$dir_name"; then
		echo rm *	# TESTING
	else
		echo "cannot cd to '$dir_name'" >&2
		exit 1
	fi
# else
# 	echo "no such directory: '$dir_name'" >&2
# 	exit 1
fi
exit # TESTING
```

By placing comment symbols at the beginning of each line in a logical section of a script, we prevent that section from being executed. Testing can then be performed again to see whether the removal of the code has any impact on the behavior of the bug.

#### Tracing

To view the actual flow of the program, we use a technique called _tracing_.

One tracing method involves placing informative messages in a script that display the location of execution.

```
#!/bin/bash

# test-rm: echo rm * to test before actually executing statement

dir_name=$1
echo "preparing to delete files" >&2
if [[ -d "$dir_name" ]]; then
	if cd "$dir_name"; then
		echo "deleting files" >&2
		rm *
	else
		echo "cannot cd to '$dir_name'" >&2
		exit 1
	fi
else
	echo "no such directory: '$dir_name'" >&2
	exit 1
fi
echo "file deletion complete" >&2
```