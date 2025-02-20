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
Fedora          10      11/25/2008
Ubuntu          8.10    10/30/2008
SUSE            11.0    06/19/2008
Fedora          9       05/13/2008
SUSE            10.1    05/13/2008
Ubuntu          8.04    04/24/2008
Fedora          8       11/08/2007
Ubuntu          7.10    10/18/2007
SUSE            10.3    10/04/2007
Fedora          7       05/31/2007
Ubuntu          7.04    04/19/2007
SUSE            10.2    12/07/2006
Ubuntu          6.10    10/26/2006
Fedora          6       10/24/2006
Ubuntu          6.06    06/01/2006
Fedora          5       03/20/2006
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
SUSE^I10.1^I05/13/2008$
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
05/13/2008
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
2008
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