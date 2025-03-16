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