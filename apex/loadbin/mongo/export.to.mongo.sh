#!/bin/bash -x
#
cat all.dirs |
grep /201 |
grep /proc |
while read dir
do
	cd "$dir"
	#
	case "${dir}" in
	*mount_log*)
		echo "====>>>> $dir"
		find . -type f -print |
		grep u03 |
		~/g/bin/maih2mongo.pl -D pasmx -C u03
		;;
	*spc_log*)
		echo "====>>>> $dir"
		find . -type f -print |
		grep u01 |
		~/g/bin/maih2mongo.pl -D pasmx -C u01
		;;
	*)
		;;
	esac
	#
	cd -
done
#
exit 0
