set.seed(101)

n.dir = 100

dir = '~/Work/m33_miras/testcpp/'
flcdir = paste0(dir,'flcs/')


if (F) {

    f.lst = paste0(dir,'../traindata/train.data.jkl.lst')
    lst = read.table(f.lst)
    lst = lst[!is.na(lst[,4]),]
    lst = lst[lst[,4]>0.6,]

    ids = as.character(lst[,1])
    nids = length(ids)

    idx = sample(1:nids,replace=F)
    ids = ids[idx]
    idx = substr(ids,1,4) == 'mira'
    ids = ids[idx]
    lids = gsub('con_','~/Work/m33_miras/simulate_constant/constant_flcs/con_',ids)
    lids = gsub('mira_','~/Work/m33_miras/simulate_mira/v3_mira_flcs/mira_',lids)
    lids = gsub('srv_','~/Work/m33_miras/simulate_srv/v3_srv_flcs/srv_',lids)

    nids = length(ids)

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
    
}

f.do = paste0(dir,'dosubmit.sh')
write('#',f.do,append=F)

for (i in 1:n.dir) {
    sdir = paste0(flcdir,'batch_',i,'/')
    fs = list.files(sdir)
    lfs = paste0('flcs/batch_',i,'/',fs)
    f.lst = paste0(dir,'b_',i,'.lst')
    sf.lst = paste0('b_',i,'.lst')
    write.table(lfs,f.lst,quote=F,row.names=F,col.names=F)

    f.slrm = paste0(dir,'cgp_',i,'.slrm')
    sf.slrm = paste0('cgp_',i,'.slrm')
    ts = '#!/bin/bash'
    write(ts,f.slrm)
    ts = paste0('#SBATCH -J cgp_',i)
    write(ts,f.slrm,append=T)
    ts = '#SBATCH -p background-4g'
    write(ts,f.slrm,append=T)
    ts = '#SBATCH --time=05:59:59'
    write(ts,f.slrm,append=T)
    ts = '#SBATCH -n1'
    write(ts,f.slrm,append=T)
    ts = '#SBATCH --mem-per-cpu=4095'
    write(ts,f.slrm,append=T)
    ts = paste0('#SBATCH -o cgp_%j',i,'.out')
    write(ts,f.slrm,append=T)
    ts =  paste0('#SBATCH -e cgp_%j',i,'.err')
    write(ts,f.slrm,append=T)
    ts = 'module load gcc'
    write(ts,f.slrm,append=T)
    ts = 'module load openblas'
    write(ts,f.slrm,append=T)
    ts = 'module load lapack'
    write(ts,f.slrm,append=T)
    ts = paste0('/fdata/scratch/yuanwenlong/m33_v3/packages/cpp_version/gpmodel -l ',sf.lst)
    write(ts,f.slrm,append=T)
    ts = 'exit 0'
    write(ts,f.slrm,append=T)
    ts = paste0('sbatch ',sf.slrm)
    write(ts,f.do,append=T)
    ts = 'sleep 2'
    write(ts,f.do,append=T)
}

