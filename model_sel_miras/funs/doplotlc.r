PI = 3.1415926536
prior.gamma.cov = diag(5, 3, 3)
prior.gamma.cov.inv = solve(prior.gamma.cov)
n.tpl = 1000

doplotlc = function(f.peak, dat, f.lc, theta.1, theta.2, f.out) {
    lc = read.table(f.lc)
    n.obs = nrow(lc)
    mean.mag = mean(lc[,2])
    phase = 2 * PI * f.peak * lc[,1]
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
    H.star = matrix(1, ncol = 3, nrow = n.tpl)
    phase.star = 2 * PI * f.peak * tpl.mjd
    H.star[, 2] = cos(phase.star)
    H.star[, 3] = sin(phase.star)
    Kc.star = matrix(NA, nrow = n.tpl, ncol = n.obs)
    for (ik1 in 1:n.tpl) {
        for (ik2 in 1:n.obs) {
            Kc.star[ik1, ik2] = theta.1.sqr * exp(-(tpl.mjd[ik1] - lc[ik2,1])^2 / (2*theta.2.sqr))
        }
    }
    tpl.mag = H.star %*% posterior.gamma + Kc.star %*% Kc.inv %*% (y - H %*% posterior.gamma)
    p.mag = posterior.gamma[2] * cos(phase.star) + posterior.gamma[3] * sin(phase.star)
    h.mag = tpl.mag - posterior.gamma[1] - p.mag
    png(f.out)
    par(mfrow=c(2,1))
    plot(dat[,1:2],pch=19,cex=0.2,main='',xlab='Frequency',ylab='Q')
    lines(dat[,1:2])
    abline(v = f.peak, col=2)
    plot(lc[,1:2], ylim = c(max(tpl.mag)+0.3, min(tpl.mag)-0.3), xlab='MJD', ylab='I (mag)',
         pch = 19, cex = 0.5)
    arrows(lc[,1],lc[,2]+lc[,3],lc[,1],lc[,2]-lc[,3],length=0,angle=90,code=3)
    lines(tpl.mjd, tpl.mag)
    dev.off()
}
