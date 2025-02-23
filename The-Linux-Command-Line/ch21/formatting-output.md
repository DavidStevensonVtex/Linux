# The Linux Command Line, 2nd Edition, © 2019

## Chapter 21: Formatting Output

* nl Number lines
* fold Wrap each line to a specified length
* fmt A simple text formatter
* pr Prepare text for printing
* printf Format and print data
* groff A document formatting system

### Simple Formatting Tools

#### nl -- Number Lines

```
$ nl distros.txt | head
     1  SUSE    10.2    12/07/2006
     2  Fedora  10      11/25/2008
     3  SUSE    11.0    06/19/2008
     4  Ubuntu  8.04    04/24/2008
     5  Fedora  8       11/08/2007
     6  SUSE    10.3    10/04/2007
     7  Ubuntu  6.10    10/26/2006
     8  Fedora  7       05/31/2007
     9  Ubuntu  7.10    10/18/2007
    10  Ubuntu  7.04    04/19/2007
```

`nl` caan accept either multiple files as command line arguments or standard input.

`nl` supports a concept called _logical pages_ when numbering. This allows nl to reset (start over) the numerical sequence when numbering.

Using options, it is possible to set the starting number to a specific value, and to a limited extent, its format. A logical page is further broken down into a header, body, and footer. Within each of these sections, line numbering may be reset and/or be assigned a different style.

If `nl` is given multiple files, it treats them as a single stream of text. Sections in the text stream are indicated by the presence of some rather odd-looking marketup added to the text:

**nl Markup**

* \\:\\:\\: Start of logical page header
* \\:\\: Start of logical page body
* \\: Start of logical page footer

Each of the markup elements must appear alone on its own line.

**Common options for nl**

* -b _style_ Set body numbering to _style_, where _style_ is one of the following:
  * a Number all lines
  * t Number only non-blank lines
  * n None
  * _pregexp Number only lines matching basic regular expression _regexp_.
* -f _style_ Set footer numbering to _style_. Default is n (none).
* -h _style_ Set header numbering to _style_. Default is n (none).
* -i _number_ Set page numbering increment to _number_. The default is 1.
* -n _format_ Sets numbering format to _format_, where _format is one of the following:
  * ln Left justified, without leading zeros.
  * rn Right justified, without leading zeros. This is the default.
  * rz Right justified, with leading zeros.
* -p Do not reset page numbering at the beginning of each logical page.
* -s _string_ Add _string_ to the end of each line number to create a separator. The default is a single tab character.
* -v _number_ Set the first line number of each logical page to _number_. The default is 1.
* -w _width_ Set the width of the line number field to _width_. The default is 6.

**distros-nl.sed**

```
# sed script to produce Linux distributions report

1 i\
\\:\\:\\:\
\
Linux Distributions Report\
\
Name         Ver.  Released\
----         ----  --------\
\\:\\:
s/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{4\}\)$/\3-\1-\2/
$ a\
\\:\
\
End Of Report
```

Note that we had to double up the backslashes in our markup because they are normally interpreted as an escape character by _sed_.

```
$ sort -k 1,1 -k 2n distros.txt | sed -f distros-nl.sed | nl

       
       Linux Distributions Report
       
       Name         Ver.  Released
       ----         ----  --------

     1  Fedora  5       2006-03-20
     2  Fedora  6       2006-10-24
     3  Fedora  7       2007-05-31
     4  Fedora  8       2007-11-08
     5  Fedora  9       2008-05-13
     6  Fedora  10      2008-11-25
     7  SUSE    10.1    2006-05-11
     8  SUSE    10.2    2006-12-07
     9  SUSE    10.3    2007-10-04
    10  SUSE    11.0    2008-06-19
    11  Ubuntu  6.06    2006-06-01
    12  Ubuntu  6.10    2006-10-26
    13  Ubuntu  7.04    2007-04-19
    14  Ubuntu  7.10    2007-10-18
    15  Ubuntu  8.04    2008-04-24
    16  Ubuntu  8.10    2008-10-30

       
       End Of Report
```

```
$ sort -k 1,1 -k 2n distros.txt | sed -f distros-nl.sed | nl -n rz

       
       Linux Distributions Report
       
       Name         Ver.  Released
       ----         ----  --------

000001  Fedora  5       2006-03-20
000002  Fedora  6       2006-10-24
000003  Fedora  7       2007-05-31
000004  Fedora  8       2007-11-08
000005  Fedora  9       2008-05-13
000006  Fedora  10      2008-11-25
000007  SUSE    10.1    2006-05-11
000008  SUSE    10.2    2006-12-07
000009  SUSE    10.3    2007-10-04
000010  SUSE    11.0    2008-06-19
000011  Ubuntu  6.06    2006-06-01
000012  Ubuntu  6.10    2006-10-26
000013  Ubuntu  7.04    2007-04-19
000014  Ubuntu  7.10    2007-10-18
000015  Ubuntu  8.04    2008-04-24
000016  Ubuntu  8.10    2008-10-30

       
       End Of Report
```

```
$ sort -k 1,1 -k 2n distros.txt | sed -f distros-nl.sed | nl -w 3 -s ' '

    
    Linux Distributions Report
    
    Name         Ver.  Released
    ----         ----  --------

  1 Fedora      5       2006-03-20
  2 Fedora      6       2006-10-24
  3 Fedora      7       2007-05-31
  4 Fedora      8       2007-11-08
  5 Fedora      9       2008-05-13
  6 Fedora      10      2008-11-25
  7 SUSE        10.1    2006-05-11
  8 SUSE        10.2    2006-12-07
  9 SUSE        10.3    2007-10-04
 10 SUSE        11.0    2008-06-19
 11 Ubuntu      6.06    2006-06-01
 12 Ubuntu      6.10    2006-10-26
 13 Ubuntu      7.04    2007-04-19
 14 Ubuntu      7.10    2007-10-18
 15 Ubuntu      8.04    2008-04-24
 16 Ubuntu      8.10    2008-10-30

    
    End Of Report
```

#### fold -- Wrap Each Line to a Specified Length

_Folding_ is the process of breaking lines of text at a specified width.

_fold_ accepts either one or more text files or standard input.

```
$ echo "The quick brown fox jumped over the lazy dog." | fold -w 12
The quick br
own fox jump
ed over the 
lazy dog.
```

The addition of the `-s` option will cause _fold_ to break the line at the last available space before the line width is reached.

```
$ echo "The quick brown fox jumped over the lazy dog." | fold -w 12 -s
The quick 
brown fox 
jumped over 
the lazy 
dog.
```

#### fmt -- A Simple Text Formatter

```
$ fmt -w 50 fmt-info.txt | head
‘fmt’ fills and joins lines to produce output
lines of (at most) a given number of characters
(75 by default).  Synopsis:

     fmt [OPTION]... [FILE]...

   ‘fmt’ reads from the specified FILE
   arguments (or standard input if
none are given), and writes to standard output.

```

So, _fmt_ is preserving the indentation of the first line. Fortunately, _fmt_ provides an option to correct this.

```
$ fmt -cw 50 fmt-info.txt
‘fmt’ fills and joins lines to produce output
lines of (at most) a given number of characters
(75 by default).  Synopsis:

     fmt [OPTION]... [FILE]...

   ‘fmt’ reads from the specified FILE
arguments (or standard input if none are given),
and writes to standard output.

   By default, blank lines, spaces between words,
and indentation are preserved in the output;
successive input lines with different indentation
are not joined; tabs are expanded on input and
introduced on output.

   ‘fmt’ prefers breaking lines at the end
of a sentence, and tries to avoid line breaks
after the first word of a sentence or before
the last word of a sentence.  A “sentence
break” is defined as either the end of a
paragraph or a word ending in any of ‘.?!’,
followed by two spaces or end of line, ignoring
any intervening parentheses or quotes.  Like TeX,
‘fmt’ reads entire “paragraphs” before
choosing line breaks; the algorithm is a variant
of that given by Donald E. Knuth and Michael F.
Plass in “Breaking Paragraphs Into Lines”,
‘Software—Practice & Experience’ 11, 11
(November 1981), 1119–1184.
```

**fmt options**

* -c Operate in _crown margin_ mode. This preserves the indentation of the first two lines of a paragraph. Subsequent lines are aligned with the indentation of the second line.
* -p _string_ Format only those lines beginning with the prefix _string_. After formatting, the contents of _string_ are prefixed to each reformatted line. This option can be used to format text in source code comments.
* -s Split-ony mode. In this mode, lines will only be split to fit the specified column width. Short lines will not be joined to fill lines. This mode is useful when formatting text such as code where joining is not desired.
* -u Perform uniform spacing. This will apply traditional "typewriter-style" formatting to the text. This means a single space between words and two spaces between sentences. This mode is useful for removing _justification_.
* -w _width_ Format text to fit within a column _width_ characters wide. The default is 75 characters. Note: _fmt_ actually formats lines slightly shorter than the specified width to allow for line balancing.

```
$ fmt -w 50 -p '# ' fmt-code.txt
# This file contains code with comments.

# This line is a comment.  Followed by another
# comment line.  And another.

This, on the other hand, is a line of code.
And another line of code.
And another.
```

#### pr -- Format Text for Printing

The _pr_ program is used to _paginate_ text. When printing text, it is often desirable to separate pages of output with several lines of whitespace to provide a top margin and a bottom margin for each page.

```
$ pr -l 15 -w 65 distros.txt


2025-02-23 06:12                distros.txt                Page 1


SUSE    10.2    12/07/2006
Fedora  10      11/25/2008
SUSE    11.0    06/19/2008
Ubuntu  8.04    04/24/2008
Fedora  8       11/08/2007







2025-02-23 06:12                distros.txt                Page 2


SUSE    10.3    10/04/2007
Ubuntu  6.10    10/26/2006
Fedora  7       05/31/2007
Ubuntu  7.10    10/18/2007
Ubuntu  7.04    04/19/2007







2025-02-23 06:12                distros.txt                Page 3


SUSE    10.1    05/11/2006
Fedora  6       10/24/2006
Fedora  9       05/13/2008
Ubuntu  6.06    06/01/2006
Ubuntu  8.10    10/30/2008







2025-02-23 06:12                distros.txt                Page 4


Fedora  5       03/20/2006










```

In this example, we employ the `-l` option (for page length) and the `-w` option (page width) to define a "page" that is 65 columns wide and 15 lines long.

#### printf -- Format and Print Data

_printf_ is not used for pipelines (it does not accept standard input).

_printf_ (from the phrase _print formatted_) was originally developed for the C programming language.

In _bash_, _printf_ is a builtin.

`printf "format" arguments`

```
$ printf "I formatted the string: %s\n" foo
I formatted the string: foo
```

The format string may contain literal text and sequences beginning with the \% character, which are called _conversion specifications_.

```
$ printf "I formatted '%s' as a string.\n" foo
I formatted 'foo' as a string.
```

**Common printf Data Type Specifiers**

* d Format a number as a signed decimal integer
* f Format and output a floating-point number
* o Format an integer as an octal number
* s Format a string
* x Format an integer as a hexadecimal number using lowercase a to f.
* X Same as x but use uppercase letters
* \% Print a literal \% symbol (i.e., specify \%\%)

```
$ printf "%d, %f, %o, %s, %x, %X\n" 380 380 380 380 380 380
380, 380.000000, 574, 380, 17c, 17C
```

A complete conversion specification may consist of the following:

`%[flags][width][.precision]conversion_specification`

**printf Conversion Specification Components**

* _flags_ There are five different flags:
  * \# Use the alternate format for output. This varies by data type. For o (octal number) conversion, the output is prefixed with 0. For x and X (hexadecimal number) conversions, the output is prefixed with 0x or 0X, respectively.
  * 0 (zero): Padd the output  with zeros. This means that the field with be filled with leading zeros, as in 000380.
  * \- (dash) Left align the output. By default, printf right-aligns output.
  * ' ' (space): Produce a leading space for positive numbers.
  * \+ (plus sign) Sign positive numbers. By default, _printf_ only signs negative numbers.
* _width_ A number specifying the minimum field width.
* _.precision_ For floating point numbers, specify the number of digits of precision to be output after the decimal point. For string conversion, _precision_ specifies the number of characters to output.

```
$ printf "%d\n" 380
380
$ printf "%#x\n" 0x17c
0x17c
$ printf "%05d\n" 00380
bash: printf: 00380: invalid octal number
00003
$ printf "%05d\n" 380
00380
$ printf "%05.5f\n" 380
380.00000
$ printf "%010.5f\n" 380
0380.00000
$ printf "%+d\n" 380
+380
$ printf "%-d\n" 380
380
$ printf "%5s\n" abcdefghijk
abcdefghijk
$ printf "%.5s\n" abcdefghijk
abcde
```

_printf_ is used mostly in scripts where it is employed to format tabular data, rather than on the command line directly.

```
$ printf "%s\t%s\t%s\n" str1 str2 str3
str1    str2    str3
```

_\\t_ is the escape sequence for a tab.

```
$ printf "Line: %05d %15.3f Result: %+15d\n" 1071 3.14156295 32589
Line: 01071           3.142 Result:          +32589
```

### Document Formatting Systems


#### groff

_groff_ is a suite of programs containing the GNU implementation of _troff_.
It also includes a script that is used to emulate _nroff_ and the rest of the _roff_ family as well.

This section will concentrate on one of its _macro packages_ that remains in wide use.

```
$ zcat /usr/share/man/man1/ls.1.gz | head
.\" DO NOT MODIFY THIS FILE!  It was generated by help2man 1.47.3.
.TH LS "1" "September 2019" "GNU coreutils 8.30" "User Commands"
.SH NAME
ls \- list directory contents
.SH SYNOPSIS
.B ls
[\fI\,OPTION\/\fR]... [\fI\,FILE\/\fR]...
.SH DESCRIPTION
.\" Add any additional description here
.PP
```

```
$ man ls | head
LS(1)                                                                      User Commands                                                                      LS(1)

NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

DESCRIPTION
       List information about the FILEs (the current directory by default).  Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.
```

The reason this is of interest is that man pages are rendered by _groff_ using the _mandoc_ macro package.

```
$ zcat /usr/share/man/man1/ls.1.gz | groff -mandoc -T ascii | head
LS(1)                            User Commands                           LS(1)



NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

```

If no format is specified, _PostScript_ is output by default.

```
$ zcat /usr/share/man/man1/ls.1.gz | groff -mandoc | head
%!PS-Adobe-3.0
%%Creator: groff version 1.22.4
%%CreationDate: Sun Feb 23 13:24:21 2025
%%DocumentNeededResources: font Times-Roman
%%+ font Times-Bold
%%+ font Times-Italic
%%DocumentSuppliedResources: procset grops 1.22 4
%%Pages: 4
%%PageOrder: Ascend
%%DocumentMedia: Default 612 792 0 () ()
```

_PostScript_ is a _page description language_ that is used to describe the contents of a printed page to a typesetter-like device.

```
$ zcat /usr/share/man/man1/ls.1.gz | groff -mandoc > ~/Desktop/ls.ps
$ ps2pdf ~/Desktop/ls.ps > ~/Desktop/ls.pdf
```

The _ps2pdf_ program is part of the _ghostscript_ package, which is installed on most Linux systems that support printing.

```
$ sort -k 1,1 -k 2n distros.txt | sed -f distros-tbl.sed | groff -t -T ascii
                  +----------------------------+
                  |Linux Distributions Report  |
                  +----------------------------+
                  +----------------------------+
                  |Fedora     5     2006-03-20 |
                  |Fedora    6      2006-10-24 |
                  |Fedora    7      2007-05-31 |
                  |Fedora    8      2007-11-08 |
                  |Fedora    9      2008-05-13 |
                  |Fedora   10      2008-11-25 |
                  |SUSE     10.1    2006-05-11 |
                  |SUSE     10.2    2006-12-07 |
                  |SUSE     10.3    2007-10-04 |
                  |SUSE     11.0    2008-06-19 |
                  |Ubuntu    6.06   2006-06-01 |
                  |Ubuntu    6.10   2006-10-26 |
                  |Ubuntu    7.04   2007-04-19 |
                  |Ubuntu    7.10   2007-10-18 |
                  |Ubuntu    8.04   2008-04-24 |
                  |Ubuntu    8.10   2008-10-30 |
                  +----------------------------+
```

`$ sort -k 1,1 -k 2n distros.txt | sed -f distros-tbl.sed | groff -t > ~/Desktop/distros.ps`