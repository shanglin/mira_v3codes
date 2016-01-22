set fields = (0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s)
echo '' > docheck.do
echo '' > check.res
foreach field ($fields)
set cdir = ../m0$field/
echo "echo "$field" >> check.res" >> docheck.do
echo "ls "$cdir"*.alf | wc -l >> check.res" >> docheck.do
echo "wc -l "$cdir"*.inf >> check.res" >> docheck.do
echo "wc -l "$cdir"*.mch >> check.res" >> docheck.do
echo "grep '<' "$cdir"/orig/*.zer | wc -l >> check.res" >> docheck.do
end
tcsh docheck.do
rm -f docheck.do
