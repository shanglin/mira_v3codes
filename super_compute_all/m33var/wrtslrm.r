
n = 2900 ## number of batches
dir = '~/Work/m33_miras/super_compute_all/m33var/'
f_sh = paste0(dir,'dosubmit.sh')
system(paste0('rm -f ',f_sh))
for (si in 1:n) {
    
    sf.slrm = paste0('slrms/pe_',si,'.slrm')
    f_slrm = paste0(dir,sf.slrm)
    subdir = paste0(dir,'flcs/batch_',si,'/')
    fs = list.files(subdir)
    lfs = paste0('flcs/batch_',si,'/',fs)
    f.lst = paste0('bat_',si,'.lst')
    lf.lst = paste0(dir,f.lst)
    write.table(lfs,lf.lst,quote=F,row.names=F, col.names=F)

    write('#!/bin/bash',file=f_slrm,append=F)
    write(paste0('#SBATCH -J m33v3_v2.7-m33-',si),file=f_slrm,append=T)
    write('#SBATCH -p background-4g',file=f_slrm,append=T)
    write('#SBATCH --time=95:59:59',file=f_slrm,append=T)
    write('#SBATCH -n1',file=f_slrm,append=T)
    write('#SBATCH --mem-per-cpu=4095',file=f_slrm,append=T)
    write('#SBATCH -o gf-%j.out',file=f_slrm,append=T)
    write('#SBATCH -e gf-%j.err',file=f_slrm,append=T)
    write('echo "starting at `date` on `hostname`"',file=f_slrm,append=T)
    write('module load gcc',file=f_slrm,append=T)
    write('module load openblas',file=f_slrm,append=T)
    write('module load lapack',file=f_slrm,append=T)
    ## for (sj in 1:length(fs))
    write(paste0('/fdata/scratch/yuanwenlong/m33_v3/packages/cpp_gpv2/gpmodelv2 -l ',f.lst),file=f_slrm,append=T)
    write('echo "ended at `date` on `hostname`"',file=f_slrm,append=T)
    write('exit 0',file=f_slrm,append=T)

    write(paste0('sbatch ',sf.slrm),file=f_sh,append=T)
    write(paste0('echo "submitting the ',si,'th job"'),file=f_sh, append=T)
    write('sleep 2',file=f_sh,append=T)
}
