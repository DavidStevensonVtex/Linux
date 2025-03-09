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

```
$ days=(Sun Mon Tue Wed Thu Fri Sat)
$ echo $days
```

It is also possible to assign values to a specific element by specifying the subscript for each value.

`$ days=([0]=Sun [1]=Mon [2]=Tue [3]=Wed [4]=Thur [5]=Fri [6]=Sat)`

