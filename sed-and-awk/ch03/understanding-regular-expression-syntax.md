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

