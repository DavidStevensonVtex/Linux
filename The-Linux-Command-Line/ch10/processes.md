# The Linux Command Line, 2nd Edition, © 2019

## Chapter 10: Processes

* ps Report a snapshot of current processes
* top Display top tasks
* jobs List active jobs
* bg Place a job in the background
* fg Place a job in the foreground
* kill Send a signal to a process
* killall Kill processes by name
* shutdown Shutdown or reboot the system

### How a Process Works

A _parent process_ produces a _child process_.

Each process is assigned a number called a _process ID (PID)_.

### Viewing Processes

```
$ ps 
    PID TTY          TIME CMD
  12785 pts/0    00:00:00 bash
  13439 pts/0    00:00:00 ps
```

TTY is short for "teletype" and refers to the _controlling terminal_ for the process.
(Unix is showing its age here)

`$ ps x`

Adding the x option (note there is no leading dash) tells `ps` to show all of our processes regardless of what terminal (if any) they are controlled by.

Process States

State Meaning
* R Running
* S Sleeping
* D Uninterruptible sleep. Waiting for I/O such as a disk drive.
* T Stopped. The process has been instructed to stop.
* Z A defunct or "zombie" process. This is a child process that has terminated but has not been cleaned up by its parent.
* \< A high-priority process.
* N A low-priority process.

`ps aux`

BSD Style ps Column Headers

Header Meaning
* USER User ID
* \% CPU CPU usage in percent
* VSZ Virtual Memory Size
* RSS Resident set size. Amount of physical memory (RAM) is using in kilobytes
* START Time when the process started. For values over 24 hours, a date is used.

#### Viewing Processes Dynamically with top

`$ top`

`h` displays the program's help screen, and `q`, which quits top.

### Controlling Processes

`xlogo `

#### Interrupting a Process

`Ctrl-C` interrupts the process.

#### Putting a Process in the Background

* _foreground_ visible on the surface like the shell prompt
* _background_ stuff hidden behind the surface

To launch a program in the background, use the ampersand (&) character.

`xlogo &`

```
$ ps
    PID TTY          TIME CMD
  13548 pts/1    00:00:00 bash
  14378 pts/1    00:00:00 xlogo
  14379 pts/1    00:00:00 ps
$ jobs
[1]+  Running                 xlogo &
```

#### Returning a Process to the Foreground

```
$ jobs
[1]+  Running                 xlogo &
$ fg %1
xlogo
```

The `fg` command followed by a percent sign and the job number (called a _jobspec_).

#### Stopping (Pausing) a Process

To stop a foreground process and place it in the background press `Ctrl-Z`. 

```
$ xlogo
^Z
[1]+  Stopped                 xlogo
```

The book says the xlogo window should appear quite dead and unable to be resized.
I was able to resize the xlogo window on Ubuntu 20.04.

We can bring the xlogo program to the foreground by using the `fg` command, or
resume the program's execution in the background with the `bg` command.

### Signals

The `kill`  command is used to "kill" processes.
This allows us to terminate programs that need killing (some kind of pausing or termination).

```
$ ps
    PID TTY          TIME CMD
  13548 pts/1    00:00:00 bash
  15127 pts/1    00:00:00 ps
$ xlogo &
[1] 15129
$ kill 15129
```

The kill command doesn't exactly "kill" processes; rather it sends them _signals_.

Signals are one of the several ways that the operating system communicates with programs.
We have already seen signals in action with the use of `Ctrl-C` and `Ctrl-Z`.

#### Sending Signals to Processes with kill

`kill -signal PID`

Common Signals

Number Name Meaning
* 1 HUP Hangup
* 2 INT Interrupt
* 9 KILL Kill. The kernel immediately terminates the process.
* 15 TERM Terminate. Default signal sent by the kill command.
* 18 CONT Continue. This will restore a process after a STOP or TSTP signal.
* 19 STOP Stop. This signal causes a process to pause with terminating.
* 20 TSTP Terminal Stop. This is the signal sent by the terminal when `Ctrl-Z` is pressed. The program may choose to ignore this signal.

```
$ xlogo &
[1] 15339
$ kill -1 15339
$ # xlogo window disappears
```

```
$ xlogo &
[1] 15384
$ kill -INT 15384
$ # xlogo window disappears
[1]+  Interrupt               xlogo
$ ps
    PID TTY          TIME CMD
  13548 pts/1    00:00:00 bash
  15387 pts/1    00:00:00 ps
```

Other Common Signals

Number Name Meaning
* 3 QUIT Quit
* 11 SEGV Segmentation violation. Illegal use of memory.
* 28 WINCH Window change. This is the signal sent by the system when a window changes size