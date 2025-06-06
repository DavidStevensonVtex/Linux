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

### 1.5 Computing with Awk

An action is a sequence of statements separated by newlines or semicolons.  In these statements, you can use not only the built-in variables like NF, but you can create your own variables performing calculations, storing data, and the like. In Awk, created variables are not declared; they come into existence when you use them.

#### Counting

This program uses a variable emp to count the number of employees who have worked more than 15 hours:

```
$3 > 15 { emp = emp + 1 }
END     { print emp, "employees worked more than 15 hours." }
```

```
$ awk '$3 > 15 { emp = emp + 1 }
> END     { print emp, "employees worked more than 15 hours." }' emp.data
3 employees worked more than 15 hours.
```

Statements like 

`emp = emp + 1`

occur so frequently that C and languages inspired by it will provide an increment operator ++ as a shorthand equivalent.

```
$3 > 15 { emp++ }
END     { print emp, "employees worked more than 15 hours." }
```

```
$ awk '$3 > 15 { emp++ }
> END     { print emp, "employees worked more than 15 hours." }' emp.data
3 employees worked more than 15 hours.
```

#### Computing Sums and Averages

To count the number of employees, we could isntead use the built-in variable NR, which holds the number of lines read so far; its value at the end of all input is the total number of lines read.

`END { print NR, "employees" }`

```
$ awk 'END { print NR, "employees" }' emp.data
6 employees
```

Here is a program that uses NR to compute the average pay.

```
      { pay = pay + $2 * $3 }
END   { print NR, "employees"
        print "total pay is", pay
        print "average pay is", pay/NR
      }
```

```
$ awk '      { pay = pay + $2 * $3 }
> END   { print NR, "employees"
>         print "total pay is", pay
>         print "average pay is", pay/NR
>       }' emp.data
6 employees
total pay is 1456
average pay is 242.667
```

Clearly, printf could be used to produce neater output, for example to produce exactly two digits after the decimal point.

The operator += is an abbreviation for incrementing a variable; it increments the variable on its left by the value of the expression on its right, so the first line of the program above could be more compactly written as:

`     { pay += $2 * $3 }`

#### Handling Text

Awk variables can hold strings of characters aw well as numbers. This program finds the employee who is paid the most per hour:

```
$2 > maxrate { maxrate = $2; maxemp = $1 }
END { print "highest hourly rate:", maxrate, "for", maxemp }
```

```
$ awk '$2 > maxrate { maxrate = $2; maxemp = $1 }
> END { print "highest hourly rate:", maxrate, "for", maxemp }' emp.data
highest hourly rate: 25 for Mark
```

In this program the variable _maxrate_ holds a numeric value, while the variable `maxemp` holds a string.

#### String Concatenation

New strings may be created by pasting together old ones; this operation is called _concatenation_.

The string concatenation operation is represented in an Awk program by writing wring values one after the other; there is no explicit concatenation operator.

An example:

```
    { names = names $1 " " }
END { print names }
```

```
$ awk '    { names = names $1 " " }
> END { print names }' emp.data
Beth Dan Kathy Mark Mary Susie 
```

#### Printing the Last Input Line

Built in variables like NR retain their value in an END action, and so do fields like $0. The program:

`END { print $0 }`

is one way to print the last line.

```
$ awk 'END { print $0 }' emp.data
Susie       17      18
```

#### [Built-in Functions](https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html)

Besides arithmetic functions for square roots, logarithms, random numbers, and the like, there are also functions that manipulate text. One of these is length, which counts the number of characters in a string.
For example, this program computes the length of each person's name:

`{ print $1, length($1) }`

```
$ awk '{ print $1, length($1) }' emp.data
Beth 4
Dan 3
Kathy 5
Mark 4
Mary 4
Susie 5
```

#### Counting Lines, Words and Characters

This program uses length, NF and NR to count the number of lines, words, and characters in the input, like the unix program wc.

```
{ nc += length($0) + 1
  nw += NF }
END { print NR, "lines,", nw, "words,", nc, "characters" }
```

```
$ awk '{ nc += length($0) + 1
>   nw += NF }
> END { print NR, "lines,", nw, "words,", nc, "characters" }' emp.data
6 lines, 18 words, 136 characters
```

### 1.6 Control-Flow Statements

Awk provides an `if-else` statement for making decisiosn and several statements for writing loops, all modeled on those found in the C programming language. They can only be used in actions.

#### If-Else Statement

The fololowing program computes the total and average pay of employees making more than $30 an hour. It uses an `if` to defined against any potential division by zero in computing the average pay.

```
$2 > 30 { n++; pay += $2 * $3 }
END   { if (n > 0) {
          print n, "high-pay employees, total pay is", pay, " average pay is", pay/n
        } else {
          print "No employees are paid more than $30/hour"
        } 
      }
```

Note also that if an `if` statement controls only a single statement, no braces are necessary, though they are if more than one statement is controlled. This version

```
$ awk '$2 > 30 { n++; pay += $2 * $3 }
> END   { if (n > 0) {
>           print n, "high-pay employees, total pay is", pay, " average pay is", pay/n
>         } else {
>           print "No employees are paid more than $30/hour"
>         } 
>       }' emp.data
No employees are paid more than $30/hour
```

uses braces around both `if` and `else` parts to make it clear what the scope of control is. In general, it's good practice to use such redundant braces.

#### While Statement

A `whilte` statement has a condition and a body. The statements in the body are performed repeatedly while the condition is true.

```
$ cat interest1.awk
# interest1 - compute compound interest
#   input: amount rate years
#   output: compounded value at the end of each year
{
  i = 1
  while (i <= $3) {
    printf("\t%.2f\n", $1 * (1 + $2) ^ i)
    i++
  }
}
```

```
$ awk -f interest1.awk
1000 .05 5
        1050.00
        1102.50
        1157.63
        1215.51
        1276.28
1000 .10 5
        1100.00
        1210.00
        1331.00
        1464.10
        1610.51
```

#### For Statement

```
$ cat interest2.awk
# interest2 - compute compound interest
#   input: amount rate years
#   output: compounded value at the end of each year
{
  for (i = 1; i <= $3 ; i++) {
    printf("\t%.2f\n", $1 * (1 + $2) ^ i)
  }
}
```

```
$ awk -f interest2.awk
1000 0.05 5
        1050.00
        1102.50
        1157.63
        1215.51
        1276.28
1000 0.10 5
        1100.00
        1210.00
        1331.00
        1464.10
        1610.51
```

#### FizzBuzz

```
$ cat fizzbuzz.awk 
BEGIN {
    for (i = 1; i <= 100; i++) {
        if (i%15 == 0)      # divisible by both 3 and 5
            print i, "fizzbuzz"
        else if (i%5 == 0)
            print i, "buzz"
        else if (i%3 == 0)
            print i, "fizz"
        else
            print i
    }
}
```

All of the computation is done in the BEGIN block; any filename arguments are simply ignored.

### 1.7 Arrays

Awk provides arrays for storing groups of related values.
This program prints its input in reverse order by line.

```
$ cat reverse.awk
# reverse - print input in reverse order by lines

        { line[NR] = $0 }   # remember each input line
END     {
    for ( i = NR; i > 0; i--) {
        print line[i]
    }
}
```

```
$ awk -f reverse.awk emp.data
Susie       17      18
Mary        22.50   22
Mark        25      20
Kathy       15.50   10
Dan         19      0
Beth        21      0
```

The subscripts in this example are numeric, but one of the most useful features of Awk is that array subscripts are not limited to numeric values; they can be arbitrary strings of characters.

### 1.8 Useful One-Liners

Print the total Number of input lines:

`END { print NR }`

Print the first 10 input lines:

`NR <= 10`

Print the tenth input line:

`NR == 10`

Print every tenth input line, starting with line 1:

`HR % 10 == 1`

Print the last field of eery input line:

`{ print $NF }`

Print every input line with more than four fields:

`NF > 4`

Print every input line that does not have exactly four fields:

`NF != 4`

Print every input line in which the last field is greater than 4:

`$NF > 4`

Print the total number of fields on all input line:

```
    { nf += NF }
END { print nf }
```

Print the total number of lines that contain Beth:

```
/Beth/  { nlines++ }
END     { print lines }
```

Print the largest first field and the line that contains it (assumes some $1 is positive):

```
$1 > max  { max = $1; maxline = $0 }
END       { print max, maxline }
```

Print every line that has at least one field (that is, not empty or all spaces):

`NF > 0`

Print every line longer than 80 characters:

`length($0) > 80`

Print first two fields, in opposite order, of every line:

`{ print $2, $1 }`

Interchange the first two fields of every line, and then print the line:

`{ temp = $1; $1 = $2; $2 = temp; print }`

Print every line preceded by its line number:

`{ print NR, $0 }`

Print every line with the first field replaced by the line number:

`{ $1 = nr; PRINT }`

Print every line after erasing the second field:

`{ $2 = ""; print }`

Print in reverse order the fields of every line:

```
{ for ( i = NF; i > 0; i--)
    printf("%s ", $i)
  printf("\n")
}
```

Print the sums of the fields of every line:

```
{ sum = 0
  for (i = 1; i <= NF ; i++) sum = sum + $i
  print sum
}
```

Add up all fields in all lines and print the sum:

```
    { for (i = 1; i <= NF; i++) sum = sum + $i }\
END { print sum }
```

Print every line after replacing each field by its absolutin value:

```
{ for (i = 1; i <= NF ; i++ ) if ($i < 0) $i = -$i
  print
}
```