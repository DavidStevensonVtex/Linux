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