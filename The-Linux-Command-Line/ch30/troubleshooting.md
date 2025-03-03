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

### Missing Quotes

```
#!/bin/bash

# missing-quotes: script to demonstrate common errors

number=1

if [ $number = 1 ]; then
	echo "Number is equal to 1.
else
	echo "Number is not equal to 1."
fi
```

```
$ chmod 744 missing-quotes 
$ ./missing-quotes 
./missing-quotes: line 10: unexpected EOF while looking for matching `"'
./missing-quotes: line 12: syntax error: unexpected end of file
```

Text editors like vim (:syntax on) or Visual Studio Code can indicate text it believes to be a part of a quote, and if the quote doesn't end where expected, it can indicate a missing quote character.

