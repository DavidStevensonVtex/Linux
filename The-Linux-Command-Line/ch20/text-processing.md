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