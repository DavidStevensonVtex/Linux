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

### Adding Color

#### Terminal Confusion

Unix and Unix-like systems have two rather complex subsystems to deal with the Babel of terminal control (called `termcap` and `terminfo`).

Character color is controlled by sending the terminal emulator an ANSI _escape code_ embedded in the stream of characters to be displayed. The control code does not "print out" on the display; rather it is interpretned by the terminal as an instruction.

For example, the code to set the text color to normal (attribute=0), black text is as follows:

\033[0;30m

##### Escape Sequences used to Set Text Colors

Sequence, Text Color

* \033[0;30m Black
* \033[0;31m Red
* \033[0;32m Green
* \033[0;33m Brown
* \033[0;34m Blue
* \033[0;35m Purple
* \033[0;36m Cyan
* \033[0;37m Light gray

* \033[1;30m Dark gray
* \033[1;31m Light red
* \033[1;32m Light green
* \033[1;33m Yellow
* \033[1;34m Light blue
* \033[1;35m Light purple
* \033[1;36m Light cyan
* \033[1;37m White

```
$ PS1="\033[0;31m<\u@\h \W>\$ "
<dstevenson@dstevensonlinux1 ch13>$ 
```

##### Escape Sequences used to Set Background Color

Sequence, Background color

* \033[0;40m Black
* \033[0;41m Red
* \033[0;42m Green
* \033[0;43m Brown
* \033[0;44m Blue
* \033[0;45m Purple
* \033[0;46m Cyan
* \033[0;47m Light gray


```
>$ PS1="\[\033[0;41m\]\u@\h \W\$\[\033[0m\] "
dstevenson@dstevensonlinux1 ch13$ 
```
The above prompt is displayed with white text and red background, while text typed by the user is black background  white white text.

### Moving the Cursor

Escape c odes can be used to position the cursor.

#### Cursor Movement Escape Sequences

Escape Code, Action

* \033[1;cH Move the cursor to line 1 and column c
* \033[nA Move the cursor up n lines
* \033[nB Move the cursor down n lines
* \033[nC Move the cursor forward n characters
* \033[nD Move the cursor backward n characters
* \033[2J Clear the screen and move the cursor to the upper-left corner (line 0, column 0)
* \033[K Clear the cursor position to the end of the current line
* \033[s Store the current cursor position
* \033[u Recall the stored cursor position


