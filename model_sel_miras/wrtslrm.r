dir = '~/Work/m33_miras/model_sel_miras/'
sdir = paste0(dir, 'slrms/')
types = c('mira','srv','const','m33var')
fields = c(0:9,letters[1:19])

w = function(ap = T) {
    write(ts,lf,append=ap)
    return(0)
}

f.sh = paste0(dir,'dosubmit_ex.sh')
write('#',f.sh)
for (type in types) {
    for (field in fields) {
        f.slrm = paste0('ex_',type,'_',field,'.slrm')
        lf = paste0(sdir,f.slrm)
        sf = paste0('slrms/',f.slrm)
        ts = '#!/bin/bash'
        w(ap=F)
        ts = paste0('#SBATCH -J ex_',type,'_',field)
        w()
        ts = '#SBATCH -p background-4g'
        w()
        ts = '#SBATCH --time=95:59:59'
        w()
        ts = '#SBATCH -n1'
        w()
        ts = '#SBATCH --mem-per-cpu=4095'
        w()
        ts = paste0('#SBATCH -o outs/ex-%j_',type,'_',field,'.out')
        w()
        ts = paste0('#SBATCH -e errs/ex-%j_',type,'_',field,'.err')
        w()
        ts = 'echo "starting at `date` on `hostname`"'
        w()
        ts = 'module load intel/2013_sp1.3'
        w()
        ts = 'module load R/3.1.1'
        w()
        ts = 'export MKL_NUM_THREADS=1'
        w()
        ts = paste0('Rscript sc.extract.features.r ',field,' ',type)
        w()
        ts = 'echo "ended at `date` on `hostname`"'
        w()
        ts = 'exit 0'
        w()
        tt = paste0('sbatch ',sf)
        write(tt, f.sh, append = T)
        tt = 'sleep 2'
        write(tt, f.sh, append = T)
    }
}

cmd = paste0('cp sc.extract.features.r ',dir)
system(cmd)
