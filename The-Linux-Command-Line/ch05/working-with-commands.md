# The Linux Command Line, 2nd Edition, © 2019

## Chapter 5: Working With Commands

* type Indicate how a command name is interpreted
* which Display which executable program will be executed
* help Get help for shell builtins
* man Display a comman's manual page
* apropos Display a list of appropriate commands
* info Display a command's info entry
* whatis Display one-line manual page descriptions
* alias Create an alias for a command

### What Exactly Are Commands?

* An executable program
* A command built into the shell itself. Example: cd
* A shell function
* An alias]

### Identifying Commands 

#### type - Display a Command's type

`type command`

```
$ type type
type is a shell builtin
$ type ls
ls is aliased to `ls --color=auto'
$ type cp
cp is /bin/cp
```

#### which - Display an Executable's location

```
$ which ls
/bin/ls
```