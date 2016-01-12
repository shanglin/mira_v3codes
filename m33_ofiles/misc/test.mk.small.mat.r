dir = '~/Work/m33_miras/tmp_m00alf/' # for test
f.mat = paste0(dir,'mat.dat')
mat = read.table(f.mat)
smat = mat[,c(ncol(mat)-1, ncol(mat)-2)]
smat = smat[!is.na(smat[,1]),]
f.smat = paste0(dir,'smat.dat')
write.table(smat,f.smat,col.names=F,row.names=F)
