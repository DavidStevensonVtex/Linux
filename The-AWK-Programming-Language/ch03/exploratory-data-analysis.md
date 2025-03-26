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