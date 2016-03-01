set.seed(101)

type = 'm33dupvar'
dir = '~/Work/m33_miras/model_sel_miras/results/'
outdir = paste0(dir,'feature_',type,'/')
cmd = paste0('mkdir -p ',outdir)
system(cmd)
figdir = paste0(outdir,'figures/')
cmd = paste0('mkdir -p ',figdir)
system(cmd)
spcdir = '/Volumes/TOSHIBA/m33_v3/gp_2.7_spectra/m33dupvar_gp_result/'
dir.lc = '~/Work/m33_miras/m33_ofiles/rlcs/dup_variable/'
star.class = -1

fs.dat = list.files(spcdir)
nfs.dat = length(fs.dat)

f.out = paste0(outdir,type,'_features.dat')
ts = '# ID   star.class   F.true    F.peak   Q.peak   Q.base   dQ.p1.base   dQ.p1.p2  rQ.p1.p2    dQ.p1.pn   rQ.p1.pn   theta.1    theta.2    amplitude   curvature   n.peaks   L    l2.energy   l1.energy   sd.error'
write(ts, f.out)
## Some parameters
PI = 3.1415926536
prior.gamma.cov = diag(5, 3, 3)
prior.gamma.cov.inv = solve(prior.gamma.cov)
n.tpl = 1000

nskip = 3
boxsize = 10
hboxsize = round(boxsize/2)
localmaxima = function(values) {
    nele = length(values)
    maxima = c()
    if (nele < nskip*2.1) {
        maxima = c(maxima,-1)
        return(maxima)
    } else {
        maxima = c(maxima,-2)
        iele = nskip
        while (iele <= (nele-nskip-1)) {
            from = iele - hboxsize
            to = iele + hboxsize
            if (from < 0) from = 0
            if (to > nele -1) to = nele - 1
            boxcar = values[seq(from=from,to=to,by=1)]
            if (values[iele] == max(boxcar)) {
                maxima = c(maxima,iele)
                iele = iele + hboxsize - 1
            } else {
                iele = iele + 1
            }
        }
        return(maxima)
    }
}

do.extract = function(i) {
    f = fs.dat[i]
    t.freq = -1
    lf = paste0(spcdir,f)
    dat = read.table(lf)
    n.dat = nrow(dat)
    bad.idx = !is.finite(dat[,2])
    print(paste(i,nfs.dat,sum(bad.idx),f))
    
    if (sum(bad.idx) > 50) {
        next
    }
    if (sum(bad.idx) > 0) {
        x.Fs = dat[!bad.idx,1]
        y.Qs = dat[!bad.idx,2]
        xy.spl = smooth.spline(x.Fs, y.Qs)
        dat[bad.idx, 2] = predict(xy.spl,dat[bad.idx, 1])$y
    }
    
    maxima.index = localmaxima(dat[,2])
    if (maxima.index[1] == -2) {
        maxima.index = maxima.index[-c(1)]
        if (length(maxima.index) > 0) {
            max.dat = dat[maxima.index,]
            sort.idx = sort(max.dat[,2], index.return=T, decreasing=T)$ix
            max.dat = max.dat[sort.idx,]
        }
    }
    
    n.maxima = nrow(max.dat)
    if (n.maxima > 0) {
        if (sum(bad.idx) > 0) {
            if (maxima.index[1] %in% which(bad.idx)) {
                next
            }
        }
        if (!is.finite(max.dat[1,5]) || !is.finite(max.dat[1,6]) || !is.finite(max.dat[1,7]) || !is.finite(max.dat[1,8]) || max.dat[1,3] > 100) {
            next
        }
            
        F.true = t.freq
        F.peak = max.dat[1,1]
        Q.peak = max.dat[1,2]
        Q.base = as.numeric(quantile(dat[,2], 0.1))
        dQ.p1.base =  Q.peak - Q.base
        if (n.maxima > 1) {
            dQ.p1.p2 = Q.peak - max.dat[2,2]
            rQ.p1.p2 = dQ.p1.base / (max.dat[2,2] - Q.base)
            dQ.p1.pn = Q.peak - max.dat[n.maxima,2]
            rQ.p1.pn = dQ.p1.base / (max.dat[n.maxima,2] - Q.base)
        } else {
            dQ.p1.p2 = 0
            rQ.p1.p2 = 0
            dQ.p1.pn = 0
            rQ.p1.pn = 0
        }
        theta.1 = exp(max.dat[1,3])
        theta.2 = exp(max.dat[1,4])
        det.inv.Hessian = det(matrix(max.dat[1,5:8], 2, 2))
        if (det.inv.Hessian != 0 ) {
            curvature = 1. / det.inv.Hessian
        } else {
            curvature = 0
        }
        # load Stetson's L
        f.lc = gsub('.gp.dat','',f)
        L = 99.999
        # load light curve and find best fit parameters
        lf.lc = paste0(dir.lc, f.lc)
        lc = read.table(lf.lc)
        # design matrix, covariance, kernel covariance --> posterior of best-fit
        n.obs = nrow(lc)
        mean.mag = mean(lc[,2])
        phase = 2 * PI * F.peak * lc[,1]
        prior.gamma = matrix(0, nrow = 3, ncol = 1)
        prior.gamma[1,1] = mean.mag
        H = matrix(1, ncol = 3, nrow = n.obs)
        H[, 2] = cos(phase)
        H[, 3] = sin(phase)
        Kc = matrix(NA, n.obs, n.obs)
        theta.1.sqr = theta.1 * theta.1
        theta.2.sqr = theta.2 * theta.2
        for (ik1 in 1:n.obs) {
            for (ik2 in ik1:n.obs) {
                Kc[ik1, ik2] = theta.1.sqr * exp(-(lc[ik1,1] - lc[ik2,1])^2 / (2*theta.2.sqr))
                if (ik1 == ik2) {
                    Kc[ik1, ik2] = Kc[ik1, ik2] + lc[ik1, 3]^2
                } else {
                    Kc[ik2, ik1] = Kc[ik1, ik2]
                }
            }
        }
        y = matrix(lc[,2], nrow = n.obs, ncol = 1)
        Kc.inv = matrix(0, n.obs, n.obs)
        try(Kc.inv <- solve(Kc), silent = T)
        tmp.1 = t(H) %*% Kc.inv %*% H + prior.gamma.cov.inv
        tmp.1.inv = matrix(0, 3, 3)
        try(tmp.1.inv <- solve(tmp.1), silent = T)
        tmp.2 = prior.gamma.cov.inv %*% prior.gamma + t(H) %*% Kc.inv %*% y
        posterior.gamma = tmp.1.inv %*% tmp.2
        tpl.mjd = seq(min(lc[,1]), max(lc[,1]), length = n.tpl)
        tpl.mjd = c(lc[,1], tpl.mjd)
        n.new.tpl = n.obs + n.tpl
        H.star = matrix(1, ncol = 3, nrow = n.new.tpl)
        phase.star = 2 * PI * F.peak * tpl.mjd
        H.star[, 2] = cos(phase.star)
        H.star[, 3] = sin(phase.star)
        Kc.star = matrix(NA, nrow = n.new.tpl, ncol = n.obs)
        for (ik1 in 1:n.new.tpl) {
            for (ik2 in 1:n.obs) {
                Kc.star[ik1, ik2] = theta.1.sqr * exp(-(tpl.mjd[ik1] - lc[ik2,1])^2 / (2*theta.2.sqr))
            }
        }
        tpl.mag = H.star %*% posterior.gamma + Kc.star %*% Kc.inv %*% (y - H %*% posterior.gamma)

        p.mag = posterior.gamma[2] * cos(phase.star[1:n.obs]) + posterior.gamma[3] * sin(phase.star[1:n.obs])
        h.mag = tpl.mag[1:n.obs] - posterior.gamma[1] - p.mag
        l2.energy = sum(p.mag^2) / (sum(p.mag^2) + sum(h.mag^2))
        l1.energy = sum(abs(p.mag)) / (sum(abs(p.mag)) + sum(abs(h.mag)))

        amplitude = sqrt(posterior.gamma[2]^2 + posterior.gamma[3]^2)
        sd.error = sd(lc[,2] - tpl.mag[1:n.obs])

        if (sample(1:20,1) == 1) {
            setEPS()
            f.eps = paste0(figdir,f.lc,'.eps')
            postscript(f.eps,width=12,height=12)
            par(mfrow=c(2,1))
            plot(dat[,1:2],pch=19,cex=0.2,main=f,xlab='Frequency',ylab='Q')
            lines(dat[,1:2])
            abline(v = F.peak, col=2)
            abline(h = Q.base, col = 'grey')
            plot(lc[,1:2], ylim = c(max(tpl.mag)+0.3, min(tpl.mag)-0.3), xlab='MJD', ylab='I (mag)',
                 pch = 19, cex = 0.5)
            arrows(lc[,1],lc[,2]+lc[,3],lc[,1],lc[,2]-lc[,3],length=0,angle=90,code=3)
            lines(tpl.mjd[(n.obs+1):n.new.tpl], tpl.mag[(n.obs+1):n.new.tpl])
            ## points(lc[,1],p.mag+posterior.gamma[1],col=2,cex=0.2,pch=19)
            dev.off()
        }

        ts = paste(f.lc, star.class, round(F.true,6), round(F.peak,6), round(Q.peak,3), round(Q.base,3), round(dQ.p1.base,3),
            round(dQ.p1.p2,3), round(rQ.p1.p2,3), round(dQ.p1.pn,3),
            round(rQ.p1.pn,3), round(theta.1,5), round(theta.2,5), round(amplitude,3),
            round(curvature,3), n.maxima, L, round(l2.energy,3), round(l1.energy,3), round(sd.error,3), sep='  ')
        write(ts,f.out,append=T)
    }
}
        
for (i in 1:nfs.dat) {
    try(do.extract(i), silent = T)
}
