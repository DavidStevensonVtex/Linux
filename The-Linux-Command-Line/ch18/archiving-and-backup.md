# The Linux Command Line, 2nd Edition, © 2019

## Chapter 18: Archiving and Backup

* gzip Compress or expand files
* bzip2 A block sorting file compressor
* tar Tape archiving utility
* zip Package and compress files
* rsync Remote file and directory synchronization

### Compressing Files

Data compression is the process of removing _redundancy_ from data.

_run-length encoding_

Two general categories:

* _Lossless_
* _Lossy_

#### gzip

The `gzip` program is used to compress one or more files.

```
$ ls -l /etc > foo.txt
$ ls -l foo.txt
-rw-rw-r-- 1 dstevenson dstevenson 13351 Feb  7 13:25 foo.txt
$ gzip foo.txt
$ ls -l
total 4
-rw-rw-r-- 1 dstevenson dstevenson 2887 Feb  7 13:25 foo.txt.gz
$ gunzip foo.txt
$ ll
total 24
drwxrwxr-x   2 dstevenson dstevenson  4096 Feb  7 13:25 ./
drwx------ 104 dstevenson dstevenson  4096 Feb  7 13:25 ../
-rw-rw-r--   1 dstevenson dstevenson 13351 Feb  7 13:25 foo.txt
```

##### gzip options

* -c --stdout --to-stdout  Write output to standard output and keep the original files.
* -d --decompress --uncompress Decompress. This causes gzip to act like gunzip.
* -f --force Force compressioin even if a compressed version of the original file already exists.
* -h --help Display usage information
* -l --list List compression statistics foreach file comrpessed.
* -r --recursive If one or more arguments on the command line is a directory, recursively compress files contained with them.
* -t --test Test the integrity of the compressed file.
* -v --verbose Display verbose messages while compressing.
* -number Set amount of compression. _number_ is an integer in the range of 1 (fastest, least compression) to 9 (slowest, most compression). the values 1 and 9 may also be expressed as --fast and --best, respectively. The default value is 6.

```
$ gzip foo.txt
$ gzip -tv foo.txt.gz
foo.txt.gz:	 OK
$ gzip -d foo.txt.gz 
$ ll foo.txt
-rw-rw-r-- 1 dstevenson dstevenson 13351 Feb  7 13:25 foo.txt
```

```
$ ls -l /etc | gzip > foo.txt.gz
$ ll foo.txt.gz
-rw-rw-r-- 1 dstevenson dstevenson 2879 Feb  7 13:34 foo.txt.gz
```

The `gunzip` program, which uncompresses `gzip` files, assumes that file names end in the extension `.gz`, so it's not necessary to specify it, as long as the specified name is not in conflict with an existing uncompressed file.

`gunzip foo.txt`

If our goal were only to view the contents of a compressed text file, we could do this.

`$ gunzip -c foo.txt | less`

Alternatively, there is a program supplied with `gzip`, called `zcat`, that is equivalent to `gunzip` with the `-c` option. It cqan be used like thecat command on gzip-compressed files.

`$ zcat foo.txt.gz | less`

There is a zless program, too. It performs the same function as the previous pipeline.

`$ zless foo.txt.gz`

#### bzip2

The `bzip2` program is similar to `gzip` but uses a different compression algorithm that achieves higher levels of compression at thecost of compression speed.

```
$ ls -l /etc > foo.txt
$ ls -l foo.txt
-rw-rw-r-- 1 dstevenson dstevenson 13351 Feb  7 13:52 foo.txt
$ bzip2 foo.txt
$ ls -l foo.txt.bz2 
-rw-rw-r-- 1 dstevenson dstevenson 2577 Feb  7 13:52 foo.txt.bz2
$ bunzip2 foo.txt.bz2 
$ ls -l foo.txt 
-rw-rw-r-- 1 dstevenson dstevenson 13351 Feb  7 13:52 foo.txt
```

`bzip2` comes with `bunzip2` and `bzcat` for decompressing files.

##### Don't be compresssive compulsive

`gzip picture.jpg`

Compressed image files shouldn't be compressed again as it is a waste of time.

### Archiving Files

A common file-management task often used in conjunction with compression is _archiving_.
Archiving is the process of gathering up many files and bundling them together into a single large file.
Archiving is often done as part of system backups. It is also used when old data is moved from a system to some type of long-term storage.

#### tar

`tar` is short for _tape archive_. We often see filenames that end with the extension _.tar_ or _.tgz_, which indicate a "plain" tar archive and a gzipped archive, respectively. A tar archive can consist of a group of separate files, one or more directory hierarchies, or a mizture of both.

`tar mode[otions] pathname`

##### tar modes

* c Create an archive from a list of files and/or directories
* x Extract an archive
* r Append specified pathnames to the end of an archive
* t List the contents of an archive


```
$ tar cf playground.tar playground
$ ls -l playground.tar 
-rw-rw-r-- 1 dstevenson dstevenson 1392640 Feb  7 14:10 playground.tar
```

Top list the contents of the archive:

```
$ tar tf playground.tar | head -5
playground/
playground/dir-076/
playground/dir-076/file-L
playground/dir-076/file-W
playground/dir-076/file-B
```

For a more detailed listing, we can add the v (verbose) option:

```
$ tar tvf playground.tar | head -5
drwx------ dstevenson/dstevenson 0 2025-02-07 14:08 playground/
drwx------ dstevenson/dstevenson 0 2025-02-07 10:01 playground/dir-076/
-rw------- dstevenson/dstevenson 0 2025-02-07 10:01 playground/dir-076/file-L
-rw------- dstevenson/dstevenson 0 2025-02-07 10:01 playground/dir-076/file-W
-rw------- dstevenson/dstevenson 0 2025-02-07 10:08 playground/dir-076/file-B
```

Extracting the playground tar files:

```
$ mkdir foo
$ cd foo
$ tar xf ../playground.tar
$ ls
playground
```

```
$ cd
$ tar cf playground2.tar ~/playground
tar: Removing leading `/' from member names
```

```
$ cd foo
$ tar xf ../playground2.tar
$ ls
home  playground
$ ls home
dstevenson
$ ls home/dstevenson
playground
$ 
```

Here we can see that when we extracted our second archive, it re-created the directory _home/dstevenson/playground_ relative to our current working directory. This allows us to extract archives to any location rather than being forced to extract them to their original locations.

If wanted to extract a single file from the archive, it could be done like this:

`tar xf archive.tar pathname`

By adding the trailing _pathname_ to the command, `tar` will restore only the specified file. Multiple pathnames may be specified. Note that the path name must be the full, exact relative pathname as restored in the archive. When specifying pathnames, wildcards are not normally supported; however, the GNU version of `tar` (which is the version most often found in Linux distrubtions) supports them with the _--wildcards_ option.

```
$ cd foo
$ tar xf ../playground2.tar --wildcards 'home/dstevenson/playground/dir-*/file-A'
```

```
find playground -name 'file-A' -exec tar rf playground.tar '{}' '+'
```

The _tar_ _r_ option appends to a _.tar_ file.

Using _tar_ with _find_ is a good way of creating _incremental backups_ of a directory tree or an entire system.

By using _find_ to match files newer than a timestamp file, we could create an archive that contains only those files newer than the last archive, assuming that the timestamp file is updated right after each archive is created.

_tar_ can also make use of both standard input and output.

```
$ find playground -name 'file-A' | tar cf - --files-from=- | gzip > playground.tgz
$ ll playground.tgz
-rw-rw-r-- 1 dstevenson dstevenson 1013 Feb  8 17:47 playground.tgz
```

In a Linux "tar" command, "empty -" means that you are instructing the "tar" utility to create a new, empty archive and write its contents to standard output (represented by the "-") instead of saving it to a named file; essentially, you are creating an empty archive that is immediately piped to another command. 

If you give a single dash as a file name for ' --files-from ', (i.e., you specify either --files-from=- or -T - ), then the file names are read from standard input.

Modern versions of GNU _tar_ support both _gzip_ and _bzip2_ compression directly with the use of the _z_ and _j_ options.

```
$ find playground -name 'file-A' | tar czf playground.tgz -T -
$ ll -rt playground.tgz
-rw-rw-r-- 1 dstevenson dstevenson 1013 Feb  8 17:51 playground.tgz
```

What is the z option in tar?

The -z option compresses archives using gzip, -j uses bzip2, and -J uses xz compression. Each offers different compression ratios and speeds, with gzip being the fastest and xz providing the highest compression.

‘-T file’

tar will use the contents of file as a list of archive members or files to operate on, in addition to those specified on the command-line.

If we had wanted to create a _bzip2_ compressed archive instead:

```
$ find playground -name 'file-A' | tar cjf playground.tbz -T -
$ ll playground.tbz
-rw-rw-r-- 1 dstevenson dstevenson 562 Feb  8 17:53 playground.tbz
```

#### zip

The _zip_ program is both a compression tool and an archiver. The file format used by the program is familiar to Windows users, as it reads and writes _.zip_ files. In Linux, however, _gzip_ is the predominant compression program, with _bzip2_ being a close second.

`zip options zipfile file...`

```
$ zip -r playground.zip playground
  adding: playground/ (stored 0%)
  adding: playground/dir-076/ (stored 0%)
  adding: playground/dir-076/file-L (stored 0%)
  ...
```

```
$ cd foo
$ unzip ../playground.zip
Archive:  ../playground.zip
   creating: playground/
   creating: playground/dir-076/
 extracting: playground/dir-076/file-L  
 ...
```

We can list and extract files selectively from a zip archive by specifying them to unzip.

```
$ unzip -l playground.zip playground/dir-087/file-Z
Archive:  playground.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2025-02-07 10:01   playground/dir-087/file-Z
---------                     -------
        0                     1 file

$ cd foo
$ unzip ../playground.zip playground/dir-087/file-Z
Archive:  ../playground.zip
replace playground/dir-087/file-Z? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
 extracting: playground/dir-087/file-Z 
```

Like _tar_, _zip_ can make use of standard input and output, though its implementation is somewhat less than useful.
It is possible to pipe a list of file names to _zip_ via the `-@` option.

```
$ cd
$ find playground -name "file-A" | zip -@ file-A.zip
  adding: playground/dir-076/file-A (stored 0%)
  adding: playground/dir-052/file-A (stored 0%)
  adding: playground/dir-049/file-A (stored 0%)
  ...
```

_zip_ also supports writing its output to standard output, but its use is limited because few programs can make use of the output. Unfortunately, the _unzip_ programdoes not accept standard input.

_zip_ can, however, accept standard input, so it c an be used to compress the output of other programs.

```
$ ls -l /etc/ | zip ls-etc.zip -
  adding: - (deflated 79%)
```

The _unzip_ program allows its output to be sent to standard output when the `-p` (for pipe) option is specified.

```
$ unzip -p ls-etc.zip | less
```

### Synchronizing Files and Directories

In the Unix-like world, the preferred tool for this task is _rsync_.
This program can synchronize both local and remote directories by using the _rsync remote-update protocol_, which allows _rsync_ to quickly detect the differences between two directories and perform the minimum amount of copying required to bring them into sync.

_rsync_ is invoked like this:

`rsync options source destination`

where source and destination are one of the following:

* A local file or directory
* A remote file or directory in the form of `[user@]host:path`
* A remote sync server specified with a URI of `rsync://[user@]host[:port]/path`

```
$ rm -rf foo/*
$ rsync -av playground foo
sending incremental file list
playground/
playground/timestamp
playground/dir-001/
playground/dir-001/file-A
playground/dir-001/file-B
...
```

We included bot the `-a` option (for archiving -- causes recursion and preservation of file attributes)and the `-v` option (verbose output) to make a _mirror_ of the _playground_ directory within _foo_.

If we run the command again, we will see a different result:

```
$ rsync -av playground foo
sending incremental file list

sent 36,548 bytes  received 134 bytes  73,364.00 bytes/sec
total size is 0  speedup is 0.00
```

_rsync_ detected that there were no differences between the two directories.

```
$ touch playground/dir-099/file-Z
$ rsync -av playground foo
sending incremental file list
playground/dir-099/file-Z

sent 36,603 bytes  received 159 bytes  73,524.00 bytes/sec
total size is 0  speedup is 0.00
```

`rsync source destination`

If we append a trailing / to the source directory name, _rsync_ will copy only the contents of the source directory and not the directory itself.

