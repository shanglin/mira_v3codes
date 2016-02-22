set.seed(101)
dir = '~/Work/m33_miras/model_sel_miras/results/'
figdir = paste0(dir,'figures_model/')
f.dat = paste0(dir,'feature_matrix.dat')

if (!exists('dat')) {
    dat = read.table(f.dat)
    dat = dat[dat[,10] > 0.6,]
    dat = dat[is.finite(dat[,8]),]
    dat[,1] = as.character(dat[,1])
}

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

library(rpart)
fit = rpart(class ~ f.peak + Q + dQ.Q.base + dQ.Q.p2 + theta.2 + amplitude,
    method = 'class', data = trn.dat)
printcp(fit)
plotcp(fit)
summary(fit)
plot(fit,uniform=T)
text(fit, use.n=TRUE, all=TRUE, cex=.8, col=4)
pfit = prune(fit, cp=   fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
setEPS()
f.eps = paste0(figdir,'cart.res.eps')
postscript(f.eps,width=8,height=8)
plot(pfit, uniform=TRUE)
text(pfit, use.n=TRUE, all=TRUE, cex=.6,col=4)
dev.off()

