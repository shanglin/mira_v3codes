rdir = '~/Work/m33_miras/m33_ofiles/rlcs/dup_variable/'
ddir = '~/Work/m33_miras/m33_ofiles/dlcs/dup_variable/'
## rdir = '~/Work/m33_miras/m33_ofiles/rlcs/variable/'
## ddir = '~/Work/m33_miras/m33_ofiles/dlcs/variable/'

fs = list.files(rdir)
nfs = length(fs)

for (i.f in 1:nfs) {
    f = fs[i.f]
    df = gsub('.rlc','.dlc',f)
    lf = paste0(rdir,f)
    of = paste0(ddir,df)

    lc = read.table(lf)
    idx = lc[,1] < 1300 | lc[,1] > 1700
    if (sum(idx) == 0) {
        cmd = paste0('touch ',of)
        ## system(cmd)
    } else {
        ## plot(lc[,1:2],col='grey',xlim=c(0,3500),pch=19,main=f)
        nlc = lc[idx,]
        ## points(nlc[,1:2],col='skyblue',pch=19)
        idx.1 = nlc[,1] > 1000 & nlc[,1] < 1200
        idx.2 = nlc[,1] < 1000 | nlc[,1] > 1200
        if (sum(idx.1) > 3*sum(idx.2) | sum(idx.1) < 2 | sum(idx.2) < 2) {
            write.table(nlc,of,col.names=F, row.names=F)
        } else {
            sub1 = nlc[idx.1,]
            sub2 = nlc[idx.2,]
            if (sd(sub1[,2]) > 2*sd(sub2[,2])) {
                dlc = sub2
                ## points(dlc[,1:2],col='red',pch=19)
            } else {
                dlc = nlc
            }
            write.table(dlc,of,col.names=F,row.names=F)
            ## Sys.sleep(3)
        }
    }
    msg = paste0('   >> ',round(i.f*100/nfs,2),' %    \r')
    message(msg,appendLF=F)
}
        
