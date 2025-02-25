# The Linux Command Line, 2nd Edition, © 2019

## Chapter 23: Compiling Programs

Why compile software?

* Availability. In some cases, the only way to get the desired program is to compile it from source.
* Timeliness. Sometimes, to obtain the latest version, compiling is necessary.

### What Is Compiling?

Compiling is the process of translating _source code_ (the human readable description of a program written by a programmer) into the native language of the compiler's processor.

_Machine language_

_Assembly language_

_High-level programming languages_

Most programs written for modern systems are written in either C or C++.

_compiler_

_linking_

_libraries_

_executable program file_

#### Are All Programs Compiled?

No.

_Scripting or interpreted languages_

Examples: Perl, Python, PHP, Ruby and many others. Bash

Scripting languages are executed by a special program called an _interpreter_.

In general, interpreted programs execute much more slowly than compiled languages.

For many programming chores, the results are "fast enough", but the real advantage is that it is generally faster and easier to develop interpreted programs than compiled programs.

### Compiling a C Program

The C compiler used almost universally in the Liux environment is called _gcc_ (GNU C Compiler).

```
$ which gcc
/usr/bin/gcc
```

#### Obtaining the Source Code

```
$ ftp ftp.gnu.org
Connected to ftp.gnu.org.
220 GNU FTP server ready.
Name (ftp.gnu.org:dstevenson): anonymous
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> cd gnu/diction
250 Directory successfully changed.
ftp> ls
200 EPRT command successful. Consider using EPSV.
150 Here comes the directory listing.
-rw-r--r--    1 3003     65534       68940 Aug 28  1998 diction-0.7.tar.gz
-rw-r--r--    1 3003     65534       90957 Mar 04  2002 diction-1.02.tar.gz
-rw-r--r--    1 3003     65534      141062 Sep 17  2007 diction-1.11.tar.gz
-rw-r--r--    1 3003     65534         189 Sep 17  2007 diction-1.11.tar.gz.sig
226 Directory send OK.
ftp> get diction-1.11.tar.gz
local: diction-1.11.tar.gz remote: diction-1.11.tar.gz
200 EPRT command successful. Consider using EPSV.
150 Opening BINARY mode data connection for diction-1.11.tar.gz (141062 bytes).
226 Transfer complete.
141062 bytes received in 0.11 secs (1.1750 MB/s)
ftp> bye
221 Goodbye.
```

The GNU project also supports downloading using HTTPS. We can download the _diction_ source code using the _wget_ program.

```
$ wget https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz
--2025-02-25 09:46:44--  https://ftp.gnu.org/gnu/diction/diction-1.11.tar.gz
Resolving ftp.gnu.org (ftp.gnu.org)... 2001:470:142:3::b, 209.51.188.20
Connecting to ftp.gnu.org (ftp.gnu.org)|2001:470:142:3::b|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 141062 (138K) [application/x-gzip]
Saving to: ‘diction-1.11.tar.gz.1’

diction-1.11.tar.gz.1         100%[================================================>] 137.76K  --.-KB/s    in 0.09s   

2025-02-25 09:46:45 (1.47 MB/s) - ‘diction-1.11.tar.gz.1’ saved [141062/141062]
```

Source code is usually supplied in the form of a compressed tar file, sometimes called a _tarball_.

```
$ tar xzf diction-1.11.tar.gz 
$ ll
total 152
drwxrwxr-x 3 dstevenson dstevenson   4096 Feb 25 09:48 ./
drwxrwxr-x 3 dstevenson dstevenson   4096 Feb 25 09:43 ../
drwxrwxr-x 3 dstevenson dstevenson   4096 Feb 25 09:48 diction-1.11/
-rw-rw-r-- 1 dstevenson dstevenson 141062 Feb 25 09:44 diction-1.11.tar.gz
```

```
$ ls *.[ch]
diction.c  getopt1.c  getopt.c  getopt.h  getopt_int.h  misc.c  misc.h  sentence.c  sentence.h  style.c
```

### Building the Program

Most programs build with a simple, two-command sequence.

```
./configure
make
```

#### Installing the Program

`sudo make install`

`which diction`