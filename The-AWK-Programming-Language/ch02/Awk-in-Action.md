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
