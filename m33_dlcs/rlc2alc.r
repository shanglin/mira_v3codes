## rdir = '~/Work/m33_miras/m33_ofiles/rlcs/dup_variable/'
## ddir = '~/Work/m33_miras/m33_ofiles/alcs/dup_variable/'
rdir = '~/Work/m33_miras/m33_ofiles/rlcs/variable/'
ddir = '~/Work/m33_miras/m33_ofiles/alcs/variable/'

fs = list.files(rdir)
nfs = length(fs)

for (i.f in 1:nfs) {
    f = fs[i.f]
    df = gsub('.rlc','.alc',f)
    lf = paste0(rdir,f)
    of = paste0(ddir,df)

    lc = read.table(lf)
    idx = lc[,1] < 1000 | lc[,1] > 1700
    if (sum(idx) == 0) {
        cmd = paste0('touch ',of)
        ## system(cmd)
    } else {
        ## plot(lc[,1:2],col='grey',xlim=c(0,3500),pch=19,main=f)
        alc = lc[idx,]
        ## points(alc[,1:2],col='skyblue',pch=19)
        write.table(alc,of,col.names=F,row.names=F)
        ## Sys.sleep(3)
    }
    msg = paste0('   >> ',round(i.f*100/nfs,2),' %    \r')
    message(msg,appendLF=F)
}
        
