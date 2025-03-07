# The Linux Command Line, 2nd Edition, © 2019

## Chapter 34: Strings and Numbers

### Parameter Expansion

#### Basic Parameters

Simple parameters may also be surrounded by braces.

`${a}`

The following doesn't work properly.

```
$ a="foo"
$ echo "$a_file"   # Doesn't work.

$ echo "${a}_file" # works correctly.
foo_file
```

To access the eleventh positional parameter, we can do this:

`${11}`