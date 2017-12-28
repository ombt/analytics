#!/usr/bin/bash -x
#
if [[ $# -eq 0 ]]
then
	echo "usage: $0 db_name [...]"
	exit 2
fi
#
for db in "${@}"
do
	bkupfn="$(date '+%Y%m%d%H%M').${db}.gz"
	/usr/bin/pg_dump "${db}" | gzip > "${bkupfn}"
done
#
exit 0