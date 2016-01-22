pro do_trialp_con


  ;; max number of stars in the force file in 6000 by default
  ;; cannot compile any more
  
  neach = 5000
  

  fields = ['m00','m01','m02','m03','m04','m05','m06','m07','m08','m09','m0a','m0b','m0c','m0d','m0e','m0f','m0g','m0h','m0i','m0j','m0k','m0l','m0m','m0n','m0o','m0p','m0q','m0r','m0s']  
  fields = fields[where(fields ne 'm07')] ;; m07 is bad, too few frames. No useful light curves in orignal reduction
  for ifield = 0, n_elements(fields) - 1  do begin
     field = fields[ifield]
     
     dir = '../' + field + '/'
     cd,dir
     
     f_frc = field + 'i.frc'
     f_head = 'force_file.header'
     f_all = field + 'i.frc_all'
     cmd = 'head -3 ' + f_frc + ' > ' + f_head
     spawn, cmd
     if (~file_test(f_all)) then begin
        cmd  = 'awk "NR > 3" ' + f_frc + ' > ' + f_all
        spawn, cmd
     endif
     cmd = 'rm -f ' + f_frc
     cmd = 'wc -l ' + f_all
     spawn, cmd, nstars
     nstars = repstr(nstars, f_all)
     print, 'There are ' + nstars + ' stars in field ' + field
     nstars = float(nstars)

     npiece = ceil(nstars/neach)
     npiece = npiece[0]

     f_sh = 'do_trialp_con_' + field + '.sh'
     f_do = 'do_trialp_con_' + field + '.do'
     f_out = 'do_trialp_con_' + field + '.out'
     f_varout = 'do_trialp_var_' + field + '.out'
     f_log = 'do_trialp_con_' + field + '.log'
     spawn, 'echo "#" > ' + f_out

     openw, l_sh, f_sh, /get_lun
     printf,l_sh, 'set field = ' + field
     printf,l_sh, 'set fieldi = $field"i"'
     printf,l_sh, 'set condir = trialp_con_$field'
     printf,l_sh, 'mkdir -p $condir'
     printf,l_sh, ''
     printf,l_sh, 'rm -f $fieldi.fnl $fieldi.vry $fieldi.zer $fieldi.per'
     printf,l_sh, ''
     printf,l_sh, 'trialp < ' + f_do + ' >> ' + f_out
     printf,l_sh, ''
     printf,l_sh, 'set i = 10'
     printf,l_sh, 'while ($i <= 99)'
     printf,l_sh, '  mv lcV.$i* $condir'
     printf,l_sh, '  @ i++'
     printf,l_sh, 'end'
     printf,l_sh, 'mv lcV.* $condir'
     printf,l_sh, 'mv $fieldi.fnl $fieldi.vry $fieldi.zer $fieldi.per $condir'
     close,l_sh
     free_lun,l_sh

     
     if file_test(f_varout) then begin
        cmd = 'grep "Suggested sigma multiplier" ' + f_varout
        spawn,cmd,outstring
        multiplier = repstr(outstring,'Suggested sigma multiplier (1) ','')
     endif else begin
        multiplier = '1'
     endelse


     openw,l_do,f_do,/get_lun
     printf,l_do, field + 'i.tfr'
     printf,l_do, ''
     printf,l_do, 'new_' + field + 'i.inf'
     printf,l_do, ''
     printf,l_do, ''
     printf,l_do, multiplier
     printf,l_do, '1000, 5, 3, -99'
     printf,l_do, ''
     close,l_sh
     free_lun,l_sh
     
     openw,l_log, f_log, /get_lun, /append
     printf,l_log, 'multiplier =  ' + multiplier
     close,l_log
     free_lun,l_log

     
     for ipiece = 0, npiece - 1 do begin
        cmd = 'head -3 ' + f_head + ' > ' + f_frc
        spawn, cmd
        start = 1 + neach * ipiece
        start = long(start)
        start = strcompress(start, /remove_all)
        toend = neach * (ipiece + 1)
        toend = long(toend)
        toend = strcompress(toend, /remove_all)
        cmd = "awk 'NR >= " + start + " && NR <= " + toend + "' " + f_all + ' >> ' + f_frc
        spawn, cmd

        ;; now we run trialp with the force file
        print,'  Running TRIAP for the ', ipiece + 1, ' group...'
        spawn,'tcsh ' + f_sh
        
     endfor
  endfor
end
