# The Linux Command Line, 2nd Edition, © 2019

## Chapter 6: Redirection

The I/O in I/O Redirection stands for Input/Output.

* cat Concatenate files
* sort Sort lines of text
* uniq Report or omit repeated lines
* grep Print lines matching a pattern
* wc Print newline, word, and byte counts for each file
* head Output the first part of a file
* tail Output the last part of a file
* tee Read from the standard output and write to standard output and files

### Standard Input, Output and Error

Unix theme: everything is a file.

I/O redirection allows us to change where output goes and where input comes from.

Normally, output goes to the s creen and input comes from the keyboard,
but with I/O redirection, we can change that.

#### Redirecting Standard Output

I/O redirection allows us to redefine where standard output goes.

`ls -l /usr/bin > ls-output.txt`

`less ls-output.txt`

Using a directory that does not exist:

```
$ ls -l /bin/usr > ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
```

Errors are output to Standard Error.

Truncate a file:

```
$ ll ls-output.txt
-rw-rw-r-- 1 dstevenson dstevenson 132657 Jan 28 13:54 ls-output.txt
$ > ls-output.txt
$ ll ls-output.txt
-rw-rw-r-- 1 dstevenson dstevenson 0 Jan 28 13:54 ls-output.txt
```

Append to a file:

```
$ ls -l /usr/bin > ls-output.txt
$ ll ls-output.txt
-rw-rw-r-- 1 dstevenson dstevenson 132657 Jan 28 13:58 ls-output.txt
$ ls -l /usr/bin >> ls-output.txt # Append to file using >>
$ ll ls-output.txt
-rw-rw-r-- 1 dstevenson dstevenson 265314 Jan 28 13:58 ls-output.txt
```

#### Redirecting Standard Error

```
$ ls -l /bin/usr 2> ls-error.txt
$ cat ls-error.txt
ls: cannot access '/bin/usr': No such file or directory
```
##### Redirecting Standard Output and Standard Error to One File

```
$ ls -l /bin/usr > ls-output.txt 2>&1
$ cat ls-output.txt
ls: cannot access '/bin/usr': No such file or directory
```

Note: The order of the redirections is significant

The redirection of standard error must always occur after redirecting standard output
or it doesn't work.

`> ls-output.txt 2>&1` redirects standard error to the ls-output.txt file.

`2>&1 > ls-output.txt` redirects standard error to the screen and standard output to the ls-output.txt file.

Recent versions of `bash` provide a second more streamlined method for performing this combined redirection, shown here:

`ls -l /bin/usr &> ls-output.txt`

##### Disposing of Unwanted Output

When Silence Is Golden:

`ls -l /bin/usr 2> /dev/null`

#### Redirecting Standard Input

##### cat: Concatenate Files

The `cat` command reads one or more files and copies them to standard output like so:

`cat filename`

`cat` is often used to display short text files.

`cat` used with no arguments can be used to read from standard input and output to standard output.
Input is terminated with Ctrl-D.

Redirect standard input from the screen to input from a file:

`cat < lazy_dog.txt`

### Pipelines

The capability of commands to read data from standard input and send to standard output is utilized by a shell featuire called _pipelines_.

The pipe operator | is used.

`command1 | command2`

`ls -l /usr/bin | less`

#### Filters

Filters take input, change it somehow, and then output it.

`ls /bin /usr/bin | sort | less`

The Difference Between > and | 

The redirection operator connects a command with a file, while a pipeline operator
connects the output of one command with the input of a second command.

command1 > command2 is bad because it overwrites command2 without the output of command1 (if the command2 exists within the current directory) or creates a file called command2 instead of executing command2 using the output of command1 and the input to command2.

##### uniq: Report or Omit Repeated Lines

`ls /bin /usr/bin | sort | uniq | less`

In this example, we use `uniq` to remove any duplicate lines.

If we want to see the list of duplicates instead, use the -d option with `uniq`.

`ls /bin /usr/bin | sort | uniq -d | less`

##### wc: Print Line, Word and Byte Counts

`wc ls-output.txt`

`ls /bin /usr/bin | sort | uniq | wc -l`

##### grep: Print Lines Matching a Pattern

`grep pattern filename`

Advanced patterns include regular expressions.

```
$ ls /bin /usr/bin | sort | uniq | grep zip
bunzip2
bzip2
bzip2recover
funzip
...
```

Useful options:

* -i - ignore case
* -v - print only lines which do not match the pattern

##### head/tail: Print First/Last Part of Files

```
$ ls -l /usr/bin > ls-output.txt
$ head -n 5 ls-output.txt
total 923852
-rwxr-xr-x 1 root       root           59736 Sep  5  2019 [
-rwxr-xr-x 1 root       root           10104 Apr 23  2016 411toppm
-rwxr-xr-x 1 root       root           31248 Mar  6  2024 aa-enabled
-rwxr-xr-x 1 root       root           35344 Mar  6  2024 aa-exec
$ tail -n 5 ls-output.txt
-rwxr-xr-x 2 root       root          186664 Feb  1  2024 zipinfo
-rwxr-xr-x 1 root       root           89488 Apr 21  2017 zipnote
-rwxr-xr-x 1 root       root           93584 Apr 21  2017 zipsplit
-rwxr-xr-x 1 root       root           26952 Mar 20  2023 zjsdecode
-rwxr-xr-x 1 root       root           14584 Jul 28  2021 zlib-flate
```

Using the -f option, `tail` continues to monitor the file, and when new lines are appended, 
they immidately appear on the display. This continues until you type `Ctrl-C`.