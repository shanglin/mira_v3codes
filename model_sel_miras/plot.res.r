

fields = c(0:9,letters[1:19])
for (field in fields) {
    print(field)
    dir = '~/Work/m33_miras/model_sel_miras/results/'
    figdir = paste0(dir,'figures/')

    f.mira = paste0(dir,'feature_mira/mira_m0',field,'_features.dat')
    f.con = paste0(dir,'feature_const/const_m0',field,'_features.dat')
    f.srv = paste0(dir,'feature_srv/srv_m0',field,'_features.dat')
    f.var = paste0(dir,'feature_m33var/m33var_m0',field,'_features.dat')
    if (file.exists(f.mira) & file.exists(f.con) & file.exists(f.srv) & file.exists(f.var)) {
        dat.mira = read.table(f.mira)
        dat.con = read.table(f.con)
        dat.srv = read.table(f.srv)
        dat.var = read.table(f.var)

        width = 800
        height = 400
        ## (1) plot Q vs log(P)

        f.png = paste0(figdir,'Q_m0',field,'.png')
        png(f.png, width = width, height = height)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,5], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q',xlim=c(1.7,3.3),ylim=c(-150,90), main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,5], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,5], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,-100,'Mira',col = rgb(1,0,0,1))
        text(3.2,-110,'Const',col = rgb(0,1,0,1))
        text(3.2,-120,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,5], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q',xlim=c(1.7,3.3),ylim=c(-150,90), main = paste0('M33 object: ','m0',field))
        dev.off()


        ## (2) plot Q.base vs log(P)

        f.png = paste0(figdir,'Q.base_m0',field,'.png')
        png(f.png, width = width, height = height)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,6], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q.base',xlim=c(1.7,3.3),ylim=c(-150,90), main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,6], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,6], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,-100,'Mira',col = rgb(1,0,0,1))
        text(3.2,-110,'Const',col = rgb(0,1,0,1))
        text(3.2,-120,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,6], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q.base',xlim=c(1.7,3.3),ylim=c(-150,90), main = paste0('M33 object: ','m0',field))
        dev.off()


        ## (3) plot Q - Q.base
        f.png = paste0(figdir,'dQ.Q.base_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 7
        ylim = c(0,20)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q.base',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,20,'Mira',col = rgb(1,0,0,1))
        text(3.2,18.5,'Const',col = rgb(0,1,0,1))
        text(3.2,17,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q.base',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()



        ## (4) Q - Q.p2
        f.png = paste0(figdir,'dQ.Q.p2_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 8
        ylim = c(0,15)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q(second peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,20,'Mira',col = rgb(1,0,0,1))
        text(3.2,18.5,'Const',col = rgb(0,1,0,1))
        text(3.2,17,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q(second peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (5) Q/Q2
        f.png = paste0(figdir,'rQ.Q.p2_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 9
        ylim = c(1,3.5)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q / Q(second peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,20,'Mira',col = rgb(1,0,0,1))
        text(3.2,18.5,'Const',col = rgb(0,1,0,1))
        text(3.2,17,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q / Q(second peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (6) Q - Qn
        f.png = paste0(figdir,'dQ.Q.pn_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 10
        ylim = c(1,30)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q(last peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,20,'Mira',col = rgb(1,0,0,1))
        text(3.2,18.5,'Const',col = rgb(0,1,0,1))
        text(3.2,17,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Q - Q(last peak)',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (7) theta 1
        f.png = paste0(figdir,'theta1_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 12
        ylim = c(0,2)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Theta 1',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,20,'Mira',col = rgb(1,0,0,1))
        text(3.2,18.5,'Const',col = rgb(0,1,0,1))
        text(3.2,17,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Theta 1',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (8) theta 2
        f.png = paste0(figdir,'theta2_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 13
        ylim = c(0,200)
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = 'Theta 2',xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,190,'Mira',col = rgb(1,0,0,1))
        text(3.2,180,'Const',col = rgb(0,1,0,1))
        text(3.2,170,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = 'Theta 2',xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (9) Amplitude
        f.png = paste0(figdir,'Amplitude_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 14
        ylim = c(0,3)
        ylab = 'Amplitude'
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,2.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,2.70,'Const',col = rgb(0,1,0,1))
        text(3.2,2.50,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (10) curvature
        f.png = paste0(figdir,'Curvature_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 15
        ylim = c(0,300)
        ylab = 'Curvature'
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,290,'Mira',col = rgb(1,0,0,1))
        text(3.2,270,'Const',col = rgb(0,1,0,1))
        text(3.2,250,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (11) curvature zoom
        f.png = paste0(figdir,'Curvature_zoom_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 15
        ylim = c(0,3)
        ylab = 'Curvature -- artifacts (Initiall Hessian Guess & Failed Cases)'
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,2.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,2.70,'Const',col = rgb(0,1,0,1))
        text(3.2,2.50,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (12) Number of peaks
        f.png = paste0(figdir,'Npeaks_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 16
        ylim = c(0,60)
        ylab = 'Number of peaks (jittered)'
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), jitter(dat.mira[,col],3), pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), jitter(dat.con[,col],3), pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), jitter(dat.srv[,col],3), pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        ## text(3.2,2.90,'Mira',col = rgb(1,0,0,1))
        ## text(3.2,2.70,'Const',col = rgb(0,1,0,1))
        ## text(3.2,2.50,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), jitter(dat.var[,col],3), pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (13) L
        f.png = paste0(figdir,'L_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 17
        ylim = c(0,5)
        ylab = "Stetson's L"
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,4.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,4.50,'Const',col = rgb(0,1,0,1))
        text(3.2,4.10,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (14) l2.energy
        f.png = paste0(figdir,'l2energy_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 18
        ylim = c(0,1)
        ylab = "Energy Ratio (squared)"
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), dat.mira[,col], pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), dat.con[,col], pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), dat.srv[,col], pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,4.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,4.50,'Const',col = rgb(0,1,0,1))
        text(3.2,4.10,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), dat.var[,col], pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (15) l2.energy zoom
        f.png = paste0(figdir,'l2energy_zoom_m0',field,'.png')
        png(f.png, width = width, height = height)
        jit = 1
        col = 18
        ylim = c(0.99,1)
        ylab = "Energy Ratio (squared) -- Zoomed in and Jittered"
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), jitter(dat.mira[,col],jit), pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), jitter(dat.con[,col],jit), pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), jitter(dat.srv[,col],jit), pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,4.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,4.50,'Const',col = rgb(0,1,0,1))
        text(3.2,4.10,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), jitter(dat.var[,col],jit), pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()

        ## (16) standard deviation of error
        f.png = paste0(figdir,'sd_error_m0',field,'.png')
        png(f.png, width = width, height = height)
        col = 20
        ylim = c(0,2)
        ylab = "Deviation from model (mag)"
        par(mfrow=c(1,2))
        plot(log10(1./dat.mira[,4]), jitter(dat.mira[,col],jit), pch=19, cex=0.2, col = rgb(1,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('m0',field))
        points(log10(1./dat.con[,4]), jitter(dat.con[,col],jit), pch=19, cex=0.2, col = rgb(0,1,0,0.1))
        points(log10(1./dat.srv[,4]), jitter(dat.srv[,col],jit), pch=19, cex=0.2, col = rgb(0,0,1,0.1))
        text(3.2,1.90,'Mira',col = rgb(1,0,0,1))
        text(3.2,1.80,'Const',col = rgb(0,1,0,1))
        text(3.2,1.70,'SRV',col = rgb(0,0,1,1))
        plot(log10(1./dat.var[,4]), jitter(dat.var[,col],jit), pch=19, cex=0.2, col = rgb(0,0,0,0.1), xlab = 'log (P)', ylab = ylab,xlim=c(1.7,3.3),ylim=ylim, main = paste0('M33 object: ','m0',field))
        dev.off()
    }

}
