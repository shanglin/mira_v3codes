## dir = '~/Work/m33/gp_v3/m33_ofiles/'
dir = '~/Work/m33_miras/m33_ofiles/'
## The directory name changed on some day before 2016 (laptop and desktop), and here we modified the path

lcdir = paste0(dir,'not.in.cat.mband/')
system(paste0('mkdir -p ',lcdir))

fs.lcs = list.files(paste0(dir,'mband/'))
nfs = length(fs.lcs)

cnt = 0
## copy mband files that not in t_mband_wo
if (F) {
for (i in 1:nfs) {
    lf = paste0(dir,'t_mband_wo/mslcs/',fs.lcs[i])
    if (!file.exists(lf)) {
        cmd = paste0('cp ',dir,'mband/',fs.lcs[i],' ',lcdir)
        system(cmd)
        cnt = cnt + 1
    }
    ## print(cnt)
    message(paste0('>>>',round(100*i/nfs,3),' %    \r  '),appendLF=F)
}
}

## copy ionly files that not in t_mband_wo and not in t_ionly_wo
if (F) {
fs.lcs = list.files(paste0(dir,'ionly/'))
nfs = length(fs.lcs)
for (i in 1:nfs) {
    lf = paste0(dir,'t_mband_wo/mslcs/',fs.lcs[i])
    if (!file.exists(lf)) {
        lf2 = paste0(dir,'t_ionly_wo/islcs/',fs.lcs[i])
        if (!file.exists(lf2)) {
            cmd = paste0('cp ',dir,'ionly/',fs.lcs[i],' ',lcdir)
            system(cmd)
        }
    }
    message(paste0('>>>',round(100*i/nfs,3),' %    \r  '),appendLF=F)
}
}

## remove duplicate if based on ID map
if (T) {
map = read.table(paste0(dir,'t_mband_wo/IDmap_it5.txt'),head=T)
map = map[map[,2] != 'xxxxx',]
nmap = nrow(map) ## well, nmap...

for (i in 1:nmap) {
    f.i = paste0(lcdir,map[i,1])
    f.m = paste0(lcdir,map[i,2])
    if (file.exists(f.m) & file.exists(f.i)) {
        cmd = paste0('rm -f ',f.i)
        system(cmd)
    }
    message(paste0('>>>',round(100*i/nmap,3),' %    \r  '),appendLF=F)
}

## or overlap with in t_mband_wo directory
for (i in 1:nmap) {
    f.i = paste0(lcdir,map[i,1])
    f.m = paste0(dir,'t_mband_wo/mslcs/',map[i,2])
    if (file.exists(f.m) & file.exists(f.i)) {
        cmd = paste0('rm -f ',f.i)
        system(cmd)
    }
    message(paste0('>>>',round(100*i/nmap,3),' %    \r  '),appendLF=F)
}


}

