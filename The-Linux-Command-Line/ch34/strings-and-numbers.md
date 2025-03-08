# The Linux Command Line, 2nd Edition, © 2019

## Chapter 34: Strings and Numbers

### [Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

#### Basic Parameters

Simple parameters may also be surrounded by braces.

`${a}`

The following doesn't work properly.

```
$ a="foo"
$ echo "$a_file"   # Doesn't work.

$ echo "${a}_file" # works correctly.
foo_file
```

To access the eleventh positional parameter, we can do this:

`${11}`

#### Expansions to Manage Empty Variables

Several parameter expansions are intended to deal with non-existent and empty variables.
These expansions are handy for handling missing positional parameters and assigning default values to parameters.

`${parameter:-word}`

```
$ foo=
$ echo ${foo:-"substitute value if unset"}
substitute value if unset
$ echo $foo

$ foo=bar
$ echo ${foo:-"substitute value if unset"}
bar
$ echo $foo
bar
```

Here is another expansion, in which we use the equal sign instead of a dash:

`${parameter:=word}`

if _parameter_ is unset or empty, this expansion results in the value of word.
In addition, the value of _word_ is assigned to _parameter_.  If _parameter_ is not empty, the expansion results in the value of _parameter_.

```
$ foo=
$ echo "${foo:="default value"}"
default value
$ echo $foo
default value
$ foo=bar
$ echo "${foo:="default value"}"
bar
$ echo $foo
bar
```

_Positional and other special parameters cvannot be assigned this way._

Here we use a quesiton mark:

`${parameter:?word}`

If _parameter_ is unset or empty, this expansion causes the script to exit with an error, and the contents of _word_ are sent to standard error. If _parameter_ is not empty, the expansion results in the value of _parameter_.

```
$ foo=
$ echo ${foo:?"parameter is empty"}
bash: foo: parameter is empty
$ echo $?
1
$ foo=bar
$ echo ${foo:?"parameter is empty"}
bar
$ echo $?
0
```

Here we use a plus sign:

`${parameter:+word}`

If _parameter_ is unset or empty, the expansion results in nothing. If _parameter_ is not empty, the value of _word_ is substituted for _parameter_; however, the value of _parameter_ is not changed.

```
$ foo=
$ echo ${foo:+"substitute value if set"}

$ foo=bar
$ echo ${foo:+"substitute value if set"}
substitute value if set
$ echo $foo
bar
```

#### String Operations

The following expansion:

`${#parameter}`

expands into the length of the string contained by _parameter_. Normally, _parameter_ is a string; however, if _parameter_ is either \@ or \*, then the expansion results in the number of positional parameters.

```
$ foo="This string is long."
$ echo "'$foo' is ${#foo} characters long."
'This string is long.' is 20 characters long.
```

The following expansions are used to extract a portion of the string contained in _parameter_.

```
${parameter:offset}
${parameter:offset:length}
```

The extraction begins at _offset_ characters from the beginning of the string and contnues to the end of the string, unless _length_ is specified.

```
$ foo="This string is long."
$ echo ${foo:5}
string is long.
$ echo ${foo:5:6}
string
```

If the value of _offset_ is negative, it is taken to mean it starts from the end of the string rather than the beginning. Note that negative values must be preceded by a space to prevent confusion with the `${parameter:-word}` expansion. _length_, if present, must not be less than zero.

if _parameter_ is \@, the result of the expansion is _length_ positional parameters, starting _offset_.

```
$ foo="This string is long."
$ echo ${foo: -5}
long.
$ echo $foo
This string is long.
$ echo ${foo: -5:2}
lo
```

The following expansiosn remove a leading portion of the string contained in _parameter_ defined by _pattern_.

```
${parameter#pattern}
${parameter##pattern}
```

_pattern_ is a wildcard pattern like those used in pathname expansion. The difference in the two forms is that the \# form removes the shortest match, while the \#\# form removes the longest match.

```
$ foo=file.txt.zip
$ echo ${foo#*.}
txt.zip
$ echo ${foo##*.}
zip
```

The following are the same as the previous \# and \#\# expansions, except they remove text from the end of the string contained in _parameter_ rather than from the beginning.

```
${parameter%pattern}
${parameter%%pattern}
```

Here is an example:

```
$ foo=file.txt.zip
$ echo ${foo%.*}
file.txt
$ echo ${foo%%.*}
file
```

The following expansions perform a search-and-replace operation upon the contents of _parameter_.

```
${paramter/pattern/string}
${parameter//pattern/string}
${parameter/#pattern/string}
${parameter/%pattern/string}
```

If text is found matching wildcard _pattern_, it is replaced with the contents of _string_.
In the normal form, only the first occurrence of _pattern_ is replaced. In the // form, all occurrences are replace. The /\# form requires that the match occur at the beginning of the string, and the /% form requiers the match to occur at the end of the string. In every form _/string_ may be omitted, causing the text matched by _pattern_ to be deleted.

```
$ foo=JPG.JPG
$ echo ${foo/JPG/jpg}
jpg.JPG
$ echo ${foo//JPG/jpg}
jpg.jpg
$ echo ${foo/#JPG/jpg}
jpg.JPG
$ echo ${foo/%JPG/jpg}
JPG.jpg
```

Expansions can improve the efficiency of scripts by eliminating the use of external programs.

```
$ diff longest-word2 longest-word3
3c3
< # longest-word2: find longest string in a file
---
> # longest-word3: find longest string in a file
10c10
<             len="$(echo -n "$j" | wc -c)"
---
>             len="${#j}"
```

```
$ time ./longest-word2 *
longest-word2: 'longest-word2:' (14 characters)
longest-word3: 'longest-word3:' (14 characters)
strings-and-numbers.md: '${parameter//pattern/string}' (28 characters)

real    0m2.203s
user    0m2.145s
sys     0m0.624s
$ 
$ time ./longest-word3 *
longest-word2: 'longest-word2:' (14 characters)
longest-word3: 'longest-word3:' (14 characters)
strings-and-numbers.md: '${parameter//pattern/string}' (28 characters)

real    0m0.021s
user    0m0.017s
sys     0m0.005s
```

#### Case Conversion

_bash_ has four parameter expansiosn and two _declare_ command options to support the uppercase/lowercase conversion of strings.

A common approach is to _normalize_ the user's input. That is, convert it into a standardized form. We can do this by converting all the characters in the user's input to either lower or uppercase.

```
#!/bin/bash

declare -u upper
declare -l lower

if [[ $1 ]]; then
    upper="$1"
    lower="$1"
    echo "\$upper = $upper"
    echo "\$lower = $lower"
fi
```

```
$ ./ul-declare aBcD
$upper = ABCD
$lower = abcd
```

**Case Conversion Parameter Expansions**

```
Format                   Result

${parameter,,pattern}    Expand the value of paramter into all lowercase. pattern is an optional shell pattern that will limit which characters (for example, [A-F]) will be converted. See the bash man page for a full description of patterns.
${parameter,pattern}     Expand the value of paramter, changing only the first character to lowercase.
${parameter^^pattern}    Expand the value of parameter into all uppercase letters.
${parameter^pattern}     Expand the value of parameter, changing only the first character to uppercase (capitalization).
```

Here is a script that demonstrates these expansions.

```
#!/bin/bash

# ul-param: demonstrate case conversion via parameter expansion

if [[ "$1" ]]; then
    echo "${1,,}"
    echo "${1,}"
    echo "${1^^}"
    echo "${1^}"
fi
```

```
$ ./ul-param aBc
abc
aBc
ABC
ABc
$ ./ul-param AbC
abc
abC
ABC
AbC
```

### Arithmetic Evaluation and Expansion

We looked at arithmetic expansion in Chapter 7.

The basic form for arithmetic expansion is:

`$((expression))`

where _expression_ is a valid arithmetic expression.

This is related to the compound command (( )) used for arithmetic evaluation (truth tests).

#### Number Bases

In Chapter 9, we got a look at octal (base 8) and hexadecimal (base 16) numbers.
In arithmetic expressions, the shell supports integer constants in any base.

**Specifying Different Number Bases**

```
Notation      Description

number        By default, numbers without any notation are treated as decimal (base 10) integers.
0number       In arithmetic expressions, numbers with a leading zero are considered octal.
0xnumber      Hexadecimal notation.
base#number   number is in base.
```

```
$ echo $((0xff))
255
$ echo $((2#11111111))
255
$ echo $((2#111111111111))
4095
```

#### Unary Operators

There are two unary operators, + and -, which are used to indicate whether a number is positive or negative.

#### Simple Arithmetic

**Arithmetic Operators**

```
Operator   Description

+          Addition
-          Subtraction
*          Multiplication
/          Integer division
**         Exponentiation
%          Modulo (Remainder)
```

Since the shell's arithmetic operates only on integers, the resuls of division are only whole numbers.

```
$ echo $(( 5 / 2 ))
2
$ echo $(( 5 % 2 ))
1
```

```
#!/bin/bash

# modulo: demonstrate the modulo operator

for (( i = 0; i <= 20 ; i = i + 1 )); do
    remainder=$((i % 5))
    if (( remainder == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
echo
```

```
$ ./modulo
<0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20> 
```

#### Assignment

Arithmetic expressiosn may perform assignment.

```
$ foo=
$ echo "\$foo = $foo"
$foo = 
$ if (( foo = 5 )); then echo "It is true. \$foo = $foo"; fi
It is true. $foo = 5
$ echo $foo
5
```

In an arithmetic expression, = is an assignment, == is a test for equality.

**Assignment Operators**

```
Notation                 Description

parameter = value        Simple assignment. Assigns value to parameter.
parameter += value       Addition. Equivalent to parameter = parameter + value.
parameter -= value       Subtraction. Equivalent to parameter = parameter + value.
parameter *= value       Multiplication. Equivalent to parameter = parameter * value.
parameter /= value       Division. Equivalent to parameter = parameter / value.
parameter %= value       Modulo. Equivalent to parameter = paramter % value.
parameter++              Variable post-increment. Equivalent to parameter = paramter + 1.
parameter--              Variable post-decrement. Equivalent to paramter = paramter - 1
++parameter              Variable pre-increment.  Equivalent to paramter = parameter + 1.
--parameter              Variable pre-decrement.  Equivalent to paramter = paramter - 1
```

```
$ foo=1
$ echo $((foo++))
1
$ echo $foo
2
```

```
$ foo=1
$ echo $((++foo))
2
$ echo $foo
2
```

```
#!/bin/bash

# modulo2: demonstrate the modulo operator

for (( i = 0; i <= 20 ; i = i + 1 )); do
    if (( (i % 5) == 0 )); then
        printf "<%d> " "$i"
    else
        printf "%d " "$i"
    fi
done
echo
```

```
$ ./modulo2
<0> 1 2 3 4 <5> 6 7 8 9 <10> 11 12 13 14 <15> 16 17 18 19 <20>
```

#### Bit Operations

```
Operator    Description
~           Bitwise negation. Negate all bits in a number.
<<          Left bitwise shift.  Shift all the bits in a number to the left.
>>          Right bitwise shift. Shift all bits in a number to the right.
&           Bitwise AND. Perform an AND operation on all bits in two numbers.
|           Bitwise OR. Perform an OR operation on all the bits in two numbers.
^           Bitwise XOR. Perform an exclusive OR operation on all the bits in two numbers.
```

```
$ for ((i=0;i<8;++i)); do echo $((1<<i)); done
1
2
4
8
16
32
64
128
```

#### Logic

As we discovered in Chapter 27, the (( )) compound command supports a variety of comparison operators.

```
Operator    Description

<=                   Less than or equal to.
>=                   Greater than or equal to.
<                    Less than.
>                    Greater than.
==                   Equal to.
!=                   Not equal to.
&&                   Logical AND.
||                   Logical OR.
expr1?expr2:expr3    Comparison (ternary) operator. If expression expr1 evaluates to nonzero (arithmetic true), then expr2; else expr3.
```

```
$ if ((1)); then echo "true"; else echo "false"; fi
true
$ if ((0)); then echo "true"; else echo "false"; fi
false
```

```
$ a=0
$ ((a<1?++a:--a))
$ echo $a
1
$ ((a<1?++a:--a))
$ echo $a
0
```

Please note that assignment within the expression is not straightforward. When attempted, _bash_ will display an error.

```
$ a=0
$ ((a<1?a+=1:a-=1))
bash: a<1?a+=1:a-=1: attempted assignment to non-variable (error token is "-=1")
```

The problem can be mitigated by surrounding the assignment expression with parentheses.

```
$ a=0
$ ((a<1?(a+=1):(a-=1)))
$ echo $a
1
```

```
#!/bin/bash

# arith-loop: script to demonstrate arithmetic operators

finished=0
a=0
printf "a\ta**2\ta**3\n"
printf "=\t====\t====\n"

until ((finished)); do
    b=$((a**2))
    c=$((a**3))
    printf "%d\t%d\t%d\n" "$a" "$b" "$c"
    ((a<10?++a:(finished=1)))
done
```

```
$ chmod 744 arith-loop 
$ ./arith-loop 
a       a**2    a**3
=       ====    ====
0       0       0
1       1       1
2       4       8
3       9       27
4       16      64
5       25      125
6       36      216
7       49      343
8       64      512
9       81      729
10      100     1000
```