set -x
#
env TZ='Asia/Vientiane' date -d "2015-02-02 00:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-02-02 23:59:59" "+%s"
#
env TZ='Asia/Vientiane' date -d "2015-02-02 09:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-02-02 10:00:00" "+%s"
#
env TZ='Asia/Vientiane' date -d "2015-02-02 09:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-02-02 09:10:00" "+%s"
#
date -d "2015-02-02 00:00:00" "+%s"
date -d "2015-02-02 23:59:59" "+%s"
#
date -d "2015-02-02 09:00:00" "+%s"
date -d "2015-02-02 10:00:00" "+%s"
#
date -d "2015-02-02 09:00:00" "+%s"
date -d "2015-02-02 09:10:00" "+%s"
#
env TZ='Asia/Vientiane' date -d "2015-05-19 00:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-05-19 23:59:59" "+%s"
#
date -d "2015-05-19 00:00:00" "+%s"
date -d "2015-05-19 23:59:59" "+%s"
#
# env TZ='Asia/Vientiane' date -d@1425428806
# env TZ='Asia/Vientiane' date -d@1425438646
#
exit 0
