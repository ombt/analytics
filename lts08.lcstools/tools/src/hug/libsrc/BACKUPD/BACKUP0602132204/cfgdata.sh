# maintain configuration data
proc deleteLastIndex { indices { separator "," } } {
	upvar $indices idx;
	if {[string length $idx] <= 0} {
		# nothing to do.
		return;
	}
	#
	set lidx [split $idx $separator];
	set lidxlen [llength $lidx];
	#
	if {$lidxlen == 1} {
		set idx "";
	} else {
		set lidxlen [expr $lidxlen-1];
		set lidx [lreplace $lidx $lidxlen $lidxlen];
		set idx [join $lidx $separator];
	}
}
#
proc insertLastIndex { indices { newindex "" } { separator "," } } {
	upvar $indices idx;
	if {[string length $idx] > 0} {
		append idx $separator $newindex;
	} else {
		set idx $newindex;
	}
}
#
proc initCfgData { cfgdata { cfgdatatype "unknown" } } {
	upvar $cfgdata cfgd;
	#
	# remove old data.
	#
	if {[info exists cfgd]} {
		foreach item [array names cfgd] {
			unset cfgd($item);
		}
		unset cfgd;
	}
	#
	# store type of data
	#
	set cfgd(file,type) ${cfgdatatype};
	#
	return "0 - success";
}
#
proc readCfgDataFile { cfgdata cfgfile } {
	upvar $cfgdata cfgd;
	#
	# basic sanity checks
	#
	if {[string length $cfgfile] <= 0} {
		return "-1 - readCfgDataFile: invalid cfg filename.";
	}
	if {![file readable $cfgfile]} {
		return "-1 - readCfgDataFile: cfg file $cfgfile is not readable";
	}
	#
	# open file for read.
	#
	if {[catch {set fd [open $cfgfile "r"]} status]} {
		return "-1 - readCfgDataFile: unable to open $cfgfile for read: $status";
	}
	#
	# read in file and populate data structure
	#
	for {set maxidx 1} {[gets $fd inbuf] > 0} {incr maxidx} {
		set cmds($maxidx) $inbuf;
	}
	catch { close $fd; } ignore;
	#
	# populate cfg data
	#
	set indices "";
	set blocklevel 0;
	#
	for {set idx 1} {$idx<=$maxidx} {incr idx} {
		set cmd $cmds($idx);
		#
		# skip comments and white-space
		#
		switch -regexp -- ${cmd} {
		{^[ \t]*$} {
			# skip empty lines
			continue;
		}
		{^[ \t]*#} {
			# skip comments
			continue;
		}
		}
		#
		# strip leading white space
		#
		set cmd [string trim $cmd]
		#
		# check for start and end of blocks
		#
		if {[regexp -- {^([a-zA-Z_0-9]+)[ \t]+\{[ \t]*$} $cmd mstr submstr] == 1} {
			incr blocklevel;
			if {[string length $submstr] <= 0} {
				return "-1 - readCfgDataFile: missing blockname at lnno $idx";
			}
			insertLastIndex indices $submstr;
		} elseif {[regexp -- {^\}[ \t]*$} $cmd mstr] == 1} {
			incr blocklevel -1;
			if {$blocklevel < 0} {
				return "-1 - readCfgDataFile: block level < 0 at lnno $idx";
			}
			deleteLastIndex indices;
		} elseif {[string length $indices] > 0} {
			if {[regexp -- {^([a-zA-Z_0-9]+)[ \t]+(.*)$} $cmd mstr submstr submstr2] == 1} {
				# store data in cfg data
				set cfgd($indices,$submstr) $submstr2;
				puts "Name($idx) : <$indices,$submstr>";
				puts "Value($idx): <$cfgd($indices,$submstr)>";
			} else {
				puts "readCfgDataFile: name-value error at lnno $idx";
				return "-1 - readCfgDataFile: name-value error at lnno $idx";
			}
		} else {
			return "-1 - readCfgDataFile: name-value pair not in block at lnno $idx";
		}
	}
	#
	if {$blocklevel != 0} {
		return "-1 - readCfgDataFile: block level ($blocklevel) != 0 at lnno $idx";
	}
	#
	return "0 - success";
}
#
proc auditCfgData { cfgdata } {
	upvar $cfgdata cfgd;
	#
	return "0 - success";
}
#
proc printCfgData { cfgdata } {
	upvar $cfgdata cfgd;
	#
	if {[info exists cfgd]} {
		puts "\nContents of CfgData:";
		foreach item [lsort [array names cfgd]] {
			puts "cfgdata\($item\): $cfgd($item)";
		}
	}
	#
	return "0 - success";
}
