fields = c(0:9, letters[1:19])
fields = fields[1]

dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
figdir = paste0(dir,'figures_cali/')

f.mas = paste0(dir,'massey_phot.std')
f.cat = paste0(dir,'m33con_raw_cat.dat')

mas = read.table(f.mas, header = T)
mas = mas[mas[,'ni'] > 0,]
mas[,1] = as.character(mas[,1])

cat = read.table(f.cat, header = T)
ids = as.character(cat[,1])

dra = 0.00005
ddec = 0.00005

f.tmp = paste0(dir,'mch.tmp')
for (field in fields) {
    idx = substr(ids,1,1) == field
    if (sum(idx) > 0) {
        sub = cat[idx,]
        n = nrow(sub)
        tmp = cbind(sub[,1],sub[,4],sub[,5],rep(NA,n),rep(NA,n),rep(NA,n))
        for (i in 1:n) {
            idx = abs(sub[i,2] - mas[,2]) < dra & abs(sub[i,3] - mas[,3]) < ddec
            if (sum(idx) == 1) {
                tmp[i,4] = mas[idx,1]
                tmp[i,5] = mas[idx,7]
                tmp[i,6] = mas[idx,4]
            } else if (sum(idx) > 1) {
                idx = which.min((sub[i,2] - mas[,2])^2 + (sub[i,3] - mas[,3])^2)
                tmp[i,4] = mas[idx,1]
                tmp[i,5] = mas[idx,7]
                tmp[i,6] = mas[idx,4]
            }
        }
        write.table(tmp,f.tmp,col.names=F,row.names=F,quote=F,sep='   ')
        tmp = read.table(f.tmp)
        plot(tmp[,5],tmp[,5]-tmp[,2],pch = 19, cex = 0.5)
    }
}
        
