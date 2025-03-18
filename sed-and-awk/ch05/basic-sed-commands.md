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