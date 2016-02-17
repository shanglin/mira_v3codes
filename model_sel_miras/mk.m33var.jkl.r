outdir = '~/Work/m33_miras/m33_ofiles/m33var.stet.jkl.vals/'
fields = c(0:9, letters[1:19])
## fields = fields[1]

rlcdir = '~/Work/m33_miras/m33_ofiles/rlcs/variable/'
fnldir = '~/Work/m33_miras/m33_trialp/fnlfiles/'
for (field in fields) {
    print(field)
    pattern = paste0('^',field,'.*.rlc')
    fs.rlc = list.files(rlcdir, pattern = pattern)
    nfs = length(fs.rlc)
    if (nfs > 0) {
        f.fnl = paste0(fnldir,'m0',field,'i.fnl')
        if (file.exists(f.fnl)) {
            f.out = paste0(outdir,'m33var_m0',field,'.jkl')
            ts = '#   ID    J    K    L'
            write(ts, f.out)
            fnl = read.table(f.fnl, skip = 1)
            for (i in 1:nfs) {
                f = fs.rlc[i]
                id = gsub(paste0(field,'vi'),'',f)
                id = gsub('.rlc','',id)
                id = as.numeric(id)
                idx = fnl[,1] == id
                if (sum(idx) != 1) {
                    print(paste0('  ID ',id,' NOT FOUND IN FIELD m0',field,'!'))
                    j = -99.999
                    k = -99.999
                    l = -99.999
                    ## stop('')
                } else {
                    j = fnl[idx,9]
                    k = fnl[idx,10]
                    l = fnl[idx,11]
                }
                ts = paste(f,j,k,l,sep='   ')
                write(ts,f.out,append=T)
            }
        }
    }
}
                
    
