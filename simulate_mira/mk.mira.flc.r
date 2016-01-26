rm(list=ls())
set.seed(101)

dir = '~/Work/m33_miras/'
sim = 'simulate_mira/'
miradir = paste0(dir,'lmc_ofiles/mira.lcs/')
outdir = paste0(dir,'simulate_mira/v3_mira_flcs/')
figure.dir = paste0(dir,'simulate_mira/figures/')
f.elk = paste0(dir,'simulate_constant/m33i_it5_lkt_flg_cal.dat')
## f.ast = paste0(dir,'lmc_ofiles/all_star_table.csv')
f.para = paste0(dir,'lmc_ofiles/allLMC.txt')
f.basicfun = '~/Work/bin/m33_lib/VarStar_r/rcodev2/BasicFuns.R'
lcdir = miradir
flcdir = outdir
ctlcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/constant/'
vtlcdir = '~/Work/m33_miras/m33_trialp/tlc_labels/variable/'

least.obs = 10
least.night = 7
mag.shift = 6.2

golden.ratio = 1.61803398875
fig.height = 10 # inches
fig.width = fig.height * golden.ratio

library(VarStar)
source(f.basicfun)
## starTable = read.table(f.ast, header=TRUE, sep=',')
## starTable = subset(starTable, Type=='Mira')
elk = read.table(f.elk,header=T)
elk = elk[elk[,'flag'] == 0,]
sig = elk
nsig = nrow(sig)
paraAll = read.table(f.para, header=FALSE)
paraIDs = paraAll[,1]
thetasAll = as.matrix(paraAll[,3:9])
thetasAll = abs(thetasAll)
thetasAll[,4] = 100000
## nfiles = nrow(starTable)

f.tbA1 = paste0(dir,sim,'tableA/conv_lmc_mira_s1.csv')
f.tbA2 = paste0(dir,sim,'tableA/conv_lmc_mira_s2.csv')
f.tbAi = paste0(dir,sim,'tableA/conv_lmc_mira_si.csv')
tblA1 = read.table(f.tbA1,header=T,sep=',')
tblA2 = read.table(f.tbA2,header=T,sep=',')
tblAi = read.table(f.tbAi,header=T,sep=',')
tblA = rbind(tblA1,tblA2,tblAi)
tblA[,1] = as.character(tblA[,1])


f.log = paste0(dir,sim,'mira.generate.log')
write('#',f.log)

LMCids = as.character(tblA[,'ID'])
LMCIDs = gsub('OGLE-LMC-LPV-','',LMCids)
LMCprob = tblA[,'Prob']
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

    idx.dat = sample(1:nfs.dat, 1, prob = LMCprob)
    f.dat = paste0(LMCids[idx.dat],'.dat')
    lf.dat = paste0(miradir, f.dat)
    LMCID = LMCIDs[idx.dat]
    LMCid = LMCids[idx.dat]

    msg = paste0('    >> ',round(i.sim.flc * 100 / n.sim.flc, 3),' %      \r')
    message(msg, appendLF = F)

    dat = read.table(lf.dat)
    
    tlc = read.table(lf.tlc)
    tlc = tlc[tlc[,4] == 1,]
    nobs = nrow(tlc)
    nights = round(tlc[,1])
    n.night = length(unique(nights))

    lmc.range = max(dat[,1]) - min(dat[,1])
    m33.range = max(tlc[,1]) - min(tlc[,1])

    if (nobs >= least.obs & n.night >= least.night & lmc.range > m33.range) {
        ## M33
        field = substr(M33ID,1,1)

        ## LMC
        period = tblA[tblA[, 'ID'] == LMCid, 'P_1']
        meanMag = mean(dat[,2])

        ## GP
        x = new(gpModel, dat$V1, dat$V2, dat$V3, meanMag)
        x$set_period(period, 0)
        ThetaIdx = paraIDs == LMCid
        x$gp_setTheta(thetasAll[ThetaIdx,])

        ## Predict at give MJDs
        sData = x$get_fake(tlc$V1, 0)
        jd.shift = sData$shift
        flc = sData$fLcurve
        flc[,2] = flc[,2] + mag.shift

        ## Add noise based on M33 observations
        for (i in 1:nobs) {
            night = nights[i]
            mag = flc[i,2]
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

        ## Write to file
        flc = flc[order(flc[,1]),]
        f.flc = paste0(outdir, 'mira_',LMCID,'_',M33ID,'_',round(jd.shift,2),'.flc')
        write.table(flc, f.flc, row.names = F, col.names = F, sep = '  ')
        i.sim.flc = i.sim.flc + 1

        ## plot figures
        if ((i.sim.flc %% 1000) == 1) {
        ## if (T) {
            f.eps = paste0(figure.dir, 'mira_',LMCID,'_',M33ID,'_',round(jd.shift,2),'.eps')
            setEPS()
            postscript(f.eps,height = fig.height, width = fig.width)    
            x = dat[,1]
            y = dat[,2] + mag.shift
            e = dat[,3]
            plot(x,y,ylim=c(max(y) + 0.5, min(y) - 0.5), pch = 19, cex = 0.5, xlab = 'MJD', ylab = 'I (mag)')
            ## arrows(x, y + e, x, y - e, code = 3, angle = 90, length = 0.01)
            x = flc[,1] - min(flc[,1]) + min(dat[,1]) + jd.shift
            y = flc[,2]
            e = flc[,3]
            points(x,y,pch = 19, cex = 0.5, col = 4)
            arrows(x, y + e, x, y - e, code = 3, angle = 90, length = 0.02, col = 4)
            dev.off()
        }
        ## Sys.sleep(5)
    }
}
print('')
print('FINISHED')
