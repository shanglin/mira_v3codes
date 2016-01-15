set.seed(101)

dir = '~/Work/m33_miras/'
srvdir = paste0(dir,'lmc_ofiles/srv.lcs/')
outdir = paste0(dir,'simulate_srv/srv_flcs/')

## load LMC catalog with completeness function convolved
f.tbl1 = paste0(dir,'tableA/conv_lmc_srv_s1.csv')
tbl1 = read.table(f.tbl1, header=TRUE, sep=',')
f.tbl2 = paste0(dir,'tableA/conv_lmc_srv_s2.csv')
tbl2 = read.table(f.tbl2, header=TRUE, sep=',')
f.tbli = paste0(dir,'tableA/conv_lmc_srv_si.csv')
tbli = read.table(f.tbli, header=TRUE, sep=',')


## load I-band sigma-magnitude relation (calibrated magnitude)
f.sig = paste0(dir,'simulate_constant/m33i_it5_lkt_flg_cal.dat') 
sig = read.table(f.sig, header=T)
sig = sig[sig[,'flag'] == 0, ]

## distance modulus between LMC and M33
mag.shift = 6.2

## ignore light curves with less observations
least.obs = 10
least.night = 7


