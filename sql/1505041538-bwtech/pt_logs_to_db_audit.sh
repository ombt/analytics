#!/bin/bash
#
ls AB21DTP* |
grep -v _App_ |
xargs -L1 cat |
sed -n 's/\r//gp' |
gawk 'BEGIN {
    rpm67 = 0;
    rmp = 0;
    date = "";
    machine = "";
}
/DATA OUT : RPM67/ {
    rpm67 = 1;
    next;
}
/<RAWMGMT_PACKAGE>/, /<\/RAWMGMT_PACKAGE>/ {
    rmp = 1;
    # FALL THRU
}
/<WM_FILE>/, /<\/WM_FILE>/ {
    # print "PRODUCTION " $0;
    next;
}
/<NM_FILE>/, /<\/NM_FILE>/ {
    # print "NOZZLE " $0;
    next;
}
/<PM_FILE>/, /<\/PM_FILE>/ {
    # printf "DATE ... <%s>\n", date;
    # printf "MACHINE ... <%s>\n", machine;
    if ($0 ~ /^T[0-9]/)
    {
        printf "%s %s %s\n", machine, date, $0;
    }
    else if ($0 ~ /^Date:/)
    {
        date = $0;
    }
    else if ($0 ~ /^Author:/)
    {
        machine = $0;
    }
    next;
}
{
    rpm67 = 0;
    rmp   = 0;
    date = "";
    machine = "";
    next;
}
END {
} ' |
sed -e 's/Author:AB21DTP1/1000/' \
    -e 's/Author:AB21DTP2/1002/' \
    -e 's/Date://' \
    -e 's/,/ /' \
    -e 's/SS/ SS/' \
    -e 's/PC/ PC/' \
    -e 's/PM/ PM/' \
    -e 's/RE/ RE/' \
    -e 's/HM/ HM/' \
    -e 's/PN/ PN/' \
    -e 's/LN/ LN/' |
sort -t' ' --key 1 --key 2,3 --key 4,5 | 
uniq
#
exit 0
# 
# 
# 
# # FEEDER <PM_FILE>Format:ProductDat
# # FEEDER Version:3
# # FEEDER Machine:ProViewer
# # FEEDER Date:2015/02/06,16:02:57
# # FEEDER AuthorType:PT100CG
# # FEEDER Author:AB21DTP1
# # FEEDER T10002SS1PC21499PM2RE3HM0PNLN0
# # FEEDER T10002SS2PC21555PM4RE1HM0PNLN0
# # FEEDER T10003SS1PC44862PM22RE4HM0PNLN0
# # FEEDER T10003SS2PC46731PM13RE2HM0PNLN0
# # FEEDER T10004SS1PC89089PM20RE5HM0PNLN0
# # FEEDER T10004SS2PC87026PM35RE21HM0PNLN0
# # FEEDER T10005SS1PC88145PM73RE67HM0PN119055LN0
# # FEEDER T10005SS2PC84923PM22RE15HM0PN50104991-021LN0
# # FEEDER T10006SS1PC66344PM30RE4HM0PN113207LN0
# # FEEDER T10006SS2PC67715PM12RE11HM0PN103085LN0
# # FEEDER T10007SS1PC48947PM12RE4HM0PN110722LN0
# # FEEDER T10007SS2PC42271PM34RE3HM0PN136355LN0
# # FEEDER T10008SS1PC36382PM8RE17HM0PN110894LN0
# # FEEDER T10008SS2PC26800PM3RE2HM0PN102984LN0
