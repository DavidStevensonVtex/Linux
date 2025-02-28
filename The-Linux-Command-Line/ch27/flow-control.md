# The Linux Command Line, 2nd Edition, © 2019

## Chapter 27: Flow Control: Branching Wit If

### if Statements

```
#!/bin/bash

x=5
if [ "$x" -eq 5 ]; then
    echo "x equals 5."
else
    echo "x does not equal 5."
fi
```

```
$ chmod 744 if-statements 
$ ./if-statements 
x equals 5.
```

```
if commands; then
    commands
[elif commands; then 
    commands...]
[else
    commands]
fi
```