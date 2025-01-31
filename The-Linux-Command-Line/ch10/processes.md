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
