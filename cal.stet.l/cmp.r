
field = 'b'
type = 'c'
f.jkl = paste0('~/Work/m33_miras/m33_trialp/testJKL/m0',field,'_',type,'.jkl')
jkl = read.table(f.jkl,skip = 1)
jkl[,1] = as.character(jkl[,1])

ids = gsub(paste0(field,type,'i'),'',jkl[,1])
ids = gsub('.lc','',ids)

if (type == 'c') {
    f.vry = paste0('~/Work/m33_miras/m33_trialp/fnlfiles/m0',field,'i.fnl')
    vry = read.table(f.vry, skip = 1)
}

if (type == 'v') {
    f.vry = paste0('~/Work/m33_miras/m33_trialp/fnlfiles/m0',field,'i.vry')
    vry = read.table(f.vry)
}

mch = match(ids,vry[,1])
vry = vry[mch,]

dj = jkl[,2] - vry[,9]
dk = jkl[,3] - vry[,10]
dl = jkl[,4] - vry[,11]

mag = vry[,4]

f.png = paste0('~/Work/m33_miras/m33_trialp/testJKL/m0',field,'_',type,'.png')
golden.ratio = 1.61803398875
fig.height = 600 # inches
fig.width = fig.height * golden.ratio
## setEPS()
## postscript(f.eps,height = fig.height, width = fig.width)
png(f.png,height = fig.height, width = fig.width)
plot(mag,dj,pch=19,cex=0.3,xlim=c(17,23),ylim=c(-1,5),col=rgb(1,0,0,0.1),ylab = 'Delta J, Delta K + 2, Delta L + 4', xlab = 'I (mag)')
points(mag,dk + 2,pch=19,cex=0.3,col=rgb(0,1,0,0.1))
points(mag,dl + 4,pch=19,cex=0.3,col=rgb(0,0,1,0.1))
abline(h = 0, lty=3)
abline(h = 2, lty=3)
abline(h = 4, lty=3)

dev.off()
