set fields = (0 1 2 3 4 5 6 8 9 a b c d e f g h i j k l m n o p q r s)

foreach field ($fields)
set dir = "../m0"$field"/"
set vardir = $dir"trialp_var_m0"$field"/"
set Ffnl = $vardir"m0"$field"i.fnl"
set Fnmg = $dir"m0"$field"i.nmg"
set Ffrc = $dir"m0"$field"i.frc"
set Ftmp = "tmp.awk"

echo "Making constant frc file for field m0"$field
awk 'NR > 1 && $6 >= 10 && $11 < 0.6 {print "NR > 3 && $1 == "$1}' $Ffnl > $Ftmp
head -3 $Fnmg > $Ffrc
awk -f $Ftmp $Fnmg >> $Ffrc
end

rm -f $Ftmp
