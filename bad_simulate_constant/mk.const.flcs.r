least.obs = 10
least.night = 7

## (0) Random number is needed for this program
set.seed(101)

## (1) Generate a table for all the real light curve where we extract MJDs
m33dir = '~/Work/m33_miras/m33_ofiles/'
f.mlst = paste0(m33dir,'t_mband_wo/t_mband.lst')
fs.lc.m = read.table(f.mlst)
nfs.lc.m = length(fs.lc.m)
lfs.lc.m = paste0(m33dir,'t_mband_wo/mslcs/',fs.lc.m[,1])
fields = substr(fs.lc.m[,1],1,1)
lfs.lc.mdf = cbind(lfs.lc.m,rep('m',nfs.lc.m),fields)

f.ilst = paste0(m33dir,'t_ionly_wo/t_ionly.lst')
fs.lc.i = read.table(f.ilst)
nfs.lc.i = length(fs.lc.i)
lfs.lc.i = paste0(m33dir,'t_ionly_wo/islcs/',fs.lc.i[,1])
fields = substr(fs.lc.i[,1],1,1)
lfs.lc.idf = cbind(lfs.lc.i,rep('i',nfs.lc.i),fields)
## This data.frame below contains: lc file name (include path), lc type (tm or ti), and field
lfs.lc.df = rbind(lfs.lc.mdf,lfs.lc.idf)

## (2) Load instrumental sigma-mag relations
dir = '~/Work/m33_miras/simulate_constant/'
f.rel = paste0(dir,'m33i_nkt_it5_flg_ins.dat')
rel = read.table(f.rel,header=T)
## only keep the good relations
rel = rel[rel[,'flag']==0,]
nrel = nrow(rel)

## (3) Generate light curves one by one: from the fnl magnitudes and reduced chi squares!
outdir = paste0(dir,'const_flcs')
flc.counter = 0
fields = c(0:9,letters[1:19])
## field = '0'
f.log = paste0(dir,'const.generate.log')
write('#',f.log)
for (field in fields) {
    sub.df = lfs.lc.df[lfs.lc.df[,3]==field,]
    nsub = nrow(sub.df)
    f.dat = paste0(dir,'id.fnlmag.chi/id.mag.chi.m0',field,'.dat')
    dat = read.table(f.dat)
    dat = dat[!is.na(dat[,3]),]
    dat = dat[!is.na(dat[,2]),]
    ndat = nrow(dat)
    if (ndat > 0) {
        for (i in 1:ndat) {
            msg = paste0('    >> [field:',field,'] Generating light curve: ',round(i/ndat*100,2),' %     \r')
            message(msg,appendLF=F)
            fnl.id = dat[i,1]
            fnl.mag = dat[i,2]
            red.chi = dat[i,3]
            
            ## Randomly select a MJD pattern in the field of consideration
            random.idx = sample(1:nsub,1)
            f.lc = sub.df[random.idx,1]
            lc.type = sub.df[random.idx,2]
            if (lc.type == 'm') {
                lc.path = paste0(m33dir,'t_mband_wo/mslcs/')
            } else if (lc.type == 'i') {
                lc.path = paste0(m33dir,'t_ionly_wo/islcs/')
            } else {
                msg = paste0('  !!>>',f.lc,' type = ',lc.type,' not found.')
                stop(msg)
            }
            sf.lc = gsub(lc.path,'',f.lc)
            
            rlc = read.table(f.lc,skip=1)
            error.flag = rlc[,8]
            good.idx = (error.flag %% 10) == 1
            mjds = rlc[good.idx,1]
            nobs = length(mjds)
            
            ## Simulating light curve
            if (nobs >= least.obs) {
                nights = round(mjds)
                uniq.nights = unique(nights)
                if (length(uniq.nights) >= least.night) {
                    flc.counter = flc.counter + 1
                    simulate.lc = as.data.frame(matrix(NA,nrow=nobs,ncol=3))
                    simulate.lc[,1] = mjds
                    for (i.obs in 1:nobs) {
                        night = nights[i.obs]
                        ssid = paste0(field,'ii',night)
                        sig.idx = rel[,1] == ssid
                        if (sum(sig.idx) != 1) {
                            nssid = paste0(field,'ii',night-1)
                            sig.idx = rel[,1] == nssid
                            if (sum(sig.idx) != 1) {
                                nssid = paste0(field,'ii',night+1)
                                sig.idx = rel[,1] == nssid
                                if (sum(sig.idx) != 1) {
                                    msg = paste0('  !!>>',ssid,' not found in the sig-mag relation table, Use a random one instead.')
                                    write(msg,f.log,append=T)
                                    sig.idx = sample(1:nrel,1)
                                }
                            }
                        }
                        rel.a = rel[sig.idx,'A']
                        rel.b = rel[sig.idx,'B']
                        rel.c = rel[sig.idx,'C']
                        simulate.lc[i.obs,3] = round(rel.a^(fnl.mag - rel.b) + rel.c, 3)
                        simulate.lc[i.obs,2] = round(rnorm(1, mean = fnl.mag, sd = sqrt(red.chi)*simulate.lc[i.obs,3]), 3)
                    }
                    if ((flc.counter %% 1000) == 1) {
                        f.eps = paste0(dir,'figures/',gsub('.slc','',sf.lc),'_',fnl.id,'_',lc.type,'.eps')
                        golden.ratio = 1.61803398875
                        fig.height = 10 # inches
                        fig.width = fig.height * golden.ratio
                        setEPS()
                        postscript(f.eps,height = fig.height, width = fig.width)
                        par(mfrow=c(2,1))
                        a = simulate.lc
                        plot(a[,1:2],pch=19,main='Simulated Constant Star Light Curve',ylab='instrumental I (mag)',xlab='MJD',ylim=c(max(a[,2]+0.3),min(a[,2])-0.3))
                        arrows(a[,1],a[,2]+a[,3],a[,1],a[,2]-a[,3],code=3,length=0.05,angle=90)
                        b = rlc[good.idx,]
                        plot(b[,1:2],pch=19,main='Real Light Curve (Unknown Class)',ylab='instrumental I (mag)',xlab='MJD',ylim=c(max(b[,2])+0.3,min(b[,2])-0.3))
                        arrows(b[,1],b[,2]+b[,3],b[,1],b[,2]-b[,3],code=3,length=0.05,angle=90)
                        dev.off()
                        ## stop('good')
                        ## Sys.sleep(1)
                    }
                    f.sim = paste0(dir,'const_flcs/',gsub('.slc','',sf.lc),'_',fnl.id,'_',lc.type,'.flc')
                    write.table(simulate.lc,f.sim,row.names=F,col.names=F)
                }
            }
        }
    }
    print('')
}

