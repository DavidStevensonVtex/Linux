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