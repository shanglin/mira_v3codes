set.seed(101)

n.mira = 5000
n.srv = 5000
## n.constant = all the simulated constant will be used

dir = '~/Work/m33_miras/'
trndir = paste0(dir,'traindata/')
outdir = paste0(trndir,'train_flcs/')
condir = paste0(dir,'simulate_constant/')
miradir = paste0(dir,'simulate_mira/')
srvdir = paste0(dir,'simulate_srv/')

fields = c(0:9,letters[1:19])

f.lst = paste0(trndir,'train.data.jkl.lst')
write('#',f.lst)

for (field in fields) {
    f.jkl = paste0(condir,'stet.jkl.vals/simu_con_m0',field,'.jkl')
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            write.table(jkl, f.lst, row.names = F, col.names = F, append = T, quote = F)
        }
    }
}

f.tmp = 'a.tmp'
write('#',f.tmp)

for (field in fields) {
    f.jkl = paste0(miradir,'mira.stet.jkl.vals/simu_mira_m0',field,'.jkl')
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            write.table(jkl, f.tmp, row.names = F, col.names = F, append = T, quote = F)
        }
    }
}
tmp = read.table(f.tmp)
ntmp = nrow(tmp)
idx = sample(1:ntmp, n.mira, replace = F)
jkl = tmp[idx,]
write.table(jkl, f.lst, row.names = F, col.names = F, append = T, quote = F)
system(paste0('rm -f ',f.tmp))


for (field in fields) {
    f.jkl = paste0(srvdir,'srv.stet.jkl.vals/simu_srv_m0',field,'.jkl')
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            write.table(jkl, f.tmp, row.names = F, col.names = F, append = T, quote = F)
        }
    }
}
tmp = read.table(f.tmp)
ntmp = nrow(tmp)
idx = sample(1:ntmp, n.mira, replace = F)
jkl = tmp[idx,]
write.table(jkl, f.lst, row.names = F, col.names = F, append = T, quote = F)
system(paste0('rm -f ',f.tmp))
