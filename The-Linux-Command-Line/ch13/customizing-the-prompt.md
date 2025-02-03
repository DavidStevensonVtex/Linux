# The Linux Command Line, 2nd Edition, © 2019

## Chapter 13: Customizing the Prompt

### Anatomy of a Prompt

`dstevenson@dstevensonlinux1:~/Linux/GitHub/Linux/The-Linux-Command-Line/ch10$ `

The prompt is defined by an environment variable named `PS1`.


```
$ echo $PS1
\[\]\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ \[\]
```

Many of the escaped character sequences deal with color encoding and perhaps bolding.
The hostname appears in green and the current directory in blue, both apparently bolded.

#### Escape Codes used in Shell prompts

* \\a ASCII bell.
* \\d Current date in day, month and date format.
* \\h Hostname of the local machine, minus the trailing domain name.
* \\H Full hostname
* \\j Number of jobs running in the current shell session.
* \\l The name of the current terminal device.
* \\n A newline character
* \\r A carriage return.
* \\s Name of the shell program.
* \\t Current time in 24-hour hours:minutes:seconds format
* \\T Current time in 12-hour format.
* \\@ Current time in 12-hour AM/PM format.
* \\A Current time in 24-hour hours:minutes format.
* \\u Username of the current user.
* \\v Version number of the shell.
* \\V Version and release number of the shell
* \\w Name of the current working directory.
* \\W Last part of the current working directory name.
* \\! History number of the current command
* \\# Number of commands entered during this shell session.
* \\$ This displays a character unless we have supervisor privoleges. In that case, it displays a # instead.
* \\[ Signals the start of a series of one or more non-printing characters. This is used to embed non-printing control characters that manipulate the terminal emulator in some way, such as moving the cursor or changing text colors.
* \\] Signals the end of non-printing character sequence.

### Trying Some Alternative Prompt Designs

```
ps1_old="$PS1"
echo $ps1_old
```

We can restore the original prompt at any time by reversing the process.

`PS1="$ps1_old"`

Set the prompt to an empty string.

`PS1=`

`PS1="\$ "`

```
$ PS1="\A \h \$ "
11:46 dstevensonlinux1 $ 
```

```
11:46 dstevensonlinux1 $ PS1="<\u@\h \W>\$ "
<dstevenson@dstevensonlinux1 ch13>$ 
```