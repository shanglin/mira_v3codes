set.seed(101)

n.dir = 2900 ## 3000 jobs at maximum
dir = '~/Work/m33_miras/'
scdir = paste0(dir,'super_compute_all/')
outdir = paste0(scdir,'const/')
flcdir = paste0(outdir,'flcs/')

condir = paste0(dir,'simulate_constant/')
miradir = paste0(dir,'simulate_mira/')
srvdir = paste0(dir,'simulate_srv/')

fields = c(0:9,letters[1:19])
f.lst = paste0(outdir,'const.jkl.lst')
write('#',f.lst)

f.tmp = 'a.tmp'
write('#',f.tmp)
for (field in fields) {
    f.jkl = paste0(condir,'stet.jkl.vals/simu_con_m0',field,'.jkl')
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            jkl = jkl[jkl[,4] > 0.6,]
            write.table(jkl, f.tmp, row.names = F, col.names = F, append = T, quote = F)
        }
    }
}
jkl = read.table(f.tmp)
write.table(jkl, f.lst, row.names = F, col.names = F, append = T, quote = F)
system(paste0('rm -f ',f.tmp))

lst = read.table(f.lst)
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
        
