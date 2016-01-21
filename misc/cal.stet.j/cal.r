
f = 'tt.lst'
fs = as.character(read.table(f)[,1])
nfs = length(fs)

for (i in 1:nfs) {
    f = fs[i]
    f = paste0('mslcs/',f)
    dat = read.table(f,skip=1)
    mags = dat[,2]
    errs = dat[,3]
    mean.mag = sum(1/errs^2*mags) / sum(1/errs^2)
    n = nrow(dat)
    delta = (mags - mean.mag) / errs
    p = n/(n-1) * delta^2 - 1
    j = sum(sign(p)*sqrt(abs(p)))/n
    print(mean.mag)
    ## stop('fas')
}

