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

### Traps

In Chapter 10, we saw how programs can respond to signals. We can add this capability to our scripts, too.
Larger and more complicated scripts may benefit from having a singla handling routine.

When we design a large, complicated script, it is important to consider what happens if the user logs off or shuts down the computer while the script is running. When such an event occurs, a signal will be sent to all affected processes. In turn, the programs representing those processes can perform actions to ensure a proper and orderly termination of the program.

We could have the script delete the file when the script finishes its work. It would also be smart to have the script delete the file if a signal is received indicating that the program was going to be terminated prematurely.

`trap argument signal [signal...]`

where _argument_ is a string that will be read and treated as a command and _signal_ is the specification of a signal that will trigger the execution of the interpreted command.

Here is a simple example:

```
#!/bin/bash

# trap-demo: simple signal handling demo

trap "echo 'I am ignoring you.'" SIGINT SIGTERM

for i in {1..5}; do 
    echo "Iteration $i of 5"
    sleep 5
done
```

```
$ ./trap-demo
Iteration 1 of 5
^CI am ignoring you.
Iteration 2 of 5
^CI am ignoring you.
Iteration 3 of 5
^CI am ignoring you.
Iteration 4 of 5
^CI am ignoring you.
Iteration 5 of 5
^CI am ignoring you.
```

Constructing a string to form a useful sequence of c ommands can be awkward, so it it is common practice to specify a shell function as the command.

```
#!/bin/bash

# trap-demo2: simple signal handling demo

exit_on_signal_SIGINT () {
    echo "Script interrupted." 2>&1
    exit 0
}

exit_on_signal_SIGTERM () {
    echo "Script terminated." 2>&1
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

for i in {1..5}; do 
    echo "Iteration $i of 5"
    sleep 5
done
```

```
$ ./trap-demo2
Iteration 1 of 5
^CScript interrupted.
```

#### Temporary Files

Traditionally, programs on Unix-likesystems create their temporary files in the /tmp/directory, a shared directory intended for such files. However, since the directory is shared, this poses certain security concerns, particularly for programs running with superuser privileges.

Aside fromt he obvious step of setting proper permissiosn for files exposed to all users of the system, it is important to give temporary files non-predictable file names. This avoids an exploit known as a _temp race attack_. One way tocreate a non-predictable (but still descriptive) file name is to do something like this:

`tempfile=/tmp/$(basename $0).$$.$RANDOM`

where \$\$ is the current process id, and basename \$0 is the filename of the currently executing program.

Note, however that the \$RANDOM shell variable returns a value only in the range 1-32767, which is not a large range in computer terms, so a single instance of the variable is not sufficient to overcome a determined cracker.

A bettter way is to use the _mktemp_ program (not to be confused with the _mktemp_ standard library function) to both name and create the temporary file.

The template should include a series of X characters, which are replaced by a correspodning number of random letters and numbers. The longer the series of X characters, the longer the series of random characters. Here is an example:

`tempfile=$(mktemp /tmp/foobar.$$.XXXXXXXXXXX)`

```
$ tempfile=$(mktemp /tmp/foobar.$$.XXXXXXXXXXX)
$ echo $tempfile
/tmp/foobar.14541.xYrWrWTqt0N
```

For scripts that are executed by regular users, it may be wise to avoid the use of the _/tmp_ directory and create a directory for temporary files within the user's home directory, with a line of code such as this:

`[[ -d $HOME/tmp ]] || mkdir $HOME/tmp
