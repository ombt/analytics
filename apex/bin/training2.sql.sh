#!/usr/bin/bash
#
for sql in "${@}"
do
	psql -F ',' -d training_data2 -U cim -A -f "${sql}"
	# psql -F '	' -d training_data2 -U cim -A -f "${sql}"
done
#
exit 0
