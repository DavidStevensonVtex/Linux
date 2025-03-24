
# isplit - make an indexed array from str

function isplit(str, arr,   n, i, temp) {
    n = split(str, temp)
    for (i = 1; i <= n ; i++) 
        arr[temp[i]] = i
    return n
}

BEGIN {
    isplit("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", m)
    for ( key in m ) 
       print key, m[key]
}