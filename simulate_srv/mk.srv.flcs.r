rm(list=ls())
set.seed(101)

dir = '~/Work/m33_miras/'
sim = 'simulate_srv/'
srvdir = paste0(dir,'lmc_ofiles/srv.lcs/')
outdir = paste0(dir,'simulate_srv/v3_srv_flcs/')
figure.dir = paste0(dir,'simulate_srv/figures/')
ctlcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/constant/'
vtlcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/variable/'


f.log = paste0(dir,sim,'srv.generate.log')
write('#',f.log)

## some plot parameters
golden.ratio = 1.61803398875
fig.height = 10 # inches
fig.width = fig.height * golden.ratio


## load I-band sigma-magnitude relation (calibrated magnitude)
f.sig = paste0(dir,'simulate_constant/m33i_it5_lkt_flg_cal.dat') 
sig = read.table(f.sig, header=T)
sig = sig[sig[,'flag'] == 0, ]
nsig = nrow(sig)

## distance modulus between LMC and M33
mag.shift = 6.2

## ignore light curves with less observations
least.obs = 10
least.night = 7

sim.engine = function(f.slc,f.lmc,lmc.id,sid,ts.plot) {
    ## f.lmc = paste0(srvdir,'OGLE-LMC-LPV-09998.dat')
    ## f.slc = '~/Work/m33_miras/m33_ofiles/t_mband_wo/mslcs/smi938_it5.slc'
    ## lmc.id = '09998'
    ## sid = 'smi938'
    ## ts.plot = T

    ## load lmc light curve and M33 MJDs, remove bad observations
    field = substr(sid,1,1)
    lmc.dat = read.table(f.lmc)
    m33.dat = read.table(f.slc, skip = 0)
    idx = m33.dat[,4] == 1
    m33.dat = m33.dat[idx,]
    nobs = nrow(m33.dat)
    nights = round(m33.dat[,1])
    nnight = length(unique(nights))

    if (nobs <= least.obs | nnight <= least.night) {
        ret = 9
    } else {
        lmc.range = max(lmc.dat[,1]) - min(lmc.dat[,1])
        m33.range = max(m33.dat[,1]) - min(m33.dat[,1])
        if (lmc.range < m33.range) {
            ret = 8
        } else {
            orig.jds = m33.dat[,1]
            align.jds = orig.jds - min(orig.jds) + min(lmc.dat[,1])
            random.shift = runif(1, 0, (max(lmc.dat[,1]) - max(align.jds)))
            shift.jds = align.jds + random.shift

            flc = as.data.frame(matrix(NA, ncol = 3, nrow = nobs))
            flc[,1] = orig.jds
            
            x = lmc.dat[,1]
            y = lmc.dat[,2] + mag.shift
            ye = lmc.dat[,3]

            mag.spline = smooth.spline(x,y,w=1/ye^2)
            mag.predict = predict(mag.spline,shift.jds)$y
            
            ## add noise
            for (i in 1:nobs) {
                night = nights[i]
                mag = mag.predict[i]
                ssid = paste0(field,'ii',night)
                sig.idx = sig[,1] == ssid
                if (sum(sig.idx) != 1) {
                    nssid = paste0(field,'ii',night-1)
                    sig.idx = sig[,1] == nssid
                    if (sum(sig.idx) != 1) {
                        nssid = paste0(field,'ii',night+1)
                        sig.idx = sig[,1] == nssid
                        if (sum(sig.idx) != 1) {
                            msg = paste0('  !!>>',ssid,' not found in the sig-mag relation table, Use a random one instead.')
                            write(msg,f.log,append=T)
                            sig.idx = sample(1:nsig,1)
                        }
                    }
                }
                sig.a = sig[sig.idx,'A']
                sig.b = sig[sig.idx,'B']
                sig.c = sig[sig.idx,'C']
                flc[i,3] = round(sig.a^(mag - sig.b) + sig.c, 3)
                flc[i,2] = round(rnorm(1, mean = mag, sd = flc[i,3]), 3)
            }
            flc = flc[order(flc[,1]),]
            f.flc = paste0(outdir,'srv_',lmc.id,'_',sid,'_',round(random.shift,2),'.flc')
            write.table(flc,f.flc,row.names=F,col.names=F, sep = '  ')
            ret = 0

            if (ts.plot) {
                f.eps = paste0(figure.dir,'srv_',lmc.id,'_',sid,'_',round(random.shift,2),'.eps')
                setEPS()
                postscript(f.eps,height = fig.height, width = fig.width)
                par(mfrow=c(2,1))
                plot(x,y,pch=19,cex=0.5,xlab='MJD',ylab='I + 6.2 (mag)')
                arrows(x,y+ye,x,y-ye,code=3,angle=90,length=0.02)
                points(shift.jds,mag.predict,col=4,pch=19,cex=1)

                plot(x,y,pch=19,cex=0.5,xlab='MJD',ylab='I + 6.2 + Noise (mag)')
                arrows(x,y+ye,x,y-ye,code=3,angle=90,length=0.02)
                x = shift.jds
                y = flc[,2]
                ye = flc[,3]
                points(x,y,pch=19,col=2)
                arrows(x,y+ye,x,y-ye,code=3,angle=90,length=0.02,col=2)
                dev.off()
            }
        }
    }
    return(ret)
}


v2sim = 'v2_simulate_srv/'
f.tblA1 = paste0(dir,v2sim,'tableA/conv_lmc_srv_s1.csv')
f.tblA2 = paste0(dir,v2sim,'tableA/conv_lmc_srv_s2.csv')
f.tblAi = paste0(dir,v2sim,'tableA/conv_lmc_srv_si.csv')
tblA1 = read.table(f.tblA1, header=TRUE, sep=',')
tblA2 = read.table(f.tblA2, header=TRUE, sep=',')
tblAi = read.table(f.tblAi, header=TRUE, sep=',')
tblA = rbind(tblA1,tblA2,tblAi)

f.log2 = paste0(dir,sim,'srv.check.lumin.log')
write('#',f.log2)

LMCids = as.character(tblA[,'ID'])
LMCIDs = gsub('OGLE-LMC-LPV-','',LMCids)
LMCprob = tblA[,'Prop']
nfs.dat = nrow(tblA)

cfs.tlc = list.files(ctlcdir)
vfs.tlc = list.files(vtlcdir)
fs.tlc = c(cfs.tlc, vfs.tlc)
lfs.tlc = c(paste0(ctlcdir,cfs.tlc), paste0(vtlcdir,vfs.tlc))
nfs.tlc = length(fs.tlc)

n.sim.flc = 1e5
i.sim.flc = 0
while (i.sim.flc < n.sim.flc) {
    
    idx.tlc = sample(1:nfs.tlc, 1)
    lf.tlc = lfs.tlc[idx.tlc]
    f.tlc = fs.tlc[idx.tlc]
    M33ID = gsub('.tlc','',f.tlc)
    f.slc = lf.tlc
    sid = M33ID

    idx.dat = sample(1:nfs.dat, 1, prob = LMCprob)
    f.dat = paste0(LMCids[idx.dat],'.dat')
    lf.dat = paste0(srvdir, f.dat)
    LMCID = LMCIDs[idx.dat]
    LMCid = LMCids[idx.dat]
    f.lmc = lf.dat
    lmc.id = LMCID
    lmc.idx = idx.dat

    msg = paste0('    >> ',round(i.sim.flc * 100 / n.sim.flc, 3),' %      \r')
    message(msg, appendLF = F)
    
    if ((i.sim.flc %% 1000) == 1) {
        ts.plot = T
    } else {
        ts.plot = F
    }
    ret = sim.engine(f.slc,f.lmc,lmc.id,sid,ts.plot)

    if (ret == 0) {
        imag = tblA[lmc.idx,'I']
        ts = paste(lmc.id,imag,sep='  ')
        write(ts, f.log2, append = T)
        i.sim.flc = i.sim.flc + 1
    }
    
}
print('')
print('FINISHED')
