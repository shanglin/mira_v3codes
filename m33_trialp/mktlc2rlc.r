
types = c('constant/','variable/')
for (type in types) {
    tdir = paste0('~/Work/m33_miras/m33_trialp/tlc_labels/',type)
    rdir = paste0('~/Work/m33_miras/m33_ofiles/rlcs/',type)
    fs = list.files(tdir)
    nfs = length(fs)
    for (i in 1:nfs) {
        tf = fs[i]
        ltf = paste0(tdir,tf)
        rf = gsub('.tlc','.rlc',tf)
        lrf = paste0(rdir,rf)

        dat = read.table(ltf)
        if (nrow(dat) > 0) {
            dat = dat[dat[,4]==1,]
            if (nrow(dat) > 9) {
                write.table(dat[,1:3], lrf, col.names=F, row.names=F)
            }
        }
        msg = paste0('  >> ',type,': ',round(100.*i/nfs,2),' %   \r')
        message(msg, appendLF=F)
    }
}
