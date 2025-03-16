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
