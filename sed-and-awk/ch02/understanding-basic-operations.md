# sed & awk, 2nd Edition, © 1997

## Chapter 2: Understanding Basic Operations

sed and awk have the following in common:

* They are invoked using similar syntax
* They are both stream-oriented reading input from text files one line at a time and redirecting the result to standard output.
* They use regular expressions for pattern matching.
* They allow the user to specify instructions in a script.

### Awk, by Sed and Grep, out of Ed

You can trace the lineage of awk to sed and _grep_, and through those two programs to _ed_, the original UNIX line editor.

sed applies a command without an address to _every_ line in the file.

`s/regular/complex`

The previous example has the same result as the following global command in _ed_.

`g/regular/s//complex/`

Understanding the difference between current-line addressing in _ed_ and global-line addressing in _sed_ is very important. In _ed_ you use addressing to _expand_ the number of lines that are the object of a command; in sed, you use addressing to _restrict_ the number of lines affected by a command.

Awl was developed as a programmable editor that, like sed, is stream-oriented and interprets a script of editing commands. Where awk departs from sed is in discarding the line-editor command set. It offers in its place a programming language modeled on the C language. The **print** statement replaces the **p** command, for example.

`/regular/ { print }`

The advantage of using a programming language in scripts is that it offers many more ways to control what the programmable editor can do. Awk offers expressions, conditional statements, loops, and other programming constructs.

One of the most distinctive features of awk is that it _parses_, or breaks up, each input line and makes individual words available for processing with a script.

The authors of awk never imagined it would be used to write large programs. But, recognizing that awk was being used in this way, the authors revised the language, creating **nawk** to offer more support for writing larger programs and tackling general-purpose programming problems.

### Command-Line Syntax

You invoke sed and awk in much the same way. The command-line syntax is:

`command [options] script filename`

Like almost all UNIX programs, sed and awk can take input from standard input and send the output to standard output. If _filename_ is specified, input is taken from that file. The output contains the processed information.

The _options_ for each command are different. The complete list of command-line options can be found in Appendix A, _Quick Reference for sed_; the complete list of options for awk is in Appendix B, _Quick Reference for awk_.

One option common to both sed and awk is the _-f_ option that allows you to specify the name of a script file.

`sed -f scriptfile inputfile`

### Scripting

A script is where you tell the program what to do. At least one line of instruction is required. Short scripts can be specified on the command line; longer scripts are usually placed in a file where they easily be revised and tested.

In sed and awk, each instruction has two parts: a _pattern_ and a _procedure_.
The pattern is a regular expression delimited with slashes (/). A procedure specifies one or more actions to be performed.

As each line of input is read, the program reads the first instruction in the script and checks the _pattern_ against the current line. if there is no match, the _procedure_ is ignored and the next instruction is read. If there is a match, then action or actions specified in the _procedure_ are followed. All of the instructions are read, not just the first instruction that matches the input line.

When all the applicable instructions have been interpreted and applied for a single line, sed outputs the line and repeats the cycle for each input line. Awk, on the other hand, does not _automatically_ output the line; the instructions in your script control what is finally done with it.

### Sample Mailing List

```
John Daggett, 341 King Road, Plymouth MA
Alice Ford, 22 East Broadway, Richmond VA
Orville Thomas, 11345 Oak Bridge Road, Tulsa OK
Terry Kalkas, 402 Lans Road, Beaver Falls PA
Eric Adams, 20 Post Road, Sudbury MA
Hubert Sims, 328A Brook Road, Roanoke VA
Amy Wilde, 334 Bayshore Pkwy, Mountain View CA
Sal Carpenter, 73 6th Street, Boston MA
```

### Using sed

There are two ways to invoke sed: either you specify your editing instructiosn on the command line or you put them in a file and supply the name of the file.

### Specifying Simple Instructions

You can specify simple editing commands on the command line.

`sed [-e] 'instruction' file`

The _-e_ option is necessary only when you supply more than one instruction on the command line.

```
$ sed 's/MA/Massachusetts/' list
John Daggett, 341 King Road, Plymouth Massachusetts
Alice Ford, 22 East Broadway, Richmond VA
Orville Thomas, 11345 Oak Bridge Road, Tulsa OK
Terry Kalkas, 402 Lans Road, Beaver Falls PA
Eric Adams, 20 Post Road, Sudbury Massachusetts
Hubert Sims, 328A Brook Road, Roanoke VA
Amy Wilde, 334 Bayshore Pkwy, Mountain View CA
Sal Carpenter, 73 6th Street, Boston Massachusetts
```

Enclosing the instruction in single quotes is not required in all cases but you should get in the habit of always doing it. The enclosing single quotes prevent the shell from interpreting special characters or spaces found in the editing instruction. (The shell usees spaces to determine individual arguments submitted to a program; characters that are special to the shell are expanded before the command is invoked.)

```
$ sed 's/ MA/, Massachusetts/' list
John Daggett, 341 King Road, Plymouth, Massachusetts
Alice Ford, 22 East Broadway, Richmond VA
Orville Thomas, 11345 Oak Bridge Road, Tulsa OK
Terry Kalkas, 402 Lans Road, Beaver Falls PA
Eric Adams, 20 Post Road, Sudbury, Massachusetts
Hubert Sims, 328A Brook Road, Roanoke VA
Amy Wilde, 334 Bayshore Pkwy, Mountain View CA
Sal Carpenter, 73 6th Street, Boston, Massachusetts
```

There are three ways to specify multiple instructions on the command line.

1. Separate instructions with a semicolon.

    `sed 's/ MA/, Massachusets/; s/ PA, Pennsylvania/' list`

2.  Precede each instruction by _-e_.

    `sed -e 's/ MA/, Massachusetts/' -e 's/ PA/, Pennsylvania/' list`

3.  Use the multiline entry capability of the Bourne shell.

    ```
    $ sed '
    > s/ MA/, Massachusetts/
    > s/ PA/, Pennsylvania/
    > s/ CA/, California/' list
    ```

This technique will not work in the C shell (but should work with shells compatible with Bourne shell, such as ksh, bash, pdksh, and zsh).

#### Command garbled

```
$ sed -e 's/MA/Massachusetts' list
sed: -e expression #1, char 18: unterminated `s' command
```

### Script Files

It is not practical to enter longer editing scripts on the command line.
That is why it is usually best to create a script file that contains the editing instructions.

`sed -f scriptfile file`

```
$ cat sedscr 
s/ MA/, Massachusetts/
s/ PA/, Pennsylvania/
s/ CA/, California/
s/ VA/, Virginia/
s/ OK/, Oklahoma/
```

```
$ sed -f sedscr list
John Daggett, 341 King Road, Plymouth, Massachusetts
Alice Ford, 22 East Broadway, Richmond, Virginia
Orville Thomas, 11345 Oak Bridge Road, Tulsa, Oklahoma
Terry Kalkas, 402 Lans Road, Beaver Falls, Pennsylvania
Eric Adams, 20 Post Road, Sudbury, Massachusetts
Hubert Sims, 328A Brook Road, Roanoke, Virginia
Amy Wilde, 334 Bayshore Pkwy, Mountain View, California
Sal Carpenter, 73 6th Street, Boston, Massachusetts
```

#### Saving Output

`$ sed -f sedscr list > newlist`

Do not redirect the output to the file you are editing or you will clobber it.
(The ">" redirection operator truncates the file before the shell does anything else.)

If you want the output file to replace the input file, you can do that as a separate step, using the **mv** command. But first make very sure your editing script has worked properly.

#### Suppressing automatic display of input lines

The default operation of sed is to output every input line. The _-n_ option suppresses the automatic output. When specifying this option, each instructino intended to produce output must contain a print command, p. 

```
$ sed -n -e 's/MA/Massachusetts/p' list
John Daggett, 341 King Road, Plymouth Massachusetts
Eric Adams, 20 Post Road, Sudbury Massachusetts
Sal Carpenter, 73 6th Street, Boston Massachusetts
```

#### Mixing Options (POSIX)

You can build up a script by combining both the _-e_ and _-f_ options on the command line. The script is the combination of all the commands in the order given.

```
Option   Description

-e       Editing instruction follows.
-f       Filename of script follows.
-n       Suppress automatic output of input lines.
```

### Using awk

_awk_ executes a set of instructions for each line of input.
You can specify instructions on the command line or create a script file.

#### Running awk

`awk 'instructions' files`

_Instructions+_ must be enclosed in single quotes to protect them from the shell.
Instructions almost always contain curly braces and/or dollar signs, which are interpreted as special characters by the shell. Multiple command lines can be entered in the same way as show for sed: separating commands with semicolons or using the multiline input capability of the Bourne shell.

`awk -f script files`

While awk instructions have the same structure as sed, consisting of _pattern_ and _procedure_ sections, the procedures themselves are quite different. 

There are statements and functions instead of one- or tw-character command sequences.
For instance, you use the **print** statement to print the value of an expression or to print the contents of the current input line.

Awk, in the usual case, interprets each input line as a record and each word on that line, delimited by spaces or tabs, as a field. (These defaults can be changed).
One or more consecutive spaces or tabs count as a single delimiter. Awk allows you to reference these fields, in either patterns or procedures. $0 represents the entire input line. $1, $2, ... refer to the individual fields on the input line.

```
$ awk '{ print $1 }' list
John
Alice
Orville
Terry
Eric
Hubert
Amy
Sal
```

The default action is to match each line that matches the pattern.

```
$ awk '/MA/' list
John Daggett, 341 King Road, Plymouth MA
Eric Adams, 20 Post Road, Sudbury MA
Sal Carpenter, 73 6th Street, Boston MA
```

```
$ awk '/MA/ { print $1 }' list
John
Eric
Sal
```

By default awk separates the input into fields using either spaces or tabs as the field separator.

In the next example, we use the _-F_ option to change the field separator to a comma.

```
$ awk -F,  '/MA/ { print $1 }' list
John Daggett
Eric Adams
Sal Carpenter
```

Do not confuse the -F option to change the field separator with the -f option to specify the name of a script file.

In the next example, we print each field on its own line. Multiple commands are separated by semicolons.

```
$ awk -F,  '{ print $1; print $2; print $3 }' list
John Daggett
 341 King Road
 Plymouth MA
Alice Ford
 22 East Broadway
 Richmond VA
Orville Thomas
 11345 Oak Bridge Road
 Tulsa OK
Terry Kalkas
 402 Lans Road
 Beaver Falls PA
Eric Adams
 20 Post Road
 Sudbury MA
Hubert Sims
 328A Brook Road
 Roanoke VA
Amy Wilde
 334 Bayshore Pkwy
 Mountain View CA
Sal Carpenter
 73 6th Street
 Boston MA
```

### Error Messages

Messages can be caused by any of the following:

* Not enclosing a procedure with braces ({})
* Not surrounding the instructions with single quotes('')
* Not enclosing regular expressions within slashes(//)

#### Summary of Options

```
Option   Description

-f       Filename of script follows.
-F       Change field separator
-v       var=value follows.
```

The _-v_ option for specifying parameters on the command line is discussed in Chapter 7, _Writing Scripts for awk_.

### Using sed and awk Together

```
$ cat nameState
s/ CA/, California/
s/ MA/, Massachusetts/
s/ OK/, Oklahoma/
s/ PA/, Pennsylvania/
s/ VA/, Virginia/
```

```
$ sed -f nameState list | awk -F, '{ print $4 }'
 Massachusetts
 Virginia
 Oklahoma
 Pennsylvania
 Massachusetts
 Virginia
 California
 Massachusetts
```

While the result of this program is not very useful, it could be passed to **sort | uniq -c**, which would sort the states into an alphabetical list with a count of the occurrences of each state.

```
$ sed -f nameState list | awk -F, '{ print $4 }' | sort | uniq -c
      1  California
      3  Massachusetts
      1  Oklahoma
      1  Pennsylvania
      2  Virginia
```

```
#!/bin/bash

awk -F, '{
    print $4 ", " $0
}' $@ | 
sort |
awk -F, '
$1 == LastState {
    print "\t" $2 
}
$1 != LastState {
    LastState = $1
    print $1
    print "\t" $2
}'
```

```
$ sed -f nameState list | ./byState
 California
         Amy Wilde
 Massachusetts
         Eric Adams
         John Daggett
         Sal Carpenter
 Oklahoma
         Orville Thomas
 Pennsylvania
         Terry Kalkas
 Virginia
         Alice Ford
         Hubert Sims
```

```
$ sed -f nameState list | awk -F, '{ print $4 ", " $0 }'
 Massachusetts, John Daggett, 341 King Road, Plymouth, Massachusetts
 Virginia, Alice Ford, 22 East Broadway, Richmond, Virginia
 Oklahoma, Orville Thomas, 11345 Oak Bridge Road, Tulsa, Oklahoma
 Pennsylvania, Terry Kalkas, 402 Lans Road, Beaver Falls, Pennsylvania
 Massachusetts, Eric Adams, 20 Post Road, Sudbury, Massachusetts
 Virginia, Hubert Sims, 328A Brook Road, Roanoke, Virginia
 California, Amy Wilde, 334 Bayshore Pkwy, Mountain View, California
 Massachusetts, Sal Carpenter, 73 6th Street, Boston, Massachusetts
```
