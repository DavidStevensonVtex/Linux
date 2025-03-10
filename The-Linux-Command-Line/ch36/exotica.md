# The Linux Command Line, 2nd Edition, © 2019

## Chapter 36: Exotica

### Group Commands And Subshells

_bash_ allows commands to be grouped together. This can be done in one of tw ways, either with a _group command_ or with a subshell.

Here is the syntax of a group command:

{ command1; command2 ; [command3; ...]}

Here is the syntax of a subshell:

( command1; command2 ; [command3; ...] )

It is important to note that because of the way _bash_ implements group commands, the braces must be separarated from the commands by a space and the last command must be terminted with either a seimicolon or a newline prior to the closing brace.

So, what are group commands and subshells good for? While they have an important difference, they are both used to manage redirection.

```
ls -l > output.txt
echo "Listing of foo.txt" >> output.txt
cat foo.txt >> output.txt
```

Using a group command, we could code this as follows:

{ ls -l; echo "Listing of foo.txt" ; cat foo.txt ; } > output.txt

Using the subshell is similar.

(ls -l; echo "Listing of foo.txt" ; cat foo.txt)  > output.txt

Using this technique we have saved ourselves some typing, but where a group command or subshell really shines is with pipelines.

{ ls -l; echo "Listing of foo.txt" ; cat foo.txt ; } | lpr

```
#!/bin/bash

# array-2: Use arrays to tally file owners

declare -A files file_group file_owner groups owners

if [[ ! -d "$1" ]]; then
    echo "Usage: array-2 dir" >&2
    exit 1
fi

for i in "$1"/*; do
    owner="$(stat -c %U "$i")"
    group="$(stat -c %G "$i")"
    files["$i"]="$i"
    file_owner["$i"]="$owner"
    file_group["$i"]="$group"
    ((++owners["$owner"]))
    ((++groups["$group"]))
done

# List the collected files
{   for i in "${files[@]}"; do
        printf "%-40s %-10s: %-10s\n" "$i" "${file_owner["$i"]}" "${file_group["$i"]}"
    done
} | sort
echo

# List owners
echo "File owners:"
{   for i in "${!owners[@]}"; do
        printf "%-10s: %5d file(s)\n" "$i" "${owners["$i"]}"
    done } | sort
    echo

# List groups
echo "File group owners:"
{   for i in "${!groups[@]}"; do
        printf "%-10s: %5d file(s)\n" "$i" "${groups["$i"]}"
    done } | sort
```

```
$ ./array-2 ../ch35
../ch35/arrays.md                        dstevenson: dstevenson
../ch35/array-sort                       dstevenson: dstevenson
../ch35/hours                            dstevenson: dstevenson

File owners:
dstevenson:     3 file(s)

File group owners:
dstevenson:     3 file(s)
```

#### Process Substitution

While they look similar and can both be used to combine streams for redirection, there is an important difference between group commands and subshells. Whereas a group command executes all of its commands in the current shell, a subshell (as the name suggests) executes its command in a child copy of the current shell. This means the environment is copied and given to a new instance of the current shell.  When the subshell exits, the copy of the enviornment is lost, so any changes made to the subshell's environment (including variable assignment) are lost as well. Therefore, in most cases, unless a script requires a subshell, group commands are preferable to subshells. Group commands are both faster and require less memory.

Process substitution is expressed in two ways.

For processes that produce standard output, it looks like this:

`<(list)`

For processes that intake standard input, it looks like this:

`>(list)`

where _list_ is a list of commands.

To solve our problem with _read_, we can employ process substitution like this.

```
$ read< <(echo "foo")
$ echo $REPLY
foo
```
Process substitution allows us to treat the outptu of a subshell as an ordinary file for purposes of redirection. In fact, since it is a form of expansion, we can examine its real value.

```
$ echo <(echo "foo")
/dev/fd/63
```

By using echo to view the result of the expansion, we see that the output of the subshell is being provided by a file named _/dev/fd/63_.

Process substitution is often used with loops containing _read_. 

```
#!/bin/bash

# pro-sub: demo of process substitution

while read attr links owner group size date time filename; do 
    cat << EOF
        Filename:   $filename
        Size:       $size
        Owner:      $owner
        Group:      $group
        Modified:   $date $time
        Links:      $links
        Attributes: $attr

EOF
done < <(ls -l --time-style="+%F %H:%m" | tail -n +2)
```

```
$ ./pro-sub
        Filename:   array-2
        Size:       885
        Owner:      dstevenson
        Group:      dstevenson
        Modified:   2025-03-10 14:03
        Links:      1
        Attributes: -rwxr--r--

        Filename:   exotica.md
        Size:       3837
        Owner:      dstevenson
        Group:      dstevenson
        Modified:   2025-03-10 14:03
        Links:      1
        Attributes: -rw-rw-r--

        Filename:   pro-sub
        Size:       385
        Owner:      dstevenson
        Group:      dstevenson
        Modified:   2025-03-10 14:03
        Links:      1
        Attributes: -rwxr--r--

```

