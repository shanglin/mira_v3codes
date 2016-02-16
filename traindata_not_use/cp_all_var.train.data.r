## 1. all the constant light curves with L>=0.6
## 2. all the SRV light curves with L>=0.6
## 3. all the Mira light curves with L>=0.6
## only make a list but not actually copy the files

dir = '~/Work/m33_miras/'
trndir = paste0(dir,'traindata/')
condir = paste0(dir,'simulate_constant/')
miradir = paste0(dir,'simulate_mira/')
srvdir = paste0(dir,'simulate_srv/')
outdir = paste0(dir,'traindata/')

f.out = paste0(outdir,'traindata.lst')

## identifier with whole path, ready to feed C++ as the list file
cmd = paste0('rm -f ',f.out)
system(cmd)

fields = c(0:9,letters[1:19])

for (field in fields) {
    f.jkl = paste0(condir,'stet.jkl.vals/simu_con_m0',field,'.jkl')
    print(paste0('    >> Constant m0',field))
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            sub.lst = jkl[jkl[,4] >= 0.6,1]
            if (sum(is.na(sub.lst)) > 0) stop('NA comes')
            sub.lst = paste0('cp ',condir,'constant_flcs/',sub.lst,' ./flc_files/')
            write.table(sub.lst,f.out,row.names=F, col.names = F, quote = F, append = T)
        } else {
            print(paste0('  No lines in file ',f.jkl))
        }   
    } else {
        print(paste0('  No lines in file ',f.jkl))
    }
}

for (field in fields) {
    f.jkl = paste0(srvdir,'srv.stet.jkl.vals/simu_srv_m0',field,'.jkl')
    print(paste0('    >> SRV m0',field))
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            sub.lst = jkl[jkl[,4] >= 0.6,1]
            if (sum(is.na(sub.lst)) > 0) stop('NA comes')
            sub.lst = paste0('cp ',srvdir,'v3_srv_flcs/',sub.lst,' ./flc_files/')
            write.table(sub.lst,f.out,row.names=F, col.names = F, quote = F, append = T)
        } else {
            print(paste0('  No lines in file ',f.jkl))
        }
    }
}

for (field in fields) {
    f.jkl = paste0(miradir,'mira.stet.jkl.vals/simu_mira_m0',field,'.jkl')
    print(paste0('    >> Mira m0',field))
    if (file.exists(f.jkl)) {
        jkl = try(read.table(f.jkl), silent = T)
        if (class(jkl) != 'try-error') {
            jkl[,1] = as.character(jkl[,1])
            jkl = jkl[!is.na(jkl[,4]),]
            sub.lst = jkl[jkl[,4] >= 0.6,1]
            if (sum(is.na(sub.lst)) > 0) stop('NA comes')
            sub.lst = paste0('cp ',miradir,'v3_mira_flcs/',sub.lst,' ./flc_files/')
            write.table(sub.lst,f.out,row.names=F, col.names = F, quote = F, append = T)
        } else {
            print(paste0('  No lines in file ',f.jkl))
        }
    }
}

