# The Linux Command Line, 2nd Edition, © 2019

## Chapter 4: Manipulating Files and Directories

* cp - Copy Files and directores
* mv - Move/rename files and directores
* mkdir - Create directories
* rm - Remove files and directories
* ln - Create hard and symbolic links
* 
### Wildcards

* \* - Matches any characters
* \? - Matches any single character
* '[characters]'- Matches any character that is a member of the set _characters_
* `[!characters]` - Matches any character that is not a member of the set _characters_
* `[[:class:]]` - Matches any character that is a member of the specified class.


#### Commmonly Used Character Classes

* `[:alnum:]` - Matches any alphanumeric character
* `[:alpha:]` - Matches any alphabetic character
* `[:digit:]` - Matches any numeral
* `[:lower:]` - Matches any lowercase letter
* `[:upper:]` - Matches any uppercase letter

#### Wildcard Examples

* `*` - All Files
* `g*` - Any file beginning with g
* `b*.txt` - Any file beginning with b, followed by any characters, ending with .txt
* `Data???` - Any file beginning with Data followed by exactly 3 characters
* `[abc]*` - Amny file beginning with either an a, b, or c
* `BACKUP.[0-9][0-9][0-9]` - Any file beginning with BACKUP followed by exactly 3 digits
* `[[:upper:]]*` - Any file beginning with an upper case letter
* `[![:digit:]]*` - Any file not beginning with a number
* `[*[[:lower:]]123] - Any file ending with a lowercase letter or the numbers 1, 2, or 3
