set.seed(101)

dir = '~/Work/m33_miras/model_sel_miras/results/'
if (T) {
    f.mat = paste0(dir,'feature_matrix.dat')
mat = read.table(f.mat)
ids = as.character(mat[,1])
idx = substr(ids,1,4) == 'mira'

miras = mat[idx,]
nmiras = nrow(miras)
n.rec = sum(miras[,4] == 1)
    rate = round(n.rec/nmiras*100,2)
print(paste(nmiras,n.rec,rate))


mat = mat[mat[,10] > 0.6,] ## get rid of L<=0.6

    ids = as.character(mat[,1])
idx = substr(ids,1,4) == 'mira'
miras = mat[idx,]
nmiras = nrow(miras)
n.rec = sum(miras[,4] == 1)
    rate = round(n.rec/nmiras*100,2)
print(paste(nmiras,n.rec,rate))

    print(paste('n.miras = ',nmiras))
    
    idx = substr(ids,1,3) == 'srv'
    srvs = mat[idx,]
    nsrvs = nrow(srvs)
    print(paste('n.srv = ',nsrvs))

    idx = substr(ids,1,3) == 'con'
    cons = mat[idx,]
    ncons = nrow(cons)
    print(paste('n.con = ',ncons))

    idx = substr(ids,1,3) != 'mir' & substr(ids,1,3) != 'srv' & substr(ids,1,3) != 'con'  
    m33vars = mat[idx,]
    nm33vars = nrow(m33vars)
    print(paste('n.m33var = ',nm33vars))


idx = sample(1:nrow(mat),replace=F)
mat = mat[idx,]
}

train.dat = mat[mat[,4] != -1,]
