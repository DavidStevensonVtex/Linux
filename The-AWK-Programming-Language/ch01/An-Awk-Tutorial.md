# The AWK Programming Language, © 2024

## Chapter 1: An Awk Tutorial

### 1.1. Getting Started

The file `emp.data` contains three fields of information about your employees: name, pay rate in dollars per hour, and number of hours worked.

```
$ cat emp.data
Beth        21      0
Dan         19      0
Kathy       15.50   10
Mark        25      20
Mary        22.50   22
Susie       17      18
```

```
$ awk '$3 > 0 { print $1, $2 * $3 }' emp.data
Kathy 155
Mark 500
Mary 495
Susie 306
```

The part inside the quotes is the complete Awk program. It consists of a single _pattern-action statement_.

```
$ awk '$3 == 0 { print $1, $2 * $3 }' emp.data
Beth 0
Dan 0
```

#### The Structure of an Awk Program

An Awk program is a sequence of one or more pattern-action statements:

```
pattern1  { action1 }
pattern2  { action2 }
```

The basic operation of Awk is to scan a sequence of input lines, from any number of iles, one after another, searching for lines that are _matched_ by any of the patterns in the program.

Every input line is tested against each of the patterns in turn.

If a pattern has no action, the entire line is printed.

```
$ awk '$3 == 0' emp.data
Beth        21      0
Dan         19      0
```