# sed & awk, 2nd Edition, © 1997

## Chapter 5: Basic sed Commands

The sed command set consists of 25 commands. In this chapter, we introduce four new editing commands: **d** (delete), **a** (append), **i** (insert), and **c** (change). We also look at ways to change the flow control (i.e. determine which command is executed next) with a script.

### About the Syntax of sed Commands

A line address is optional with any command. Most sed commands can accept two comma-separated addresses that indicate a range of lines.

Conventions:

`[address]command`

A few commands accept only a single line address. They cannot be applied to a range of lines. The convention for them is:

`[line-address]command`

Remember also that commands can be grouped at the same address by surrounding the list of commands in braces:

```
address{
    command1
    command2
    command3
}
```

Each command can have its own address and multiple levels of grouping are permitted.
Also, as you can see from the indentation of the commands inside the braces, spaces, and tabs at the beginning of lines are permitted.

Whe sed is unable to understand a command, it prints the message "Command garbled." One subtle syntax error is adding aspace after a command. This is not allowed; the end of a command must be at the end of a line.

Multiple sed commands can be placed on the same line if each one is separated by a semicolon.

Placing multiple commands on the same line is highly discouraged because sed scripts are difficult enough to read even when each command is written on its own line.

### Comment

You can use a comment to document a script by describing its purpose.

In System V's version of sed, a comment is permitted only on the first line.

The number sign (\#) must be the first character on the line.

If necessary, the comment can be continued on multiple lines by ending the preceding line with a backslash. For consistency, you might begin the continuation line with a \# so the line's purpose is obvious.

If the next character following \# is **n**, the script will not automatically produce output. It is equivalent to specify the command-line option `-n`. Under the POSIX standard, \#n used in this way must be the first two characters in the file.

### Substitution

`[address]s/pattern/replacement/flags`

The flats that modify the substitution are:

```
n       A number (1 to 512) indicating that a replacement should be made for only the nth occurrence of the pattern.
g       Make thechanges globally on all occurrences in the pattern space. Normally only the first occurrence is replace.d
p       Print the contents of the pattern space
w file  Write the contents of the pattern space to file
```

Unlike addresses, which require a slash (/) as a delimiter, the regular expression can be delimited by any character except a newline. Thusk, if the pattern contained slashes, you could choose another charater, such as an exclamation mark, as the delimiter.

`s!/usr/mail!/usr2/mail!`

Note that the delimiter appears three times and is required after the _replacement_.
Regardless of which delimiter you use, if it does appear in the regular expression, or in the replacement text, use a backslash (\\) to escape it.

Since newline is just another character when stored internally, a regular expression can use "\n" to match an _embedded_ newline.

The _replacement_ is a string of characters that will match what is matched by the regular expression.

```
&   Replaced by the string matched by the regular expression.
\n  Matches the nth substring (n is a single digit) previously specified in the pattern using "\(" and "\)".
\   Used to escape the ampersand (&), the backslash (\), and the subtitution command's delimiter when they are used literally in the replacement section. In addition, it can be used to escape the newline and create a multiline replacement string.
```

_Flags_ can be used in combination where it makes sense. For instance, **gp** makes the substitution globally on the line and prints the line. The global flag is by far the most commonly used. Without it, the replacement is made only for the first occurrence on the line.

Because the default action is to pass through all lines, regardless of whether any action is taken, the print and write flags are typically used when the default output is suppressed (the `-n` option).

### Replacement Metacharacters

The replacement metacharacters are backslash (\\), apmersand (&), and `\n`.

"•" represents an actual tab character.

Replace the second tab on each line with a newline.
```
s/•/\
/2
```

Note that no spaces are permitted after the backslash.

This script produces the following result:

```
Column1•Column2
Column3•Column4
```

As a metacharacter, the ampersand (&) represents the extent of the pattern match, not the line that was matched.

Because backslashes are also replacement metacharacters, two backslashes are necessary to output a single backslash. Tjhe "&" in the replacement string refers to "UNIX".

`s/UNIX\\s-2&\\s0/g

If the input line is:

on the UNIX Operating System.

then the substitute command produces:

on the \s-2UNIX\s0 Operating System.

The ampersand is particularly useful when the regular expression matches variations of a word. It allows you to specify varaible replacement string that corresponds to what was actually matched.

A pair of escaped parentheses are use used in _sed_ to enclose any part of a regular expression and save it for recall.

Up to nine "saves" are permitted for a single line. "\n" is used to recall the portion of the match that was saved.

```
$ cat test1
first:second
one:two
$ sed 's/\(.*\):\(.*\)/\2:\1/' test1
second:first
two:one
```

### Correcting index entries

### Delete

Delete command (**d**). It takes an address and deletes the contents of the pattern space if the line matches the address.

The delete command is also a command that can change the flow of control in a script. That is because once it is executed, no further c ommands are executed on the "empty" pattern space.*

\* UNIX documentation reads "no further commands are attempted on the corpse of a deleted line".

To delete blank lines:

`/^$/d

The delete command can be used to delete a range of lines.

`/\.TS/,/\.TE/d`

There is also a delete command (**D**) used to delete a portion of a multiline pattern space. This advanced command is presented in the next chapter.

### Append, Insert, and Change

The append (**a**), insert (**i**), and change (**c**) commands provide editing functions that are commonly performed with an interactive editor, such as **vi**.

The syntax of these commands is unusual for sed because they must be specified over multiple lines.

```
append [line-address]a\
text
insert [line-address]i\
text
change [address]c\
text
```

The insert command places the supplied text before the current line in the pattern space. The append command places it after the c urrent line. The change command replaces the contents of the pattern space with the supplied text.

Each of these commands requires a backslash following it to escape the first end-of-line. The _text_ must begin on the next line. To input multiple lines of text, each successive line must end with a backslash, with the exception of the various last line.

```
/<Larry's Address>/i\
4700 Cross Court\
French Lick, IN
```

Also, if the text contains a literal backslash, add an extra backslash to escape it.

The append and insert commands can be applied only to a single line address, not a range of lines. The change command, however, can address a range of lines. In this case, it replaces _all_ addressed lines with a single copy of the text.

```
/^From /,/^$/c\
<Mail Header Removed>
```

Note that you will see the opposite behavior when the change command is one of a group of commands, enclosed in braces, that act on a range of lines. For instance, the following script:

```
^From/, /^$/{
    s/^From //p
    c\
<Mail Header Removed>
}
```

will output "<Mail Header Removed>" for each line in the range.

The change command clears the pattern space, having the same effect on the pattern space as the delete command. No command following the change command in the script is applied.

The insert and append commands do not affect the contents of the pattern space.

```
1i\
New First Line\
New Second Line
```

```
$a\
New Last Line
```

The \$ is a line-addressing symbol that matches the last line of a file.

The insert command can be used to put a blank line before the curreent line, or the append command to put one after, by leaving the line following it blank.

The change command replaces the contents of the pattern space with the text you provide. In effect, it deletes the current line and puts the supplied text in its place.

It can be used when you want to match a line and replace it entirely.
