set -x
#
env TZ='Asia/Vientiane' date -d "2015-09-23 00:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-09-24 00:00:00" "+%s"
#
date -d "2015-09-23 00:00:00" "+%s"
date -d "2015-09-24 00:00:00" "+%s"
#
# env TZ='Asia/Vientiane' date -d@1425428806
# env TZ='Asia/Vientiane' date -d@1425438646
#
exit 0
