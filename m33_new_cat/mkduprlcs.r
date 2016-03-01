dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
f.dup = paste0(dir,'duplicates_map.map')

f.dm = 'ionly_dm.log'
dms = read.table(f.dm)

f.cat = paste0(dir,'m33con_cat.dat')
cat1 = read.table(f.cat,header=T)
f.cat = paste0(dir,'m33var_cat.dat')
cat2 = read.table(f.cat,header=T)
cat = rbind(cat1,cat2)
cat[,1] = as.character(cat[,1])

dup = read.table(f.dup,header=T)
n.dup = nrow(dup)

f.con = paste0(dir,'m33du_mt_con_cat.dat')
f.var = paste0(dir,'m33du_mt_var_cat.dat')
ts = 'sid   ra   dec   imag   ierr   vmag   verr   bmag   berr  n.obs  fields'
write(ts,f.con)
write(ts,f.var)

for (i in 1:n.dup) {
    id = dup[i,1]
    sids = dup[i,2:5]
    sids = sids[!is.na(sids)]
    n.sids = length(sids)
    tsfields = substr(sids,1,1)
    tsfields = paste(tsfields,collapse='')
    types = substr(sids,2,2)
    type = 'c'
    ltype = 'constant'
    if (sum(types=='v')>0) {
        type = 'v'
        ltype = 'variable'
    }
    did = gsub('xdi',paste0('x',type,'i'),id)

    ## prepare basic information
    sidices = match(sids, cat[,1])
    ra = cat[sidices[1],2]
    dec = cat[sidices[1],3]
    scalis = cat[sidices,4]
    scalvs = cat[sidices,6]
    scalves = cat[sidices,7]
    scalbs = cat[sidices,8]
    scalbes = cat[sidices,9]
    scalvs = scalvs[scalvs!=-1]
    scalves = scalves[scalves!=-1]
    scalbs = scalbs[scalbs!=-1]
    scalbes = scalbes[scalbes!=-1]
    
    scali = mean(scalis)
    scalie = sd(scalis)
    if (length(scalvs) == 0) {
        scalv = -1
        scalve = -1
    } else if (length(scalvs) == 1) {
        scalv = scalvs[1]
        scalve = scalves[1]
    } else {
        scalv = mean(scalvs)
        scalve = sd(scalvs)
    }
    if (length(scalbs) == 0) {
        scalb = -1
        scalbe = -1
    } else if (length(scalbs) == 1) {
        scalb = scalbs[1]
        scalbe = scalbes[1]
    } else {
        scalb = mean(scalbs)
        scalbe = sd(scalbs)
    }

    ## load light curves, shift by dm, combine and save
    f.did = paste0(dir,'du_mt_',ltype,'/',did,'.rlc')
    cmd = paste0('rm -f ',f.did)
    system(cmd)
    for (isid in 1:n.sids) {
        sid = sids[isid]
        field = substr(sid,1,1)
        tstype = substr(sid,2,2)
        dm = dms[dms[,1]==field,2]
        tsltype = 'constant'
        if (tstype == 'v') {
            tsltype = 'variable'
        }
        f.sid = paste0(dir,tsltype,'/',sid,'.rlc')
        lc = read.table(f.sid)
        lc[,2] = lc[,2] - dm
        write.table(lc,f.did,append=T,col.names=F,row.names=F)
        ## if (isid==1) {
        ##     ylim = c(mean(lc[,2])+0.9,mean(lc[,2])-0.9)
        ##     plot(lc[,1:2],pch=19,cex=0.5,col=isid,xlab='MJD',ylab='shifted I (mag)',ylim=ylim)
        ## } else {
        ##     points(lc[,1:2],pch=19,cex=0.5,col=isid)
        ##     ## abline(v=min(lc[,1]),col=5)
        ## }
        ## arrows(lc[,1],lc[,2]+lc[,3],lc[,1],lc[,2]-lc[,3],code=3,length=0,angle=90,col=isid)
    }
    ## Sys.sleep(0.3)
    
    lc = read.table(f.did)
    n.obs = nrow(lc)
    ## write the catalog
    ## ts = 'sid   ra   dec   imag   ierr   vmag   verr   bmag   berr  n.obs  fields'
    ts = paste(did,ra,dec,round(scali,3),round(scalie,3),round(scalv,3),round(scalve,3),round(scalb,3),round(scalbe,3),n.obs,tsfields, sep='   ')
    if (type == 'c') {
        write(ts, f.con, append=T)
    } else {
        write(ts, f.var, append=T)
    }
    msg = paste0('    >> [',substr(tsfields,1,1),']  ',round(100*i/n.dup,2),' %    \r')
    message(msg, appendLF = F)
}
print('')
print('')
