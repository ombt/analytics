# execute cmds in scripts.
proc execcall { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
proc execftp { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
proc exectl1 { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
proc execksh { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
proc execsh { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
proc execrsh { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	return "0 - success";
}
#
proc execCmd { cfgdata section cmd xcmd } {
	upvar $cfgdata cfgd;
	#
	# get cmd type
	#
	set status [regexp $xcmd "^\[ \t]*(\[a-zA_Z0-9_]+)\ \t]+(.*)$" var0 cmdsuffix newxcmd];
	if {$status != 1} {
		return "-1 - execCmd: unknown cmd form: $xcmd";
	}
	#
	set cmd2exec exec$cmdsuffix;
	#
	set status [llength [info command $cmd2exec]];
	if {$status <= 0} {
		return "-1 - unknown cmd: $cmdsuffix.";
	} elseif {$status > 1} {
		return "-1 - ambiguous cmd: $cmdsuffix.";
	}
	#
	# run the command
	#
	set status [$cmd2exec cfgs $section $cmd $newxcmd];
	if {[isNotOk $status]} {
		return "-1 - execCmd: cmd $cmd ($cmd2exec) failed.\n$status";
	} else {
		return "0 - success";
	}
}
#
proc execScript { cfgdata {startsec ""} {startcmd 1} } {
	upvar $cfgdata cfgd;
	#
	# find the the section to execute.
	#
	if {[string length $startsec] <= 0} {
		# look for the first section, should be marked 
		# when data file was read in.
		#
		if {![info exists $cfgd(file,1stexecsec)]} {
			return "-1 - execScript: unknown 1st section to execute.";
		}
		#
		set execsec $cfgd(file,1stexecsec);
	} else {
		set execsec $startsec;
	}
	#
	# check start and end cmds
	#
	if {![info exists $cfgd($execsec)]} {
		return "-1 - execScript: section to execute $execsec does not exist.";
	}
	if {$startcmd < 1} {
		return "-1 - execScript: startcmd ($startcmd) less than 1.";
	}
	#
	if {![info exists $cfgd($execsec,lastcmd)]} {
		return "-1 - execScript: lastcmd for section $execsec is undefined.";
	}
	set lastcmd $cfgd($execsec,lastcmd);
	if {$lastcmd < 1} {
		return "-1 - execScript: lastcmd ($lastcmd) less than 1.";
	}
	if {$startcmd > $lastcmd} {
		return "-1 - execScript: startcmd ($startcmd) > lastcmd ($lastcmd)";
	}
	#
	# start executing the cmds
	#
	for {set cmdno $startcmd} {$cmdno<=$lastcmd} {incr cmdno} {
		if {![info exists $cfgd($execsec,$cmdno)]} {
			return "-1 - execScript: cmd $cmdno for section $execsec is undefined.";
		}
		set xcmd $cfgd($execsec,$cmdno);
		set status [execCmd cfgd $execsec $cmdno $xcmd];
		if {[isNotOk $status]} {
			return "-1 - execScript: cmd $cmdno failed.\n$status";
		}
	}
	#
	return "0 - success";
}
