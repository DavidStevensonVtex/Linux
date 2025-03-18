# The AWK Programming Language, © 2024

## Chapter 1: An Awk Tutorial

### 1.1 Getting Started

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

#### Running an Awk Program

Command line:

`awk 'program' input files`

Example:

`$ awk '$3 == 0 { print $1 }' file1 file2`

You can omit the input files from the command line and just type

`awk 'program'`

In this case, Awk will apply the _program_ to whatever you type next on your terminal until you type an end-of-file signal (Control-D on Unix systems).

It may be easier to put the program into a program file:

`awk -f profile optional list of input files`

#### Errors

```
$ awk '$3 == 0 [ print $1, $2 * $3 }' emp.data
awk: cmd. line:1: $3 == 0 [ print $1, $2 * $3 }
awk: cmd. line:1:         ^ syntax error
awk: cmd. line:1: $3 == 0 [ print $1, $2 * $3 }
awk: cmd. line:1:                             ^ syntax error
```

Because of the syntax error, Awk did not try to execute this program.

### 1.2 Simple Output

The rest of this chapter contains a collection of short, typical Awk programs based on manipulation of the `emp.data` file above.

There are only two types of data in Awk: numbers and strings of characters.

Awk reads its input one line at a time and splits each line into fields, where, by default, afield is a sequence of characters that doesn't contain any spaces or tabs. The first field in the current line is called `$1`, the second `$2`, and so forth. The entire line is called `$0`.

#### Printing Every Line

The statement by itself prints the current line, so the program

`{ print }`

prints all of its input on the standard output. Since $0 is the whole line, 

`{ print $0 }`

does the same thing.

#### Printing Specific Fields

`{ print $1, $3 }`

```
$ awk '{ print $1, $3 }' emp.data
Beth 0
Dan 0
Kathy 10
Mark 20
Mary 22
Susie 18
```

Expressions separated by a comma in a `print` statement are, by default, separated by a single space when they are printed.
Each line produced by `print` ends witha newline character.

#### NF, the Number of Fields

It might appear that you must always refer to fields as `$1`, `$2`, and so on, but any expression can be used after \$ to denote a field number; the expression is evaluated and its numeric value is used as a field number. Awk counts the number of fields in the current input line and stores the count in a built-in variable called `NF`.

```
$ awk '{ print NF, $1, $NF }' emp.data
3 Beth 0
3 Dan 0
3 Kathy 10
3 Mark 20
3 Mary 22
3 Susie 18
```
The above program prints the number of fields and the first and last fields of each input line.

#### Computing and Printing

You can also do computations on field values and include the results in what is printed.

The progeram

`{ print $1, $2 * $3 }`

is a typical example.

```
$ awk '{ print $1, $2 * $3 }' emp.data
Beth 0
Dan 0
Kathy 155
Mark 500
Mary 495
Susie 306
```

#### Printing Line Numbers

Awk provides another built-in variable, called NR, that counts the number of lines (records) read so far. We can use NR and \$0 to prefix each line of emp.data with its line number, like this:

`{ print NR, $0 }`

```
$ awk '{ print NR, $0 }' emp.data 
1 Beth        21      0
2 Dan         19      0
3 Kathy       15.50   10
4 Mark        25      20
5 Mary        22.50   22
6 Susie       17      18
```

#### Putting Text in the Output

You can also print words in the mids of fields and computed values, by including quoted strings of characters in the list:

`{ print "total pay for", $1, "is", $2 * $3 }`

```
$ awk '{ print "total pay for", $1, "is", $2 * $3 }' emp.data
total pay for Beth is 0
total pay for Dan is 0
total pay for Kathy is 155
total pay for Mark is 500
total pay for Mary is 495
total pay for Susie is 306
```

### 1.3 Formatted Output 

The `print` statement is meant for quick and easy output. To format the output exacly the way you want it, you may have to use the `printf` statement. As well wee in many subsequent examples, `printf` can produce almost any kind of output, but in this section we'll only show a few of its capabilities. Section A.4.3 gives the details.

#### Lining Up Fields

The `printf` statement has the form:

`printf(format, value-1, value-2, ..., value-n)

Where `format` is a string that contains text to be printed verbatim, interspersed with specifications of how each of the values is to be printed.

`{ printf("total pay for %s is $%.2f\n", $1, $2 * $3) }`

```
$ awk '{ printf("total pay for %s is $%.2f\n", $1, $2 * $3) }' emp.data
total pay for Beth is $0.00
total pay for Dan is $0.00
total pay for Kathy is $155.00
total pay for Mark is $500.00
total pay for Mary is $495.00
total pay for Susie is $306.00
```

Here is another program that prints each employee's name and pay:

`{ printf("%-8s $%6.2f\n", $1, $2 * $3) }`

```
$ awk '{ printf("%-8s $%6.2f\n", $1, $2 * $3) }' emp.data
Beth     $  0.00
Dan      $  0.00
Kathy    $155.00
Mark     $500.00
Mary     $495.00
Susie    $306.00
```

#### Sorting the Output

We can sort awk output using the `sort` command.

`awk '{ printf("%6.2f  %s\n", $2 * $3, $0) }' emp.data | sort`

```
$ awk '{ printf("%6.2f  %s\n", $2 * $3, $0) }' emp.data | sort
  0.00  Beth        21      0
  0.00  Dan         19      0
155.00  Kathy       15.50   10
306.00  Susie       17      18
495.00  Mary        22.50   22
500.00  Mark        25      20
```

### 1.4 Selection

Awk patterns are good for selecting interesting lines from the input for further processing. Since a pattern without an action prints all lines matching the pattern, many Awk programs consist of nothing more than a single pattern.

#### Selection by Comparison

`$2 >= 20`

```
$ awk '$2 >= 20 { print $0 }' emp.data
Beth        21      0
Mark        25      20
Mary        22.50   22
```

#### Selection by Computation

`$2 * $3 > 200 { printf("$%.2f for %s\n", $2 * $3, $1 ) }`

```
$ awk '$2 * $3 > 200 { printf("$%.2f for %s\n", $2 * $3, $1 ) }' emp.data
$500.00 for Mark
$495.00 for Mary
$306.00 for Susie
```

#### Selection by Text Content

`$1 == "Susie"`

```
$ awk '$1 == "Susie"' emp.data
Susie       17      18
```

#### Combination of Patterns

Patterns can be combined with parentheses and the logical opeators &&, ||, and !, which stand for AND, OR, and NOT. The program

`$2 >= 20 || $3 >= 20`

prints those lines where $2 is at least 20 or \$3 is at least 20:

```
$ awk '$2 >= 20 || $3 >= 20' emp.data
Beth        21      0
Mark        25      20
Mary        22.50   22
```

Contrast this with the following program, which consts of two patterns:

```
$2 >= 20
$3 >= 20
```

```
$ awk '$2 >= 20; $3 >= 20' emp.data
Beth        21      0
Mark        25      20
Mark        25      20
Mary        22.50   22
Mary        22.50   22

$ awk '$2 >= 20
> $3 >= 20' emp.data
Beth        21      0
Mark        25      20
Mark        25      20
Mary        22.50   22
Mary        22.50   22
```

#### Data Validation

Real data always contains errors. Awk is an excellent tool for checking that data in in the right format and has reasonable values, a task called _data validation_.

Data validation is essentially negative: instead of printing lines with desirable properties, one prints lines that are suspicious.

The following program uses comparison patterns to apply five plausibility tests to each line of `emp.data`.

**emp.validate**

```
NF != 3     { print $0, "number of fields is not equal to 3" }
$2 < 15     { print $0, "rate is too low" }
$2 > 25     { print $0, "rate exceeds $25 per hour" }
$3 < 0      { print $0, "negative hours worked" }
$3 > 60     { print $0, "too many hours worked" }
```

If there are no errors, there's no output.

```
$ awk -f emp.validate emp.data
```

#### BEGIN and END

The special pattern `BEGIN` matches before the first line of the first input file is read, and `END` matches after the last line of the last file has been processed.

```
$ awk 'BEGIN { print "NAME    RATE        HOURS"; print "" }; { print $0 }' emp.data
NAME    RATE        HOURS

Beth        21      0
Dan         19      0
Kathy       15.50   10
Mark        25      20
Mary        22.50   22
Susie       17      18
```