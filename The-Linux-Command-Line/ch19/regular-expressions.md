# The Linux Command Line, 2nd Edition, © 2019

## Chapter 19: Regular Expressions

### What Are Regular Expressions

Regular expressions are symbolic notations used to identify patterns in text.

Not all regular expressions are the same; they vary from tool to tool and from programming language to language.

#### grep

The name _grep_ is actually derived from the phrase "global regular expression print".

```
$ ls /usr/bin | grep zip
funzip
gpg-zip
mzip
preunzip
prezip
...
```

`grep [options] regex [file...]`

##### grep options

Option Long option Description

* -i --ignore-case Do not distinguish between upper and lower case characters
* -v --invert-match Causes grep to print every line that does not contain a match
* -c --count Print the number of matches
* -l --file-with-matches Print the name of each file that contains a match instead of the lines themselves.
* -L --files-without-match Like the -l option, but print only the names of files that do not contain matches.
* -n --line-number Prefix each matching line with the number of the line within the file
* -h --no-filename For multifile searches, suppress the output of filenames

```
$ ls /bin > dirlist-bin.txt
$ ls /usr/bin > dirlist-user-bin.txt
$ ls /sbin > dirlist-sbin.txt
$ ls dirlist*.txt
dirlist-bin.txt  dirlist-sbin.txt  dirlist-user-bin.txt
```

```
$ grep bzip dirlist*.txt
dirlist-bin.txt:bzip2
dirlist-bin.txt:bzip2recover
```

```
$ grep -l bzip dirlist*.txt
dirlist-bin.txt
```

```
$ grep -L bzip dirlist*.txt
dirlist-sbin.txt
dirlist-user-bin.txt
```

#### Metacharacters and Literals

The characters in the string _bzip_ are all _literal characters_.

Regular expression metacharacters consist of the following:

`^ $ . [ ] { } - ? + ( ) | \`

All other characters are considered literals.

#### The Any Character

The first metacharacter we will look at is the dot (.) or period character, which is used to match any character.

```
$ grep -h '.zip' dirlist*.txt
bunzip2
bzip2
bzip2recover
gunzip
gzip
funzip
gpg-zip
mzip
preunzip
prezip
prezip-bin
unzip
unzipsfx
```

Note that the _zip_ program was not found.
The period matches one character, not zero characters.


#### Anchors

The caret (\^) and dollar sign (\$) are treated as _anchors_ in regular expressions.
This means they cause the match to occur only if the regular expression is found at the beginning of the line (\^) or at the end of the line (\$).

```
$ grep -h '^zip' dirlist*.txt
zip
zipcloak
zipdetails
zipgrep
zipinfo
zipnote
zipsplit
$ grep -h 'zip$' dirlist*.txt
gunzip
gzip
funzip
gpg-zip
mzip
preunzip
prezip
unzip
zip
$ grep -h '^zip$' dirlist*.txt
zip
```

#### Bracket Expresssions and Character Classes

With bracket expressions, we can specify a set of characters (including characters that would otherwise be interpreted as metacharacters) to be matched.

```
$ grep -h '[bg]zip' dirlist*.txt
bzip2
bzip2recover
gzip
```

##### Negation

If the first character in a bracket expression is a caret (^), the remaining characters are taken to be a set of characters that must not be present at the given character position.

```
$ grep -h '[^bg]zip' dirlist*.txt
bunzip2
gunzip
funzip
gpg-zip
mzip
preunzip
prezip
prezip-bin
unzip
unzipsfx
```

The caret character invokes negation only if it is the first character within a bracket expression.

