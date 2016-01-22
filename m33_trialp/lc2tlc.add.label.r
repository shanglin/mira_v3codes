

fields = c(0:9,letters[1:19])
types = c('constant/','variable/')
tlcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/'
lcdir = '~/Work/m33_miras/m33_trialp/lcfiles/'

f.sig = '~/Work/m33_miras/m33_trialp/tlc_labels/m33i_lkt.dat'
sig = read.table(f.sig)

## field = '0'
## type = types[2]

cal.thres = function(x,a,b,c) {
    return(a^(x-b) + c)
}

for (field in fields) {
    for (type in types) {
        
        indir = paste0(lcdir,type)
        outdir = paste0(tlcdir,type)
        fs.lc = list.files(indir,pattern=paste0('^',field,'.*.lc$'))
        nfs.lc = length(fs.lc)
        if (nfs.lc > 0) {
        
        for (i in 1:nfs.lc) {
            msg = paste0('     >> [m0',field,':',type,'] ',round(i*100/nfs.lc,2),' %     \r')
            message(msg,appendLF = F)
            f.lc = fs.lc[i]
            lf.lc = paste0(indir,f.lc)
            lc = read.table(lf.lc)[,1:3]
            lc[,1] = round(lc[,1]-2450000,4)
            nlc = nrow(lc)
            labels = rep(NA,nlc)
            for (ilc in 1:nlc) {
                ssid = paste0(field,'xi',round(lc[ilc,1]))
                idx = ssid == sig[,1]
                if (sum(idx) != 1) stop(paste0(ssid,' not found in ',f.sig))
                q = sig[idx,7]
                a = sig[idx,2]
                b = sig[idx,3]
                c = sig[idx,4]
                xsh = sig[idx,5]
                ysh = sig[idx,6]
                if (q != 10) {
                    labels[ilc] = 9
                } else {
                    thres = cal.thres(lc[ilc,2] + xsh, a,b,c) + ysh
                    if (lc[ilc,3] > thres) {
                        labels[ilc] = 8
                    } else {
                        labels[ilc] = 1
                    }
                }
            }
            
            lc = cbind(lc,labels)
            f.tlc = paste0(outdir,gsub('.lc','.tlc',f.lc))
            write.table(lc,f.tlc,row.names=F,col.names=F)
        }
        print('')
    }
    }
}
