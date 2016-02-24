

dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
fnldir = '~/Work/m33_miras/m33_trialp/fnlfiles/'
type = 'var'

f.cat = paste0(dir,'m33',type,'_raw_cat.dat')
cat = read.table(f.cat,header=T)
ids = as.character(cat[,1])
n.ids = length(ids)

field = '0'
last.field = '0'
f.fnl = paste0(fnldir,'m0',field,'i.fnl')
fnl = read.table(f.fnl, skip = 1)
f.dm = 'ionly_dm.log'
dms = read.table(f.dm)
dm = dms[dms[,1]==field,2]

for (i in 1:n.ids) {
    id = ids[i]
    field = substr(id,1,1)
    if (field != last.field) {
        f.fnl = paste0(fnldir,'m0',field,'i.fnl')
        fnl = read.table(f.fnl, skip = 1)
        dm = dms[dms[,1]==field,2]
        print(paste0('  Switch to field m0',field,' with dm = ',dm))
    }
    last.field = field
    if (cat[i,'vmag'] == -1) {
        tsid = as.numeric(substr(id,4,100))
        idx = tsid == fnl[,1]
        if (sum(idx) != 1) stop(paste0('   ID ',id,' not found in .fnl!'))
        imag = fnl[idx,4] - dm
        cat[i,'imag'] = imag
        cat[i,'ierr'] = round(fnl[idx,5],3)
    }
    msg = paste0('  >> [',field,']  ',round(100*i/n.ids,2),' %  \r')
    message(msg, appendLF = F)
}
print('')

f.new = paste0(dir,'m33',type,'_cat.dat')
write.table(cat,f.new,row.names=F,quote=F,sep='   ')
print('')
