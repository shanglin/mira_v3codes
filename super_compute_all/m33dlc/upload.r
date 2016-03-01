set.seed(101)

n.dir = 2900
odir = '~/Work/m33_miras/m33_ofiles/dlcs/variable/'
dir = '~/Work/m33_miras/'
scdir = paste0(dir,'super_compute_all/')
outdir = paste0(scdir,'m33dlc/')
flcdir = paste0(outdir,'flcs/')
system(paste0('mkdir -p ', flcdir))

all.ids = list.files(odir)
n.obs = rep(NA, length(all.ids))

for (i in 1:length(all.ids)) {
    id = all.ids[i]
    f = paste0(odir,id)
    dat = read.table(f)
    n.obs[i] = nrow(dat)
    msg = paste0('    >> [checking number of observations] ',round(100*i/length(all.ids),2),' %     \r')
    message(msg,appendLF=F)
}


least.obs = 10
least.night = 7
mag.shift = 6.2

ids = all.ids[n.obs >= least.obs]
nids = length(ids)
idx = sample(1:nids,replace=F)
ids = ids[idx]
lids = paste0(odir,ids)


nless = floor(nids/n.dir)
nmore = ceiling(nids/n.dir)

n.moredir = nids - nless*n.dir
n.lessdir = n.dir - n.moredir

idx.start = 1
for (i in 1:n.dir) {
    cpdir = paste0(flcdir,'batch_',i,'/')
    system(paste0('mkdir -p ',cpdir))
    if (i <= n.moredir) {
        idx.end = idx.start + nmore - 1
        for (j in idx.start:idx.end) {
            file.copy(lids[j],cpdir)
        }
        idx.start = idx.start + nmore
    } else {
        idx.end = idx.start + nless - 1
        for (j in idx.start:idx.end) {
            file.copy(lids[j],cpdir)
        }
        idx.start = idx.start + nless
    }
    print(paste0(' Copying ',idx.end,' out of ',nids))
}
