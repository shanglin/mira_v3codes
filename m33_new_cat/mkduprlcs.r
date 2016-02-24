dir = '~/Work/m33_miras/m33_ofiles/rlcs/'
f.dup = paste0(dir,'duplicates_map.map')

f.dm = 'ionly_dm.log'
dms = read.table(f.dm)

dup = read.table(f.dup,header=T)
n.dup = nrow(dup)

for (i in 1:n.dup) {
    
