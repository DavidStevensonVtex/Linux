# The AWK Programming Language, © 2024

## Chapter 2: Awk in Action:

### 2.1 Personal Computation

#### Body Mass Index

```
$ cat bmi
# bmi: compute body mass index
# bmi: bmi = weight / height^2

awk 'BEGIN { print "enter pounds inches" }
    { printf("%.1f\n", ($1/2.2) / ($2 * 2.54/100)^2) } '
```

```
$ ./bmi
enter pounds inches
190 68
28.9
```

#### Units Conversion

```
$ units
Currency exchange rates from FloatRates (USD base) on 2019-05-31 
3460 units, 109 prefixes, 109 nonlinear units

You have: inches
You want: meters
        * 0.0254
        / 39.370079
You have: pounds
You want: kg
        * 0.45359237
        / 2.2046226
```


```
$ cat cf
# cf: units conversion for temperature, length, weight

awk 'BEGIN {
    t = ARGV[1]     # first command-line argument
    printf("%s C = %.1f F; %s F = %.1f C\n", t, t*9/5 + 32, t, (t - 32)*5/9)
    printf("%s cm = %.1f in; %s in = %.1f cm\n", t, t/2.54, t, t * 2.54)
    printf("%s kg = %.1f lb;  %s lb = %.1f kg\n", t, 2.2*t, t, t/2.2)
}' $*
```

```
$ ./cf 30
30 C = 86.0 F; 30 F = -1.1 C
30 cm = 11.8 in; 30 in = 76.2 cm
30 kg = 66.0 lb;  30 lb = 13.6 kg
```

The \$\* in the script is the shell notation for the arguments that the program was called with; the shell expands it into a list of strings that are passed to the program.

Awk stores the arguments that the program was called with in the arry ARGV, where ARGV[1] is the first argument, ARGV[2] is the second, and so on to ARGV[ARGC-1]. ARGC is the number of arguments and ARGV[0] is the name of the program, usually _awk_.

#### A Reminder About Shell Scripts

To make a file executable on Unix systems, run _chmod_ ("change mode") once:

`$ chmod +x bmi cf`

### 2.2 Selection

The Unix command _head_ by default prints the first 10 lines of its input. 
The following Awk one-liner provides the same functionality:

`NR <= 10`

It isn't efficient on large inputs. An improved version would print each line but exit after the tenth.

```
{ print }
NR > 10 { exit }
```

What if you want a program that will print the first three and the last three lines of its input, for example to see the most common and least common values in a numerically sorted list?

```
awk '{ line[NR] == $0 }
END {
    for (i = 1; i <= 3; i++ ) print line[i] 
    print"..."
    for (i = NR - 2; i <= NR ; i++) print line[i]
}' $*
```

This isn't correct for inputs shorter than 7 lines, but as a personal tool, that may not matter as long as you remain aware of the limitation.

Another approach is to print the first three lines as they arrive, and then retain only the most recent three lines, printing them at the end.

```
awk 'NR < 3 { print; next }
    { line[1] = line[2]; line[2] = line[3]; line[3] = $0 }
END {
    print "..." 
    for ( i = 1; i <= 3; i++) print line[i] } ' $*
```

The _next_ statement stops processing the current record and starts processing the next one, starting with the first statement of the Awk program.

Somewhat surprisingly, this version is about one third slower than the first, perhaps because it's copying a lot of lines. A third option would be to treat the input as a circular buffer: store only three lines and cycle an index from 1 to 2 to 3 to 1 for the last three lines so there's no extra copying:

```
awk 'NR <= 3 { print; next }
    { line[NR%3] = $0 }
END {
    print "..."
    if = (NR+1) %3
    for ( j = 0; j < 3 ; j++) {
        print line[i]
        i = (i+1) % 3
    }
}' $*
```

### 2.3 Transformation

Transforming input into output is what computers do, but there's a specific kind of transformatin that Awk is meant for: text data enters, some modest change is made to all or some selected lines, and then it leaves.

#### Carriage Returns

On Widows, each line of text file ends with a carriage return character \\r and a newline character \\n, where on macOS and Unix, each line ends with a newline only.

Awk uses the newline-only model, though if the input is in Windows format, it will be processed correctly.

We can use one of Awk's text substution functions, _sub_, to eliminate the \\r on each line. The function sub(re, repl, str) replaces the first match of the regulare expression _re_ in _str_ by the replacement text _repl_.

`{ sub(/\r$/, ""); print }

removes any carriage return at the end of a line before printing.

The function _gsub_ is siimilar but replaces all occurrences of text that match the regular expression; _g_ implies "global". Both _sub_ and _gsub_ return the number of replacements they made so you can tell whether anything changed.

Going in the other direction, it's easy to insert a carriage return before each newline if there isn't one there already:

`{ if (!/\r$/) sub(/$/, "\r"); print }`

The test succeeds if the regular expression does not match, that is, if there is no carriage return at the end of the line.

Regular expressions are covered in great detail in the Section A.1.4 of the reference manual.

#### Multiple Columns

Our next example is a program that prints its input in multiple columnns, under the assumptino that most lines are shortish, for example a list of filenames or the names of people.

One basic choice is whether to read the entire input to figure out the range of sizes, or to produce the output on the fly without knowing what is to come. Another choice is whether to produce the output in row order (which is what we'll do) or in column order; if the latter, then  necessarily all the input has to be read before any output can be produced.

Let's do a streaming version first. The program assumes that input lines are no more than 10 characters wide, so with a couple of spaces between columns, there's room for 5 columns in a 60 character line. We can truncate too-long lines, with or without an indicator, or we can insert ellipses in the moddle, or we can print them across multiple columns.  Such choices could be parameterized, though that's definitely overkill for what is meant to be a simple example.


```
# mc: streaming version of multi-column printing

{
    out = sprintf("%s%-10.10s  ", out, $0)
    if (n++ > 5) {
        print substr(out, 1, length(out) - 2)
        out = ""
        n = 0
    }
}

END {
    if (n > 0) 
        print substr(out, 1, length(out)-2)
}
```

```
$ awk -f mc names
Alice       Archie      Eva         Liam        Louis       Mary        Naomi     
Rafael      Sierra      Sydney 
```

```
# mc2: multi-column printer

{   lines[NR] = $0
    if (length($0) > max)
        max = length($0)
}
END {
    fmt = sprintf("%%-%d.%ds", max, max)    # make a format string
    ncol = int(60 / max + 0.5)              # returns integer value of x
    for ( i = 1; i <= NR ; i+= ncol) {
        out = ""
        for (j = i ; j < i + ncol && j <= NR ; j++)
            out = out sprintf(fmt, lines[j]) "  "
        sub(/ +$/, "", out)                 # remove trailing spaces
        print out
    }
}
```

```
$ awk -f mc2 names
Alice   Archie  Eva     Liam    Louis   Mary    Naomi   Rafael  Sierra  Sydney
```

### 2.4 Summarization

Awk is useful for getting a quick summary of files that contain tabular data: maximum and minimum values, sums of columns and the like. These are also useful fo data validation -- what is in each field, whether there are empty values, and so on.

The _addup_ script adds up the values in each column of its input and reports the sums at the end. It's a simple exercise in array subscripts.

```
$ cat addup
# addup: add up values in each field separately

{
    for ( i = 1; i <= NF ; i++ )
        field[i] += $i
    if ( NF > maxnf)
        maxnf = NF
}

END {
    for (i = 1; i <= maxnf ; i++) {
        printf("%6g\t", field[i])
    }
    printf("\n")
}
```

What if some value or even an entire column is not numeric? No problem? Awkuses the numeric prefix of a string as its numeric value, so if a value doesn't have a numeric appearing prefix, its value is zero. For example, the numeric value of a string like "50% off" is 50.

Some spreadsheet tools provide similar functionality, as in Google Sheets, and so does the Pandas library for Python. the advantage of using Awk is that you can tailor the computation to your specific need; naturally the corresponding disadvantage is that you have to wriet aa bit of code yourself.

### 2.5 Personal Databases

```
#!/bin/bash

# sliding-window-averages

awk '
{ s += $2; x[NR] = $2 }

END {
    for (i = NR-6;    i <= NR; i++) w += x[i]
    for (i = NR-30;   i <= NR; i++) m += x[i]
    for (i = NR-90;   i <= NR; i++) q += x[i]
    for (i = NR-365 ; i <= NR ; i++) yr += x[i]
    printf("  7: %.0f  30: %.0f  90: %.0f 1yr: %0.f %.1f hr: %.0f\n", w/7, m/30, q/90, yr/365, NR/365, s/NR)
}' $*
```

#### Stock Prices

### 2.6 A Personal Library

Awk provides a modest ibrary of built-in functions like _length_, _sub_, _substr_, _printf_, and a dozen or two more; they are listed in Section A.2.1 of the reference manual.


It's possible to create more functions of your own, to be included in an Awk program when you need them.

One good example would be a function that uses _sub_ or _gsub_, but returns the modified string rather than a count.

```
$ cat rest
# rest(n): returns fields n..NF as a space-separated string

function rest(n, s) {
    s = ""
    for (j = n; j <= NF ; j++) {
        s = s $j " "
    }
    return substr(s, 1, length(s)-1)
}

# test it:
{
    for (i = 1; i <= NF ; i++)
        printf("%3d [%s]\n", i, rest(i))
}
```

```
$ cat test
abc def ghi
xyz mno pqr
```

```
$ awk -f rest test
  1 [abc def ghi]
  2 [def ghi]
  3 [ghi]
  1 [xyz mno pqr]
  2 [mno pqr]
  3 [pqr]
```

#### Date Formatter

```
$ cat datefix
#!/bin/bash

# datefix: convert mm/dd/yy into yyyy-mm-dd (for 1940 to 2039)

awk '
function datefix(s,     y, date) {
    split(s, date, "/")
    y= date[3] < 40 ? 2000+date[3] : 1900+date[3]       # arbitrary year
    return sprintf("%4d-%02d-%02d", y, date[1], date[2])
}

{ print(datefix($0)) }
' $*
```

```
$ ./datefix
12/25/23
2023-12-25
```