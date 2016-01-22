
fnl.bri.lim = 16
fnl.fnt.lim = 19.5
least.obs = 10

fields = c(0:9,letters[1:19])
## field = '0'
for (field in fields) {
################################################
    ## (1) Load fnl files and mat files
    matdir = paste0('~/Work/m33_miras/m33_ofiles/alf.files/m0',field,'/')
    f.mat = paste0(matdir,'mat.dat')
    fnldir = '~/Work/m33_miras/m33_ofiles/fnl.files/'
    f.fnl = paste0(fnldir,'m0',field,'i.fnl')
    chidir = '~/Work/m33_miras/simulate_constant/id.fnlmag.chi/'

    fnl = read.table(f.fnl,skip = 1)
    mat = read.table(f.mat)

    fnl.ids = fnl[,1]
    mat.ids = mat[,1]
    idx = match(mat.ids,fnl.ids)

    fnl = fnl[idx,]
    nfs = (ncol(mat)-3)/2

################################################
    ## (2) calculate unweighted mean magnitude and determine the offset between fnl magnitude
    ## least.obs = 10
    ## nrow = nrow(mat)
    ## for (i in 1:nrow) {
    ##     msg = paste0('    >> [field:',field,'] Calculate unweighted mean : ',round(i/nrow*100,1),' %     \r')
    ##     message(msg,appendLF=F)
    ##     s = 0
    ##     n = 0
    ##     for (j in 1:nfs) {
    ##         if (!is.na(mat[i,2*j])) {
    ##             ## s = s + mat[i,2*j]*(1/mat[i,2*j+1])^2
    ##             ## e = e + (1/mat[i,2*j+1])^2
    ##             s = s + mat[i,2*j] # this is for unweighted mean and worked worse
    ##             n = n + 1
    ##         }
    ##     }
    ##     mat[i,2*nfs+2] = s/n
    ## }
    ## print('')
    ## x = fnl[,4]
    ## y = mat[,2*nfs+2]
    ## idx = x > fnl.bri.lim & x < fnl.fnt.lim
    ## x = x[idx]
    ## y = y[idx]
    ## d = x - y
    ## for (j in 1:50) d = d[d < (mean(d)+3*sd(d)) & d > (mean(d)-3*sd(d))]
    ## f.eps = paste0(chidir,'fnl.mag.mean.mag.diff.m0',field,'.eps')
    ## golden.ratio = 1.61803398875
    ## fig.height = 5 # inches
    ## fig.width = fig.height * golden.ratio
    ## setEPS()
    ## postscript(f.eps,height = fig.height, width = fig.width)
    ## plot(x,x-y-mean(d),pch=19,cex=0.1,ylim=c(-1,1),xlab='.fnl mag',ylab='mean mag - .fnl mag - mean difference',main=paste0('m0',field))
    ## abline(h=0,col=4,lwd=0.3)
    ## dev.off()
    ## mag.off = round(mean(d),3)

################################################
    ## (3) Update mat files with mag.off, and replace the mean mag with fnl mag
    nmat = mat
    ## for (j in 1:nfs) nmat[,2*j] = nmat[,2*j] + mag.off
    nmat[,2*nfs+2] = fnl[,4]

################################################
    ## (4) Calculate Reduced Chi square using fnl mag as mean mag
    ## nrow = nrow(mat)
    ## for (i in 1:nrow) {
    ##     msg = paste0('    >> [field:',field,'] Calculate Reduced Chi Square : ',round(i/nrow*100,3),' %     \r')
    ##     message(msg,appendLF=F)
    ##     chi = 0
    ##     n = 0
    ##     for (j in 1:nfs) {
    ##         if (!is.na(nmat[i,2*j])) {
    ##             chi = chi + (nmat[i,2*j] - nmat[i,2*nfs+2])^2 / nmat[i,2*j+1]^2
    ##             n = n + 1
    ##         }
    ##     }
    ##     if (n >= least.obs) {
    ##         chi = chi / (n-1)
    ##         nmat[i,2*nfs+3] = chi
    ##     }
    ## }
    ## print('')
    ## x = mat[,91]
    ## y = nmat[,91]
    ## z = nmat[,90]
    ## plot(z,y,pch=19,cex=0.1)
    ## No improvement & even worse...

################################################
    ## (5) Write small tables: ID, fnl mag, and Chi from previous result
    idat = cbind(nmat[,1],nmat[,2*nfs+2],nmat[,2*nfs+3])
    f.idat = paste0(chidir,'id.mag.chi.m0',field,'.dat')
    write.table(idat,f.idat,row.names=F,col.names=F)
}
