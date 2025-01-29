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