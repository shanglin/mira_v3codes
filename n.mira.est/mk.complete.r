if (F) {
dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
f.1 = paste0(dir,'m33con_cat.dat')
f.2 = paste0(dir,'m33var_cat.dat')

d1 = read.table(f.1,header=T)
d2 = read.table(f.2,header=T)
d1[,1] = as.character(d1[,1])
d2[,1] = as.character(d2[,1])

dat = rbind(d1,d2)

imags = dat[,'imag']
imags = imags[imags!=-1,]
}

b.start = round(floor(min(imags))*10)/10
b.end = round(ceiling(max(imags))*10)/10
b.by = 0.1

breaks = seq(b.start,b.end,b.by)
h = hist(imags,breaks=breaks,col='skyblue')

n = length(h$breaks)
x = (h$breaks[1:(n-1)] + h$breaks[2:n])/2
y = log10(h$counts)

plot(x,y,pch=19,cex=0.5)
lines(x,y)
fit.s = 18.5
fit.e = 20
abline(v=c(fit.s,fit.e),col=4)

idx = x >= fit.s & x <= fit.e
x = x[idx]
y = y[idx]
n = length(x)

D = matrix(1,nrow=n,ncol=2)
D[,2] = x
y = matrix(y,nrow=n,ncol=1)
S = matrix(0,nrow=n,ncol=n)
for (i in 1:n) {
    S[i,i] = y[i]
}
iS = solve(S)
tD = t(D)
beta = solve(tD %*% iS %*% D) %*% (tD %*% iS %*% y)

x = seq(0,40,1)
y = beta[1] + beta[2]*x

lines(x,y,col=2)

x.model = seq(10,35,by=0.001)
y.model = beta[1] + beta[2]*x.model
ey.model = 10^(y.model)

n = length(breaks)
x.obs = (h$breaks[1:(n-1)] + h$breaks[2:n])/2
ey.obs = h$counts
spl = smooth.spline(x.obs,ey.obs)
sp.pred = predict(spl,x.model)
x.obs.cnt = sp.pred$x
y.obs.cnt = sp.pred$y

complete = rep(1,length(x.model))

## plot(x.obs.cnt,y.obs.cnt,type='l',xlim=c(15,25))
## lines(x.model,ey.model,col=2)

idx = x.model > fit.e
complete[idx] = y.obs.cnt[idx] / ey.model[idx]
complete[complete>1] = 1
complete[complete<0] = 0
complete = round(complete,5)
idx = x.model >= 12 & x.model <= 24
x.model = x.model[idx]
complete = complete[idx]
lines(x.model,complete, col=3)

dat = cbind(x.model,complete)
f.dat = '~/Work/m33_miras/n.mira.est/completeness.allcol.dat'
ts = '# I (mag)   completeness'
write(ts,f.dat)
write.table(dat,f.dat,col.names=F,row.names=F,append=T,sep='   ')
