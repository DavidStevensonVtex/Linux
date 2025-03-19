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