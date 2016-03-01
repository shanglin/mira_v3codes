m33con = 395016
m33var = 77254
m33ratio = m33var/(m33var+m33con)
print(paste(' Con ratio = ',round(m33ratio,5)))

f = '~/Work/m33_miras/n.mira.est/mira.jkl.dat'
jkl = read.table(f)
jkl = jkl[!is.na(jkl[,4]),]
mira.ratio = sum(jkl[,4]>0.6)/nrow(jkl)
print(paste(' Mira ratio = ',round(mira.ratio,5)))


f = '~/Work/m33_miras/n.mira.est/srv.jkl.dat'
jkl = read.table(f)
jkl = jkl[!is.na(jkl[,4]),]
srv.ratio = sum(jkl[,4]>0.6)/nrow(jkl)
print(paste(' SRV ratio = ',round(srv.ratio,5)))
