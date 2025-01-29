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
