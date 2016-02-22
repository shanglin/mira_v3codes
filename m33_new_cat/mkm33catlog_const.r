dir = '~/Work/m33_miras/m33_ofiles/'
rdir = paste0(dir,'/rlcs/')
f.lst = paste0(rdir,'constant.lst')

lst = read.table(f.lst)
ids = as.character(lst[,1])
n.ids = length(ids)
## n.ids = 50

f.tmp = paste0(rdir,'tmp.out')
if (T) {
    ts = '    sid         ra         dec    imag     ierr   vmag    verr    bmag    berr    vid     bid'
    write(ts,f.tmp)

    f.cat = paste0(dir,'catalog_ionly.dat')
    catlog = read.table(f.cat)

    last.field = '0'
    lfield = paste0('m0','0')
    sub = catlog[catlog[,18] == lfield,]
    
    for (i in 1:n.ids) {
        id = ids[i]
        field = substr(id,1,1)
        sid = gsub('.rlc','',id)
        iid = substr(sid,4,100)
        iid = as.numeric(iid)

        if (field != last.field) {
            lfield = paste0('m0',field)
            sub = catlog[catlog[,18] == lfield,]
        }
        last.field = field
        
        idx = sub[,2] == iid
        ra = -1
        dec = -1
        vmag = -1
        imag = -1
        bmag = -1
        verr = -1
        ierr = -1
        berr = -1
        vid = -1
        bid = -1
        if (sum(idx) == 1) {
            ts = sub[idx,]
            ra = ts[1,4]
            dec = ts[1,5]
            imag = ts[1,7]
            ierr = ts[1,10]
        }
        ts = paste(sid,ra,dec,imag,ierr,vmag,verr,bmag,berr,vid,bid,sep='   ')
        write(ts,f.tmp,append=T)
        msg = paste0('  >> [',field,']  ',round(100*i/n.ids,2),' %  \r')
        message(msg, appendLF = F)
    }
}
print('')

f.cat = paste0(dir,'catalog_mband.dat')
catlog = read.table(f.cat)
tmp = read.table(f.tmp,header=T)

last.field = '0'
lfield = paste0('m0','0')
sub = catlog[catlog[,18] == lfield,]

for (i in 1:n.ids) {
    id = ids[i]
    field = substr(id,1,1)
    sid = gsub('.rlc','',id)
    iid = substr(sid,4,100)
    iid = as.numeric(iid)

    if (field != last.field) {
        lfield = paste0('m0',field)
        sub = catlog[catlog[,18] == lfield,]
    }
    last.field = field

    idx = sub[,2] == iid
    if (sum(idx) == 1) {
        ## if (tmp[i,'ra'] != -1) print(sub[idx,4] - tmp[i,'ra'])
        tmp[i,'ra'] = sub[idx,4]
        tmp[i,'dec'] = sub[idx,5]
        tmp[i,'imag'] = sub[idx,7]
        tmp[i,'ierr'] = sub[idx,10]
        tmp[i,'vmag'] = sub[idx,6]
        tmp[i,'verr'] = sub[idx,9]
        bmag = sub[idx,8]
        if (abs(bmag) < 90) {
            tmp[i,'bmag'] = bmag
            tmp[i,'berr'] = sub[idx,11]
            tmp[i,'bid'] = sub[idx,3]
        }
        tmp[i,'vid'] = sub[idx,1]
        msg = paste0('  >> [',field,']  ',round(100*i/n.ids,2),' %  \r')
        message(msg, appendLF = F)
    }
}
print('')

f.out = paste0(rdir,'m33con_raw_cat.dat')
write.table(tmp,f.out,row.names = F, quote = F, sep = '   ')
cmd = paste0('rm -f ',f.tmp)
system(cmd)


