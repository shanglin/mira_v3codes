dir = '~/Work/m33_miras/m33_ofiles/'
rdir = paste0(dir,'rlcs/')
lcdir = paste0(rdir,'variable/')

f.cat = paste0(rdir,'m33var_cat.dat')
cat = read.table(f.cat,header=T)
ncat = nrow(cat)

ncat = 50

for (i in 1:ncat) {
    id = cat[i,1]
    m = cat[i,4]
    f = paste0(lcdir,id,'.rlc')
    lc = read.table(f)
    mm = mean(lc[,2])
    if (cat[i,6] == -1)
        print(m - mm)
}

