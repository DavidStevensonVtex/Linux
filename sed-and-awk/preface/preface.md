# sed & awk, 2nd Edition, © 1997

## Preface

Because there is a natural progression in learning from **grep** to sed to awk, we will be covering all three programs, although the focus is on sed and awk.

Sed, so called because it is a stream editor, is perfect for applying a series of edits to a number of files.

Awk, named after its developers, Aho, Weinberger, and Kernighan, is a programming language that permits easy manipulation of structured data and the generation of formatted reports.

### Scope of This Handbook

* Chapter 1: _Power Tools for Editing_
* Chapter 2: _Understanding Basic Operations_
* Chapter 3: _Understanding Regular Expression Syntax_
* Chapter 4: _Writing sed Scripts_
* Chapter 5: _Basic sed Commands_
* Chapter 6: _Advanced sed Commands_
* Chapter 7: _Writing Scripts for awk_
* Chapter 8: _Conditionals, Loops and Arrays_
* Chapter 9: _Functions_
* Chapter 10: _The Bottom Drawer_
* Chapter 11: _A Flock of awks_
* Chapter 12: _Full-Featured Applications_
* Chapter 13: _A Miscellany of Scripts_
* Appendix A: _Quick Reference for sed_
* Appendix B: _Quick Reference for awk_
* Appendix C: _Supplement for Chapter 12_

### Availability of sed and awk

What is the modern alternative to awk?

"The Pyed Piper", or pyp, is a linux command line text manipulation tool similar to awk or sed, but which uses standard python string and list methods as well as custom functions evolved to generate fast results in an intense production environment.

```
$ ll /usr/bin/*awk
lrwxrwxrwx 1 root root     21 Dec  5 12:48 /usr/bin/awk -> /etc/alternatives/awk*
-rwxr-xr-x 1 root root 702944 Aug 17  2023 /usr/bin/gawk*
-rwxr-xr-x 1 root root 162552 Feb 16  2020 /usr/bin/mawk*
lrwxrwxrwx 1 root root     22 Dec  5 12:48 /usr/bin/nawk -> /etc/alternatives/nawk*
$ ll /etc/alternatives/*awk
lrwxrwxrwx 1 root root 13 Dec 13 11:31 /etc/alternatives/awk -> /usr/bin/gawk*
lrwxrwxrwx 1 root root 13 Dec 13 11:31 /etc/alternatives/nawk -> /usr/bin/gawk*
```

### Other Sources of Information About sed and awk

* Volume 2 of the UNIX Programmer's Guide
* UNIX Power Tools
* The AWK Programming Language
* UNIX Programming Environment???
* The GNU Awk User's Guide
* Effective AWK Programming
* UNIX Text Processing
