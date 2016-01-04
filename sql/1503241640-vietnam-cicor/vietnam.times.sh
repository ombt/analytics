set -x
#
env TZ='Asia/Vientiane' date -d "2015-03-04 08:00:00" "+%s"
env TZ='Asia/Vientiane' date -d "2015-03-04 15:45:00" "+%s"
#
env TZ='Asia/Vientiane' date -d "2015-03-04 08:05:01" "+%s"
env TZ='Asia/Vientiane' date -d "2015-03-04 09:23:07" "+%s"
#
env TZ='Asia/Vientiane' date -d "2015-03-04 11:03:52" "+%s"
env TZ='Asia/Vientiane' date -d "2015-03-04 15:32:55" "+%s"
#
env TZ='Asia/Vientiane' date -d@1425428806
env TZ='Asia/Vientiane' date -d@1425438646
#
date -d "2015-03-04 08:00:00" "+%s"
date -d "2015-03-04 15:45:00" "+%s"
#
date -d "2015-03-04 08:05:01" "+%s"
date -d "2015-03-04 09:23:07" "+%s"
#
date -d "2015-03-04 11:03:52" "+%s"
date -d "2015-03-04 15:32:55" "+%s"
#
date -d@1425428806
date -d@1425438646
#
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 08:00:00" "+%s")
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 15:45:00" "+%s")
#
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 08:05:01" "+%s")
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 09:23:07" "+%s")
#
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 11:03:52" "+%s")
# env TZ='Asia/Vientiane' date -d@$(env TZ='Asia/Vientiane' date -d "2015-03-04 15:32:55" "+%s")
#
exit 0
