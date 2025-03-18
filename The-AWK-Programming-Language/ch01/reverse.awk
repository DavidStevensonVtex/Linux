# reverse - print input in reverse order by lines

        { line[NR] = $0 }   # remember each input line
END     {
    for ( i = NR; i > 0; i--) {
        print line[i]
    }
}