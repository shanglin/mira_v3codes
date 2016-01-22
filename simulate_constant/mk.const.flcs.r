set.seed(101)


condir = '~/Work/m33_miras/simulate_constant/'
tlcdirbase = '~/Work/m33_miras/m33_trialp/tlc_labels/'
mjddir = paste0(condir,'unique_mjds/')
flcdir = paste0(condir,'constant_flcs/')
chidir = paste0(condir,'red_chi_sqr/')

least.obs = 10
least.night = 7
fields = c(0:9,letters[1:19])
types = c('constant/','variable/')


cal.chi = function(lc) {
    mean.mag = sum(1/lc[,3]^2 * lc[,2]) / sum(1/lc[,3]^2)
    chi = 1/(nrow(lc) - 1) * sum((lc[,2] - mean.mag)^2 / lc[,3]^2)
    return(c(mean.mag,chi))
}


## field = '0'
## type = types[2]
for (field in fields) {
    for (type in types) {
        stype = substr(type,1,1)
        tlcdir = paste0(tlcdirbase,type)

        ## (1) Declare the file name for storing the values of reduced chi square
        f.chi = paste0(chidir,'m0',field,'_',stype,'_chis.dat')
        write('# ID   old.chi   new.chi',f.chi)

        ## (2) Find all the constant star light curves in that field
        pattern = paste0('^',field,'.*.tlc$')
        fs.tlc = list.files(tlcdir, pattern = pattern)
        nfs.tlc = length(fs.tlc)

        ## (3) Loop over all the stars, calculating chi, simulate light curves
        if (nfs.tlc > 0) {
            ## (4) Load all the MJDs and prepare for the last re-sample
            f.mjds = paste0(mjddir,'m0',field,'_mjds.dat')
            allmjds.prob = read.table(f.mjds)
            allmjds = allmjds.prob[,1]
            mjds.prob = allmjds.prob[,2]
            
            for (iflc in 1:nfs.tlc) {
                msg = paste0('    >> m0',field,'[',type,'] ',round(iflc*100/nfs.tlc,2),' %    \r')
                message(msg,appendLF = F)
                f.tlc = fs.tlc[iflc]
                lf.tlc = paste0(tlcdir, f.tlc)
                tlc = read.table(lf.tlc)
                tlc = tlc[tlc[,4]==1,1:3] # only use good observations
                ntlc = nrow(tlc)
                n.night = length(unique(round(tlc[,1])))
                if (ntlc < least.obs | n.night < least.night) { # only simulated light curve with enough observations
                    chi = -99
                } else {
                    mean.mag.chi = cal.chi(tlc)
                    mean.mag = mean.mag.chi[1]
                    chi = mean.mag.chi[2]
                    true.sig = tlc[,3] * sqrt(chi)

                    ## par(mfrow = c(2,1))           
                    ## x = tlc[,1]
                    ## y = tlc[,2]
                    ## e = tlc[,3]
                    ## ylim = c(max(y) + 0.9, min(y) - 0.9)
                    ## plot(x,y,pch= 19,ylim=ylim, main = 'Original')
                    ## arrows(x,y+e,x,y-e,angle=90,length=0.05,code=3)

                    flc = tlc
                    flc[,2] = round(rnorm(n = ntlc, mean = mean.mag, sd = true.sig),3)
                    flc[,1] = sample(allmjds, ntlc, prob = mjds.prob)
                    flc = flc[order(flc[,1]),]
                    
                    new.chi = cal.chi(flc)[2]
                    
                    ## x = flc[,1]
                    ## y = flc[,2]
                    ## e = flc[,3]
                    ## plot(x,y,pch= 19,col=4,ylim=ylim, main = 'Simulated')
                    ## arrows(x,y+e,x,y-e,angle=90,length=0.05,code=3,col=4)
                    ## Sys.sleep(1)
                }
                if (chi != -99) {
                    ts.chi = paste(f.tlc, round(chi,3), round(new.chi,3), sep = '   ')
                    write(ts.chi,f.chi, append = T)
                    f.flc = paste0(flcdir,'con_',gsub('.tlc','.flc',f.tlc))
                    write.table(flc,f.flc, row.names = F, col.names = F)
                }
            }
            print('')
        }
    }
}
