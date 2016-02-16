# send email to list of addresses
proc sendemail { branch operation reason { extras ""} } {
	global env;
	#
	if {![info exists env(LCSTOOLSDATA)]} {
		puts "sendemail: LCSTOOLSDATA not defined."
		return 2;
	}
	#
	cd $env(LCSTOOLSDATA);
	#
	set timeout 30;
	if {$whereclause == ""} {
		eval spawn -noecho "/opt/exp/lib/unity/bin/uselect" -q $fields from $relation;
	} else {
		eval spawn -noecho "/opt/exp/lib/unity/bin/uselect" -q $fields from $relation where $whereclause;
	}
# set tupcnt 0;
	expect {
	-re {(.*uselect.*)\r\n} {
		puts "\ndbselect: $expect_out(1,string)";
		if {[info exists $obufname]} {
			unset $obufname;
		}
		catch { close; wait; } ignore;
		return 2;
	}
	-re {([^\r\n]*)[\r\n][\r\n]*} {
# incr tupcnt;
# set tbuf $expect_out(1,string);
# puts "dbselect: (${tupcnt}) <$tbuf>";
		lappend obuf $expect_out(1,string);
		exp_continue;
	}
	eof {
		# done
		catch { close; wait; } ignore;
		return 0;
	}
	timeout {
		puts "\ndbselect: timeout during 'uselect' ...";
		if {[info exists $obufname]} {
			unset $obufname;
		}
		catch { close; wait; } ignore;
		return 2;
	}
	};
	# 
	catch { close; wait; } ignore;
	#
	return 0;
}
#
proc dbinsert { relation nmvalname } {
	global env;
	upvar $nmvalname namevalue;
	#
	if {![info exists env(LCSTOOLSDATA)]} {
		puts "dbinsert: LCSTOOLSDATA not defined."
		return 2;
	}
	cd $env(LCSTOOLSDATA);
	#
	set tuple "";
	set Dfd [open D${relation} "r"];
	while {[gets $Dfd line] != -1} {
		set fldinfo [split $line " \t"];
		set fldname [lindex $fldinfo 0];
		set flddelimiter [lindex $fldinfo 1];
		#
		if {[info exists namevalue($fldname)]} {
			set fldvalue $namevalue($fldname);
		} else {
			set fldvalue "";
		}
		#
		switch -regexp -- $flddelimiter {
		{^t\\t$} {
			append tuple "$fldvalue" "\t";
		}
		{^t\\n$} {
			append tuple "$fldvalue" "\n";
		}
		{^t;$} {
			append tuple "$fldvalue" ";";
		}
		default {
			catch { close $Dfd; } ignore;
			puts "dbinsert: unsupported delimiter <$flddelimiter>.";
			return 2;
		}
		}
	}
	#
	catch { close $Dfd; } ignore;
	#
	append tmpfile "/tmp/dbinsert" [exp_pid];
	set tmpfd [open ${tmpfile} "w"];
	puts -nonewline $tmpfd "$tuple";
	catch { close $tmpfd; } ignore;
	#
	system "/opt/exp/lib/unity/bin/insert" -q in $relation from $tmpfile;
	#
	file delete -force -- $tmpfile;
	#
	return 0;
}