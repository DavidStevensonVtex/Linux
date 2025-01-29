# The Linux Command Line, 2nd Edition, © 2019

## Chapter 7: Seeing the world as the shell sees it

* echo Display a line of text

### Expansion

`echo this is a test`

```
$ echo *
shell.md
```

Wildcards are expanded to file names.

### Pathname Expansion

```
$ echo D*
Derby Desktop Documents Downloads
```

```
$ echo *s
Documents Downloads Pictures Templates Videos
```

```
$ echo .*
. .. .bash_history .bash_logout .bashrc .byobu .cache .config .dbus .dotnet .emacs.d .gitconfig .gnupg .ICEauthority .java .lesshst .local .mongodb .mozilla .pki .profile .python_history .redhat .sh_history .ssh .sudo_as_admin_successful .thunderbird .vscode
```

`ls -d .* | less`

#### Tilde Expansion

The tilde character (~) has special meaning.
It expands into the name of the home directory.

```
$ echo ~
/home/dstevenson
```

#### Arithmetic Expansion

```
$ echo $((2 + 2))
4
```

Operators / Description
* \+ Addition
* \- Subtraction
* \* Multiplication
* \/ Division
* \% Modulo
* \*\* Exponentiation

Spaces are not significant in arithmetic expressions, and expressions can be nested.

```
$ echo $(($((5**2)) * 3))
75
```

[Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html)

Arithmetic expansion is covered in greater detail in Chapter 34.

#### Brace Expansion

Files do not need to exist for these examples to work.

```
$ echo Front-{A,B,C}-Back
Front-A-Back Front-B-Back Front-C-Back
```

```
$ echo Number_{1..5}
Number_1 Number_2 Number_3 Number_4 Number_5
```

In bash version 4.0 and newer, integers may also be _zero-padded_ like so:

```
$ echo {01..15}
01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
```

```
$ echo {Z..A}
Z Y X W V U T S R Q P O N M L K J I H G F E D C B A
```

```
$ echo a{A{1,2},B{3,4}}b
aA1b aA2b aB3b aB4b
```

So, what is this good for? The most common application is to 
make lists of files or directories to be created.

```
$ mkdir Photos
$ cd Photos
$ mkdir {2007..2009}-{01..12}
$ ls
2007-01  2007-07  2008-01  2008-07  2009-01  2009-07
2007-02  2007-08  2008-02  2008-08  2009-02  2009-08
2007-03  2007-09  2008-03  2008-09  2009-03  2009-09
2007-04  2007-10  2008-04  2008-10  2009-04  2009-10
2007-05  2007-11  2008-05  2008-11  2009-05  2009-11
2007-06  2007-12  2008-06  2008-12  2009-06  2009-12
```