## Results looks very good

lcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/variable/'
if (!exists('fs.lc')) {
    field = '0'
    fs.lc = list.files(lcdir,pattern=paste0('^',field,'.*.lc$'))
    nfs.lc = length(fs.lc)
}

outdir = '~/Work/m33_miras/m33_trialp/check_sig_mag/'
f.all = paste0(outdir,'m0',field,'.all.tlc')

if (T) {
write('#',f.all)
for (i in 1:nfs.lc) {
    msg = paste0('    >> loading ',round(i*100/nfs.lc,2), '   %      \r')
    message(msg, appendLF = F)
    f.lc = fs.lc[i]
    lf.lc = paste0(lcdir,f.lc)
    lc = read.table(lf.lc)
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
        x = seq(10,27,by=0.1)
        y = a^(x-b) + c

        sub1 = sub[sub[,4]==1,]
        mag = sub1[,2]
        err = sub1[,3]
        sub2 = sub[sub[,4]>1,]
        m2 = sub2[,2]
        e2 = sub2[,3]
        
        ## f.png = paste0(outdir,'m0',field,'_',ssid,'_tlc.png')
        ## png(f.png)
        plot(mag,err,pch=19,cex=0.1,ylim=c(0,1), main=ssid)
        points(m2,e2,pch=19,cex = 0.3, col=4)
        lines(x,y, col=2)
        ## dev.off()
        Sys.sleep(5)
    } else {
        print(paste0(' ssid ',ssid, ' not found in the lookup table'))
    }
}
    
