fields = c(0:9, letters[1:19])
## fields = fields[1]

dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
figdir = paste0(dir,'figures_cali/')
fnldir = '~/Work/m33_miras/m33_trialp/fnlfiles/'
fitdir = '~/Work/m33_miras/m33_ofiles/fits.files/'

f.mas = paste0(dir,'massey_phot.std')
mas = read.table(f.mas, header = T)
mas = mas[mas[,'ni'] > 0,]
mas[,1] = as.character(mas[,1])

f.mnh = paste0(dir,'massey_phot_nh.std')
f.dm = 'ionly_dm.log'
ts = '# when vmag = -1, imag should be .fnl mag - mean, which is listed below'
write(ts,f.dm)
ts = '# field   mean_dm'
write(ts,f.dm, append = T)
for (field in fields) {
    print(field)
    f.fnl = paste0(fnldir,'m0',field,'i.fnl')
    if (file.exists(f.fnl)) {
        f.fit = paste0(fitdir,'m0',field,'iw.fits')
        
        
        rdtmp = 'rd.tmp'
        cmd = paste0('awk \'NR>1 {print $2,$3}\' ',f.mas,' > ',rdtmp)
        system(cmd)
        cmd = paste0('sky2xy ',f.fit,' @',rdtmp,' > xy.tmp')
        system(cmd)
        cmd = 'rm -f rd.tmp'
        system(cmd)
        cmd = paste0('paste ',f.mnh,' xy.tmp > cmb.tmp')
        system(cmd)
        cmd = 'rm -f xy.tmp'
        system(cmd)
        cmd = 'awk \'$17==""\' cmb.tmp > xy.on.tmp'
        system(cmd)
        cmd = 'rm -f cmb.tmp'
        system(cmd)

        xyon = read.table('xy.on.tmp')
        xyon = xyon[xyon[,10]>0,]
        fnl = read.table(f.fnl, skip = 1)
        n.xy = nrow(xyon)
        cmd = 'rm -f xy.on.tmp'
        system(cmd)
        dx = 1
        dy = 1
        mch = cbind(xyon[,1:3],xyon[,7],xyon[,15:16],rep(NA,n.xy),rep(NA,n.xy),rep(NA,n.xy))
        colnames(mch) = c('id_massey','ra','dec','i','x','y','id','i_fnl','ei')
        for (i in 1:n.xy) {
            idx = abs(mch[i,'x'] - fnl[,2]) < dx & abs(mch[i,'y'] - fnl[,3]) < dy
            if (sum(idx) == 1) {
                mch[i,'id'] = fnl[idx,1]
                mch[i,'i_fnl'] = fnl[idx,4]
                mch[i,'ei'] = fnl[idx,5]
            }
        }
        mch = mch[!is.na(mch[,'ei']),]
        a = mch[mch[,'i']<19.5,]
        b = mch[mch[,'i']>=19.5,]
        fnli = a[,'i_fnl']
        masi = a[,'i']
        ei = a[,'ei']
        ylim = median(fnli-masi)+c(-0.5,0.5)
        f.png = paste0(figdir,'dm_m0',field,'.png')
        png(f.png)
        plot(masi,fnli-masi,pch=19,cex=0.5, xlab='I (mag) from Massey',ylab='.fnl I - Massey I (mag)', main=paste0('m0',field),xlim=range(mch[,'i_fnl']),ylim=ylim,col='grey')
        points(b[,'i'],b[,'i_fnl'] - b[,'i'],pch=19,cex=0.5,col='grey')
        for (ifoo in 1:20) {
            fnli = a[,'i_fnl']
            masi = a[,'i']
            di = fnli-masi
            idx = di > mean(di) - 2.3*sd(di) & di < mean(di) + 2.3*sd(di)
            a = a[idx,]
        }
        fnli = a[,'i_fnl']
        masi = a[,'i']
        di = fnli-masi
        ei = a[,'ei']
        points(masi,di,pch=19,cex=0.5)
        arrows(masi,di+ei,masi,di-ei,angle=90,code=3,length=0.001)
        abline(h=mean(di),col=2)
        fnli = fnli - mean(di)
        text(median(a[,'i']),ylim[2]-0.1,paste0('mean = ',round(mean(di),3)),col=2)
        ## text(median(a[,'i_fnl']),ylim[2]-0.15,'I\' = I - mean',col=2)
        dev.off()
        ts = paste(field, round(mean(di),3), sep = '      ')
        write(ts,f.dm,append=T)
    }
}

