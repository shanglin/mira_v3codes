
mag.shift = 6.2

## generate 3 tables for 3 color groups
f.lmc = '~/Work/m33_miras/lmc_ofiles/all_star_table.csv'
lmc = read.table(f.lmc, header=TRUE, sep=',')
lmc = subset(lmc, Type == 'SRV')
lmc1 = subset(lmc,V-I > 2.0 & V-I <= 2.5)
lmc2 = subset(lmc,V-I > 2.5 & V-I < 3.0)
lmci = subset(lmc,V-I >= 3.0 | V < (-90))


dir = '~/Work/m33_miras/simulate_srv/'
f.fit1 = paste0(dir,'m33mbandall1_em.fit')
f.fit2 = paste0(dir,'m33mbandall2_em.fit')
f.fiti = paste0(dir,'m33ionlyall_em.fit')
fit1 = read.table(f.fit1, header = F)
fit2 = read.table(f.fit2, header = F)
fiti = read.table(f.fiti, header = F)
fit1[,4] = round(fit1[,4] - 1, 5)
fit2[,4] = round(fit2[,4] - 1, 5)
fiti[,4] = round(fiti[,4] - 1, 5)

## output file header 
header = '"ID","Field","StarID","RA","Decl","Type","Evol","Spectr","I","V","P_1","A_1","P_2","A_2","P_3","A_3","ID_OGLE_II","ID_MACHO","ID_GCVS","ID_OTHER","Remarks","Prop"'

mk.table = function (fit,sub,f.out) {
    write(header,f.out)
    freqs = rep(NA,nrow(sub))
    for (j in 1:nrow(sub)) {
        mag = round(sub[j,'I'] + mag.shift, 2)
        idx = which.min(abs(mag - fit[,1]))
        freq = fit[idx,4]
        freqs[j] = freq
    }
    tbl = cbind(sub,freqs)
    write.table(tbl,f.out,col.names=F, row.names=F, append=T, sep=',')
}

f.out = paste0(dir,'tableA/conv_lmc_srv_s1.csv')
mk.table(fit1,lmc1,f.out)

f.out = paste0(dir,'tableA/conv_lmc_srv_s2.csv')
mk.table(fit2,lmc2,f.out)

f.out = paste0(dir,'tableA/conv_lmc_srv_si.csv')
mk.table(fiti,lmci,f.out)
