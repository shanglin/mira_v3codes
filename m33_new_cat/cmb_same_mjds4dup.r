dir = '~/Work/m33_miras/m33_ofiles/rlcs/'

types = c('constant/','variable/')

for (type in types) {
    f.cat = paste0(dir,'m33du_mt_',substr(type,1,3),'_cat.cat')
    cat = read.table(f.cat,header=T)
    cat[,1] = as.character(cat[,1])
    tdir = paste0(dir,'du_mt_',type)
    odir = paste0(dir,'dup_',type)
    cmd = paste0('mkdir -p ',odir)
    system(cmd)
    fs.rlc = list.files(tdir)
    nfs.rlc = length(fs.rlc)
    ## nfs.rlc = 30
    for (i in 1:nfs.rlc) {
        f.rlc = paste0(tdir,fs.rlc[i])
        rlc = read.table(f.rlc)
        mjds = unique(rlc[,1])
        n = length(mjds)
        mjds = mjds[order(mjds)]
        mags = rep(NA, n)
        errs = rep(NA, n)
        for (j in 1:n) {
            idx = rlc[,1] == mjds[j]
            if (sum(idx) == 1) {
                mags[j] = rlc[idx,2]
                errs[j] = rlc[idx,3]
            } else {
                mags[j] = mean(rlc[idx,2])
                errs[j] = max(sd(rlc[idx,3]),0.5*min(rlc[idx,3]))
            }
        }
        dat = cbind(mjds,mags,errs)
        f.new = gsub('x','t',fs.rlc[i])
        lf.new = paste0(odir,f.new)
        dat[,2] = round(dat[,2],3)
        dat[,3] = round(dat[,3],3)
        write.table(dat,lf.new,col.names=F,row.names=F,quote=F)
        msg = paste0('   >>  [',type,'] ',round(100*i/nfs.rlc,2),' %     \r')
        message(msg,appendLF=F)

        id2 = gsub('.rlc','',fs.rlc[i])
        idx = cat[,1] == id2
        if (sum(idx) != 1) {
            stop(' index not correct')
        } else {
            cat[idx,1] = gsub('x','t',id2)
            cat[idx,'n.obs'] = n
        }   
    }
    f.new = paste0(dir,'m33dup',substr(type,1,3),'_cat.dat')
    write.table(cat,f.new,row.names=F,col.names=T,quote=F,sep='   ')
    print('')
}
