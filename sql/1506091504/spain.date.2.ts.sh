#!/bin/bash
# 
# TZ="Canada/Mountain"
TZ="Europe/Madrid"
export TZ
#
for dia in "${@}"
do
	date -d "${dia}" '+%s'
done
#
exit 0
