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
proc filesub { cfgdata filename substring } {
	upvar $cfgdata cfgd;
	upvar $filename fname;
	#
	if {[string length $substring] <= 0} {
		return "-1 - filesub: null length substring.";
	}
	#
	set fname $substring;
	#
	while {[regexp "<(\[a-zA-Z0-9\.]+)>" $fname ignore var] == 1} {
		set cidx "file,$var";
		regsub -all -- "\\\." $cidx "," newcidx;
		set cidx $newcidx;
		#
		if {![info exists cfgd($cidx)]} {
			return "-1 - filesub: undefined variable $cidx";
		}
		regsub -all -- "<$var>" $fname $cfgd($cidx) newfname;
		set fname $newfname;
	}
	#
	return "0 - success";
}
#
proc readAndParseCfgDataFile { cfgdata cfgdidx block cfgfile } {
	upvar $cfgdata cfgd;
	upvar $cfgdidx cidx;
	upvar $block blk;
	#
	# basic sanity checks
	#
	if {[string length $cfgfile] <= 0} {
		return "-1 - readAndParseCfgDataFile: null length cfg filename.";
	}
	if {![file readable $cfgfile]} {
		return "-1 - readAndParseCfgDataFile: cfg file $cfgfile is not readable";
	}
	#
	# open file for read.
	#
	if {[catch {set fd [open $cfgfile "r"]} status]} {
		return "-1 - readAndParseCfgDataFile: unable to open $cfgfile for read: $status";
	}
	#
	# read in file and populate data structure
	#
	for {set lnno 1} {[gets $fd inbuf] > 0} {incr lnno} {
		# puts "File $cfgfile, Lnno $lnno: $inbuf";
		#
		# skip comments and white-space
		#
		switch -regexp -- ${inbuf} {
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
		set cmd [string trim $inbuf]
		#
		# parse command line.
		#
		if {[regexp -- {^([a-zA-Z_0-9]+)[ \t]+\{[ \t]*$} $cmd mstr submstr] == 1} {
			incr blk;
			if {[string length $submstr] <= 0} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: missing blockname at lnno $lnno in $cfgfile";
			}
			insertLastIndex cidx $submstr;
			# we need to know the type of section.
			if {$blk == 1} {
				set cfgd($cidx,requiretype) 1;
			} else {
				set cfgd($cidx,requiretype) 0;
			}
			set cfgd($cidx,maxcmd) 0;
		} elseif {[regexp -- {^\}[ \t]*$} $cmd mstr] == 1} {
			incr blk -1;
			if {$blk < 0} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: block level < 0 at lnno $lnno in $cfgfile";
			}
			if {$cfgd($cidx,requiretype) != 0} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: unknown block type for section $cidx at lnno $lnno in $cfgfile";
			}
			deleteLastIndex cidx;
		} elseif {[regexp -- {^source[ \t]+(.*)$} $cmd mstr submstr] == 1} {
			# read in another file
			set status [filesub cfgd newfilename $submstr];
			if {[isNotOk $status]} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: filesub failed at lnno $lnno in $cfgfile: \n$status";
			}
			set status [readAndParseCfgDataFile cfgd cidx blk $newfilename]
			if {[isNotOk $status]} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: readAndParseCfgDataFile failed at lnno $lnno in $cfgfile: \n$status";
			}
		} elseif {[string length $cidx] > 0} {
			if {[regexp -- {^([a-zA-Z_0-9]+)[ \t]+(.*)$} $cmd mstr submstr submstr2] != 1} {
				catch { close $fd; } ignore;
				return "-1 - readAndParseCfgDataFile: name-value error at lnno $lnno in $cfgfile";
			}
			if {$submstr == "type"} {
				if {$cfgd($cidx,requiretype) == 0} {
					catch { close $fd; } ignore;
					return "-1 - readAndParseCfgDataFile: type not allowed for $cidx at lnno $lnno in $cfgfile";
				} 
				set cfgd($cidx,requiretype) 0;
				# store type in cfg data
				set cfgd($cidx,type) $submstr2;
				puts "";
				puts "Name : <$cidx,type>";
				puts "Value: <$cfgd($cidx,type)>";
			} elseif {$cfgd($cidx,type) == "exec"} {
				incr cfgd($cidx,maxcmd);
				# store cmd in cfg data
				set cfgd($cidx,$cfgd($cidx,maxcmd)) "$submstr $submstr2";
				puts "";
				puts "Name : <$cidx,$cfgd($cidx,maxcmd)>";
				puts "Value: <$cfgd($cidx,$cfgd($cidx,maxcmd))>";
			} else {
				# store data in cfg data
				set cfgd($cidx,$submstr) $submstr2;
				puts "";
				puts "Name : <$cidx,$submstr>";
				puts "Value: <$cfgd($cidx,$submstr)>";
			}
		} else {
			catch { close $fd; } ignore;
			return "-1 - readAndParseCfgDataFile: name-value pair not in block at lnno $lnno in $cfgfile";
		}
	}
	catch { close $fd; } ignore;
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
#
proc readCfgDataFile { cfgdata cfgfile } {
	upvar $cfgdata cfgd;
	#
	set cfgdidx "";
	set block 0;
	#
	# start reading in data 
	#
	set status [readAndParseCfgDataFile cfgd cfgdidx block $cfgfile]
	if {[isNotOk $status]} {
		return "-1 - readCfgDataFile: readAndParseCfgDataFile failed: \n$status";
	} elseif {$block != 0} {
		return "-1 - readCfgDataFile: block level ($block) != 0 in $cfgfile";
	}
	#
	return "0 - success";
}
