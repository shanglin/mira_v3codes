## Results looks very good, no need to re-fit the relation

lcdir = '~/Work/m33_miras/m33_trialp/lcfiles/variable/'
if (!exists('fs.lc')) {
    field = 'i'
    fs.lc = list.files(lcdir,pattern=paste0('^',field,'.*.lc$'))
    nfs.lc = length(fs.lc)
}

outdir = '~/Work/m33_miras/m33_trialp/check_sig_mag/'
f.all = paste0(outdir,'m0',field,'.all.lc')

if (T) {
write('#',f.all)
for (i in 1:nfs.lc) {
    msg = paste0('    >> loading ',round(i*100/nfs.lc,2), '   %      \r')
    message(msg, appendLF = F)
    f.lc = fs.lc[i]
    lf.lc = paste0(lcdir,f.lc)
    lc = read.table(lf.lc)
    lc = lc[,1:3]
    lc[,1] = round(lc[,1] - 2450000,4)
    write.table(lc, f.all, append = T, col.names=F, row.names = F)
}
print('')
}

all = read.table(f.all)
nights = round(all[,1])
uniq.nights = unique(nights)
n.uniq.night = length(uniq.nights)

f.sig = '~/Work/m33_miras/simulate_constant/m33i_nkt_it5_flg_ins.dat'
sig = read.table(f.sig, header = T)

for (i in 1:n.uniq.night) {
    night = uniq.nights[i]
    ssid = paste0(field,'ii',night)
    idx = ssid == sig[,1]
    if (sum(idx) == 1) {
        a = sig[idx,2]
        b = sig[idx,3]
        c = sig[idx,4]
        
        sub = all[nights == night,]
        mag = sub[,2]
        err = sub[,3]
        x = seq(10,27,by=0.1)
        y = a^(x-b) + c

        f.png = paste0(outdir,'m0',field,'_',ssid,'.png')
        png(f.png)
        plot(mag,err,pch=19,cex=0.1,ylim=c(0,1), main=ssid)
        lines(x,y, col=2)
        dev.off()
        ## Sys.sleep(5)
    } else {
        print(paste0(' ssid ',ssid, ' not found in the lookup table'))
    }
}
    
