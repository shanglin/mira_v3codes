set.seed(101)
dir = '~/Work/m33_miras/model_sel_miras/results/'
figdir = paste0(dir,'figures_model/')
f.dat = paste0(dir,'feature_matrix.dat')

if (!exists('dat')) {
    dat = read.table(f.dat)
    dat = dat[dat[,10] > 0.6,]
    dat = dat[is.finite(dat[,8]),]
    dat[,1] = as.character(dat[,1])
    colnames(dat) = c('ID','f.true','f.peak','class','Q','dQ.Q.base','dQ.Q.p2','theta.2','amplitude','L')
    sim.dat = dat[dat[,4]!=-1,]
    n.sim = nrow(sim.dat)
    m33.dat = dat[dat[,4]==-1,]
    idx = sample(1:n.sim,replace=F)
    sim.dat = sim.dat[idx,]

    sim.dat[,4] = 0
    idx = substr(sim.dat[,1],1,4) == 'mira'
    sim.dat[idx,4] = 1

    n.test = round(0.2 * n.sim)
    n.trn = n.sim - n.test

    idx = 1:n.test
    test.dat = sim.dat[idx,]
    trn.dat = sim.dat[-idx,]
}


library(randomForest)
a = trn.dat
a[,'class'] = as.factor(a[,'class'])
b = test.dat
rf = randomForest(class ~ f.peak + Q + dQ.Q.base + dQ.Q.p2 + theta.2 + amplitude,
    data = a, do.trace=T, ntree = 500)

f.eps = paste0(figdir,'rf.error.vs.ntrees.eps')
setEPS()
postscript(f.eps)
plot(rf)
text(400,0.055,'OOB')
text(400,0.045,'Mira purity',col=3)
text(400,0.07,'Non-Mira purity',col=2)
dev.off()

pred = predict(rf, b)
tab = table(observed = b[,4], predicted = pred)
m33.pred = predict(rf, m33.dat, type = 'prob')
threshold = 0.9
n.m33.miras = sum(m33.pred[,2] > threshold)
m33.miras = m33.dat[m33.pred[,2] > threshold,]


source('funs/doplotlc.r')
rdir = '~/Work/m33_miras/m33_ofiles/rlcs/variable/'
spcdir = '/Volumes/TOSHIBA/m33_v3/gp_2.7_spectra/m33var_gp_result/'
for (i in seq(1,n.m33.miras, by = 33)) {
    f.peak = m33.miras[i,3]
    id = m33.miras[i,1]
    f.rlc = paste0(rdir,id)
    f.spc = paste0(spcdir,id,'.gp.dat')
    spc = read.table(f.spc)
    idx = which.min(abs(f.peak - spc[,1]))
    theta.1 = exp(spc[idx,3])
    theta.2 = exp(spc[idx,4])
    f.out = paste0(figdir,'tmp/',id,'.png')
    ret = doplotlc(f.peak, spc, f.rlc, theta.1, theta.2, f.out)
}

    
