

f.tmp = 'tmp.zer'
zerdir = '~/Work/m33_miras/m33_trialp/zerfiles/'
infdir = '~/Work/m33_miras/m33_trialp/inffiles/'

fields = c(0:9,letters[1:19])
field = 'b'
tele.types = c('x','y','z','f','g','i')
for (field in fields) {

## load zero files and remove unsolved lines (scatter = 9.9999)
f.zer = paste0(zerdir,'m0',field,'i.zer')
cmd = paste0('grep "<" ',f.zer, ' > ',f.tmp)
system(cmd)
zer = read.table(f.tmp)
zer[,8] = as.character(zer[,8])
zer = zer[zer[,3] < 9.9999,]
n.orig = nrow(zer)

## group for different telescopes or chips
a = zer[,8]
b = substr(a,1,1)
idx = substr(a,1,2) != 'x2' & substr(a,1,2) != 'y2'
zer = zer[idx,]
n.god = nrow(zer)


## plot(1:n.god, zer[,3], pch = 19, col = as.factor(b), main = field)

sub = zer
n.sigma = 3
for (ifoo in 1:50) {
    err = sub[,3]
    idx = err < mean(err) + sd(err) * n.sigma
    sub = sub[idx,]
}
h = mean(sub[,3]) + sd(sub[,3]) * n.sigma

## abline(h = h, col=4)

## abline(h = 0.05, col=2)

## Finally criteria: not x2, not y2, scatter < 0.05
frames = zer[zer[,3]<0.05,8]
frames = gsub('.alf','',frames)

f.inf = paste0('m0',field,'i.inf')
f.new = paste0('new_',f.inf)
lf.inf = paste0(infdir,f.inf)
lf.new = paste0(infdir,f.new)
cmd = paste0('echo "" > ',lf.new)
system(cmd)
if (length(frames) > 0) {
    icount = 1
    for (frame in frames) {
        if (icount == 1)
            cmd = paste0('awk ',"'$1==",'"',frame,'"',"' ",lf.inf,' > ',lf.new)
        else
            cmd = paste0('awk ',"'$1==",'"',frame,'"',"' ",lf.inf,' >> ',lf.new)
        system(cmd)
        icount = icount + 1
    }
}
}

