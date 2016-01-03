#!/bin/bash
# 
# TZ="Canada/Mountain"
TZ="Europe/Madrid"
export TZ
#
for ts in "${@}"
do
	date -d@${ts}
done
#
exit 0
