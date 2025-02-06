# The Linux Command Line, 2nd Edition, © 2019

## Chapter 17: Searching For Files

* locate Find files by name
* find Search for files in a directory hierarchy
* xargs Build and execute command lines from standard input
* touch Change file times
* stat Display file or file system status

### locate - Find Files the Easy Way

```
$ locate bin/zip
/snap/emacs/2504/usr/bin/zipdetails
/snap/gnome-42-2204/176/usr/bin/zipdetails
/snap/gnome-42-2204/202/usr/bin/zipdetails
/usr/bin/zip
/usr/bin/zipcloak
/usr/bin/zipdetails
/usr/bin/zipgrep
/usr/bin/zipinfo
/usr/bin/zipnote
/usr/bin/zipsplit
```

```
$ locate zip | grep bin | egrep -v "(snap|Apache|firmware)"
/bin/bunzip2
/bin/bzip2
/bin/bzip2recover
/bin/gunzip
/bin/gzip
/usr/bin/funzip
/usr/bin/gpg-zip
/usr/bin/mzip
/usr/bin/preunzip
/usr/bin/prezip
/usr/bin/prezip-bin
/usr/bin/unzip
/usr/bin/unzipsfx
/usr/bin/zip
/usr/bin/zipcloak
/usr/bin/zipdetails
/usr/bin/zipgrep
/usr/bin/zipinfo
/usr/bin/zipnote
/usr/bin/zipsplit
/usr/lib/klibc/bin/gunzip
/usr/lib/klibc/bin/gzip
/usr/share/man/man1/prezip-bin.1.gz
```

```
$ which slocate
$ which mlocate
/usr/bin/mlocate
```

The `locate` atabase is created by another program named `updatedb`.