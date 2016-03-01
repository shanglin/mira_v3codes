
n = 2900 ## number of batches
dir = '~/Work/m33_miras/extract_features/con/'
f_sh = paste0(dir,'dosubmit.sh')
system(paste0('rm -f ',f_sh))
system(paste0('mkdir -p ',dir,'slrms/'))
system(paste0('mkdir -p ',dir,'errs/'))
system(paste0('mkdir -p ',dir,'outs/'))
cmd = paste0('cp ext.feature.r ',dir)
system(cmd)
cmd = paste0('cp llmax.r ',dir)
system(cmd)

if (T) {
    for (si in 1:n) {
        
        sf.slrm = paste0('slrms/ex_',si,'.slrm')
        f_slrm = paste0(dir,sf.slrm)

        write('#!/bin/bash',file=f_slrm,append=F)
        write(paste0('#SBATCH -J exft_con-',si),file=f_slrm,append=T)
        write('#SBATCH -p background-4g',file=f_slrm,append=T)
        write('#SBATCH --time=95:59:59',file=f_slrm,append=T)
        write('#SBATCH -n1',file=f_slrm,append=T)
        write('#SBATCH --mem-per-cpu=4095',file=f_slrm,append=T)
        write('#SBATCH -o outs/ex-%j.out',file=f_slrm,append=T)
        write('#SBATCH -e errs/ex-%j.err',file=f_slrm,append=T)
        write('echo "starting at `date` on `hostname`"',file=f_slrm,append=T)
        write('module load intel/2013_sp1.3',file=f_slrm,append=T)
        write('module load R/3.1.1',file=f_slrm,append=T)
        write('MKL_NUM_THREADS=1',file=f_slrm,append=T)
        write(paste0('Rscript ext.feature.r ',si),file=f_slrm,append=T)
        write('echo "ended at `date` on `hostname`"',file=f_slrm,append=T)
        write('exit 0',file=f_slrm,append=T)

        write(paste0('sbatch ',sf.slrm),file=f_sh,append=T)
        write(paste0('echo ',si),file=f_sh,append=T)
        write('sleep 0.5',file=f_sh,append=T)
    }
}
