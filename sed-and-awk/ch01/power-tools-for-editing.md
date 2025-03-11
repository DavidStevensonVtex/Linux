# sed & awk, 2nd Edition, © 1997

## Chapter 1: Power Tools for Editing

### May You Solve Interesting Problems

The primary motivation for learning _sed_ and _awk_ is that they are useful for devising general solutions to text editing problems.*

* I suppose this section title is a combination of the ancient Chinese curse "May you live in interesting times" and what Tim O'Reilly once said to me, that someone will solve a problem if he finds the problem interesting.

Given the choice of using _vi_ or _sed_ to make a series of repeated edits over a number of files, I will choose sed, simply because it makes the problem more intresting to me.

Part of solving a problem is knowing which tool to build. You have to keep in mind what kinds of applicatinos are best suited for sed and awk.

### A Stream Editor

Sed is a "non-interactive" stream oriented editor. It is stream-oriented because, like many UNIX programs, input flows through the program and is directed to standard output.

You will find sed very useful to make a series of c hanges across a number of files.

Sed can also be used effectively to edit very large files that would be slow to edit interactively.

_Sed_ also has the ability to be used as an editing _filter_. In other words, you could procerss an input file and send the output to another program.

Sed has a few rudimentary programming constructs that can be used to build more complicated scripts.

All but the simplest _sed_ scripts are usually invoked from a "shell wrapper," a shell script that invokes _sed_ and also contains the commands that sed executes. A shell wrapper is an easy way to name and execute a single-word command.

In summary, use _sed_:

1. To automate editing actions to be performed on one or more files.
2. To simplify the task of performing the same edits on multiple files.
3. To write conversion programs.
