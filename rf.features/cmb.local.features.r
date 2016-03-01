fdir = '~/Work/m33_miras/extract_features/'
outdir = '~/Work/m33_miras/rf.features/'

types = c('m33dlc','m33dup','con','srv','mira')
ltypes = c('m33dlc','m33dup','sim_con','sim_srv','sim_mira')
    
type = types[1]
ltype = ltypes[1]
f.dat = paste0(fdir,ltype,'_features.dat')
f.jkl = paste0(outdir,type,'.jkl')

dat = read.table(f.dat)
jkl = read.table(f.jkl)
dat[,1] = as.character(dat[,1])
jkl[,1] = as.character(jkl[,1])
idx = match(dat[,1], jkl[,1])
ls = jkl[idx,4]
ndt = cbind(dat,ls)

f.out = paste0(outdir,'local.features.dat')
ts = '# ID   F.true    F.peak   Q.peak   Q.base   dQ.p1.base   dQ.p1.p2  rQ.p1.p2    dQ.p1.pn   rQ.p1.pn   theta.1    theta.2    A.model   A.lc    A.lc.9   curvature   n.obs    l2.energy   sd.error  sigma.a   sigma.b    i.mag    color.vi    color.bi   L'
write(ts, f.out)
write.table(ndt, f.out, col.names=F, row.names=F, append = T, quote=F, sep='   ')

for (i in 2:length(types)) {
    type = types[i]
    ltype = ltypes[i]
    print(type)
    f.dat = paste0(fdir,ltype,'_features.dat')
    f.jkl = paste0(outdir,type,'.jkl')
    dat = read.table(f.dat)
    jkl = read.table(f.jkl)
    dat[,1] = as.character(dat[,1])
    jkl[,1] = as.character(jkl[,1])
    idx = match(dat[,1], jkl[,1])
    ls = jkl[idx,4]
    ndt = cbind(dat,ls)
    write.table(ndt, f.out, col.names=F, row.names=F, append = T, quote=F, sep='   ')
}
