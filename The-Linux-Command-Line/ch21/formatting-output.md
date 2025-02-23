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