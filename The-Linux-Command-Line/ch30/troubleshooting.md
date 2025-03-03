# The Linux Command Line, 2nd Edition, © 2019

## Chapter 30: Troubleshooting

### Syntactic Errors

One general class of errors is _syntactic_. Syntactic errors involve mistypign some element of shell syntax.

```
#!/bin/bash

# trouble: script to demonstrate common errors

number=1

if [ $number = 1 ]; then
	echo "Number is equal to 1."
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 trouble
$ ./trouble
Number is equal to 1.
```