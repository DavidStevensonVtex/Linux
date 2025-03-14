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

