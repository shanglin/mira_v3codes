f.prs = 'm03i.prs'
f.inf = 'm03i.inf'

f.ins = paste0(f.inf,'s')
cmd = paste0('shrink_inf ',f.inf,' > ',f.ins)
system(cmd)

inf = read.table(f.ins)
inf[,1] = as.character(inf[,1])

con = file(f.prs, open = 'r')

icount = 0
while (T) {
    ts = readLines(con, n = 1)
    if (length(ts) == 0) break
    icount = icount + 1
}
close(con)

prs = as.data.frame(matrix(NA, ncol=3, nrow=icount/3))
con = file(f.prs, open = 'r')
icount = 0
jcount = 0
while (T) {
    ts = readLines(con, n = 1)
    if (length(ts) == 0) break
    ts = gsub(' ','',ts)
    icount = icount + 1
    if ((icount %% 3) == 1) {
        jcount = jcount + 1
        idx = inf[,1] == ts
        prs[jcount,1] = inf[idx,2]
    }
    if ((icount %% 3) == 2) {
        if (ts == '') {
            prs[jcount,2] = -99
        } else {
            idx = inf[,1] == ts
            prs[jcount,2] = inf[idx,2]
        }
    }
    if ((icount %% 3) == 0) {
        prs[jcount,3] = as.numeric(ts)
    }   
}
close(con)


f.lc = '3ci11524.lc'
lc = read.table(f.lc)
nlc = nrow(lc)
lc[lc[,3] < 0.001,3] = 0.001 ## just to avoid numeric failure
## mean.mag = sum(1/lc[,3]^2*lc[,2]) / sum(1/lc[,3]^2)
flux = 10^(0.4*(25 - lc[,2]))
mean.flux = sum(1/lc[,3]^2 * flux) / sum(1/lc[,3]^2)
mean.mag = 25 - 2.5*log10(mean.flux)

## calculate J
## (1) make a paired lc table, 7 columns, last column to be weight
clc = lc[,1:3]
clc.pair = as.data.frame(matrix(NA, ncol = 4, nrow = nlc))
clc = cbind(clc,clc.pair)
for (i in 1:nlc) {
    jd = clc[i,1]
    idx.1 = prs[,1] == jd
    if (sum(idx.1) == 1) {
        jd.2 = prs[idx.1, 2]
        if (jd.2 == -99) { ## no partner
            clc[i,4:6] = -99
            clc[i,7] = prs[idx.1, 3]
        } else { ## there should be a visit, but not essentially got an observation
            idx.clc = clc[,1] == jd.2
            if (sum(idx.clc) == 0) { ## didn't get an observation for this star
                clc[i,4:6] = -99
                clc[i,7] = 0.5  ## should only give half the weight
            } else {
                if (sum(idx.clc) !=1) stop(paste0(' Bad light curve file for ',f.lc))
                clc[i,4:6] = clc[idx.clc, 1:3]
                clc[i,7] = prs[idx.1, 3]
            }
        }
    } else { ## well, there is a case that the JD sit in prs[,2] and its counterpart is not obtained
        idx.2 = prs[,2] == jd
        if (sum(idx.2) != 1) stop(paste0(' Bad light curve file for ',f.lc,': JD not found in .inf'))
        jd.1 = prs[idx.2,1] ## Hopefully there is an observation at JD.1, but not necessary
        idx.clc = clc[,1] == jd.1
        if (sum(idx.clc) == 0) {
            clc[i,4:6] = -99
            clc[i,7] = 0.5 ## Although there is a paired frame, this star only shows up in one frame, thus give it half the weight
        } else {
            if (sum(idx.clc) !=1) stop(paste0(' Bad light curve file for ',f.lc))
            clc[i,4:6] = clc[idx.clc, 1:3]
            clc[i, 7] = prs[idx.2, 3] ## Probably full weight
        }
    }
}

if (sum(is.na(clc[,4])) > 0) stop(paste0(' Check for ',f.lc)) ## There should no NAs for now

## (1.2) Remove duplicates from the clc object
dup.idx = c()
for (i in 1:nlc) {
    idx = clc[i,1] == clc[,4]
    if (sum(idx) == 1) {
        idx = which(idx)
        min.i = min(i,idx)
        max.i = max(i,idx)
        dup.idx = c(dup.idx, paste0(min.i,'---------',max.i))
    }
}
dup.idx = unique(dup.idx)
dup.idx = substr(dup.idx,1,5)
dup.idx = as.numeric(gsub('-','',dup.idx))
clc = clc[-c(dup.idx),]
nclc = nrow(clc)

ncoe = sqrt(nclc/(nclc-1))
Pks = rep(NA, nclc)
for (i in 1:nclc) {
    if (clc[i,4] == -99) {
        delta = ncoe * (clc[i,2] - mean.mag) / clc[i,3]
        Pks[i] = delta^2 - 1
    } else {
        delta.1 = ncoe * (clc[i,2] - mean.mag) / clc[i,3]
        delta.2 = ncoe * (clc[i,5] - mean.mag) / clc[i,6]
        Pks[i] = delta.1 * delta.2
    }
}
stet.j = sum(clc[,7] * sign(Pks) * sqrt(abs(Pks))) / sum(clc[,7])


## Calculate Stetson' K
klc = lc[,1:3]
deltas = sqrt(nlc/(nlc-1)) * (klc[,2] - mean.mag)/klc[,3]
## stet.k = sqrt(1/nlc) * sum(abs(deltas)) / sqrt(sum(deltas^2))  ## defined in the paper
stet.k = (n-1)/n^2 * sum(abs(deltas))^2 / sum(deltas^2)  ## what in TRIALP.F, which is the squared value of Kurtosis

## Calculate Stetson's L
stet.l = stet.j * stet.k / 0.798 ## assumed sum(w)/w_all = 1, since we deleted some images from .prs. It is also true for TRIALP.F

print(paste(stet.j,stet.k,stet.l))
