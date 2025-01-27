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

### Getting a Command's Documentation

#### help -- Get Help for Shell builtins

```
$ help cd
cd: cd [-L|[-P [-e]] [-@]] [dir]
    Change the shell working directory.
    
    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable.
    ...
```

#### --help - Display Usage Information

```
$ mkdir --help
Usage: mkdir [OPTION]... DIRECTORY...
Create the DIRECTORY(ies), if they do not already exist.

Mandatory arguments to long options are mandatory for short options too.
  -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask
  -p, --parents     no error if existing, make parent directories as needed
  -v, --verbose     print a message for each created directory
  -Z                   set SELinux security context of each created directory
                         to the default type
      --context[=CTX]  like -Z, or if CTX is specified then set the SELinux
                         or SMACK security context to CTX
      --help     display this help and exit
      --version  output version information and exit
```

