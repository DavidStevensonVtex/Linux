BEGIN {
    for (i = 1; i <= 100; i++) {
        if (i%15 == 0)      # divisible by both 3 and 5
            print i, "fizzbuzz"
        else if (i%5 == 0)
            print i, "buzz"
        else if (i%3 == 0)
            print i, "fizz"
        else
            print i
    }
}
