fields = c(0:9,letters[1:19])
fields = fields[fields != '7']

dir = '~/Work/m33_miras/m33_trialp/'
flcdir = '~/Work/m33_miras/simulate_mira/mira_flcs/'
prsdir = paste0(dir,'prsfiles/')
infdir = paste0(dir,'inffiles/')
outdir = '~/Work/m33_miras/simulate_mira/mira.stet.jkl.vals/'

pattern = '^OGLE-LMC-LVP-.*.flc$'
all.fs.lc = list.files(flcdir, pattern = pattern)
lc.fields = substr(all.fs.lc,20,20)
n.all.fs = length(all.fs.lc)

fields = fields[12]
for (field in fields) {
    
    f.prs = paste0(prsdir,'m0',field,'i.prs')
    f.inf = paste0(infdir,'m0',field,'i.inf')

    ## Prepare inf files and prs file to pair observations
    f.ins = paste0(f.inf,'s')
    ## cmd = paste0('../cal.stet.l/shrink_inf ',f.inf,' > ',f.ins)
    ## system(cmd)
    inf = read.table(f.ins)
    inf[,1] = as.character(inf[,1])
    inf[,2] = round(inf[,2] - 2450000,4)
    con = file(f.prs, open = 'r')
    icount = 0
    while (T) {
        ts = readLines(con, n = 1)
        if (length(ts) == 0) break
        icount = icount + 1
    }
    close(con)


    prs = as.data.frame(matrix(NA, ncol=3, nrow=icount/3))
    con = file(f.prs, open = 'r')
    icount = 0
    jcount = 0
    while (T) {
        ts = readLines(con, n = 1)
        if (length(ts) == 0) break
        ts = gsub(' ','',ts)
        icount = icount + 1
        if ((icount %% 3) == 1) {
            jcount = jcount + 1
            idx = inf[,1] == ts
            prs[jcount,1] = inf[idx,2]
        }
        if ((icount %% 3) == 2) {
            if (ts == '') {
                prs[jcount,2] = -99
            } else {
                idx = inf[,1] == ts
                prs[jcount,2] = inf[idx,2]
            }
        }
        if ((icount %% 3) == 0) {
            prs[jcount,3] = as.numeric(ts)
        }   
    }
    close(con)

    ## Calculate variability for light curve files
    f.out = paste0(outdir,'simu_mira_m0',field,'.jkl')
    ts = '# ID      J      K      L'
    write(ts,f.out)

    fs.lc = all.fs.lc[lc.fields =  field]
    nfs.lc = length(fs.lc)

    if (nfs.lc > 1) {
        for (ifs.lc in 1:nfs.lc) {
            msg = paste0('   >> [m0',field,']  ',round(ifs.lc*100/nfs.lc,2),' %     \r')
            message(msg,appendLF = F)
            sf.lc = fs.lc[ifs.lc]
            f.lc = paste0(flcdir,sf.lc)
            lc = read.table(f.lc)
            nlc = nrow(lc)
            
