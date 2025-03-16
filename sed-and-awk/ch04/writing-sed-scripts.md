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

### A Global Perspective on Addressing

One of the first things you'll notice about _sed_ commands is that _sed_ will apply them to every input line. _Sed_ is implicitly global, unlike **ed**, **ex**, or **vi**.

In _sed_, it is as though each line has a turn at becoming the current line and so the command is applied to every line. Line addresses are used to supply context for, or _restrict_, and operation.

A _sed_ command can specify zero, one, or two addresses. Anaddress can be a regular expression describing a pattern, a line number, or a line addressing symbol.

* If no address is specified, then the command is applied to each line.
* If there is only one address, thecommand is applied to any line matching the address.
* If two comma-separated addresses are specified, the command is performed on the first line matching the first address and all succeeding lines up to and including a line matching the second address.
* If an address is followed by an exclamation mark (!), the command is applied to all lines that do *not* match the address.

To illustrate how addressing works, let's lok at examples using the delete command, **d**. A script consisting of simply the **d** command and no address produces no output since it deletes _all_ lines.

`d`

When a line number is supplied as an address, the command affects only that line.
Forinstance, the following example deletes only the first line:

`1d`

The line number refers to an internal line count maintained by sed. This counter is not reset for multiple input files.

Similarly, the input stream has only one last line. It can be specified using the addressing symbol \$. The following example deletes the last line of input:

`$d`

The following commqnd shows how to delete all line blocked by a partern of macros, in this cas, .TS and .TE, that mark **tbl** input.

`/^\.TS/,/^\.TE/d`

The following command deletes from line 50 to the last line in the file:

`50,$d`

You can mix a line address and a pattern addres:

`1,/^$/d`

This example deletes fromt he first line up to the first blank line, which for instance, will delete a mailer header from an Internet mail message that you have saved in a file.

You can think of the first address as enabling the action and the second address as disabling it. _Sed_ has no way of looking ahead to determine if the second match will be made. The action will be applied to lines once the first match is made. The command will be applied to _all_ subsequent lines until the second match is made. In the previous example, if the file did not contain a blank line, then all lines would be deleted.

An exclamation mark (!) following an address reverses the sense of the match. For instance, the following script deletes all lines _except_ those inside **tbl** input:

`/^\.TS/,/^\.TE/!d`

This script, in effect, extracts **tbl** input from a source file.

### Grouping Commands

Braces ({}) are used in _sed_ to nest one address inside another to or to apply multiple commands at the same address. You can nest addressies if you want to specify a range of lines and then, within that range, specify another address. For example, to delete blank lines only inside blocks of **tbl** input, use the following command:

```
/^\.TS/,/^\.TE/ {
    /^$/d
}
```

The opening curly brace must end a line and the closing curly brace must be on a line by itself. Be sure there are no spaces after the braces.

You can apply multiple commands to the same range of lines by enclosing the editing commands within braces, as shown below:

```
/^\.TS/,/^\.TE/ {
    /^$/d
    s/^\.ps 10/.ps 8/
    s/^\.vs 12/.vs 10/
}
```

This example not only deletes blank lines in **tbl** input but it also uses the substitute command, **s**, to change several **troff** requests. These commands are applied only to lines within the .TS/.TE block.

### Testing and Saving Output

In our previous discussion of the pattern space, you saw that sed:

1. Makes a copy of the input line.
2. Modifies that copy in the pattern space.
3. Outputs the copy to standard output.

What this means is that sed has a built-in safeguard so that you don't make changes to the original file. Thus the following line:

`$ sed -f sedscr testfile`

does not make the change in _testfile_. It sends all lines to standard output (typically the screen) -- the lines that were modified as well as the lines that are unchanged. You have to captuer this output in a new file if you want to save it.

`$ sed -f sedscr testfile > newfile`

The redirection symbol ">" redirects the output from sed to the file _newfile_. Don't rediret the output from the c ommand back to the input file or you will overwrite the input file. This will happen _before_ sed even gets a chance to process the file, effectively destroying your data.

One important reason to redirect the output to a file is to verify your results.

`$ diff testfile newfile`

When you have verified your results, make a backup copy of the original input file and then use the **mv** command to overwrite the original with the new version. Be sure that the editing script is working properly before abandoning the original version.

The following two shell scripts are useful for testing sed scripts and then making the changes permanently in a file. They are particularly useful when the same script needs to be run on multiple files.

### testsed

The shell script **testsed** automates the process of saving the output of sed in a temporary file. It excpects to find the script file, _sedscr_, in the current directory and applies these instructions to the input file named on the command line. The output is placed in a temporary file.

```
for x   # for each script argument, $1 .. $9 ...
do
    sed -f sedscr $x > tmp.$x
done
```

You might also incorporate the **diff** command into the shell script. Add `diff $x tmp.$x` after the sed command.

### runsed

The shell script **runsed** was developed to make changes to an input file permanently. In other words, it is used in cases where you want the input file and the output file to be the same. Like **testsed**, it creates a temporary file, but then it takes the next step: copy the file over the original.

```
#!/bin/bash

for x
do  
    echo "editing $x: \c"
    if [[ "$x" = "sedscr" ]]; then
        echo "not editing sedscr!"
    elif [ -s "$s" ]; then  # file exists and has a length greater than zero
        sed -f sedscr "$x" > /tmp/$x$$
        if [ -s "/tmp/$x$$" ]
        then 
            if cmp -s "$x" "/tmp/$x$$"
            then
                echo "file not changed: \c"
            else
                mv "$x" "$x.bak"    # save original, just in case
                cp "/tmp/$x$$" "$x"
            file
            echo "done"
        else
            echo "Sed produced an empty file\c"
            echo " - check your sedscript."
        fi
        rm -f "/tmp/$$$"
    else
        echo "original file is empty."
    fi
done
echo "all done"
```

**runsed** simply invokes **sed -f sedscr** on the named files, one at a time, and redirects the  output to a temporary file. **runsed** then tests this temporary file to make sure that output was produced before copying it over the original.

**runsed** does not protect you from imperfect editing scripts. You should run **testsed** first to verify your c hanges before actually making them permanent with **runsed**.
