# The Linux Command Line, 2nd Edition, © 2019

## Chapter 35: Arrays

Arrays are a data structure that hold multiple values.

### What Are Arrays?

Arrays are variables that hold more than one value at a time.

A spreadsheet acts like a _two dimensional array_. It has both rows and columns.
An array has cells, which are called _elements_, and each element contains data.
An individual array element is accessed using an address called an _index_ or _subscript_.

Most programming languages support _multidimensional arrays_.

Arrays in _bash_ are limited to a single dimension.
Array support first appeared in _bash_ version 2.

### Creating an Array

Array variables are named just like other _bash_ variables and are created automatically when they are accessed.

```
$ a[1]=foo
$ echo ${a[1]}
foo
```

An array can also be created with the _declare_ command.

`$ declare -a a`

### Assigning Values to an Array

Single values may be assigned using the following syntax:

`name[subscript]=value`

Note that an array's first element is subscript zero, not one.

Multiple values may be assigned using the following syntax:

`name=(value1 value2 ...)`

`$ days=(Sun Mon Tue Wed Thu Fri Sat)`

It is also possible to assign values to a specific element by specifying the subscript for each value.

`$ days=([0]=Sun [1]=Mon [2]=Tue [3]=Wed [4]=Thur [5]=Fri [6]=Sat)`

### Accessing Array Elements

```
#!/bin/bash

# hours: script to count files by modification time

usage() {
	echo "usage: ${0##*/} directory" >&2:
}

# Check that argument is a directory
if [[ ! -d "$1" ]]; then
	usage
	exit 1
fi

# Initialize array
for i in {0..23}; do hours[i]=0; done

#  Collect data
for i in $(stat -c %y "$1"/* | cut -c 12-13); do
	j=${i#0}	# Remove leading "0" if any
	((++hours[j]))
	((++count))
done

# Display data
echo -e "Hour\tFiles\tHour\tFiles"
echo -e "----\t-----\t----\t-----"
for i in {0..11}; do
	j=$((i + 12))
	printf "%02d\t%d\t%02d\t%d\n" \
		"$i" \
		"${hours[i]}" \
		"$j" \
		"${hours[j]}"
done
printf "\nTotal files = %d\n" $count
```

### Array Operations

#### Outputting the Entire Contents of an Array

The subscripts \* and \@ can be used to access every element in an array.
As with positional parameters, the \@ notation is the more useful of the two.


```
$ animals=("a dog" "a cat" "a fish")
$ for i in ${animals[*]}; do echo $i; done
a
dog
a
cat
a
fish
$ for i in ${animals[@]}; do echo $i; done
a
dog
a
cat
a
fish
$ echo "${animals[*]}"
a dog a cat a fish
$ echo "${animals[@]}"
a dog a cat a fish
$ for i in "${animals[*]}"; do echo $i ; done
a dog a cat a fish
$ for i in "${animals[@]}"; do echo $i ; done
a dog
a cat
a fish
```

We use four loops to see the effect of word splitting on the array contents.

The \* notation results in a single word containing the array's contents, while the \@ notation results in three two-word strings, which matches the array's "real" contents.

#### Determining the Number of Array Elements

Using parameter expansion, we can determine the number of elements in an array in much the same way as finding the length of a string.

```
$ a[100]=foo
$ echo ${#a[@]}  # number of array elements
2
$ echo ${#a[100]}  # length of element 100
3
$ for i in "${a[@]}"; do echo $i ; done
foo
foo
$ echo ${a[1]}, ${a[100]}
foo, foo
```

#### Finding the Subscripts Used by an Array

As _bash_ allows arrays to contain "gaps" in the assignment of subscripts, it is sometimes useful to determine which elements actually exist. This can be done with a parameter expansion using the following forms:

```
${!array[*]}
${!array[@]}
```

```
$ echo ${!a[*]}
1 100
$ echo ${!a[@]}
1 100
```

```
$ foo=([2]=a [4]=b [6]=c)
$ for i in "${foo[@]}"; do echo $i ; done
a
b
c
$ for i in "${!foo[@]}"; do echo $i ; done
2
4
6
```

#### Adding Elements to the End of an Array

By using the += assignment operator, we can automatically append values to the end of an array.

```
$ foo=(a b c)
$ echo ${foo[@]}
a b c
$ foo+=(d e f)
$ echo ${foo[@]}
a b c d e f
```