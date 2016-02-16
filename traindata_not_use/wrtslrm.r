
n = 2900 ## number of batches
dir = '~/Work/m33_miras/traindata/train_data/'
f_sh = paste0(dir,'dosubmit.sh')
system(paste0('rm -f ',f_sh))
for (si in 1:n) {
    sf.slrm = paste0('pe_',si,'.slrm')
    f_slrm = paste0(dir,sf.slrm)
    write('#!/bin/bash',file=f_slrm,append=F)
    write(paste0('#SBATCH -J sp-train-',si),file=f_slrm,append=T)
    write('#SBATCH -p background-4g',file=f_slrm,append=T)
    write('#SBATCH --time=95:59:59',file=f_slrm,append=T)
    write('#SBATCH -n1',file=f_slrm,append=T)
    write('#SBATCH --mem-per-cpu=4095',file=f_slrm,append=T)
    write('#SBATCH -o gf-%j.out',file=f_slrm,append=T)
    write('#SBATCH -e gf-%j.err',file=f_slrm,append=T)
    write('echo "starting at `date` on `hostname`"',file=f_slrm,append=T)
    write('module load intel/2013_sp1.3',file=f_slrm,append=T)
    write('module load R/3.1.1',file=f_slrm,append=T)
    write('export MKL_NUM_THREADS=1',file=f_slrm,append=T)
    write(paste0('Rscript m33v3_pest_train.r ',si),file=f_slrm,append=T)
    write('echo "ended at `date` on `hostname`"',file=f_slrm,append=T)
    write('exit 0',file=f_slrm,append=T)

    write(paste0('sbatch ',sf.slrm),file=f_sh,append=T)
    write('sleep 2',file=f_sh,append=T)
}
