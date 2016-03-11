f.csv = '~/Work/m33_miras/lmc_ofiles/all_star_table.csv'
csv = read.csv(f.csv,header=T)
mira = subset(csv,Type=='Mira')
srv = subset(csv,Type=='SRV')

## col>2
idx.1.mira = (mira[,'V']-mira[,'I'])>2 & (mira[,'V']-mira[,'I'])<=2.5 & mira[,'I']>12
n.1.mira = sum( idx.1.mira )
print(n.1.mira)

idx.1.srv = (srv[,'V']-srv[,'I'])>2 & (srv[,'V']-srv[,'I'])<=2.5 & srv[,'I']>12
n.1.srv = sum( idx.1.srv )
print(n.1.srv)

## col>2.5
idx.2.mira = (mira[,'V']-mira[,'I'])>2.5 & (mira[,'V']-mira[,'I'])<=3 & mira[,'I']>12
n.2.mira = sum( idx.2.mira )
print(n.2.mira)

idx.2.srv = (srv[,'V']-srv[,'I'])>2.5 & (srv[,'V']-srv[,'I'])<=3 & srv[,'I']>12
n.2.srv = sum( idx.2.srv )
print(n.2.srv)


## col>3
idx.3.mira = (mira[,'V']-mira[,'I'])>3 | abs(mira[,'V'])>50 & mira[,'I']>12
n.3.mira = sum( idx.3.mira )
print(n.3.mira)

idx.3.srv = (srv[,'V']-srv[,'I'])>3 | abs(srv[,'V'])>50 & srv[,'I']>12
n.3.srv = sum( idx.3.srv )
print(n.3.srv)


### convolve

## c1
sub = mira[idx.1.mira,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33mbandall1_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed mira c1 is ',n.sub))


sub = srv[idx.1.srv,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33mbandall1_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed srv c1 is ',n.sub))


## c2
sub = mira[idx.2.mira,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33mbandall2_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed mira c2 is ',n.sub))


sub = srv[idx.2.srv,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33mbandall2_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed srv c2 is ',n.sub))


## c3
sub = mira[idx.3.mira,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33ionlyall_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed mira c3 is ',n.sub))


sub = srv[idx.3.srv,]
dir = '~/Work/m33_miras/n.mira.est/'
f.fit = paste0(dir,'m33ionlyall_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,'I'] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed srv c3 is ',n.sub))

###############################################
f.dat = paste0(dir,'OGLE_VI.dat')
dat = read.table(f.dat)
idx = dat[,3] < 3 | dat[,4] > 90
sub = dat[idx,]

d2 = sub

sub = d2[d2[,3]<2.5,]
f.fit = paste0(dir,'m33mbandall1_em.fit')
fit = read.table(f.fit)
mags = fit[,1]
coms = fit[,4] - 1
n.sub = 0
magshift = 6.2
for (i in 1:nrow(sub)) {
    imag = sub[i,4] + magshift
    idx = which.min(abs(imag - mags))
    ts.n = coms[idx]
    n.sub = n.sub + ts.n
}
print(paste('Number of observed mira c1 is ',n.sub))
