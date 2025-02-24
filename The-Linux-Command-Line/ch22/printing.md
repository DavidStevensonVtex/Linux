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