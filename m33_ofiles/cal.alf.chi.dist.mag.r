
## dir = '~/Work/m33_miras/tmp_m00alf/' # for test

fields = c(0:9,letters[1:19])
## fields = letters[6:19]
for (field in fields) {
    dir = paste0('~/Work/m33_miras/m33_ofiles/alf.files/m0',field,'/')
    
    plot = F
    bri.lim = 12
    faint.lim = 15
    least.obs = 10

    fs = list.files(dir,pattern='\\.alf$')
    nfs = length(fs)

    ## (1) generate a matrix that contains ID, m1, e1, m2, e2, ..., <m>, chi
    ncol = 1 + 2*nfs + 2
    nrow = 200000
    mat = as.data.frame(matrix(NA, ncol = ncol, nrow = nrow))

    f = fs[1]
    lf = paste0(dir,f)
    alf = read.table(lf, skip = 3)[,c(1,4,5)]
    nline = nrow(alf)
    mat[1:nline,1:3] = alf

    for (i in 2:nfs) {
        f = fs[i]
        msg = paste0('   >> [field:',field,'] Loading ',i,' out of ',nfs,' : ',f,'     \r')
        message(msg,appendLF=F)
        lf = paste0(dir,f)
        alf = read.table(lf, skip = 3)[,c(1,4,5)]
        idx = match(alf[,1],mat[,1])
        id.exist = alf[!is.na(idx),]
        id.new = alf[is.na(idx),]

        idx = match(id.exist[,1],mat[,1])
        mat[idx,c(2*i,2*i+1)] = id.exist[,2:3]

        nrow.new = nrow(id.new)
        if (nrow.new > 1) {
            pos.start = which(is.na(mat[,1]))[1]
            pos.end = pos.start + nrow.new - 1
            mat[pos.start:pos.end,c(1,2*i,2*i+1)] = id.new
        }
    }
    pos.end = which(is.na(mat[,1]))[1] - 1
    mat = mat[1:pos.end,]
    print('')

    ## (2) Calculate the magnitude offset between frames and shift to the level of first frame
    msg = '    >> Calculating the offset between frames'
    print(msg)
    for (i in 2:(nfs-1)) {
        x = mat[,2]
        y = mat[,2*i]
        d = y - x
        d = d[x>bri.lim & x<faint.lim]
        d = d[!is.na(d)]
        for (j in 1:5) d = d[d < (mean(d)+3*sd(d)) & d > (mean(d)-3*sd(d))]
        mat[,2*i] = mat[,2*i] - mean(d)
        if (plot) {
            ny = y - mean(d)
            par(mfrow=c(1,2))
            plot(x,y,pch=19,cex=0.1)
            lines(1:100,1:100,col=2)
            plot(x,ny,pch=19,cex=0.1)
            lines(1:100,1:100,col=2)
            Sys.sleep(3)
        }
    }

    ## (3) Calculate the reduced Chi square
    nrow = nrow(mat)
    for (i in 1:nrow) {
        msg = paste0('    >> [field:',field,'] Calculate Reduced Chi Square : ',round(i/nrow*100,3),' %     \r')
        message(msg,appendLF=F)
        s = 0
        n = 0
        e = 0
        for (j in 1:nfs) {
            if (!is.na(mat[i,2*j])) {
                s = s + mat[i,2*j]*(1/mat[i,2*j+1])^2
                e = e + (1/mat[i,2*j+1])^2
                ## s = s + mat[i,2*j] # this is for unweighted mean and worked worse
                n = n + 1
            }
        }
        if (n >= least.obs) {
            mat[i,2*nfs+2] = s/e
            ## mat[i,2*nfs+2] = s/n # this is for unweighted mean and worked worse
            chi = 0
            for (j in 1:nfs) {
                if (!is.na(mat[i,2*j])) {
                    chi = chi + (mat[i,2*j] - mat[i,2*nfs+2])^2 / mat[i,2*j+1]^2
                }
            }
            chi = chi / (n-1)
            mat[i,2*nfs+3] = chi
        }
    }
    print('')           

    ## (4) Record the results: A matrix of all the useful data, with last two columns as mean mag and reduced Chi square
    f.mat = paste0(dir,'mat.dat')
    mat = round(mat,3)
    write.table(mat,f.mat,row.names=F,col.names=F)
    msg = paste0('    >> Results write to ',f.mat)
    print(msg)

    ## (5) Calculate the mean and dispersion of chi square in mag bins
    mat = mat[!is.na(mat[,ncol(mat)]),]
    f.eps = paste0(dir,'chi_dist_table_scatter.eps')
    golden.ratio = 1.61803398875
    fig.height = 5 # inches
    fig.width = fig.height * golden.ratio
    setEPS()
    postscript(f.eps,height = fig.height, width = fig.width)
    par(mfrow=c(1,1),mar=c(1,1,1,1)*5)
    xlab = expression(Instrumental~italic(I)~(mag))
    ylab=expression(chi[nu]^2)
    plot(mat[,ncol(mat)-1],mat[,ncol(mat)],pch=19,cex=0.1,xlab=xlab,ylab=ylab,ylim=c(0,sd(mat[,ncol(mat)])*2))
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
    plot(mat[,ncol(mat)-1],mat[,ncol(mat)],pch=19,cex=0.1,xlab=xlab,ylab=ylab,ylim=c(0,sd(mat[,ncol(mat)])*2),col='grey',xlim=c(min(x),max(x)))
    points(x,y,pch=19,col=4)
    arrows(x,y-ye,x,y+ye,length=0.05,angle=90,code=3,col=4)
    dev.off()

    smat = mat[,c(ncol(mat)-1, ncol(mat)-2)]
    f.smat = paste0(dir,'smat.dat')
    write.table(smat,f.smat,col.names=F,row.names=F)
}
