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

##### Traditional Character Ranges

```
$ grep -h '[ABCDEFGHIJKLMNOPQRSTUVWXYZ]' dirlist*.txt
amuFormat.sh
GET
HEAD
NF
POST
X
X11
Xephyr
Xorg
Xwayland
$ grep -h '[A-Z]' dirlist*.txt
amuFormat.sh
GET
HEAD
NF
POST
X
X11
Xephyr
Xorg
Xwayland
```

`$ grep -h '[A-Za-z0-9]' dirlist*.txt`

How do we include the dash character as a search character.
By making it the first character in the expression.

`$ grep -h '[-AZ]' dirlist*.txt`

#### POSIX Character Classes

```
$ ls -1  /usr/sbin/[ABCDEFGHIJKLMNOPQRSTUVWXYZ]*
/usr/sbin/ModemManager
/usr/sbin/NetworkManager
$ ls -1  /usr/sbin/[A-Z]*
/usr/sbin/ModemManager
/usr/sbin/NetworkManager
```

```
$ echo $LANG
en_US.UTF-8
```

With this setting, POSIX-compliant applications will use a dictionary collation order rather than ASCII order. The character range `[A-Z]` when interpreted in dictionary order includes all of the alphabetic characters except the lowercase _a_, hence our results.

##### POSIX Character Class and Description

* [:alnum:] alphanumeric characters [A-Za-z0-9]
* [:word:] Same as [:alnum:] with the addition of the underscore.
* [:alpha:] The alphabetic characters. [A-Za-z]
* [:blank:] Includes the space and tab characters
* [:cntrl:] The ASCII control codes. 0 through 31 and 127
* [:digit:] The numbers 0 through 9.
* [:graph:] The visible characters. ASCII 33-126.
* [:lower:] Lowercase letters.
* [:punct:] Punctuation characters
* [:print:] The printable characters.
* [:space:] The whitespace characters including space, tab, carriage return, newline, vertical tab, and form feed. In ASCII, `[ \t\r\n\v\f]`
* [:upper:] Uppercase characters.
* [:xdigit:] Characters used to express hexadecimal numbers. In ASCII, [0-9A-Fa-f].

```
$ ls -1 /usr/sbin/[[:upper:]]*
/usr/sbin/ModemManager
/usr/sbin/NetworkManager
```

Remember, however, that this is not an example of a regular expression; rather, it is the shell performing pathname expansion.

