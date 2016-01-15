## (1) generate catalog files for those with light curve files
## this will takes some time...
if (T) {
    ## (1.1) deal with t_mband
    f.lst = '~/Work/m33_miras/m33_ofiles/t_mband_wo/t_mband.lst'
    lst = read.table(f.lst)
    lst = as.character(lst[,1])
    lst = gsub('_it5.slc','',lst)
    nlst = length(lst)

    f.cat = '~/Work/m33_miras/m33_ofiles/catalog_mband.dat'
    cat = read.table(f.cat)
    cat[,18] = as.character(cat[,18])

    header = '# sid  V_ID   I_ID    B_ID      V_RA(J2000) V_DEC     Vmag     Imag     Bmag     Verr     Ierr     Berr  V_Jindex I_Jindex B_Jindex n_V n_I n_B Field'
    f.sat = '~/Work/m33_miras/m33_ofiles/t_mband_wo/catalog_t_mband.dat'
    write(header,f.sat)

    for (i in 1:nlst) {
        sid = lst[i]
        field = substr(sid,1,1)
        id.type = substr(sid,2,2)
        id = as.numeric(substr(sid,4,100))
        if (id.type == 'i') {
            idx = cat[,2] == id & cat[,18] == paste0('m0',field)
            if (sum(idx) != 1) {
                stop(paste0(' Err, something is wrong with the ',f.lst))
            }
            ts = paste(cat[idx,], collapse = '   ')
            ts = paste(sid,ts,sep='   ')
            write(ts,f.sat,append=T)
        }
        else if (id.type == 'm') {
            idx = cat[,1] == id & cat[,18] == paste0('m0',field)
            if (sum(idx) != 1) {
                stop(paste0(' Err, something is wrong with the ',f.lst))
            }
            ts = paste(cat[idx,], collapse = '   ')
            ts = paste(sid,ts,sep='   ')
            write(ts,f.sat,append=T)
        } else {
            stop(paste0(' Err, bad file name for ',sid))
        }
        msg = paste0('  >>   [t_mband] Complete: ',round(i*100/nlst,2),' %    [',sid,']    \r')
        message(msg,appendLF=F)
    }


    ## (1.2) deal with t_ionly : this should be a little simpler, since only IID used
    f.lst = '~/Work/m33_miras/m33_ofiles/t_ionly_wo/t_ionly.lst'
    lst = read.table(f.lst)
    lst = as.character(lst[,1])
    lst = gsub('_it5.slc','',lst)
    nlst = length(lst)

    f.cat = '~/Work/m33_miras/m33_ofiles/catalog_ionly.dat'
    cat = read.table(f.cat)
    cat[,18] = as.character(cat[,18])

    header = '# sid  V_ID   I_ID    B_ID      V_RA(J2000) V_DEC     Vmag     Imag     Bmag     Verr     Ierr     Berr  V_Jindex I_Jindex B_Jindex n_V n_I n_B Field'
    f.sat = '~/Work/m33_miras/m33_ofiles/t_ionly_wo/catalog_t_ionly.dat'
    write(header,f.sat)

    for (i in 1:nlst) {
        sid = lst[i]
        field = substr(sid,1,1)
        ## id.type = substr(sid,2,2) ## id type should be all 'i'
        id = as.numeric(substr(sid,4,100))
        idx = cat[,2] == id & cat[,18] == paste0('m0',field)
        if (sum(idx) != 1) {
            stop(paste0(' Err, something is wrong with the ',f.lst))
        }
        ts = paste(cat[idx,], collapse = '   ')
        ts = paste(sid,ts,sep='   ')
        write(ts,f.sat,append=T)
        msg = paste0('  >>   [t_ionly] Complete: ',round(i*100/nlst,2),' %    [',sid,']    \r')
        message(msg,appendLF=F)
    }
}
