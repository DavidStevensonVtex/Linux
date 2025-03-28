# The Linux Command Line, 2nd Edition, © 2019

## Chapter 22: Printing

* pr Convert text files for printing
* lpr Print files
* a2ps Format files for printing on a PostScript printer
* lpstat Show printer status information
* lpq Show printer queue status
* lprm cancel print jobs

### A Brief History of Printing

#### Printing in the Dim Times

When printers were expensive and centralized, as they often were in the early days of Unix, it was common practice for many users to share a printer. To identify print jobs belonging to a particular user, a _banner page_ displaying the name of the user was often printed at the beginning of each print job.

#### Character-Based Printers

Printers of the 1980s were almost always _impact printers_.

Two of the popular technologies of that time were _daisy-wheel_ and _dot-matrix_ printing.

Low-numbered ASCII control codes provided a means of moving the printer's carriage and paper, using codes for carriage return, line feed, form feed, and so on.

```
$ zcat /usr/share/man/man1/ls.1.gz | nroff -man | cat -A | head
LS(1)                            User Commands                           LS(1)$
$
$
$
N^HNA^HAM^HME^HE$
       ls - list directory contents$
$
S^HSY^HYN^HNO^HOP^HPS^HSI^HIS^HS$
       l^Hls^Hs [_^HO_^HP_^HT_^HI_^HO_^HN]... [_^HF_^HI_^HL_^HE]...$
$
```
The _^H_ (Ctrl-H) characters are the backspaces used to create the bold-face effect.


#### Graphical Printers

Laser printers with 300 dots per inch were created, but sending a bit for each pixel slowed networks.

The solution was the _page description language_ (PDL).

The first major PDL was _PostScript_ from Adobe Systems.

A _PostScript_ printer accepted a PostScript program as input.

#### Printing with Linux

Modern Linux systems employ two software suites to perform and manage printing.

* Common Unix Printing System (CUPS) - print drivers and print job management
* GhostScript - A _PostScript_ interpreter, acts as a Raster Image Processor (RIP).

### Preparing Files for Printing

#### pr -- Convert Text Files for Printing

**Common pr Options**

* +_first_[:_last_] Output a range of pages
* -_columns_ Organize the content of the page into the number of c olumns specified by _columns_.
* -a By default, multicolumn output is listed vertically. By adding the \-a (across) option, content is listed horizontally.
* -d Double-space output
* -f Use form feeds rather than carriage returns to separate pages
* -h _header_ In the center portion of the page header, use _header_ rather than the name of the file being processed
* -l _length_ Set page length to _length_. The default is 66 (US letter at 6 lines per inch).
* -n Number lines
* -o _offset_ Create a left margin _offset_ characters wide
* -w _width_ Set the page width to _width_. The default is 72

_pr_ is often used in pipelines as a filter

```
$ ls /usr/bin | pr -3 -w 65 | head


2025-02-24 12:43                                           Page 1


[		          aseqdump		    boltctl
411toppm	      aseqnet		    bootctl
aa-enabled	      aspell		    brltty-ctb
aa-exec		      aspell-import	    brltty-trtxt
ac		          at		        brltty-ttb
```

### Sending a Print Job to a Printer

#### lpr -- Print Files (Berkeley Style)

The _lpr_ program can be used to send files to the printer. It may also be used in pipelines, as it accepts standard input.

`$ ls /usr/bin | pr -3 | lpr`

The report would be sent to the system's default printer.
To send the file to a different printer, the `-P` otion can be used like this:

`lpr -P printer_name`

To see a list of printers known to the system, use this:

`lpstat -a`

Many Linux distributions allow you to define a "printer" that outputs files to PDF, rather than printing on the physical printer. This is handy for experimenting with printing commands. Check your printer configuration program to see whether it supports this configuration. On some distributions, you may need to install additional packages (such as _cups-pdf) to enable this capability.

`sudo apt install cups`

Since Ubuntu 16:

`sudo apt-get install printer-driver-cups-pdf`

```
$ lpstat -a
PDF accepting requests since Mon 24 Feb 2025 12:55:51 PM EST
```

**Common _lpr_ Options**

* \-\# _number_ Set number of copies to _number_.
* -p Print each page with a shaded header with the date, time, job name, and page number. This so-called pretting-print option can be used when printing text files.
* -P printer Specify the name of the printer used for output. If no printer is specified, the system's default printer is used.
* -r Delete files after printing. This would be useful for programs that produce temporary printer-output files.

#### lp =-- Print Files (System V Style)

Like _lpr_, _lp_ accepts either files or standard input for printing. It differs from _lpr_ in that it supports a different (and slightly more sophisticated) option set.

**Common _lp_ Options**

* -d _printer_ Set the destination (printer) to _printer_. If no -d option is specified, the system default printer is used.
* -n _number_ Set the number of copies to _number_.
* -o landscape Set output to landscape orientation.
* -o fitplot Scale the file to fit the page. This is useful when printing images, such as JPEG files.
* -o scaling=_number_ Scale file to _number_. The value of 100 fills the page. Values less than 100 are reduced, while values greater than 100 cause the file to printed across multiple pages.
* -o cpi=_number_ Set the output characters per inch to _number_. The default is 6.
* -o page-bottom=_points_ Set the page margins. Values are expressed in _points_, a unit of typographic measurement. There are  72 points to an inch.
* -o page-left=_points_
* -o page-right=_points_
* -o page-top=_points_
* -P _pages_ Specify the list of pages. _pages_ may be expressed as a comma-separated list and/or a range, for example, 1,3,5,7-10.



`lp -d PDF fmt-info.txt`

PDF file is placed in ~/PDF folder.

#### Another Option: a2ps

a2ps originally meant "ASCII to PostScript", and it was used to prepare text files for pringint on PostScript printers.

a2ps now means "Anything to PostScript".

While its name suggests a format-conversion program, it is actually a printing program.

`sudo apt install a2ps`

The program's default behavior is that of a "pretty printer", meaning that it improves the appearance of output.

We can use the program to create a PostScript file on our desktop.

```
$ ls /usr/bin | pr -3 -t | a2ps -o ~/Desktop/ls.ps -L 66
[stdin (plain): 10 pages on 5 sheets]
[Total: 10 pages on 5 sheets] saved into the file `/home/dstevenson/Desktop/ls.ps'
```

**a2ps Options**

* --center-title=_text_ Set center page title to _text_.
* --columns=_number_ Arrange pages into _number_ columns. The default is 2.
* --footer=_text_ Set page footer to text
* --guess Report the types of files given as arguments. Since _a2ps_ tries to convert and format all types of data, this option can be useful for predicting what _a2ps_ will do when given a particular file.
* --left-footer=_text_ Set the left-page footer to _text_.
* --left-title=_text_ Set the left-page title t- _text_.
* --line-numbers=_interval_ Number lines of output every _interval_ lines.
* --list=defaults Display default settings.
* --pages=_range_ Print pages in range.
* --right-footer=_text_ Set right-page footer to _text_.
* --right-title=_text_ Set right-page title to _text_.
* --rows=_number_ Arrange pages into number rows. The default is 1.
* -B No page headers.
* -b _text_ Set the page header to _text_.
* -f _size_ Use _size_ point font.
* -l _number_ Set characters per line to _number_. This and the -L option (see the next entry) can be used to make files paginated with other programs, such as _pr_, fit correctly on the page.
* -L _number_ Set lines per page to _number_.
* -M _name_ Output number copies of each page.
* -n _number_ Set lines per page to _number_.
* -o _file_ Send output to _file_. If _file_ is specified as -, use standard output.
* -P _printer_ Use _printer_. If printer is not specified, the system default printer is used.
* -R Portrait orientation.
* -r Landscape orientation.
* -T _number_ Set tab stops to every _number_ characters.
* -u _text_ Underlay (watermark) pages with _text_.

Another option is called _enscript_.

### Monitoring and Controlling Print Jobs

Each printer is given a _print queue_, where jobs are parked until they can be _spooled_ to the printer.

#### lpstat - Display Print System Status

```
$ lpstat -a
PDF accepting requests since Mon 24 Feb 2025 01:10:42 PM EST
```

```
$ lpstat -s
system default destination: PDF
device for PDF: cups-pdf:/
```

```
$ lpstat -d
system default destination: PDF
```

```
$ lpstat -r
scheduler is running
```

```
$ lpstat -t
scheduler is running
system default destination: PDF
device for PDF: cups-pdf:/
PDF accepting requests since Mon 24 Feb 2025 01:10:42 PM EST
printer PDF is idle.  enabled since Mon 24 Feb 2025 01:10:42 PM EST
```

**Common _lpstat_ Options**

* -a [_printer_...] Display the state of the printer queue for _printer_.
* -d Display the name of the system's default printer.
* -p [_printer_...] Display the status of the specified _printer_. If no printers are specified, all printers are shown.
* -r Display the status of the print server
* -s Display a status summary.
* -t Display a complete status report.
* 
#### lpq -- Display Printer Queue Status

```
$ lpq
PDF is ready
no entries
```

```
$ ls *.txt | pr -3 | lp
request id is PDF-7 (0 file(s))
```

#### lprm/cancel -- Cancel Print Jobs

CUPS supplies two programs used to terminate print jobs and remove them from the print queue. One is Berkeley style (_lprm_), and the other is System V (_cancel_).

```
cancel 603
lpq
```