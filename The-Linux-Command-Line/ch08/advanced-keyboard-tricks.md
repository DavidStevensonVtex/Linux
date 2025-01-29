# The Linux Command Line, 2nd Edition, © 2019

## Chapter 8: Advanced Keyboard Tricks

* clear Clear the terminal screen
* history - Display or manipulate the history list

### Command Line Editing

#### Cursor Movement

* `Ctrl-A` Move cursor to the beginning of the line
* `Ctrl-E` Move cursor to the end of the line
* `Ctrl-F` Move cursor forward one character; same as right arrow key
* `Ctrl-B` Move cursor backward one character; same as left arrow key
* `Alt-F` Move cursor forward one word
* `Alt-B` Move cursor backward one word
* `Ctrl-L` Clear the screen and move the cursor to the top left corner. The `clear` command does the same thing.

#### Modifying Text

* `Ctrl-D` Delete the character at the cursor location
* `Ctrl-T` Transpose (exchange) the character at the cursor location with the one preceding it.
* `Alt-T` Transpose the word at the cursor location with the one preceding it.
* `Alt-L` Convert the characters from the cursor location to the end of the word to lowercase.
* `Alt-U` Convert the characters from the cursor location to the end of the word to uppercase.

#### Cutting and Pasting (Killing and Yanking) Text

* `Ctrl-K` Kill text from the cursor location to the end of the line.
* `Ctrl-U` Kill text from the cursor location to the beginning of the line.
* `Alt-D` Kill text from the cursor location to the end of the current word.
* `Alt-Backspace` Kill text from the cursor location to the beginning of the current word. If the cursor is at the beginning of the word, kill the previous word.
* `Ctrl-Y` Yank text from the kill-ring and insert it at the cursor location.

While the ALT key serves as the meta key on modern keyboards, you can also press and release the ESC key to get the same effect as holding down the ALT key.

#### Completion

Completion occurs when you press the TAB key while typing a command (or part of a file name).

* `Alt-?` Display a list of possible completions. On most systems, you can also do this by pressing the TAB key a second time, which is much easier.
* `Alt-*` Insert all possible completions. This is useful when you want to use more than one match.

Programmable Completion
`set | less`

### Using History

```
$ ll ~/.bash_history
-rw------- 1 dstevenson dstevenson 30122 Jan 29 17:29 /home/dstevenson/.bash_history
```

#### Searching History

`history | less`

```
$ history | grep /usr/bin
 1494  cd /usr/bin
 1543  ll /usr/bin
 1696  ls -l /usr/bin > ls-output.txt
 1701  ls -l /usr/bin > ls-output.txt
 1703  ls -l /usr/bin >> ls-output.txt # Append to file using >>
 1706  ls -l /usr/bin > ls-output.txt
 1708  ls -l /usr/bin >> ls-output.txt # Append to file using >>
 1711  ls -l /usr/bin > ls-output.txt
 1713  ls -l /usr/bin >> ls-output.txt # Append to file using >>
 1730  ls /bin /usr/bin | sort | less
 1732  ls /bin /usr/bin | sort | uniq | less
 1733  ls /bin /usr/bin | sort | uniq -d | less
 1734  ls /bin /usr/bin | sort | uniq | wc -l
 1735  ls /bin /usr/bin | sort | uniq | grep zip
 1737  ls -l /usr/bin > ls-output.txt
 1742  ls /usr/bin | tee ls.txt | grep zip
 1845  file $(ls -d /usr/bin/* | grep zip)
 2012  history | grep /usr/bin
```

```
$ !1696
ls -l /usr/bin > ls-output.txt
```

To start incremental search, press `Ctrl-R` followed by the text you are looking for.

`(reverse-i-search)`/usr/bin': ls -l ^Csr/bin > ls-output.txt`

Keystrokes to manipulate the history list:

* `Ctrl-P` Move to the previous history entry. This is the same as the up arrow.
* `Ctrl-N` Move to the next history entry. This is the same as the down arrow.
* `Alt-<` Move to the beginning (top) of the history list.
* `Alt->` Move to the end (bottom) of the history list, i.e. the current command line.
* `Ctrl-R` Reverse incremental search. This searches incrementally from the current command up the history list.
* `Alt-P` Reverse search, non-incremental. With this key, type in the search string and press `ENTER` before the search is performed.
* `Alt-N` Forward search, non-incremental.
* `Ctrl-O` Execute the current item in the history list and advance to the next one. This is handy if you are trying to re-execute a sequenceof commands in a history list.

#### History Expansion

The shell offers a specialized type of expansion for items in the history list by using the \! character.

* `!!` Repeat the last command. It is probably easier to press the up arrow and ENTER
* `!number` Repeat history list item _number_.
* `!string` Repeat last history list item starting with _string_.
* `!?string` Repeat last history list item containing _string_.
