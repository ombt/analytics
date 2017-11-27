#!/usr/bin/bash
#
for sql in "${@}"
do
	psql -F ',' -d testing -U cim -A -f "${sql}"
done
#
exit 0
