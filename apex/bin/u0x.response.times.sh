cat LNB*FILE* LNB*TR* |
egrep -i '(u01|u03)' |
egrep -v '(DEBUG)' |
sed 's/[	 ][	 ]*/ /g' |
gawk '
BEGIN {
    last_u01_fm_time = "";
    last_u03_fm_time = "";
    last_u01_tr_time = "";
    last_u03_tr_time = "";
}
$5 == 407 {
    # print "====>>>> " $0
    print $3 " FM-407-U01 " $7 " " $15;
    last_u01_fm_time = $1;
    next;
}
$5 == 599 {
    # print "====>>>> " $0
    print $3 " FM-599-U03 " $7 " " $15;
    next;
}
$5 == 1892 {
    # print "====>>>> " $0
    print $3 " FM-1892-U01 " $7 " " $10;
    next;
}
$5 == 2019 {
    # print "====>>>> " $0
    print $3 " FM-2019-U03 " $7 " " $10;
    next;
}
$5 == 517 {
    # print "====>>>> " $0
    print $3 " TR-517-U01 " $7 " " $15;
    next;
}
$5 == 731 {
    # print "====>>>> " $0
    print $3 " TR-731-U03 " $7 " " $15;
    next;
}
$5 == 2153 {
    # print "====>>>> " $0
    print $3 " TR-2153-U01 " $7 " " $10;
    next;
}
$5 == 2576 {
    # print "====>>>> " $0
    print $3 " TR-2576-U03 " $7 " " $10;
    next;
}
END {
} ' | 
sort -t' ' -k1,1 |
sed 's/ /	/g' |
sed 's/+-+/	/g' |
cut -d: -f3- |
sort -t'	' -k5,5 -k4,4 -k1,1 |
egrep '(FM-599|TR-2576)' |
grep '	05	' |
paste - - |
cut -d'	' -f1,13 |
gawk '
BEGIN {
    sum = 0;
    count = 0;
    sum_sd = 0;
}
{
    count = count + 1;
    sum = sum + $2 - $1;
    sum_sd = sum_sd + ($2 - $1 - 5.35)*($2 - $1 - 5.35);
    next;
}
END {
    print "Count is ... " count;
    print "Sum is ... " sum;
    print "Sum SD is ... " sum_sd;
    print "Mean is ... " sum/count;
    print "SD is ... " sqrt(sum_sd/count);
} '
