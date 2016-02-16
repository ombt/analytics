#
# poor man's way of doing semaphores. this implementation violates
# everything you learned about semaphores, ie, it has race conditions
# built in, but I can't think of (or found) another way to do it.
# well, i could use a TCP port and bind to it, then any other attempt
# to bind to the same TCP port would fail. i might add this if
# this doesn't work.
#
proc P { locktype labid } {
	global env;
	# sanity check
	if {![info exists env(LCSTOOLSQ)]} {
		puts "P: LCSTOOLSQ not defined.";
		exit 2;
	}
	# check if queue exists
	set qdir $env(LCSTOOLSQ);
	if {![file isdirectory $qdir]} {
		file mkdir $qdir;
	}
	# lock file
	set lockfile "${qdir}/${locktype}${labid}";
	# check if lock file exists.
	if {[file exists $lockfile]} {
		# lock exists
		# puts "P: lock $lockfile exists ...";
		return 0;
	}
	# create lock file - possible race condition ...
	set lockfd [open $lockfile "w"];
	puts $lockfd "$locktype - $labid - [pid] - [exec id] - [exec date]";
	close $lockfd;
	#
	if {[file owned $lockfile]} {
		system /usr/bin/chmod 0777 $lockfile;
	}
	# our turn
	# puts "P: creating lock $lockfile ...";
	return 1;
}
#
proc quietP { locktype labid } {
	global env;
	# sanity check
	if {![info exists env(LCSTOOLSQ)]} {
		exit 2;
	}
	# check if queue exists
	set qdir $env(LCSTOOLSQ);
	if {![file isdirectory $qdir]} {
		file mkdir $qdir;
	}
	# lock file
	set lockfile "${qdir}/${locktype}${labid}";
	# check if lock file exists.
	if {[file exists $lockfile]} {
		# lock exists
		return 0;
	}
	# create lock file - possible race condition ...
	set lockfd [open $lockfile "w"];
	puts $lockfd "$locktype - $labid - [pid] - [exec id] - [exec date]";
	close $lockfd;
	#
	if {[file owned $lockfile]} {
		system /usr/bin/chmod 0777 $lockfile;
	}
	# our turn
	return 1;
}
#
proc V { locktype labid } {
	global env;
	# sanity check
	if {![info exists env(LCSTOOLSQ)]} {
		puts "V: LCSTOOLSQ not defined.";
		exit 2;
	}
	# lock file
	set qdir $env(LCSTOOLSQ);
	set lockfile "${qdir}/${locktype}${labid}";
	# check if queue exists
	if {![file isdirectory $qdir]} {
		file mkdir $qdir;
		# puts "V: no lock $lockfile ...";
		return 1;
	}
	#
	if {[file owned $lockfile]} {
		system /usr/bin/chmod 0777 $lockfile;
	}
	# check if lock file exists.
	if {[file exists $lockfile]} {
		# puts "V: deleting lock $lockfile ...";
		file delete -force -- $lockfile;
	} else {
		# puts "V: no lock $lockfile ...";
	}
	return 1;
}
#
proc quietV { locktype labid } {
	global env;
	# sanity check
	if {![info exists env(LCSTOOLSQ)]} {
		exit 2;
	}
	# check if queue exists
	set qdir "$env(LCSTOOLSQ)";
	if {![file isdirectory $qdir]} {
		file mkdir $qdir;
		return 1;
	}
	# lock file
	set qdir $env(LCSTOOLSQ);
	set lockfile "${qdir}/${locktype}${labid}";
	#
	if {[file owned $lockfile]} {
		system /usr/bin/chmod 0777 $lockfile;
	}
	# check if lock file exists.
	if {[file exists $lockfile]} {
		file delete -force -- $lockfile;
	}
	return 1;
}
#
#
proc L { { all 0 } } {
	global env;
	# sanity check
	if {![info exists env(LCSTOOLSQ)]} {
		puts "L: LCSTOOLSQ not defined.";
		exit 2;
	}
	# check if queue exists
	set qdir "$env(LCSTOOLSQ)";
	if {![file isdirectory $qdir]} {
		file mkdir $qdir;
		# puts "L: no lock $qdir ...";
		return 1;
	}
	# list all locks
	puts "Current lock files:";
	#
	# OLD WAY - system /usr/bin/ls -l $qdir;
	#
	catch {
	if {$all != 0} {
		system "cd ${qdir}; for f in *; do echo; cat \$f; echo; /usr/bin/ls -l \$f; done";
	} else {
		system /usr/bin/ls -l $qdir;
	} } ignore;
	#
	return 1;
}
