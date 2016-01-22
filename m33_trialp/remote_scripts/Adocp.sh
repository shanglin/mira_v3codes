set fields = (0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s)
# set fields = (o p q r s)
echo '' > docp.do
# set fields = (0)
set dir = /dc/m33/d3/wiyn/
foreach field ($fields)
set fdir = $dir"m0"$field/i/
set cdir = ../m0$field/
mkdir -p $cdir
echo "echo copying "$fdir"..." >> docp.do
echo cp $fdir"m0"$field"i.* "$cdir >> docp.do
echo cp $fdir"*.alf "$cdir >> docp.do
mkdir -p $cdir/orig
echo cp $cdir"*.fnl" $cdir"*.zer" $cdir"*.vry" $cdir"*.per" $cdir"orig/" >> docp.do
end
tcsh docp.do
rm -f docp.do
