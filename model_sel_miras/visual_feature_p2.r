

dir = '~/Work/m33_miras/model_sel_miras/results/'
figdir = paste0(dir,'figures_p2/')

f.mat = paste0(dir,'feature_matrix.dat')
if (F) {
    ## build the feature matrix in a single file
    types = c('mira', 'const', 'srv', 'm33var')
    fields = c(0:9,letters[1:19])
    ts = '#  ID   f.true  f.peak  class  Q   dQ.Q.base   dQ.Q.p2   theta.2   amplitude  L'
    write(ts, f.mat)
    for (type in types) {
        for (field in fields) {
            print(paste(type,field))
            f.dat = paste0(dir,'feature_',type,'/',type,'_m0',field,'_features.dat')
            if (file.exists(f.dat)) {
                dat = read.table(f.dat)
                dat[,1] = as.character(dat[,1])
                class = rep(0, nrow(dat))
                idx = abs(dat[,4] - dat[,3]) < 0.00027
                class[idx] = 1
                if (type == 'm33var') {
                    class[] = -1
                }
                ndat = cbind(dat[,1],dat[,3],dat[,4],class,dat[,5],dat[,7],dat[,8],dat[,13],dat[,14],dat[,17])
                write.table(ndat, f.mat, append=T, col.names=F, row.names=F, quote=F, sep = '   ')
            }
        }
    }
}

if (T) {
mat = read.table(f.mat)
mat = mat[mat[,10] > 0.6,]
pos = mat[mat[,4] == 1,]
neg = mat[mat[,4] == 0,]
unk = mat[mat[,4] == -1,]
}

if (F) {
## (1) plot Q vs log(P)
width = 800
height = 400
ylab = 'Q'
ylim = c(-150,90)
xlab = 'log (P)'
xlim = c(1.7,3.3)
f.png = paste0(figdir,'Q_logP.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(log10(1./pos[,3]), pos[,5], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(log10(1./neg[,3]),neg[,5], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(log10(1./unk[,3]), unk[,5], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()


## (2) plot dQ.Q.base vs log(P)
col = 6
width = 800
height = 400
ylab = 'Q - Q.base'
ylim = c(0,20)
xlab = 'log (P)'
xlim = c(1.7,3.3)
f.png = paste0(figdir,'dQ.Q.base_logP.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(log10(1./pos[,3]), pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(log10(1./neg[,3]),neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(log10(1./unk[,3]), unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()


## (3) plot dQ secondary
col = 7
width = 800
height = 400
ylab = 'Q - Q.p2'
ylim = c(0,20)
xlab = 'log (P)'
xlim = c(1.7,3.3)
f.png = paste0(figdir,'dQ.Q.p2_logP.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(log10(1./pos[,3]), pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(log10(1./neg[,3]),neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(log10(1./unk[,3]), unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()


## (4) theta 2
col = 8
width = 800
height = 400
ylab = 'theta.2'
ylim = c(0,200)
xlab = 'log (P)'
xlim = c(1.7,3.3)
f.png = paste0(figdir,'theta.2_logP.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(log10(1./pos[,3]), pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(log10(1./neg[,3]),neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(log10(1./unk[,3]), unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()


## (5) amplitude
col = 9
width = 800
height = 400
ylab = 'Amplitude'
ylim = c(0,3)
xlab = 'log (P)'
xlim = c(1.7,3.3)
f.png = paste0(figdir,'amplitude_logP.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(log10(1./pos[,3]), pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(log10(1./neg[,3]),neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(log10(1./unk[,3]), unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()


## (6) amplitude vs Q - Q.base
col = 9
width = 800
height = 400
ylab = 'Amplitude'
ylim = c(0,3)
xlab = 'Q - Q.base'
xlim = c(0,20)
f.png = paste0(figdir,'amplitude_dQ.Q.base.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(pos[,6], pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(neg[,6],neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))
plot(unk[,6], unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
dev.off()
}

## (7) amplitude vs theta 2
col = 9
width = 800
height = 400
ylab = 'Amplitude'
ylim = c(0,3)
xlab = 'theta.2'
xlim = c(0,200)
f.png = paste0(figdir,'amplitude_theta.2.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(pos[,8], pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(neg[,8],neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))

high.cut = 1.5
low.cut = 0.3
left.cut = 4

lines(c(300,left.cut,left.cut,300),c(high.cut,high.cut,low.cut,low.cut),col=4)
idx = pos[,8] > left.cut & pos[,9] > low.cut & pos[,9] < high.cut
ngod = sum(idx)
text(150,1.3,paste0(ngod,' out of ',nrow(pos),' red points'), col=4)
idx = neg[,8] > left.cut & neg[,9] > low.cut & neg[,9] < high.cut
nbad = sum(idx)
text(145,1.1,paste0(nbad,' out of ',nrow(neg),' black points'), col=4)

plot(unk[,8], unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
lines(c(300,left.cut,left.cut,300),c(high.cut,high.cut,low.cut,low.cut),col=4)

dev.off()

## (8) amplitude vs theta 2, v2
col = 9
width = 800
height = 400
ylab = 'Amplitude'
ylim = c(0,3)
xlab = 'theta.2'
xlim = c(0,200)
f.png = paste0(figdir,'amplitude_theta.2_v2.png')
png(f.png, width = width, height = height)
par(mfrow=c(1,2))
plot(pos[,8], pos[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
points(neg[,8],neg[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01))

high.cut = 1.5
low.cut = 0.3
left.cut = 4
right.cut = 70
mid.cut = 0.8

lines(c(300,right.cut,right.cut,left.cut,left.cut,300),c(mid.cut,mid.cut,high.cut,high.cut,low.cut,low.cut),col=4)
idx.1 = pos[,8] > left.cut & pos[,9] > low.cut & pos[,9] < high.cut
idx.2 = pos[,8] > right.cut & pos[,9] > mid.cut
idx.2 = !idx.2
idx = idx.1 & idx.2
ngod = sum(idx)
text(150,1.3,paste0(ngod,' out of ',nrow(pos),' red points'), col=4)
idx.1 = neg[,8] > left.cut & neg[,9] > low.cut & neg[,9] < high.cut
idx.2 = neg[,8] > right.cut & neg[,9] > mid.cut
idx.2 = !idx.2
idx = idx.1 & idx.2
nbad = sum(idx)
text(145,1.1,paste0(nbad,' out of ',nrow(neg),' black points'), col=4)

plot(unk[,8], unk[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.01),
     xlab = xlab, ylab = ylab,xlim=xlim,ylim=ylim)
lines(c(300,right.cut,right.cut,left.cut,left.cut,300),c(mid.cut,mid.cut,high.cut,high.cut,low.cut,low.cut),col=4)
idx.1 = unk[,8] > left.cut & unk[,9] > low.cut & unk[,9] < high.cut
idx.2 = unk[,8] > right.cut & unk[,9] > mid.cut
idx.2 = !idx.2
idx = idx.1 & idx.2
nbad = sum(idx)
text(145,1.1,paste0(nbad,' out of ',nrow(unk),' black points'), col=4)
dev.off()


