set.seed(101)

n.dir = 2900 ## 3000 jobs at maximum

dir = '~/Work/m33_miras/traindata/train_data/'
flcdir = paste0(dir,'flcs/')

f.lst = paste0(dir,'../train.data.jkl.lst')
lst = read.table(f.lst)
lst = lst[!is.na(lst[,4]),]
lst = lst[lst[,4]>0.6,]

ids = as.character(lst[,1])
nids = length(ids)

idx = sample(1:nids,replace=F)
ids = ids[idx]
lids = gsub('con_','~/Work/m33_miras/simulate_constant/constant_flcs/con_',ids)
lids = gsub('mira_','~/Work/m33_miras/simulate_mira/v3_mira_flcs/mira_',lids)
lids = gsub('srv_','~/Work/m33_miras/simulate_srv/v3_srv_flcs/srv_',lids)

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
        
