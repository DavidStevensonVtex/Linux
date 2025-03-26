# The AWK Programming Language, © 2024

## Chapter 3: Exploratory Data Analysis

_Exploratory Data Analysis_ or _EDA_, is a term first used by pioneering statistician John Tukey.

Tukey invented a number of basic data visualization techniques like boxplots, inspired by the statistical programming language S that led to the widely-used R language, co-invented the Fast Fourier Transform, and coined the words "bit" and "software".

"Finding the question is often more important than finding the answer. Exploratory data analysis is an attitude, a flexibility, and a reliance on display, NOT a bundle of techniques."

For EDA, we typically use standard Unix tools like the shell, wc, diff, sort, uniq, grep, and of course regular expressions. These combine well with Awk, and of ten with other languages like Python.

We will also encounter a variety of file formats, including comma- or tab-separated values (CSV and TSV), JSON, HTML, and XML. Some of these, like CSV and TSV, are easily processed in Awk, while others are sometimes better handled with other tools.

### 3.1 The Sinking of the Titanic

```
$ cat titanic.tsv
Type    Class   Total   Lived   Died
Male    First   175             57              118
Male    Second  168             14              154
Male    Third   462             75              387
Male    Crew    885             192             693
Female  First   144             140             4
Female  Second  93              80              13
Female  Third   165             76              89
Female  Crew    23              20              3
Child   First   6               5               1
Child   Second  24              24              0
Child   Third   79              27              52
```

Many (perhaps all) datasets contain errors. As a quick check here, each line should have five fields, and the total in the third field should equal field four (lived) plus field five (died).
```
$ awk 'NF != 5 || $3 != $4 + $5' titanic.tsv 
Type    Class   Total   Lived   Died
```

**titanic--aa.awk**

```
NR > 1 { gender[$1] += $3; class[$2] += $3 }

END {
    for (i in gender) print i, gender[i]
    print ""
    for (i in class) print i, class[i]
}
```

```
$ awk -f titanic-aa.awk titanic.tsv
Female 425
Child 109
Male 1690

Third 706
First 325
Crew 908
Second 285
```

Awk has a special form of the `for` statement for iterating over the indices of an associative array:

`for (i in array) { statements }`

What about survival rates? How did social class, gender and age affect the chance of survival among passengers?

**survival-rate.awk**

`NR > 1 { printf("%6s  %6s  %6.1f%%\n", $1, $2, 100 * $4/$3) }`

```
$ awk -f survival-rate.awk titanic.tsv | sort -k3 -nr
 Child  Second   100.0%
Female   First    97.2%
Female    Crew    87.0%
Female  Second    86.0%
 Child   First    83.3%
Female   Third    46.1%
 Child   Third    34.2%
  Male   First    32.6%
  Male    Crew    21.7%
  Male   Third    16.2%
  Male  Second     8.3%
```

Evidently women and children did survive better on average.

Note that these examples treat the header line of the dataset as a special case. If you're doing a lot of experiments, it may be easier to remove the header from the data file than to ignore it explicitly in every program.

### Passenger Data: passengers.csv

The file `passengers.csv` is a larger file that contains detailed information about passengers, though it does contain anything about crew members. The original file is a merger of a widely used machine-learning dataset with another list from Wikipedia.

```
$ wc passengers.csv
  1314   6794 112466 passengers.csv
```

```
$ awk '{ nc += length($0) + 1; nw += NF }
> END { print NR, nw, nc, FILENAME }' passengers.csv
1314 6794 112466 passengers.csv
```

Tab Separated Value (TSV) files are easily handled by Awk, by setting the field separator to a tabl with FS="\t" or equivalently wit
h the command-line argument `-F"\t"`.

To check whether all records have the same number of fields, you could use:

`awk '{ print NF }' file | sort | uniq -c | sort -nr`

For `passengers.csv`, using the `--csv` option to process CSV input properly, this produces:

With a version of Awk that does not handle CSV, the output using -F will be different:

```
$ awk -F","  '{ print NF }' passengers.csv | sort | uniq -c | sort -nr
    624 12
    517 13
    155 14
     15 15
      3 11
```

(Changed Brown, Mrs James Joseph (Margaret "Molly" Tobin) to use single quotes around "Molly")

```
$ gawk -vFPAT='[^,]*|"[^"]*"'  '{ print NF }' passengers.csv | sort | uniq -c | sort -nr
   1314 11
```

Generating CSV is straight forward. Here's a function t_csv that converts a strng to a properly quoted string by doubling each quote and surrounding the result with quotes. It's an example of a function that could go into a personal library.

```
# to_csv - convert s to proper "..."

function to_csv(s) {
    gsub(/"/, "\"\"")
    return "\"" s "\""
}
```

(Note how quotes are quoted with backslashes.)

We can use this function within a loop to insert commas between elements of an array to create a properly formatted CSV record for an associative array, or for an indexed array like the fields of a line, as illustrated in the functdions _rec_to_csv and arr_to_csv:

```
# rec_to_csv - convert a record to rec_to_csv

function rec_to_csv(    s, i) {
    for (i = 1; i < NF ; i++)
        s = s to_csv($i) ","
    s = s to_csv($NF)
    return s
}
```

```
# arr_to_csv - convert an indexed array to arr_to_csv

function arr_to_csv(arr,    s, i, n) {
    n = length(arr)
    for (i = 1; i <= n; i++)
        s = s to_csv(arr[i]) ","
    return substr(s, 1, length(s)-1)    # remove trailing comma
}
```

The following program selects the five attributes: class survival, name, age, and gender, from the original file, and converts the output to tab-separated values.

```
$ gawk -vFPAT='[^,]*|"[^"]*"'  'NR > 1 { OFS="\t"; print $2, $3, $4, $5, $11 }' passengers.csv | head 
"1st"   1       "Allen, Miss Elisabeth Walton"  29      "female"
"1st"   0       "Allison, Miss Helen Loraine"    2      "female"
"1st"   0       "Allison, Mr Hudson Joshua Creighton"   30      "male"
"1st"   0       "Allison, Mrs Hudson J.C. (Bessie Waldo Daniels)"       25      "female"
"1st"   1       "Allison, Master Hudson Trevor"  0.9167 "male"
"1st"   1       "Anderson, Mr Harry"    47      "male"
"1st"   1       "Andrews, Miss Kornelia Theodosia"      63      "female"
"1st"   0       "Andrews, Mr Thomas, jr"        39      "male"
"1st"   1       "Appleton, Mrs Edward Dale (Charlotte Lamson)"  58      "female"
"1st"   0       "Artagaveytia, Mr Ramon"        71      "male"
```

Most ages are integers, but a handful are fractions, like the last line above.

`"1st"   1       "Allison, Master Hudson Trevor"  0.9167 "male"`

How many infants were there?

```
$ gawk -vFPAT='[^,]*|"[^"]*"'  '$5 < 1' passengers.csv | head 
"row.names","pclass","survived","name","age","embarked","home.dest","room","ticket","boat","sex"
"5","1st",1,"Allison, Master Hudson Trevor", 0.9167,"Southampton","Montreal, PQ / Chesterville, ON","C22","","11","male"
"359","2nd",1,"Caldwell, Master Alden Gates", 0.8333,"Southampton","Bangkok, Thailand / Roseville, IL","","","13","male"
"545","2nd",1,"Richards, Master George Sidney", 0.8333,"Southampton","Cornwall / Akron, OH","","","4","male"
"617","3rd",1,"Aks, Master Philip", 0.8333,"Southampton","London, England Norfolk, VA","","392091","11","male"
"752","3rd",0,"Danbom, Master Gilbert Sigvard Emanuel", 0.3333,"Southampton","Stanton, IA","","","","male"
"764","3rd",1,"Dean, Miss Elizabeth Gladys (Millvena)", 0.1667,"Southampton","Devon, England Wichita, KS","","","12","female"
"1115","3rd",0,"Peacock, Master Alfred Edward",0.5833,"","","","","","male"
"1246","3rd",0,"Thomas, Master Assad Alexander",0.4167,"","","","","","male"
```