nskip = 3
boxsize = 10
hboxsize = round(boxsize/2)
localmaxima = function(values) {
    nele = length(values)
    maxima = c()
    if (nele < nskip*2.1) {
        maxima = c(maxima,-1)
        return(maxima)
    } else {
        maxima = c(maxima,-2)
        iele = nskip
        while (iele <= (nele-nskip-1)) {
            from = iele - hboxsize
            to = iele + hboxsize
            if (from < 0) from = 0
            if (to > nele -1) to = nele - 1
            boxcar = values[seq(from=from,to=to,by=1)]
            if (values[iele] == max(boxcar)) {
                maxima = c(maxima,iele)
                iele = iele + hboxsize - 1
            } else {
                iele = iele + 1
            }
        }
        return(maxima)
    }
}
