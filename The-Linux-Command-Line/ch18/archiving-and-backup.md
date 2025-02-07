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

