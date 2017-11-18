#!/usr/bin/bash
#
exec psql -d training_data "${@}"
