dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
f.cat = paste0(dir,'m33con_cat.dat')
cat1 = read.table(f.cat,header=T)
f.cat = paste0(dir,'m33var_cat.dat')
cat2 = read.table(f.cat,header=T)
cat = rbind(cat1,cat2)
cat[,1] = as.character(cat[,1])

#########################################
## topology of the overlaping fields
m00 = c('1','8','9')
m01 = c('0','2','8','9','a')
m02 = c('1','3','9','a','b')
m03 = c('2','4','a','b','c')
m04 = c('3','5','b','c','d')
m05 = c('4','6','c','d','e')
m06 = c('5','7','d','e','f')
m07 = c('6','e','f')
m08 = c('0','1','9')
m09 = c('0','1','2','8','a','g')
m0a = c('1','2','3','9','b','g','h')
m0b = c('2','3','4','a','c','g','h','i')
m0c = c('3','4','5','b','d','h','i','j')
m0d = c('4','5','6','c','e','i','j','k')
m0e = c('5','6','7','d','f','j','k','l')
m0f = c('6','7','e','k','l')
m0g = c('9','a','b','h')
m0h = c('a','b','c','g','i')
m0i = c('b','c','d','h','j','o')
m0j = c('c','d','e','i','k','o','p')
m0k = c('d','e','f','j','l','o','p','q')
m0l = c('e','f','k','m','p','q','r')
m0m = c('f','l','n','q','r','s')
m0n = c('m','r','s')
m0o = c('i','j','k','p')
m0p = c('j','k','l','o','q')
m0q = c('k','l','m','p','r')
m0r = c('l','m','n','q','s')
m0s = c('m','n','r')
#########################################

fields = c(0:9,letters[1:19])
ids = as.character(cat[,1])
all.fields = substr(ids,1,1)

foo = rep(NA,200000)
dup = cbind(foo,foo,foo,foo,foo)
colnames(dup) = c('ID','s1','s2','s3','s4')

dra = 0.00005
ddec = 0.00005
xcounter = 1
for (field in fields) {
    print(paste0('   Looking for duplicates in field ',field))
    cen = cat[all.fields == field,]
    lfield = paste0('m0',field)
    nei.fields = get(lfield)
    n.nei.fields = length(nei.fields)
    for (i.nei in 1:n.nei.fields) {
        if (i.nei == 1) {
            nei = cat[all.fields == nei.fields[i.nei],]
        } else {
            nei = rbind(nei, cat[all.fields == nei.fields[i.nei],])
        }
    }
    n.cen = nrow(cen)
    if (n.cen > 0) {
        for (i in 1:n.cen) {
            ra = cen[i,2]
            dec = cen[i,3]
            idx = abs(ra - nei[,2]) < dra & abs(dec - nei[,3]) < ddec
            if (sum(idx) > 0 & sum(idx) < 4) {
                dup.ids = nei[idx,1]
                dup.fields = substr(dup.ids,1,1)
                sum.appear = sum(dup[,] == cen[i,1], na.rm = T)
                for (i.dup in 1:length(dup.ids)) {
                    sum.appear = sum.appear + sum(dup[,] == dup.ids[i.dup], na.rm = T)
                }
                if (length(unique(dup.fields)) == length(dup.fields) & sum.appear == 0) {
                    xid = paste0('xdi',xcounter)
                    dup[xcounter,1] = xid
                    for (i.dup in 1:length(dup.ids)) {
                        dup[xcounter,2] = cen[i,1]
                        dup[xcounter,2+i.dup] = dup.ids[i.dup]
                    }
                    xcounter = xcounter + 1
                }
            }
            msg = paste0('  >> [',xcounter,']  ',round(100*i/n.cen,2),' %  \r')
            message(msg, appendLF = F)
        }
    }
}
print('')
print('')

dup = dup[!is.na(dup[,1]),]
f.dup = paste0(dir,'duplicates_map.map')
write.table(dup,f.dup,row.names=F,quote=F,sep='   ')

## xlim = c(23.63,23.635)
## ylim = c(30.95,30.96)
## plot(cen[,2:3],pch=19,cex=0.2,col=2,xlim=xlim,ylim=ylim)
## points(nei[,2:3],pch=19,cex=0.2,col=4)
## lines(c(23.633,23.633+dra),c(30.954,30.954+ddec))
