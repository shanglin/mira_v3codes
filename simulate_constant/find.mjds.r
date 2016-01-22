
lcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/variable/'
outdir = '~/Work/m33_miras/simulate_constant/'

fields = c(0:9,letters[1:19])
for (field in fields) {

    fs.lc = list.files(lcdir,pattern=paste0('^',field,'.*.lc$'))
    nfs.lc = length(fs.lc)
    
    if (nfs.lc > 0) {
        f.all = paste0(outdir,'tmp.all.mjd.lc')
        write('#',f.all)
        for (i in 1:nfs.lc) {
            msg = paste0('    >> loading ',field,': ',round(i*100/nfs.lc,2), '   %      \r')
            message(msg, appendLF = F)
            f.lc = fs.lc[i]
            lf.lc = paste0(lcdir,f.lc)
            lc = read.table(lf.lc)
            lc = lc[lc[,4]==1,1]
            write.table(lc, f.all, append = T, col.names=F, row.names = F)
        }
        print('')

        all = read.table(f.all)
        t = table(all[,1])
        mjds = names(t)
        mjd.tbl = cbind(mjds,t)
        f.mjd = paste0(outdir,'unique_mjds/m0',field,'_mjds.dat')
        write.table(mjd.tbl,f.mjd,col.names=F,row.names=F,quote=F)
    }
}
system(paste0('rm -f ',f.all))
