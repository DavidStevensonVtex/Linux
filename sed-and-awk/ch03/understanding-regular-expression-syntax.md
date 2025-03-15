# sed & awk, 2nd Edition, © 1997

## Chapter 3: Understanding Regular Expression Syntax

**grep**, sed, and awk all use regular expressions. However, not all of the metacharacters used in regular expression syntax are available for all three programs. The basic set of metacharacters was introduced with the **ed** line editor, and made available in **grep**. Sed uses the same set of metacharacters. Later a program named **egrep** was introduced that offered an _extended_ set of metacharacters. Awk uses essential the same set of metacharacters as **egrep**.

To understand regular expression syntax, you have to learn the functions performed by various metacharacters.

* Appendix A, _Quick Reference for sed_
* Appendix B, _Quick Reference for awk_
* O'Reilly's _Mastering Regular Expressions_, by Jeffrey E. F. Friedl

### That's an Expression

A pattern matches adjacent characters.

`ABE`

'A' does not match 'a'.

A regular expression is not limited to literal characters.There is a metacharacter -- the dot (.) -- that can be used as a wildcard to match any single character.

The metacharacter `*`, the asterisk, use used to match zero or more occurrences of the _preceding_ regular expression, which typically is a single character. The regular expression `.*` matches any number of  characters. The regular expression `A.*E` matches any string that matches any number of characters between A and E.

### A Line-Up of Characters

We have seen two basic elements in an expression:

1. A value expressed as a literal or a variable.
2. An operator.

A regular expression is made up of these same elements.

**Summary of Metacharacters**

```
Special
Characters      Usage

.               Matches any single character except newline. In awk, dot can match newline also.
*               Matches any number (including zero) of the single character.
                Matches any one of the class of characters enclosed between the brackets.
                A circumflex (^) as the first character inside the brackets reverses the match to all characters except the newline and those listed in the class.
                A hypen (-) is used to indicate a range of characters.
                The close bracket (]) as the first chracter in class is a member of the class.
^               First character of regular expression: matches the beginning of the line.
                Matches the beginning of a string in awk, even if the string contains embedded newlines.
$               As last character of regular expression, matches the end of the line.
                Matches the end of a string in awk, even if the string contains embedded newlines.
\{n,m\}         Matches a range of occurrences of the single character that immediately preceds it.
                \{n\} will match exactly n occurrences.
                \{n,\} will match at least n occurrences.
                \{n,m\} will match any number of occurrences between n and m.
\               Escapes the special character that follows.
```

**Extended Metacharacters (egrep and awk)**

```
Special
Characters      Usage

+               Matches one or more occurrences of the preceding regular expression.
?               Matches zero or one occurrences of the preceding regular expression.
|               Specifies that either the preceding or following regular expression can be matched.
()              Groups regular expressions.
{n,m}           Matches a range of occurrences of the single character that immediately preceds it.
                {n} will match exactly n occurrences.
                {n,} will match at least n occurrences.
                {n,m} will match any number of occurrences between n and m.
```

### The Ubiquitous Backslash

The backslash (\\) character transforms metacharacters into ordinary characters, and ordinary characters into metacharacters. It forces the literal interpretation of any metacharacter such that it will match itslef. For instance, the dot (.) is a metacharacter that needs to be escaped with a backslash if you want to match a period.

`\.   `

The backslash is typically used to match **troff* requests or macros that begin with a dot.

`\.nf`

In addition, sed uses the backslash to cause of group of ordinary characters to be interpreted as metacharacters.

`\( \) \{ \} \n`

The _n_ in the "\n" construct represents a digit from 1 to 9; its use will be explained in Chapter 5, _Basic sed Commands_.

### A Wildcard

The _wildcard_ metacharacter, or dot (.), might be considered equivalent to a variable. A variable represents any value in an arithmetic expression. In a regular expression, a dot (.) is a wildcard that represents any character except the newline. (In awk, dot can even match an embedded newline character.)

`80.86' matches "80286", "80386" or "80486".

### Writing Regular Expressions

The process of writing a regular expression involves three steps:

1. Knowing what it is you want to match and how it might appear in the text.
2. Writing a pattern to describe what you want to match.
3. Testing the pattern to see what it matches.

You might consider evaluating the results of a pattern matching-operation as follows:

```
Hits            The lines that I wanted to match
Misses          The lines that I didn't want to match.
Omissions       The lines that I didn't match but wanted to match.
False alarms    The lines that I matched but didn't want to match
```

Using metacharacters in patterns provides greater flexibility in extending or narrowing the range of matches.

### Character Classes

A character class is a refinement of the wildcard concept. Instead of matching _any_ character at a specific position, we can list the characters to be matched. The square bracket metacharacters ([]) enclose the list of characters, any of which can occupy a single position.

Character classes are useful for dealing with uppercase and lowercase letters, for instance.

`[Ww]hat`

This regular expression can match "what" or "What".

`grep '\.H[123]' ch0[12]`

Note that you have to quote the pattern so that it is passed on to **grep** rather than be interpreted by the shell.

As another example of a character class, assume you want to specify the different punctuation marks that end a sentence:

`.[!?;:,".]  .`

This expression matches "any character followed by an exclamation mark, question mark, semicolon, colon, comma, quotation mark or period, and followed by two spaces and any character. The dot inside the square brackets is interpreted literally.

**Special Characters in Character Classes**

```
Character   Function

\           Escapes any special character (awk only)
-           Indicates a range when not in the first or last position
^           Indicates a reverse match only when in the first position.
```

#### A range of characters

The hypen character (-) allows you to specify a range of characters.

`[A-Z]`

`[0-9]`

`[cC]hapter [1-9]`

Multiple ranges can be specified as well as intermixed with literal characters.

`[0-9a-z?,.;:'"]`

This expression will match any single character that is numeric, lowercase alphbetic, or question mark, comma, period, semicolon, colon, single quote, or quotation mark."

If you specify multiple classes, you are describing multiple consecutive characters such as:

`[a-zA-Z][.?!]`

This expression will match "any lowercase or uppercase letter folowed by either a period, question mark or an exclamation mark."

The close bracket (]) is interpreted as a member of the class if it occurs as the first character in the class (or as the first character after a circumflex). The hypne loses its pecial meaning with a class if it is the first or last character. Therefore, to match arithmetic operators, we put the hyphen (-) first in the following example:

`[-+*/]`

In awk, you could also use the backslash to escape the hyphen or close bracket wherever either one occurs in the range, but the syntax is messier.

Trying to match dates with a regular expression is an interesting problem. Here are two possible formats:

* MM-DD-YY
* MM/DD/YY

The following regular expression indicates the possible range of values for each character position:

`[0-1][0-9][-/][0-3][0-9][-/][0-9][0-9]`

Either "-" or "/" could be the delimiter. Putting the hyphen in the first position ensures that it will be interpreted in a character class literally, as a hyphen, and not as indicating a range.

#### Excluding a class of characters

Normally, a character class includes all the characters that you want to match in that position. The circumflex (^) as the first character in the class excludes all of the characters in the class from being matched. Instead any character except newline that is not listed in the square brackets will be matched. The following will match any non-numeric character:

`[^0-9]`

It matches all uppercase and lowercase letters of the alphabet and all special characters such as punctuation marks.

Excluding specific characters is sometimes more convenient that explicitly listing all the characters you want to match. For instance, if you wanted to match any consonant, you could simply exclude vowels:

`[^aeiou]`

The expression would match any consonant, any vowel in uppercase, and any punctuation mark or special character.

#### POSIX character class additions

The standard defines two classes of regular expressiosn: Basic Regular Expressiosn (BREs), which are the kind used by **grep** and **sed**, and Extended Regular Expressions, which are the kind used by **egrep** and **awk**.

In order to accommodate non-English environments, the POSIX standard enhanced the ability of character classes to match characters not in the English alphabet.

POSIX also changed what had been common terminology.

* _Character classes_. A POSIX character class consists of keywords bracketed by `[:` and `:]`.
* _Collating symbols_. 
* _Equivalence classes_. An equivalence class lists a set of characters that should be considered equivalent, such as **e** and **è**. In consists of a named element from the locale, bracketed by `[=` and `=]`.

**POSIX Character Classes**

```
Class       Matching Characters

[:alnum:]   Printable characters (includes whitespace)
[:alpha:]   Alphabetic characters
[:blank:]   Space and tab characters
[:cntrl:]   Control characters
[:digit:]   Numeric characters
[:graph:]   Printable and visible (non-space) characters
[:lower:]   Lowercase characters
[:print:]   Printable characters (includes whitespace)
[:punct:]   Punctuation characters
[:space:]   Whitespace characters
[:upper:]   Uppercase characters
[:xdigit:]  Hexadecimal digits
```

These features are slowing making their way into commercial versiosn of **sed** and **awk**, as vendors fully implement the POSIX standard.

GNU awk and GNU sed support the character class notation, but not the other two bracket notations.

#### Repeated Occurrences of a Character

The asterisk (\*) metacharacter indicates tha the preceding regular expression may occur zero or more times. That is, if it modifies a single character, the character may be there or not, and if it is, there may be more than one of them.

` "*hypertext"* `

The word "hypertext" will be matched regardless of whether it appears in quotes or not.

Consider a series of number:

```
1
5
10
50
100
500
1000
5000
```

The regular expression

`[15]0*`

would match all lines, whereas the regular expression

`[15]00*`

would match all but the first two lines. The first zero is a literal, but the second is modified by the asterisk, meaning it might or might not be present. A similar technique is used to match consecutive spaces because you usually want to match one or more, not zero or more, spaces. You can use the following to do that:

`  *`

If you wanted to match any string inside of quotation marks, you could specify:

`".*"`

The span matched by ".*" is always the longest possible.

As another example, a pair of angle brackets is a common notation for enclosing formatting instructions used in markup languages, such as SGML, HTML, and Ventura Publisher.

You could print all ines with these marks by specifying:

`$ grep '<.*>' sample`

**sample** (file)

```
I can do it
I cannot do it
I can not do it
I can't do it
I cant do it
```

If we wanted to match each form of the negative statement, but not the positive statement, the following regular expression would do it:

`can[ no']*t`

```
$ grep "can[ no']*t" sample
I cannot do it
I can not do it
I can't do it
I cant do it
```

The ability to match "zero or more" of something is known by the technical term "closure".
The _extended set of metacharacters_ used by **egrep** and **awk** provides several variations of closure that can be quite useful.

The plus sign (+) matches one or more occurrences of the preceding regular expression.

The question mark (?) matches zero or one occurrences.

`80[234]?86`

Matches: 80286, 80386, 80486, and 8086.

Don't confuse the ? in a regular expression with the ? wildcard character in the shell. The shell's ? represents a single character, equivalent to . in a regular expression.

### What's the Word? Part I

It is sometimes difficult to match a complete word.

` book ` misses books.

` books*` matches book and books (and bookkeeper, bookworm, and bookish?)

` book.? ` would match book, books, booky

### Positional Metacharacters

There are two metacharacters that allow you to specify the context in which a string appears, either at the beginning of a line or at the end of a line. The circumflex (^) metacharacter is a single character regular rexpression indicating the beginning of a line. The dollar sign ($) metacharacter is a single cahracter regular expression indicating  the end of a line. These are often referred to as "anchors," since they anchor, or restrict, the match to a specific position.

You could print lines that begin with a tab.

Using vi, you could remove blanks at the end of lines using the following regular expression:

`  *$`

troff macros must be input at the beginning of the line, and begin with a period. They can be matched with the following regular expression:

`^\...`

You can use both positional metacharacters together to match blank lines.

`^$` or `^ *$`

`$ grep -c '^$' ch04` counts the number of blank lines in the ch04 file.

In **sed** and **grep**, "^" and "$" are only special when they occur at the beginning or end of a regular expression respectively.

### Phrases

A pattern-matching program such as **grep** does not match a string if it extends over two lines. For all practical purposes, it is difficult to match phrases with assurance. Remember that text files are basically unstructured and line breaks are quite random. If you are looking for any sequence of words, it is possible that they might appear on one line but they may be split up over two.

You can write a series of regular expressions to capture a phrase:

```
Almond Joy
Almond$
^Joy
```

This is not perfect as the second regular expression will match "Almond" at the end of al line, regardless of whther or not the next line begins with "Joy". A similar problem exists with the third regular expression.

### A Span of Characters

The metacharacters that allow you to specify repeated occurrences of a character (*+?) indicate a span of undetermined length. Consider the following expression:

`11*0`

It will match each of the following line:

```
10
110
111110
111111111111111111111110
```

\\\{ and \\\} are available in **grep** and **sed**.
POSIX **egrep** and POSIX awk use { and }. In any case, the braces enclose one or two arguments.

`\{n,m\}`

_n_ and _m_ are integers between 0 and 255. If you specify `\{n\}` by itself, then exactly _n_ occurrences of the preceding character or regular expression will be matched. If you specify `\{n,\}`, then at least _n_ occurrences will be matched. If you specify `\{n,m\}`, then any number of occurrences between _n_ and _m_ will be matched.

For example, the following expression will match "1001", "10001" and "100001", but not "101" or "1000001".

`10\{2,4\}1`

This metacharacter pair can be useful for matching data in fixed-length fields, data that perhaps was extracted from a database. It can also be used to match formatted data such as phone numbers, U.S. social security numbers, inventory part IDS, etc.

For isntance, the format of a social security number is three digits, a hypnen, followed by two digits, a hyphen, and then four digits. That pattern could be described as follows:

`[0-9]\{3\}-[0-9]\{2\}-[0-9]\{4\}`

Note that "?" is equivalent to "\{0,1\}" and "+" is equivalent to "\{1,\}".

Similarly, a North American local phone number could be described with the following regular expression:

`[0-9]\{3\}-[0-9]\{4\}`

or 

`[0-9]\{3\}-[0-9]\{3\}-[0-9]\{4\}`

(Probably would want a combined regular expression that makes the area code optional.)

### Alternative Operations

The vertical bar (|)metacharacter, part of the extended set of metacharacters, allows you to specify a union of regular expressions. For instance, this regular expression:

`UNIX|LINUX`

More thanone alternative can be specified:

`UNIX|LINUX|NETBSD`

In sed, lacking the union metacharacter, you would specify each pattern separately.

### Grouping Operations

Parentheses, () are used to group regular expressions and establish precedence.
They are aprt of the extended set of metacharacters. Let's say that a company's name in a text file is referred to as "BigOne" or "BigOne Computer":

`BigOne( Computer)?`

`([0-9]\{3\}-)?[0-9]\{3\}-[0-9]\{4\}`

```
$ egrep "Lab (oratorie)?s" mail.list

Bell Laboratories, Lucent Technologies
Bell Labs
```

You can use parentheses with a vertical bar to group alternative operations.

`company(y|ies)`

### What's the Word? Part II

```
$ cat bookwords
This file tests for book in various places, such as
book at the beginning of a line or
at the end of a line book
as well as the plural books and
handbooks.  Here are some
phrases that use the word in different ways:
"book of the year award"
to look for a line with the word "book"
A GREAT book!
A great book? No.
told them about (the books) until it
Here are the books that you requested
Yes, it is a good book for children
amazing that it was called a "harmful book" when
once you get to the end of the book, you can't believe
A well-written regular expression should
avoid matching unrelated words,
such as booky (is that a word?)
and bookish and
bookworm and so on.
```

```
$ grep ' book.* ' bookwords
This file tests for book in various places, such as
as well as the plural books and
A great book? No.
told them about (the books) until it
Here are the books that you requested
Yes, it is a good book for children
amazing that it was called a "harmful book" when
once you get to the end of the book, you can't believe
such as booky (is that a word?)
and bookish and
```

```
$ grep book bookwords | wc -l
17
$ grep ' book.* ' bookwords | wc -l
10
```

All (some) of these problems are caused by the string appearing at the beginning or end of a line.

```
$ egrep "^book|book$|\"book" bookwords 
book at the beginning of a line or
at the end of a line book
"book of the year award"
to look for a line with the word "book"
bookworm and so on.
```

```
$ egrep "(^| )[\"[{(]*book[]})\"?\!.,;:'s]*( |$)" bookwords
This file tests for book in various places, such as
book at the beginning of a line or
at the end of a line book
as well as the plural books and
"book of the year award"
to look for a line with the word "book"
A GREAT book!
A great book? No.
told them about (the books) until it
Here are the books that you requested
Yes, it is a good book for children
amazing that it was called a "harmful book" when
once you get to the end of the book, you can't believe
```

As a further note, the **ex** and **vi** text editors have a special metacharacter for matching a string at the beginning of a word, \\\<, and one for matching the end of a word, \\\>. Used as a pair, they can match a string only when it is a complete word.

### Your Replacement Is Here

When using **grep**, it seldom matters how you match the line as long as you match it. When you want to make a replacement, however, you have to consider the extent of the match. So, what characters on the line did you actually match?

#### The extent of the match

Let's loook at the following regular expression:

`A*Z`

This matches "zero or more occurrences of the A followed by Z." It would produce the same result as simply specifying "Z". The letetr "A" could be there or not; in fact, the letter "Z" is the only character matched.

```
All of us, including Zippy, our dog
Some of us, including Zippy, our dog
```

Both lines would match the regular expression.

We can use the *gres* command (see the sidebar, "A Program for Making Single Replacements") to demonstrate the extent of the match.

```
cat gres
if [ $# -lt "3" ]; then
    echo Usage: gres pattern replacement file
    exit 1
fi

pattern=$1
replacement=$2
if [ -f $3 ];
then
    file=$3
else
    echo $3 is not a file
    exit 1
fi
# A complicated but portable way to generate a Cotnrol-A character to use as the 
# separator for the sed substitute command. Doing this greatly decreases the chance 
# of having the separator character appear in the pattern or replacement tests.
A=$(echo | tr '\012' '\001') # See footnote

sed -e "s$A$pattern$A$replacement$A" $file
```

```
$ gres "A*Z" "00" test
All of us, including 00ippy, our dog
Some of us, including 00ippy, our dog
00elda
```