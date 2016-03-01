flcdir = '~/Work/m33_miras/m33_ofiles/dlcs/dup_variable/'
outdir = '~/Work/m33_miras/m33_ofiles/dlcs/dup_variable.stet.jkl.vals/'
cmd = paste0('mkdir -p ',outdir)
system(cmd)
fs.lc = list.files(flcdir)
nfs.lc = length(fs.lc)

f.out = paste0(outdir,'m33_dup_variable.jkl')
ts = '#      ID                     J        K       L'
write(ts,f.out)
for (ifs.lc in 1:nfs.lc) {
    msg = paste0('   >>  ',round(ifs.lc*100/nfs.lc,2),' %     \r')
    message(msg,appendLF = F)
    sf.lc = fs.lc[ifs.lc]
    f.lc = paste0(flcdir,sf.lc)
    lc = read.table(f.lc)
    nlc = nrow(lc)
    mean.mag = mean(lc[,2])
    mean.flux = 10^(0.4*(25 - mean.mag))
    ## calculate J without any prs information: take observations as singlet
    clc = lc
    nclc = nrow(clc)
    ncoe = sqrt(nclc/(nclc-1))
    if (!is.finite(ncoe)) ncoe = 1
    flux = 10^(0.4*(25-clc[,2]))
    deltas = ncoe * (flux - mean.flux) / (0.921034 * flux * clc[,3])
    Pks = deltas^2 - 1
    stet.j = sum(sign(Pks)*sqrt(abs(Pks)))/nclc
    klc = clc
    deltas = ncoe * (klc[,2] - mean.mag)/klc[,3]
    stet.k = (nlc-1)/nlc^2 * sum(abs(deltas))^2 / sum(deltas^2)
    stet.l = stet.j * stet.k / 0.798
    if (nclc == 1) {
        stet.j = 0
        stet.k = 0
        stet.l = 0
    } 
    stet.j = round(stet.j, 3)
    stet.k = round(stet.k, 3)
    stet.l = round(stet.l, 3)
    ts = paste(sf.lc,stet.j,stet.k,stet.l,sep = '   ')
    write(ts,f.out,append = T)
}
print('')
