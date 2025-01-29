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

