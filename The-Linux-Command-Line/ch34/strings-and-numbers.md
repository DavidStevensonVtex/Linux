# The Linux Command Line, 2nd Edition, © 2019

## Chapter 34: Strings and Numbers

### Parameter Expansion

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


