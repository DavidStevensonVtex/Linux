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

