# sed & awk, 2nd Edition, © 1997

## Chapter 4: Writing sed Scripts

Sed allows you to take what would be a _hands-on_ procedure in an editor such as **vi** and transform it into a _look-no-hands_ procedure that is executed from a script.

In writing a script, you should follow these steps:

1. Think through what you want to do before you do it.
2. Describe, unambiguously, a procedure to do it.
3. Test the procedure repeatedly before making any final changes.

Three basic principles of how sed works.

1. All editing commands in a script are applied in order to each line of input.
2. Commands are applied to all lines (globally) unless line addressing restricts the lines affected by the editing commands.
3. The original input file is unchanged; the editing commands modify a copy of the original input line and the copy is sent to the standard output.

### Applying Commands in a Script

Combining a series of edits in a script can have unexpected results. You might not think of the consequences one edit can have on another.

New users typically think that sed applies an individual editing command to all lines of input before applying the next editing command. But the opposite is true. Sed applies the entire script to the first input line before reading the second input line and applying the editing script to it. Because sed is always working with the latest version of the original line, any edit that is made changes the line for subsequent commands. Sed doesn't retain the original. This means that a pattern that might have matched the original input line may no longer match the line after an edit has been made.

```
cat sample
The pig is pink.
The cow is not a horse.
```

```
$ sed -e 's/pig/cow/g;s/cow/horse/g' sample
The horse is pink.
The horse is not a horse.
```

### The Pattern Space

Sed maintains a _pattern space_, a workspace or temporary buffer where a single line of input is held while the editing commands are applied. \*

\* One advantage of the one line at a time design is that sed can read very large files without any problems. Screen editors that have to read the entire file into memory, or some large portion of it, can run out of memory or be extremely slow to use in dealing with large files.

Initially, the patetrn space contains a copy of a single input line. The normal flow through the s cript is to execute each command on that line until the end of the script is reached. The first command int he script is applied to that line. Then the second command is applied.

When all the instructinso have been applied, the current line is output and the next line of input is read into the pattern space. Then all the commands in the script are applied to that line.

As a consequence, any sed command might change the contents of the pattern space for the next command. The contents of the pattern space are dynamic and do not always match the original input line.

Changing the order of the script example:

```
$ sed -e 's/cow/horse/g;s/pig/cow/g' sample
The cow is pink.
The horse is not a horse.
```

Some _sed_ commands change the flow through the script, as we will see in subsequent chapters. For example, the **N** command reads another line into the pattern space without removing the current line, so you can test for patterns across multiple lines. Other commands tell _sed_ to exit before reaching the bottom of the script or go to a labeled command. Sed also maintains a second temporary buffer called the _hold space_. You can copy the contents of the pattern space to the hold space and retrieve them later. The commands that make use of the hold space are discussed in Chapter 6.

