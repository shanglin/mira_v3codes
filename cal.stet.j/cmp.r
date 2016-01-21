f.cat = '/Users/wenlong/Work/m33_miras/m33_ofiles/t_mband_wo/catalog_t_mband.dat'
cat = read.table(f.cat)
catjs = cat[,14]

f.res = 'res.dat'
res = read.table(f.res)
resjs = res[,2]
resjs = resjs[1:length(catjs)]

xlim = c(-1,5)
ylim = xlim
xlab = 'J index from M33 catalog'
ylab = 'J index computed based on light curves'


plot(catjs,resjs,col=rgb(0,0,0,0.1),cex=0.1,xlim=c(-1,5),ylim=c(-1,5),xlab=xlab,ylab=ylab)
lines(xlim,ylim,col=4)

draw.arrow = function (x,col) {
    w = 0.07
    ys = c(-1.24,0.5)
    lines(c(x,x),ys,col=col)
    lines(c(x,x-w),c(ys[1],-1.1),col=col)
    lines(c(x,x+w),c(ys[1],-1.1),col=col)
}

draw.arrow(0.6,3)
text(1.,-1,'0.75',col=2)
draw.arrow(0.75,2)
text(0.45,-1,'0.6',col=3)

text(4,3.5,'y = x',col=4)
