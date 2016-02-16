#!/usr/bin/ksh
#
# parse a PTA log file.
#
export PATH=/usr/bin:${PATH}
#
if [[ "${1}" == "-D" ]]
then
	echo "recordno	t\\\t	l"
	echo "time	t\\\t	l"
	echo "thread	t\\\t	l"
	echo "level	t\\\t	l"
	echo "category	t\\\t	l"
	echo "type	t\\\t	l"
	echo "name	t\\\t	l"
	echo "message	t\\\n	l"
	exit 0
elif [[ "${1}" == "-?" ]]
then
	echo "usage: ${0} [-D] [pta html file] ..."
	exit 0
fi
#
cat ${*} |
nawk 'BEGIN {
	recordno = 0;
	#
	time = "";
	thread = "";
	level = "";
	category = "";
	type = "";
	name = "";
	message = "";
	#
	timeslen = length("<td title=\"Time\">");
	threadslen = length("<td title=\"Thread\">");
	levelslen = length("<td title=\"Level\">");
	categoryslen = length("<td title=\"Category\">");
	typeslen = length("<td title=\"Type\">");
	nameslen = length("<td title=\"Name\">");
	messageslen = length("<td title=\"Message\">");
	#
	tdelen = length("<\/td>");
}
$0 ~ /^<tr>/ {
	# beginning of a new record
	time = "";
	thread = "";
	level = "";
	category = "";
	type = "";
	name = "";
	message = "";
	# print ">>>>>>>>>>>>> START ROW DATA <<<<<<<<<<<<";
	next;
}
$0 ~ /^<td title="Time">/, $0 ~ /<\/td>/ {
	# print "TIME RAW RECORD - " $0;
	if ($0 ~ /^<td title="Time">/ && $0 ~ /<\/td>/) {
		# we have the entire record. clear all old data.
		time = "";
		thread = "";
		level = "";
		category = "";
		type = "";
		name = "";
		message = "";
		# get all data
		time = substr($0, timeslen+1, length($0)-timeslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Time">/) {
		# we have the beginning of the record. clear all data.
		time = "";
		thread = "";
		level = "";
		category = "";
		type = "";
		name = "";
		message = "";
		# get tail of data
		time = substr($0, timeslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		time = time " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		time = time " " $0;
	}
} 
$0 ~ /^<td title="Thread">/, $0 ~ /<\/td>/ {
	# print "THREAD RAW RECORD - " $0;
	if ($0 ~ /^<td title="Thread">/ && $0 ~ /<\/td>/) {
		# get all data
		thread = substr($0, threadslen+1, length($0)-threadslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Thread">/) {
		# get tail of data
		thread = substr($0, threadslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		thread = thread " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		thread = thread " " $0;
	}
} 
$0 ~ /^<td title="Level">/, $0 ~ /<\/td>/ {
	# print "LEVEL RAW RECORD - " $0;
	if ($0 ~ /^<td title="Level">/ && $0 ~ /<\/td>/) {
		# get all data
		level = substr($0, levelslen+1, length($0)-levelslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Level">/) {
		# get tail of data
		level = substr($0, levelslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		level = level " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		level = level " " $0;
	}
} 
$0 ~ /^<td title="Category">/, $0 ~ /<\/td>/ {
	# print "CATEGORY RAW RECORD - " $0;
	if ($0 ~ /^<td title="Category">/ && $0 ~ /<\/td>/) {
		# get all data
		category = substr($0, categoryslen+1, length($0)-categoryslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Category">/) {
		# get tail of data
		category = substr($0, categoryslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		category = category " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		category = category " " $0;
	}
} 
$0 ~ /^<td title="Type">/, $0 ~ /<\/td>/ {
	# print "TYPE RAW RECORD - " $0;
	if ($0 ~ /^<td title="Type">/ && $0 ~ /<\/td>/) {
		# get all data
		type = substr($0, typeslen+1, length($0)-typeslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Type">/) {
		# get tail of data
		type = substr($0, typeslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		type = type " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		type = type " " $0;
	}
} 
$0 ~ /^<td title="Name">/, $0 ~ /<\/td>/ {
	# print "NAME RAW RECORD - " $0;
	if ($0 ~ /^<td title="Name">/ && $0 ~ /<\/td>/) {
		# get all data
		name = substr($0, nameslen+1, length($0)-nameslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Name">/) {
		# get tail of data
		name = substr($0, nameslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		name = name " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		name = name " " $0;
	}
} 
$0 ~ /^<td title="Message">/, $0 ~ /<\/td>/ {
	# print "MESSAGE RAW RECORD - " $0;
	if ($0 ~ /^<td title="Message">/ && $0 ~ /<\/td>/) {
		# get all data
		message = substr($0, messageslen+1, length($0)-messageslen-tdelen);
		next;
	} else if ($0 ~ /^<td title="Message">/) {
		# get tail of data
		message = substr($0, messageslen+1);
	} else if ($0 ~ /<\/td>/) {
		# we have the end of the record. get the beginning of the data.
		message = message " " substr($0, 1, length($0)-tdelen);
		next;
	} else {
		# we have the middle of the record. just add to data.
		message = message " " $0;
	}
} 
$0 ~ /^<\/tr>/ {
	# end of a record
	# print ">>>>>>>>>>>>> DUMP ROW DATA <<<<<<<<<<<<";
	# print "\tTIME - " time;
	# print "\tTHREAD - " thread;
	# print "\tLEVEL - " level;
	# print "\tCATEGORY - " category;
	# print "\tTYPE - " type;
	# print "\tNAME - " name;
	# print "\tMESSAGE - " message;
	# print ">>>>>>>>>>>>> END ROW DATA <<<<<<<<<<<<";
	recordno += 1;
	print recordno "\t" time "\t" thread "\t" level "\t" category "\t" type "\t" name "\t" message;
	# clear data
	time = "";
	thread = "";
	level = "";
	category = "";
	type = "";
	name = "";
	message = "";
	next;
}
END {
} '
#
exit 0

