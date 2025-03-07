# The Linux Command Line, 2nd Edition, © 2019

## Chapter 33: Flow Control: Looping with For

The _for loop_ differs from the _while_ and _until_loops in that it provides a means of processing sequences during a loop.

### for: Traditional Shell Form

```
for variable [in words]; do
    commands
done
```

```
$ for i in A B C D; do echo $i ; done
A
B
C
D
```

An example using brace expansion:

```
$ for i in {A..D}; do echo $i ; done
A
B
C
D
```

An example using pathname expansion:

```
$ for i in ../ch20/distros*.txt; do echo "$i" ; done
../ch20/distros-by-date.txt
../ch20/distros-dates.txt
../ch20/distros-key-names.txt
../ch20/distros-key-vernums.txt
../ch20/distros-names.txt
../ch20/distros.txt
../ch20/distros-vernums.txt
../ch20/distros-versions.txt
```

```
#!/bin/bash

# pathname-expansion

# By default, if the expansion fails to match any fiels, the wildcards themselves 
# (distros*.txt in this example) will be returned.

# To guard against this, we would check for the existence of a file using a test expression.


for i in distros*.txt; do
    if [[ -e "$i" ]]; then
        echo "$i"
    fi
done
```

By adding a test for file existence, we will ignore a failed expansion.

Another common method of word production is command substitution.

```
#!/bin/bash

# longest-word: find longest string in a file

while [[ -n "$1" ]]; do
    if [[ -r "$1" ]]; then
        max_word=
        max_len=0
        for i in $(strings "$1"); do
            len="$(echo -n "$i" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$i"
            fi
        done
        echo "$1: '$max_word' ($max_len characters)"
    fi
    shift
done
```

```
$ ./longest-word pathname-expansion 
pathname-expansion: 'pathname-expansion' (18 characters)
```

If the optional in words portion of the for command is omitted, for defaults to processing the positional parameters.

```
#!/bin/bash

# longest-word2: find longest string in a file

for i; do
    if [[ -r "$i" ]]; then
        max_word=
        max_len=0
        for j in $(strings "$i"); do
            len="$(echo -n "$j" | wc -c)"
            if (( len > max_len )); then
                max_len="$len"
                max_word="$j"
            fi
        done
        echo "$i: '$max_word' ($max_len characters)"
    fi
done
```

As we can see, we have changed the outermost loop to use for instead of while.
By omitting the list of words in the for command, the positional parameters are used isntead. Inside the loop, previous instances of the variable i have been changed to the variable j. The use of _shift_ has also been eliminated.

```
$ ./longest-word2 longest-word longest-word2 pathname-expansion 
longest-word: 'max_len="$len"' (14 characters)
longest-word2: 'longest-word2:' (14 characters)
pathname-expansion: 'pathname-expansion' (18 characters)
```

### for: C Language Form

Recent versions of _bash_ have added a second form of the for command syntax, one that resembles the form found in the C programming language.

```
for (( expression1; expression2 ; expresson3 )); do
    commands
done
```

```
#!/bin/bash

# simple-counter: demo of C style for command

for (( i=0; i < 5; i=i+1 )); do
    echo -n "$i "
done
echo
```