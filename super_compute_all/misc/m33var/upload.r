set.seed(101)

n.dir = 2900 ## 3000 jobs at maximum
odir = '~/Work/m33_miras/m33_ofiles/rlcs/variable/'
dir = '~/Work/m33_miras/'
scdir = paste0(dir,'super_compute_all/')
outdir = paste0(scdir,'m33var/')
flcdir = paste0(outdir,'flcs/')
system(paste0('mkdir -p ', flcdir))

ids = list.files(odir)
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
