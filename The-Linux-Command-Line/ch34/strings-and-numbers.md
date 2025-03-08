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