# The Linux Command Line, 2nd Edition, © 2019

## Chapter 29: Flow Control: Looping with While/Until

### while

```
#!/bin/bash

# while-count: display a series of numbers

count=1

while (( "$count" <= 5 )); do
	echo "$count"
	count=$((count + 1))
done
echo "Finished."
```

```
$ chmod 744 while-count
$ ./while-count
1
2
3
4
5
Finished.
```

