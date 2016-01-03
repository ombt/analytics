#!/bin/bash -x
#
TZ="Asia/Tokyo"
export TZ
#
(
cat <<EOF
10/09/2015 00:00:00
10/09/2015 00:14:10
EOF
) |
while read dia
do
	date -d "${dia}" '+%s'
done
#
(
cat <<EOF
1444015462
1444015466
EOF
) |
while read dia
do
	date -d@${dia}
done
#
exit 0
