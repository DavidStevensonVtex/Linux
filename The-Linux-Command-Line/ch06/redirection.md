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