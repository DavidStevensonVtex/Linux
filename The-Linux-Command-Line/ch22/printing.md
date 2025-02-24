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

* # _number_ Set number of copies to _number_.
* -p Print each page with a shaded header with the date, time, job name, and page number. This so-called pretting-print option can be used when printing text files.
* -P printer Specify the name of the printer used for output. If no printer is specified, the system's default printer is used.
* -r Delete files after printing. This would be useful for programs that produce temporary printer-output files.

