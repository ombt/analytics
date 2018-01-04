#!/usr/bin/bash
#
for sql in "${@}"
do
	psql -F ',' -d training_data -U cim -A -f "${sql}"
done
#
exit 0
