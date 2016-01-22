pro Grename_lc

  lcdir_c = '../lcfiles/constant/'
  lcdir_v = '../lcfiles/variable/'
  fields = ['m00','m01','m02','m03','m04','m05','m06','m07','m08','m09','m0a','m0b','m0c','m0d','m0e','m0f','m0g','m0h','m0i','m0j','m0k','m0l','m0m','m0n','m0o','m0p','m0q','m0r','m0s']  
  fields = fields[where(fields ne 'm07')] ;; m07 is bad, too few frames. No useful light curves in orignal reduction

  for ifield = 0, n_elements(fields) - 1  do begin
     field = fields[ifield]
     sfield = strmid(field,2,1)
     dir = '../' + field + '/'
     
     print,' Copying constant light curves for field ' + field
     cdir = dir + 'trialp_con_' + field + '/'
     fs_lc = file_search(cdir + 'lcV.*')
     nfs_lc = n_elements(fs_lc)
     for ilc = 0, nfs_lc - 1 do begin
        f_lc = fs_lc[ilc]
        id = repstr(f_lc, cdir + 'lcV.', '')
        f_new = lcdir_c + sfield + 'ci' + id + '.lc'
        cmd = 'cp ' + f_lc + ' ' + f_new
        spawn,cmd
     endfor

     print,' Copying variable light curves for field ' + field
     vdir = dir + 'trialp_var_' + field + '/'
     fs_lc = file_search(vdir + 'lcV.*')
     nfs_lc = n_elements(fs_lc)
     for ilc = 0, nfs_lc - 1 do begin
        f_lc = fs_lc[ilc]
        id = repstr(f_lc, vdir + 'lcV.', '')
        f_new = lcdir_v + sfield + 'vi' + id + '.lc'
        cmd = 'cp ' + f_lc + ' ' + f_new
        spawn,cmd
     endfor
  endfor

end
