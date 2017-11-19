#!/usr/bin/bash
#
DB_SERVER=${DB_SERVER:-"localhost"}
DB_PORT_NO=${DB_PORT_NO:-"5432"}
DB_NAME=${DB_NAME:-"training_data"}
#
exec psql -h ${DB_SERVER} -p ${DB_PORT_NO} -d ${DB_NAME} -U cim -c "${@}"
