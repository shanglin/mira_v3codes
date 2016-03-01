f.dat = '~/Work/m33_miras/n.mira.est/completeness.allcol.dat'
f.csv = '~/Work/m33_miras/lmc_ofiles/all_star_table.csv'
csv = read.csv(f.csv,header=T)
mira = subset(csv,Type=='Mira')
srv = subset(csv,Type=='SRV')

dat = read.table(f.dat)
n.mira = 0
minmag = min(dat[,1])
maxmag = max(dat[,1])
magshift = 6.2
for (i in 1:nrow(mira)) {
    imag = mira[i,'I'] + magshift
    if (imag < minmag) {
        ts.n = 1
    } else if (imag > maxmag) {
        ts.n = 0
    } else {
        idx = which.min(abs(imag - dat[,1]))
        ts.n = dat[idx,2]
    }
    n.mira = n.mira + ts.n
}
print(paste('Number of observed Miras is ',n.mira))

n.srv = 0
for (i in 1:nrow(srv)) {
    imag = srv[i,'I'] + magshift
    if (imag < minmag) {
        ts.n = 1
    } else if (imag > maxmag) {
        ts.n = 0
    } else {
        idx = which.min(abs(imag - dat[,1]))
        ts.n = dat[idx,2]
    }
    n.srv = n.srv + ts.n
}
print(paste('Number of observed Srvs is ',n.srv))
    
f.con = '~/Work/m33_miras/n.mira.est/OGLE_I_phot.dat'
con = read.table(f.con)
n.con = 0
ncon = nrow(con)
imags = con[,3]+magshift
imags = imags[imags<maxmag]
sub1 = imags[imags < minmag]
n.con = n.con + length(sub1)
sub2 = imags[imags >= minmag]
sub2 = round(sub2,3)
idx = match(sub2, dat[,1])
vals = dat[idx,2]
n.con = n.con + sum(vals)

print(paste('Number of observed Cons is ',n.con))
   
