# The Linux Command Line, 2nd Edition, © 2019

## Chapter 20 Text Processing

All Unix-like operating systems rely heavily on text files for data storage.

* cat Concatenate and print on the standard output
* sort Sort lines of text files
* uniq Report or omit repeated lines
* cut Remove sections from each line of files
* paste Merge lines of files
* join Join lines of two files on a common field
* comm Compare two sorted files line by line
* diff Compare files line by line
* patch Apply a diff file to an original
* tr Translate or delete characters
* sed Stream editor for filtering and transforming text
* aspell Interactive spell checker

### Applications of Text

#### Documents

Many people write documents using plain text formats.

Many scientific papers are written using this method, as Unix-based text processing systems were among the first systems that supported the advanced typographical layout needed by writers in technical disciplines.

#### Web Pages

Web pages are text documents that use either Hypertext Markup Language (HTML) or Extensible Markup Language (XML) as markup languages to describe the documents visual format.

#### Email

An email begins with a header that describes the source of the message and processing it received during its journey, followed by the body of the message with its content.

#### Printer Output

#### Program Source Code

### Revisiting Some Old Friends

#### cat

One interesting option is the `-A` option, which is used to display non-printing characters.

The most common of these are tab characters and carriage returns.

```
$ cat > foo.txt
The quick brown fox jumped over the lazy dog.      
$ cat -A foo.txt
The quick brown fox jumped over the lazy dog.      $
```

The `-n` option numbers lines, and the `-s` option suppresses the output of multiple blank lines.

```
$ cat -ns foo.txt
     1  The quick brown fox
     2
     3  jumped over the lazy dog.
```

#### sort

The `soft` program sorts the contents of standard output, or one or more files specified on the command line, and sends the results to standard output.

```
$ sort > foo.txt
c
b
a
$ cat foo.txt
a
b
c
```

It is possible to _merge_ multiple files into a single sorted whole.

`sort file1.txt file2.txt file3.txt > final_sorted_list.txt`

**Common sort Options**

* -b --ignore-leading-blanks
* -f --ignore-case
* -n --numeric-sort
* -r --reverse 
* -k --key=field1[,field2] Sort based on a key field from _field1_ to _field2_.
* -m -merge Treat each argument as the name of a presorted file. Merge multiple files into a single sorted result without performing any additional sorting.
* -o --output-file Send sorted output to _file_ rather than standard output
* -t --field-separator=char Define the field separateor character. By default fields are separated by spaces or tabs

```
$ du -s /usr/share/* | sort -nr | head
434536  /usr/share/code
186316  /usr/share/fonts
91520   /usr/share/doc
75340   /usr/share/icons
65804   /usr/share/libreoffice
51092   /usr/share/gimp
50692   /usr/share/backgrounds
46860   /usr/share/locale
46152   /usr/share/help
42840   /usr/share/ibus
```

by using the n and r options, we produce a reverse numerical sort, with the largest values appearing first in the results.

```
$ ls -l /usr/bin | sort -nrk 5 | head
-rwxr-xr-x 1 root       root       217608984 Dec 19  2013 mongod
-rwxr-xr-x 1 root       root       168212624 Dec 19  2013 mongos
-rwxr-xr-x 1 root       root       149245160 Feb  4 12:38 mongosh
-rwxr-xr-x 1 root       root        76771480 Feb  7 08:26 atlas
-rwxr-xr-x 1 dstevenson dstevenson  18100544 Jan 22 11:58 mongorestore
-rwxr-xr-x 1 dstevenson dstevenson  17767248 Jan 22 11:58 mongodump
-rwxr-xr-x 1 dstevenson dstevenson  17677776 Jan 22 11:58 mongoimport
-rwxr-xr-x 1 root       root        17605304 Oct 11 04:05 snap
-rwxr-xr-x 1 dstevenson dstevenson  17505256 Jan 22 11:58 mongoexport
-rwxr-xr-x 1 dstevenson dstevenson  17490664 Jan 22 11:58 mongofiles
```

It mostly worked. The problem occurs in the sorting of the Fedora version numbers.
Because 1 comes before 5 in the character set, version 10 ends up at the top while version 9 falls to the bottom.


```
$ sort distros.txt
Fedora          10      11/25/2008
Fedora          5       03/20/2006
Fedora          6       10/24/2006
Fedora          7       05/31/2007
Fedora          8       11/08/2007
Fedora          9       05/13/2008
SUSE            10.1    05/13/2008
SUSE            10.2    12/07/2006
SUSE            10.3    10/04/2007
SUSE            11.0    06/19/2008
Ubuntu          6.06    06/01/2006
Ubuntu          6.10    10/26/2006
Ubuntu          7.04    04/19/2007
Ubuntu          7.10    10/18/2007
Ubuntu          8.04    04/24/2008
Ubuntu          8.10    10/30/2008
```

```
$ sort --ke=1,1 --key=2n distros.txt
Fedora          5       03/20/2006
Fedora          6       10/24/2006
Fedora          7       05/31/2007
Fedora          8       11/08/2007
Fedora          9       05/13/2008
Fedora          10      11/25/2008
SUSE            10.1    05/13/2008
SUSE            10.2    12/07/2006
SUSE            10.3    10/04/2007
SUSE            11.0    06/19/2008
Ubuntu          6.06    06/01/2006
Ubuntu          6.10    10/26/2006
Ubuntu          7.04    04/19/2007
Ubuntu          7.10    10/18/2007
Ubuntu          8.04    04/24/2008
Ubuntu          8.10    10/30/2008
```

Because we wanted to limit the sort to just the first field, we specified 1,1 which means "start at field 1 and end at field 1".

```
$ sort -k 3.7nbr -k 3.1nbr -k 3.4nbr distros.txt
Fedora  10      11/25/2008
Ubuntu  8.10    10/30/2008
SUSE    11.0    06/19/2008
Fedora  9       05/13/2008
Ubuntu  8.04    04/24/2008
Fedora  8       11/08/2007
Ubuntu  7.10    10/18/2007
SUSE    10.3    10/04/2007
Fedora  7       05/31/2007
Ubuntu  7.04    04/19/2007
SUSE    10.2    12/07/2006
Ubuntu  6.10    10/26/2006
Fedora  6       10/24/2006
Ubuntu  6.06    06/01/2006
SUSE    10.1    05/11/2006
Fedora  5       03/20/2006

```

Sort by default shell:

```
$ sort -t ':' -k 7 /etc/passwd | head
dstevenson:x:1000:1000:dstevenson,,,:/home/dstevenson:/bin/bash
root:x:0:0:root:/root:/bin/bash
gdm:x:120:125:Gnome Display Manager:/var/lib/gdm3:/bin/false
gnome-initial-setup:x:119:65534::/run/gnome-initial-setup/:/bin/false
hplip:x:117:7:HPLIP system user,,,:/var/run/hplip:/bin/false
speech-dispatcher:x:110:29:Speech Dispatcher,,,:/var/run/speech-dispatcher:/bin/false
tss:x:123:128:TPM software stack,,,:/var/lib/tpm:/bin/false
whoopsie:x:111:117::/nonexistent:/bin/false
sync:x:4:65534:sync:/bin:/bin/sync
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
```

#### uniq 

`uniq` removes any duplicate lines and sends the results to standard output.
It is often used in conjunction with sort to clean the output of duplicates.

_While uniq isa traditional Unix tool often used with sort, the GNU version of sort supports a -u option, which removes duplicates from the sorted output._

```
$ cat > foo.txt
a
b
c
a
b
c
$ uniq foo.txt
a
b
c
a
b
c
$ sort foo.txt | uniq
a
b
c
```

**Common uniq Options**

* -c --count Output a list of duplicate lines preceded by the number of times the line occurs.
* -d --repeated Output only repeated lines, rather than unique lines
* -f n --skip-fields=n Ignore n leading fields in each line. Fields are separated by whitespace as they are in sort; however, unlike sort, uniq has no option for setting an alternate field separator.
* -i --ignore case Ignore case during the line comparisions
* -s n --skip-chars=n Skip (ignore) the leading n characters of each line
* -u --unique Output only unique lines. Lines with duplicates are ignored.

```
$ sort foo.txt | uniq -c
      2 a
      2 b
      2 c
```

### Slicing and Dicing

#### cut -- Remove Sections from Each Line of Files

The `cut` program is used to extract a section of text from a line and output the extracted section to standard output. It can accept multiple file arguments or input from standard input.

**cut Selection Options**

* -c list --characters=_list_ Extract the portion of the line defined by _list_. The list may consist of one or more comma-separated numerical ranges.
* -f list --fields=_list_ Extract one or more fields from the line as defined by _list_. The list may contain one or more field ranges separated by commas.
* -d delim --delimiter=_delim_ When -f is specified, use _delim_ as the field delimiting character. By default, fields must  be separated by a single tab character.
* --complement Extract the entire line of text, except for those portions specified by -c and/or -f.


```
$ cat -A distros.txt
SUSE^I10.2^I12/07/2006$
Fedora^I10^I11/25/2008$
SUSE^I11.0^I06/19/2008$
Ubuntu^I8.04^I04/24/2008$
Fedora^I8^I11/08/2007$
SUSE^I10.3^I10/04/2007$
Ubuntu^I6.10^I10/26/2006$
Fedora^I7^I05/31/2007$
Ubuntu^I7.10^I10/18/2007$
Ubuntu^I7.04^I04/19/2007$
SUSE^I10.1^I05/11/2006$
Fedora^I6^I10/24/2006$
Fedora^I9^I05/13/2008$
Ubuntu^I6.06^I06/01/2006$
Ubuntu^I8.10^I10/30/2008$
```

```
$ cut -f 3 distros.txt
12/07/2006
11/25/2008
06/19/2008
04/24/2008
11/08/2007
10/04/2007
10/26/2006
05/31/2007
10/18/2007
04/19/2007
05/11/2006
10/24/2006
05/13/2008
06/01/2006
10/30/2008
03/20/2006
```

```
$ cut -f 3 distros.txt | cut -c7-10
2006
2008
2008
2008
2007
2007
2006
2007
2007
2007
2006
2006
2008
2006
2008
2006
```

```
$ cut -d ':' -f 1 /etc/passwd | head
root
daemon
bin
sys
sync
games
man
lp
mail
news
```

#### paste -- Merge Lines of Files

The _paste_ command does the opposite of _cut_. Rather than extracting a column of text from a file, it adds one or more columns of text to a file.

It does this by reading multiple files and combining the fields found in each file into a single stream on standard input. Like _cut_, _paste_ accepts multiple file arguments and/or standard input.

```
$ sort -k 3.7nbr -k 3.1nbr -k 3.4nbr distros.txt > distros-by-date.txt
$ cut -f 1,2 distros-by-date.txt > distros-versions.txt
$ head distros-versions.txt
Fedora  10
Ubuntu  8.10
SUSE    11.0
Fedora  9
Ubuntu  8.04
Fedora  8
Ubuntu  7.10
SUSE    10.3
Fedora  7
Ubuntu  7.04
```

```
$ cut -f 3 distros-by-date.txt > distros-dates.txt
$ head distros-dates.txt
11/25/2008
10/30/2008
06/19/2008
05/13/2008
04/24/2008
11/08/2007
10/18/2007
10/04/2007
05/31/2007
04/19/2007
```

```
$ paste distros-dates.txt distros-versions.txt
11/25/2008      Fedora  10
10/30/2008      Ubuntu  8.10
06/19/2008      SUSE    11.0
05/13/2008      Fedora  9
04/24/2008      Ubuntu  8.04
11/08/2007      Fedora  8
10/18/2007      Ubuntu  7.10
10/04/2007      SUSE    10.3
05/31/2007      Fedora  7
04/19/2007      Ubuntu  7.04
12/07/2006      SUSE    10.2
10/26/2006      Ubuntu  6.10
10/24/2006      Fedora  6
06/01/2006      Ubuntu  6.06
05/11/2006      SUSE    10.1
03/20/2006      Fedora  5
```

#### join -- Join Lines of Two Files on a Common Field

In some ways, join is like paste in that it adds columns to a file, but it uses a unique way to do it. A join is an operation usually associated with relational databases where data from multiple tables with a shared key field is combined to form a desired result.

```
First table: CUSTOMERS

CUSTNUM FNAME LNAME
======= ===== =====
4681934 John  Smith

Second table: ORDERS

ORDERNUM    CUSTNUM   QUAN   ITEM
========    =======   ====   ====
3014953305  4681934   1      Blue Widget

```

Performing a join operation would allow us to combine the fields in the two tables to achieve a useful result, such as preparing an invoice.

```
FNAME LNAME QUAN  ITEM
===== ===== ====  ====
John  Smith 1     Blue Widget
```
One contains the release dates (which will be our shared key for this demonstration) and the release names.
```
$ cut -f 1,1 distros-by-date.txt > distros-names.txt
$ paste distros-dates.txt distros-names.txt > distros-key-names.txt
$ head distros-key-names.txt
11/25/2008      Fedora
10/30/2008      Ubuntu
06/19/2008      SUSE
05/13/2008      Fedora
04/24/2008      Ubuntu
11/08/2007      Fedora
10/18/2007      Ubuntu
10/04/2007      SUSE
05/31/2007      Fedora
04/19/2007      Ubuntu
```

The second file contains the release dates and the version numbers, as shown here.


```
$ cut -f 2,2 distros-by-date.txt > distros-vernums.txt
$ paste distros-dates.txt distros-vernums.txt > distros-key-vernums.txt
$ head distros-key-vernums.txt
11/25/2008      10
10/30/2008      8.10
06/19/2008      11.0
05/13/2008      9
04/24/2008      8.04
11/08/2007      8
10/18/2007      7.10
10/04/2007      10.3
05/31/2007      7
04/19/2007      7.04
```

We now have two files with a shared key (the "release date" field). It is important to point out that the files must be sorted on the key field for join to work properly.

```
$ join distros-key-names.txt distros-key-vernums.txt  | head
$ join distros-key-names.txt distros-key-vernums.txt  | head
11/25/2008 Fedora 10
10/30/2008 Ubuntu 8.10
06/19/2008 SUSE 11.0
05/13/2008 Fedora 9
04/24/2008 Ubuntu 8.04
11/08/2007 Fedora 8
10/18/2007 Ubuntu 7.10
10/04/2007 SUSE 10.3
05/31/2007 Fedora 7
04/19/2007 Ubuntu 7.04
```

### Comparing Text

It is often useful to compare versions of text files.

#### comm -- Compare Two Sorted Files Line by Line

```
$ cat > file1.txt
a
b
c
d
$ cat > file2.txt
b
c
d
e
$ comm file1.txt file2.txt
a
                b
                c
                d
        e
```

As we can see, comm produces three columns of output. The first column contains lines unique to the first file argument, the second column contains lines unique to the second file argument, and the third column contains the lines shared by both files.

If we wanted to output only the lines shared by both files, we would suppress the output of the first and second columns.

```
$ comm -12 file1.txt file2.txt
b
c
d
```

#### diff -- Compare Files Line by Line

`diff` is used to detect the differences between files.

```
$ diff file1.txt file2.txt
1d0
< a
4a4
> e
```

`diff` provides a terse description of the differences between two files.
In the default format, each group of changes is preceded by a _change command_ in the form of _range operation range` to describe the positions and types of c hanges required to convert the first file to the second file.

`diff` Change Commands

* r1ar2 Append the lines at position r2 in the second file to the position r1 in the first file.
* r1cr2 Change (replace) the lines at position r1 with the lines at the position r2 in the second file.
* r1dr2 Delete the lines in teh first file at position r1, which would have appeared at range r2 in the second file.

In this format, a range is a comma-separated list of the starting line and ending line.

Two of the more popular formats are the _context format_ and the _unified format_.

When viewed using the context format (the `-c` option), we will see this:

```
$ diff -c file1.txt file2.txt
*** file1.txt   2025-02-21 15:36:43.873271961 -0500
--- file2.txt   2025-02-21 15:36:58.225266759 -0500
***************
*** 1,4 ****
- a
  b
  c
  d
--- 1,4 ----
  b
  c
  d
+ e
```

The first file is marked with asterisks, and the second file is marked with dashes. 
Throughout the remainder of the listing, these markers will signify their respective files.

`diff` Context Format Change Indicators

* blank A line shown for context. It does not indicate a difference between the two files.
* - A line deleted. This line will appear in the first file but not in the second file.
* + A line added. This line will appear in the second file but not in the first file.
* ! A line changed. The two versiosn of the line will be displayed each in its respective section of the change group.

The unified format is similar to the context format but is more concise. It is specified with the `-u` option.

```
$ diff -u file1.txt file2.txt
--- file1.txt   2025-02-21 15:36:43.873271961 -0500
+++ file2.txt   2025-02-21 15:36:58.225266759 -0500
@@ -1,4 +1,4 @@
-a
 b
 c
 d
+e
```

The most notable difference between the context and unified formats is the elimination of the duplicated lines of context, making the results of the unified format shorter than those of the context format.

`diff` Unified Format Change Indicators

* blank This line is shared by both files.
* - This line was removed from the first file.
* + This line was added to the first file.

#### patch -- Apply a diff to an Original

The `patch` program is used to apply changes to text files. It accepts output from `diff` and is generally used to convert older-version files into newer versions.

Using `diff/patch` offers two significant advantages.

* The diff file is small, compared to the full size of the source tree.
* The diff file concisely shows the change being made, allowing reviewers of the patch to quickly evaluate it.

Of course, `diff/patch` will work on any text file, not just source code.

To prepare a diff file for use with patch, the GNU documentation suggests using `diff` as follows:

`diff -Naur old_file new_file > diff_file`

where _old\_file_ and _new\_file_ are either single files or directories containing files.

The `r` option supports recursion of a directory tree.

Once the diff file has been created, we can apply it to patch the old file into the new file.

`patch < diff_file`

```
$ diff -Naur file1.txt file2.txt > patchfile.txt
$ patch < patchfile.txt
patching file file1.txt
$ diff file1.txt file2.txt
$ cat file1.txt
b
c
d
e
```

### Editing on the Fly

#### tr -- Transliterate or Delete Characters

The `tr` program is used to _transliterate_ characters.

```
$ echo "lowercase letters" | tr a-z A-Z
LOWERCASE LETTERS
```

`tr` operates on standard input and outputs results to standard output.

Character sets may be expressed in one of three ways.

* An enumerated list. For example: ABCDEFGHIJKLMNOPQRSTUVWXYZ
* A character range. For example: A-Z. Subject to issues with locale collation order.
* POSIX character classes. For example: [:upper:].

```
$ echo "lowercase letters" | tr [:lower:] A
AAAAAAAAA AAAAAAA
```

`tr` allows characters to be deleted from the input stream.

`tr -d '\r' < dos_file > unix_file`

To see a complete list of the sequences and character classes `tr` supports, type the following:

`tr --help`

Using the `-s` option, tr can "squeeze" (delete) repeated instances of a character.

```
$ echo "aaabbbccc" | tr -s ab
abccc
```

**Secret Decoder Ring**

```
$ echo "secret text" | tr a-zA-Z n-za-mN-ZA-M
frperg grkg
$ echo "frperg grkg" | tr n-za-mN-ZA-M a-zA-Z
secret text
```

#### sed - Stream Editor for Filtering and Transforming Text

The name `sed` is short for _stream editor_.

```
$ echo "front" | sed 's/front/back/'
back
```

Commands in `sed` begin with a single letter.

The choice of delimiter character is arbitrary.

```
$ echo "front" | sed 's_front_back_'
back
```

Most commands in sed may be preceded by an _address_, whjich specifies which line(s) of the input stream will be edited. If the address is omitted, then the editing command is carried out on every line in the input stream. The simplest form of an address is a line number.

```
$ echo "front" | sed '1s/front/back/'
back
```

**sed Address Notation**

* n A line number where n is a positive integer.
* $ The last line
* /regexp/ Lines matching a POSIX basic regular expression. Note that the regular expression is delimited by slash characters. May be delimited by an alternate character.
* addr1,addr2 A range of lines from addr1 to addr, inclusive.
* first~step Match the line represented by number first and then each subsequent lines at step intervals.
* addr1,+n Match addr1 and the following n lines.
* addr! Match all lines except addr, which may be any of the forms listed earlier.

```
$ sed -n '1,5p' distros.txt
SUSE    10.2    12/07/2006
Fedora  10      11/25/2008
SUSE    11.0    06/19/2008
Ubuntu  8.04    04/24/2008
Fedora  8       11/08/2007
```
```
$ head -5 distros.txt
SUSE    10.2    12/07/2006
Fedora  10      11/25/2008
SUSE    11.0    06/19/2008
Ubuntu  8.04    04/24/2008
Fedora  8       11/08/2007
```

```
$ sed -n '/SUSE/p' distros.txt 
SUSE    10.2    12/07/2006
SUSE    11.0    06/19/2008
SUSE    10.3    10/04/2007
SUSE    10.1    05/11/2006
```

```
$ sed -n '/SUSE/!p' distros.txt
Fedora  10      11/25/2008
Ubuntu  8.04    04/24/2008
Fedora  8       11/08/2007
Ubuntu  6.10    10/26/2006
Fedora  7       05/31/2007
Ubuntu  7.10    10/18/2007
Ubuntu  7.04    04/19/2007
Fedora  6       10/24/2006
Fedora  9       05/13/2008
Ubuntu  6.06    06/01/2006
Ubuntu  8.10    10/30/2008
Fedora  5       03/20/2006$ 
```

By adding an exclamation point, all the lines in the file except the ones matched by the regular expression are printed.

**sed Basic Editing Commands**

* = Output the current line number
* a Append text after the current line
* d Delete the current line
* i Insert text in front of the current line.
* p Print the current line. By default, sed prints every line and only edits the line that match a specified address within the file. The default behavior can be overridden by specifying the `-n` option.
* q Exit sed without processing any more lines. If the `-n` option is not specified, output the current line.
* Q Exit sed without processing any more lines.
* s/regexp/replacement/ Substitute the contents of _replacement_ wherever _regexp_ is found. _replacement_ may include the special character \&, which is equivalent to the text matched by _regexp_. In addition, _replacement_ may include the sequences \\1 through \\9, which are the contents of the corresponding expressions in _regexp_.
* y/set1/set2 Perform transliteration by converting characters from _set1_ to the corresponding characters in _set2_. Not that unlike _tr_, sed requires that both sets be of the same length.

```
$ sed 's/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{4\}\)/\3-\1-\2/' distros.txt
SUSE    10.2    2006-12-07
Fedora  10      2008-11-25
SUSE    11.0    2008-06-19
Ubuntu  8.04    2008-04-24
Fedora  8       2007-11-08
SUSE    10.3    2007-10-04
Ubuntu  6.10    2006-10-26
Fedora  7       2007-05-31
Ubuntu  7.10    2007-10-18
Ubuntu  7.04    2007-04-19
SUSE    10.1    2006-05-11
Fedora  6       2006-10-24
Fedora  9       2008-05-13
Ubuntu  6.06    2006-06-01
Ubuntu  8.10    2008-10-30
Fedora  5       2006-03-20
```

`sed 's/regexp/replacement/' distros.txt

```
$ echo "aaabbbccc" | sed 's/b/B/'
aaaBbbccc
```

```
$ echo "aaabbbccc" | sed 's/b/B/g'
aaaBBBccc
```

It is possible to construct more complex commands in a script  file using the `-f` option.

**distros.sed**

```
# sed script to produce Linux distributions report
1i
\
Linux Distributions Report\

s/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{4\}\)/\3-\1-\2/

y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/
```

```
$ sed -f distros.sed distros.txt

Linux Distributions Report

SUSE    10.2    2006-12-07
FEDORA  10      2008-11-25
SUSE    11.0    2008-06-19
UBUNTU  8.04    2008-04-24
FEDORA  8       2007-11-08
SUSE    10.3    2007-10-04
UBUNTU  6.10    2006-10-26
FEDORA  7       2007-05-31
UBUNTU  7.10    2007-10-18
UBUNTU  7.04    2007-04-19
SUSE    10.1    2006-05-11
FEDORA  6       2006-10-24
FEDORA  9       2008-05-13
UBUNTU  6.06    2006-06-01
UBUNTU  8.10    2008-10-30
FEDORA  5       2006-03-20
```

```
$ cat -n distros.sed
     1  # sed script to produce Linux distributions report
     2
     3  1 i\
     4  \
     5  Linux Distributions Report\
     6
     7  s/\([0-9]\{2\}\)\/\([0-9]\{2\}\)\/\([0-9]\{4\}\)/\3-\1-\2/
     8  y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/
```

Line 1 is a comment.

Line 2  is a blank line. Like comments, blank lines may be added to improve readability.


Lines 3-6 contain text to be inserted at address 1, thie first line of the input.

The backslash is used to escape a carriage return, which is inserted.

_A line continuation character is formed by a backslash followed immediately by a carriage return. No intermediary spaces are permitted._

**People who like sed also like...**

Many users prefer other tools for larger tasks. The most popular of these are _awk_ and _perl_.

#### aspell -- Interactive Spellchecker

`aspell check textfile`

**foo2.txt**

```
The quick brown fox jimped over the laxy dog.
```

`$ aspell check foo2.txt`

```
$ cat foo2.txt
The quick brown fox jumped over the lazy dog.
```

```
$ cat foo2.txt.bak
The quick brown fox jimped over the laxy dog.
```

**foo.html**

```
<html>
    <head>
        <title>Misspelled HTML file</title>
    </head>
    <body>
        <p>The quick brown fox jimped over the laxy dog.</p>
    </body>
</html>
```

`$ aspell check foo.html`

```
$ cat foo.html
<html>
    <head>
        <title>Misspelled HTML file</title>
    </head>
    <body>
        <p>The quick brown fox jumped over the lazy dog.</p>
    </body>
</html>
```

```
$ cat foo.html.bak
<html>
    <head>
        <title>Misspelled HTML file</title>
    </head>
    <body>
        <p>The quick brown fox jimped over the laxy dog.</p>
    </body>
</html>
```

Check HTML tags for misspellings.

`$ aspell -H check foo.txt`

By default, aspell will ignore URLs and email addresses in text.

### Extra Credit

More interesting text-manipulation commands:

* split (split files into pieces)
* csplit (split files into pieces based on context)
* sdiff (side-by-side merge of file differences)