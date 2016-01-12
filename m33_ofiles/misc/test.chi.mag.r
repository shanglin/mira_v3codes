dir = '~/Work/m33_miras/tmp_m00alf/'
f.mat = '~/Work/m33_miras/tmp_m00alf/mat.dat'
if (!exists('mat')) {
    mat = read.table(f.mat)
    mat = mat[!is.na(mat[,ncol(mat)]),]
}
f.eps = paste0(dir,'chi_dist_table_scatter.eps')
golden.ratio = 1.61803398875
fig.height = 5 # inches
fig.width = fig.height * golden.ratio
setEPS()
postscript(f.eps,height = fig.height, width = fig.width)
par(mfrow=c(1,1),mar=c(1,1,1,1)*5)
xlab = expression(Instrumental~italic(I)~(mag))
ylab=expression(chi[nu]^2)
plot(mat[,90:91],pch=19,cex=0.1,xlab=xlab,ylab=ylab,ylim=c(0,sd(mat[,91])*2))
dev.off()


bin.size = 0.2
n.each.bin = 10

mag.bin = seq(1,40,0.1)
n.bin = length(mag.bin)-1

tbl = matrix(NA,ncol=5,nrow=n.bin)
for (i in 1:n.bin) {
    tbl[i,1] = mag.bin[i]
    tbl[i,2] = mag.bin[i+1]
    idx = mat[,ncol(mat)-1] > tbl[i,1] & mat[,ncol(mat)-1] <= tbl[i,2]
    tbl[i,3] = sum(idx)
    if (tbl[i,3] >= n.each.bin) {
        d = mat[idx,ncol(mat)]
        for (j in 1:5) d = d[d < (mean(d)+3*sd(d)) & d > (mean(d)-3*sd(d))]
        tbl[i,4] = mean(d)
        tbl[i,5] = sd(d)
    }
}

start.pos = which(!is.na(tbl[,4]))[1]
end.pos = tail(which(!is.na(tbl[,4])),1)
tbl = tbl[start.pos:end.pos,]
x = (tbl[,1]+tbl[,2])/2
y = tbl[,4]
ye = tbl[,5]

f.eps = paste0(dir,'chi_dist_table.eps')
golden.ratio = 1.61803398875
fig.height = 5 # inches
fig.width = fig.height * golden.ratio

setEPS()
postscript(f.eps,height = fig.height, width = fig.width)
par(mfrow=c(1,1),mar=c(1,1,1,1)*5)
xlab = expression(Instrumental~italic(I)~(mag))
plot(x,y,pch=19,xlab=xlab,ylab=expression(chi[nu]^2))
arrows(x,y-ye,x,y+ye,length=0.05,angle=90,code=3)
dev.off()

f.tbl = paste0(dir,'chi_dist_table.dat')
write.table(round(tbl,3),f.tbl,col.names=F,row.names=F)

f.eps = paste0(dir,'chi_dist_table_combined.eps')
golden.ratio = 1.61803398875
fig.height = 5 # inches
fig.width = fig.height * golden.ratio
setEPS()
postscript(f.eps,height = fig.height, width = fig.width)
par(mfrow=c(1,1),mar=c(1,1,1,1)*5)
xlab = expression(Instrumental~italic(I)~(mag))
ylab=expression(chi[nu]^2)
plot(mat[,90:91],pch=19,cex=0.1,xlab=xlab,ylab=ylab,ylim=c(0,sd(mat[,91])*2),col='grey',xlim=c(min(x),max(x)))
points(x,y,pch=19,col=4)
arrows(x,y-ye,x,y+ye,length=0.05,angle=90,code=3,col=4)
dev.off()
