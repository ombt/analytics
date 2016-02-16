# functions related to hardware maintenance
package provide hwmaint 1.0
#
package require db
package require cleis
package require checkretval
package require mgcips
#
# minimal set of flash partitions to update for each iom type.
#
set flashparts(minimal,ana) "kdi";
set flashparts(minimal,atmds3) "kdi";
set flashparts(minimal,cm) "kdi";
set flashparts(minimal,cpu) "kdi";
set flashparts(minimal,debug_cpu) "kdi";
set flashparts(minimal,ds1) "kdi";
set flashparts(minimal,ds1_2) "kdi";
set flashparts(minimal,ds3) "kdi";
set flashparts(minimal,e1) "kdi";
set flashparts(minimal,ena) "ife efe kdi";
set flashparts(minimal,ena2) "ife efe kdi";
set flashparts(minimal,octds3) "kdi";
set flashparts(minimal,octds3_2) "kdi";
set flashparts(minimal,octds3_3) "kdi";
set flashparts(minimal,pna) "kdi";
set flashparts(minimal,tdmoc) "kdi";
set flashparts(minimal,trids3) "kdi";
set flashparts(minimal,trids3_3) "kdi";
set flashparts(minimal,voip) "kdi";
set flashparts(minimal,voip6) "kdi";
set flashparts(minimal,vs2) "kdi";
set flashparts(minimal,vs3) "kdi";
#
# clean up routine ...
#
proc hw_maint_close { spawn_id } {
	catch { send "exit\r"; sleep 0.5; } ignore;
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
	return;
}
#
proc hw_maint_close_all { spids } {
	upvar $spids spawn_ids;
	foreach resource [array names spawn_ids] {
		set spawn_id $spawn_ids($resource);
		hw_maint_close $spawn_id;
	}
	return;
}
#
# telnet interface 
#
proc hw_maint_telnet_open { spid spip username passwd { timeout 30 } { maxlogons 5 } } {
	upvar $spid spawn_id;
	#
	for {set i 0} {$i<$maxlogons} {incr i} {
		spawn -noecho "/usr/bin/telnet" $spip;
		#
		expect {
		"Connected to " {
			# ok
			break;
		}
		"Connection refused" {
			hw_maint_close $spawn_id;
			puts "\nConnection refused. Sleep and retry.";
			sleep 5;
		}
		timeout {
			hw_maint_close $spawn_id;
			puts "\nTime out. Sleep and retry.";
			sleep 5;
		}
		eof {
			hw_maint_close $spawn_id;
			puts "\nEOF. Sleep and retry.";
			sleep 5;
		}
		}
	}
	if {$i>=$maxlogons} {
		puts "\nUnable to telnet to ($spip,$username).";
		return "-1 - unable to telnet to $spip";
	} else {
		puts "\nTelnet to ($spip,$username) succeeded.";
	}
	#
	expect {
	"user name:" {
		send "$username\r";
	}
	timeout {
		hw_maint_close $spawn_id;
		return "-1 - username timeout for $spip";
	}
	eof {
		hw_maint_close $spawn_id;
		return "-1 - username eof for $spip";
	}
	}
	#
	expect {
	"password:" {
		send "$passwd\r";
	}
	timeout {
		hw_maint_close $spawn_id;
		return "-1 - passwd timeout for $spip";
	}
	eof {
		hw_maint_close $spawn_id;
		return "-1 - passwd eof for $spip";
	}
	}
	#
	expect {
	-re "\[a-z]*\[0-9]+\[ab]#" {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	-re "\[a-zA-Z0-9_-]+#" {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	-re "\[uU]nnamed_\[Ss]ystem#" {
		puts "WARNING: UNIX is active, but 'unnamed_system' prompt was received.";
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	timeout {
		hw_maint_close $spawn_id;
		return "-1 - PS1 timeout for $spip";
	}
	eof {
		hw_maint_close $spawn_id;
		return "-1 - PS1 eof for $spip";
	}
	}
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		hw_maint_close $spawn_id;
		return "-1 - hw_telnet_open: new PS1 timeout for $spip";
	}
	eof {
		hw_maint_close $spawn_id;
		return "-1 - hw_telnet_open: new PS1 eof for $spip";
	}
	}
	#
	return "0 - success";
}
#
proc hw_maint_telnet_exec { spid cmd { timeout 60 } } {
	upvar ${spid} spawn_id;
	#
	log_user 1;
	send "${cmd}\r";
	#
	expect {
	-re {.*STATUS=([-0-9]+)[\r\n]*COMMAND_IS_DONE>} {
		log_user 0;
		puts "\nStatus is $expect_out(1,string)";
		set status $expect_out(1,string);
		if {[isNotOk $status]} {
			return "-1 - cmd failed with status $status:\n$cmd";
		} else {
			return "0 - cmd failed with status $status:\n$cmd";
		}
	}
	-re {.*[\r\n]COMMAND_IS_DONE>} {
		send "echo STATUS=$?\r";
		exp_continue;
	}
	timeout {
		log_user 0;
		return "-1 - timeout during cmd:\n$cmd";
	}
	eof {
		log_user 0;
		return "-1 - timeout during cmd:\n$cmd";
	}
	}
	#
	log_user 0;
	return "0 - success";
}
#
proc hw_maint_sfui { spid iom { timeout 30 } } {
	upvar ${spid} spawn_id;
	#
	log_user 1;
	send "/Telica/swCPU/CurrRel/system/sfui\r";
	#
	expect {
	-re {sfui> } {
		send "port ${iom} set\r";
	}
	timeout {
		log_user 0;
		return "-1 - timeout during sfui.";
	}
	eof {
		log_user 0;
		return "-1 - eof during sfui.";
	}
	}
	#
	expect {
	-re {sfui> } {
		send "mlw ${iom} 0x50000030 0x2\r";
	}
	timeout {
		log_user 0;
		return "-1 - timeout during port.";
	}
	eof {
		log_user 0;
		return "-1 - eof during port.";
	}
	}
	expect {
	-re {sfui> } {
		send "quit\r";
	}
	timeout {
		log_user 0;
		return "-1 - timeout during mlw.";
	}
	eof {
		log_user 0;
		return "-1 - eof during mlw.";
	}
	}
	expect {
	-re {.*[\r\n]COMMAND_IS_DONE>} {
		# ok;
	}
	timeout {
		log_user 0;
		return "-1 - timeout during quit";
	}
	eof {
		log_user 0;
		return "-1 - eof during quit.";
	}
	}
	#
	log_user 0;
	puts "";
	return "0 - success";
}
#
# determine active SP and open a TL1 session.
#
proc hw_maint_tl1_open { spid spaip spbip username passwd { tmout 15 } {maxlogons 5 } { tl1port 2361 } } {
	upvar $spid spawn_id;
	#
	# try both IPs to find active SP.
	#
	set foundactive 0;
	#
	foreach spip [list $spaip $spbip] {
		puts "\nTrying to telnet to IP $spip.";
		#
		for {set i 0} {$i<$maxlogons} {incr i} {
			spawn -noecho "/usr/bin/telnet" $spip $tl1port;
			#
			expect {
			"Connected to " {
				# ok
				break;
			}
			"Connection refused" {
				hw_maint_close $spawn_id;
				puts "\nConnection refused. Sleep and retry.";
				sleep 5;
			}
			timeout {
				hw_maint_close $spawn_id;
				puts "\nTime out. Sleep and retry.";
				sleep 5;
			}
			eof {
				hw_maint_close $spawn_id;
				puts "\nEOF. Sleep and retry.";
				sleep 5;
			}
			}
		}
		if {$i>=$maxlogons} {
			puts "\nUnable to telnet to ($spip,$username).";
			continue;
		} else {
			puts "\nTelnet to ($spip,$username) succeeded.";
		}
		#
		sleep 2;
		#
		send "\r";
		expect {
		"Telica>" {
			# ok
		}
		timeout {
			hw_maint_close $spawn_id;
			puts "\nTimeout waiting for Telica prompt ($spip,$username).";
			continue;
		}
		eof {
			hw_maint_close $spawn_id;
			puts "\nEOF waiting for Telica prompt ($spip,$username).";
			continue;
		}
		}
		#
		send "act-user::${username}:::${passwd};\r";
		#
		expect {
		-re "This is the WORKING System Processor.*M.*\[0-9]+.*COMPLD.*;\r\nTelica>" {
			puts "\nCOMPLETED received for ($spip,$username).";
			set foundactive 1;
			break;
		}
		-re "Host is in Standby Mode.*;\r\nTelica>" {
			puts "\nHost is in Standby Mode ($spip,$username).";
			hw_maint_close $spawn_id;
			continue;
		}
		-re "This is the PROTECTION System Processor.*;\r\nTelica>" {
			puts "\nThis is the PROTECTION System Processor ($spip,$username).";
			hw_maint_close $spawn_id;
			continue;
		}
		-re "Login Not Active.*;\r\nTelica>" {
			puts "\nLogin Not Active ($spip,$username).";
			hw_maint_close $spawn_id;
			continue;
		}
		-re "Can't login.*;\r\nTelica>" {
			puts "\nCan't login ($spip,$username).";
			hw_maint_close $spawn_id;
			continue;
		}
		-re ".*;\r\nTelica>" {
			puts "\nUnknown error ($spip,$username).";
			hw_maint_close $spawn_id;
			continue;
		}
		timeout {
			puts "\ntimeout waiting for a response ...";
			hw_maint_close $spawn_id;
			continue;
		}
		eof {
			puts "\neof waiting for a response ...";
			hw_maint_close $spawn_id;
			continue;
		}
		}
	}
	# check if were able to logon TL1.
	if {$foundactive} {
		return "0 - success";
	} else {
		return "-1 - unable to logon TL1";
	}
}
#
# get chassis data via rtrv-eqpt
#
proc hw_maint_rtrv_eqpt { spid dname } {
	upvar $spid spawn_id;
	upvar $dname data;
	#
	log_user 1;
	send "RTRV-EQPT;\r";
	#
	# exp_internal 1;
	#
	expect {
	-re "IOM-(\[0-9]+):(\[^,]*),(\[^,]*),\[^,]*,\[^,]*,\[^,]*,(\[^,]*):(\[A-Z0-9,&-]+)\"" {
		set iom $expect_out(1,string);
		set clei [string tolower $expect_out(2,string)];
		set protection [string tolower $expect_out(3,string)];
		set version $expect_out(4,string);
		#
		puts "";
		puts "IOM-$iom $expect_out(2,string) ...";
		puts "IOM-$iom $expect_out(3,string) ...";
		puts "IOM-$iom $expect_out(4,string) ...";
		puts "IOM-$iom $expect_out(5,string) ...";
		#
		regsub -all -- "\[-,&]" $expect_out(5,string) "" iomstate;
		set iomstate [string tolower $iomstate];
		set clei [string tolower $clei];
		set protection [string tolower $protection];
		set version [string tolower $version];
		#
		set data(iom,$iom,state) $iomstate;
		set data(iom,$iom,clei) $clei;
		set data(iom,$iom,protection) $protection;
		set data(iom,$iom,version) $version;
		exp_continue;
	}
	-re "SP-A:\[^\"]*:(IS,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-A $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,a,state) $spstate;
		exp_continue;
	}
	-re "SP-A:\[^\"]*:(OOS,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-A $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,a,state) $spstate;
		exp_continue;
	}
	-re "SP-A:\[^\"]*:(OOS-(AU|MA)*,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-A $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,a,state) $spstate;
		exp_continue;
	}
	-re "SP-B:\[^\"]*:(IS,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-B $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,b,state) $spstate;
		exp_continue;
	}
	-re "SP-B:\[^\"]*:(OOS,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-B $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,b,state) $spstate;
		exp_continue;
	}
	-re "SP-B:\[^\"]*:(OOS-(AU|MA)*,(\[A-Z&]+))\"" {
		puts "";
		puts "SP-B $expect_out(1,string) ...";
		regsub -all -- "\[-,&]" $expect_out(1,string) "" spstate;
		set spstate [string tolower $spstate];
		set data(sp,b,state) $spstate;
		exp_continue;
	}
	-re ";\r\nTelica>" {
		# done
		puts "";
		puts "RTRV-EQPT Done.";
	}
	timeout {
		puts "";
		puts "RTRV-EQPT timeout";
		return "-1 - RTRV-EQPT timeout";
	}
	eof {
		puts "";
		puts "RTRV-EQPT EOF";
		log_user 0;
		return "-1 - RTRV-EQPT EOF";
	}
	}
	log_user 0;
	#
	# exp_internal 0;
	#
	return "0 - success";
}
#
# retrieve all alarms
#
proc hw_maint_rtrv_alm_all { spid } {
	upvar $spid spawn_id;
	#
	log_user 1;
	catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
	} } ignore;
	log_user 0;
	#
	return "0 - success";
}
#
# remove all IOMs
#
proc hw_maint_rmv_all_ioms { labid spaip spbip username passwd { maxiom 17 } { polltime 30 } { maxtime 1200 } { maxresets 5 } } {
	# open active TL1 port 
	puts "\nOpening TL1 session for ($labid,$spaip,$spbip).";
	set status [hw_maint_tl1_open spid $spaip $spbip $username $passwd]
	if {[isNotOk $status]} {
		return "-1 - hw_maint_rmv_all_ioms: hw_maint_tl1_open failed:\n${status}";
	}
	set spawn_id $spid;
	# init some data
	puts "\nInitializing ${labid} RMV-EQPT data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,rmvstate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# remove the IOMs
	puts "\nStart ${labid} RMV-EQPT cycle.";
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set prirmvsinprog 0;
		set secrmvsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get IOM statuses.";
		set status [hw_maint_rtrv_eqpt spid data];
		if {[isNotOk $status]} {
			hw_maint_close $spid;
			return "-1 - hw_maint_rmv_all_ioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# remove any secondary IOMs
		puts "\nHandle RMV-EQPT of ${labid} Secondary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is secondary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "sec"} {
				continue;
			}
			# check state of remove
			puts "\nChecking secondary IOM-$iom.";
			if {$data(iom,$iom,rmvstate) == "NOTSTARTED"} {
				# check if IOM is already OOS
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nIOM-$iom already OOS.";
					set data(iom,$iom,rmvstate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re "DENY.*Not in Valid State.*;\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom NOT-IN-VALID STATE. Retry.";
					incr data(iom,$iom,resetcounter);
					if {$data(iom,$iom,resetcounter) > $maxresets} {
						puts "\nERROR: Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
						# try to get alarms
						log_user 1;
						catch {
						send "RTRV-ALM-ALL;\r";
						expect {
						-re ";\r\nTelica>" { }
						timeout { }
						eof { }
						} } ignore;
						log_user 0;
						hw_maint_close $spid;
						return "-1 - Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
					}
					# increment secrmvsinprog so we retry
					# again. see below.
				}
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				eof {
					puts "\nERROR: RMV-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr secrmvsinprog;
				log_user 0;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT (oosma) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumaflt"} {
					puts "\nFinished RMV-EQPT of (oosaumaflt) IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} else {
					puts "\nIn Prog RMV-EQPT of IOM-$iom.";
					incr secrmvsinprog;
				}
			} elseif {$data(iom,$iom,rmvstate) == "DONE"} {
				# ok
				puts "\nDone RMV-EQPT of IOM-$iom.";
			}
		}
		#
		if {$secrmvsinprog > 0} {
			# let secondary removes finish before starting
			# to remove primaries.
			puts "\nSecondary RMV-EQPT still in prog ... skip primary for now.";
			incr maxiters -1;
			continue;
		}
		# remove any primary IOMs
		puts "\nHandle RMV-EQPT of ${labid} Primary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is primary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "pri"} {
				continue;
			}
			# check state of remove
			puts "\nChecking primary IOM-$iom.";
			if {$data(iom,$iom,rmvstate) == "NOTSTARTED"} {
				# check if IOM is already OOS
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nIOM-$iom already OOS.";
					set data(iom,$iom,rmvstate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re "DENY.*Not in Valid State.*;\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom NOT-IN-VALID STATE. Retry.";
					incr data(iom,$iom,resetcounter);
					if {$data(iom,$iom,resetcounter) > $maxresets} {
						puts "\nERROR: Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
						log_user 1;
						catch {
						send "RTRV-ALM-ALL;\r";
						expect {
						-re ";\r\nTelica>" { }
						timeout { }
						eof { }
						} } ignore;
						log_user 0;
						hw_maint_close $spid;
						return "-1 - Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
					}
					# increment prirmvsinprog so we retry
					# again. see below.
				}
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				eof {
					puts "\nERROR: RMV-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr prirmvsinprog;
				log_user 0;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT (oosma) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumaflt"} {
					puts "\nFinished RMV-EQPT (oosaumaflt) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} else {
					puts "\nIn Prog RMV-EQPT of IOM-$iom.";
					incr prirmvsinprog;
				}
			} elseif {$data(iom,$iom,rmvstate) == "DONE"} {
				# ok
				puts "\nDone RMV-EQPT of IOM-$iom.";
			}
		}

		# check if in any rmvs are still going.
		if {$secrmvsinprog == 0 && $prirmvsinprog == 0} {
			set done 1;
			set polltime 0;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms.
		log_user 1;
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		log_user 0;
		# close TL1 session
		hw_maint_close $spid;
		puts "ERROR: time out. unable to remove all IOMs";
		return "-1 - time out. unable to remove all IOMs";
	} else {
		# close TL1 session
		hw_maint_close $spid;
		return "0 - success";
	}
}
#
# restore all IOMs
#
proc hw_maint_rst_all_ioms { labid spaip spbip username passwd { maxiom 17 } { polltime 30 } { maxtime 900 } { maxresets 5 } } {
	# open active TL1 port 
	puts "\nOpening TL1 session for ($labid,$spaip,$spbip).";
	set status [hw_maint_tl1_open spid $spaip $spbip $username $passwd]
	if {[isNotOk $status]} {
		return "-1 - hw_maint_rst_all_ioms: hw_maint_tl1_open failed:\n${status}";
	}
	set spawn_id $spid;
	# init some data
	puts "\nInitializing ${labid} RST-EQPT data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,rststate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# restore the IOMs
	puts "\nStart ${labid} RST-EQPT cycle.";
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set prirstsinprog 0;
		set secrstsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get ${labid} IOM statuses.";
		set status [hw_maint_rtrv_eqpt spid data];
		if {[isNotOk $status]} {
			return "-1 - hw_maint_rst_all_ioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# restore any secondary IOMs
		puts "\nHandle RST-EQPT of ${labid} Secondary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is secondary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "sec"} {
				continue;
			}
			# check state of restore
			puts "\nChecking secondary IOM-$iom.";
			if {$data(iom,$iom,rststate) == "NOTSTARTED"} {
				# check if IOM is already IS,ACT
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nIOM-$iom already IS,ACT.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RST-EQPT of IOM-$iom.";
				send "RST-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRST-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRST-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: RST-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RST-EQPT::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,rststate) "INPROG";
				incr secrstsinprog;
			} elseif {$data(iom,$iom,rststate) == "INPROG"} {
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nFinished RST-EQPT of IOM-$iom.";
					set data(iom,$iom,rststate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} else {
					puts "\nIn Prog RST-EQPT of IOM-$iom.";
					incr secrstsinprog;
				}
			} elseif {$data(iom,$iom,rststate) == "DONE"} {
				# ok
				puts "\nDone RST-EQPT of IOM-$iom.";
			}
		}
		#
		if {$secrstsinprog > 0} {
			# let secondary removes finish before starting
			# to remove primaries.
			puts "\nSecondary RST-EQPT still in prog ... skip primary for now.";
			incr maxiters -1;
			continue;
		}
		# remove any primary IOMs
		puts "\nHandle RST-EQPT of ${labid} Primary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is primary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "pri"} {
				continue;
			}
			# check state of remove
			puts "\nChecking primary IOM-$iom.";
			if {$data(iom,$iom,rststate) == "NOTSTARTED"} {
				# check if IOM is already IS,ACT
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nIOM-$iom already IS,ACT.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RST-EQPT of IOM-$iom.";
				send "RST-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRST-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRST-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: RST-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RST-EQPT::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,rststate) "INPROG";
				incr prirstsinprog;
			} elseif {$data(iom,$iom,rststate) == "INPROG"} {
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nFinished RST-EQPT of IOM-$iom.";
					set data(iom,$iom,rststate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} else {
					puts "\nIn Prog RST-EQPT of IOM-$iom.";
					incr prirstsinprog;
				}
			} elseif {$data(iom,$iom,rststate) == "DONE"} {
				# ok
				puts "\nDone RST-EQPT of IOM-$iom.";
			}
		}

		# check if in any rsts are still going.
		if {$secrstsinprog == 0 && $prirstsinprog == 0} {
			set done 1;
			set polltime 0;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms
		log_user 1;
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		log_user 0;
		# close TL1 session
		hw_maint_close $spid;
		puts "ERROR: time out. unable to restore all IOMs";
		return "-1 - time out. unable to restore all IOMs";
	} else {
		# close TL1 session
		hw_maint_close $spid;
		return "0 - success";
	}
}
#
# remove all IOMs
#
proc hw_maint_rmvallioms { spid { maxiom 17 } { polltime 30 } { maxtime 1200 } { maxresets 5 } } {
	upvar $spid spawn_id;
	# init some data
	puts "\nInitializing RMV-EQPT data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,rmvstate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# remove the IOMs
	puts "\nStart RMV-EQPT cycle.";
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set prirmvsinprog 0;
		set secrmvsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get IOM statuses.";
		set status [hw_maint_rtrv_eqpt spawn_id data];
		if {[isNotOk $status]} {
			return "-1 - hw_maint_rmvallioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# remove any secondary IOMs
		puts "\nHandle RMV-EQPT of Secondary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is secondary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "sec"} {
				continue;
			}
			# check state of remove
			puts "\nChecking secondary IOM-$iom.";
			if {$data(iom,$iom,rmvstate) == "NOTSTARTED"} {
				# check if IOM is already OOS
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nIOM-$iom already OOS.";
					set data(iom,$iom,rmvstate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re "DENY.*Not in Valid State.*;\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom NOT-IN-VALID STATE. Retry.";
					incr data(iom,$iom,resetcounter);
					if {$data(iom,$iom,resetcounter) > $maxresets} {
						puts "\nERROR: Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
						# try to get alarms
						log_user 1;
						catch {
						send "RTRV-ALM-ALL;\r";
						expect {
						-re ";\r\nTelica>" { }
						timeout { }
						eof { }
						} } ignore;
						log_user 0;
						hw_maint_close $spid;
						return "-1 - Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
					}
					# increment secrmvsinprog so we retry
					# again. see below.
				}
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				eof {
					puts "\nERROR: RMV-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr secrmvsinprog;
				log_user 0;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT (oosma) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumaflt"} {
					puts "\nFinished RMV-EQPT (oosaumaflt) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} else {
					puts "\nIn Prog RMV-EQPT of IOM-$iom.";
					incr secrmvsinprog;
				}
			} elseif {$data(iom,$iom,rmvstate) == "DONE"} {
				# ok
				puts "\nDone RMV-EQPT of IOM-$iom.";
			}
		}
		#
		if {$secrmvsinprog > 0} {
			# let secondary removes finish before starting
			# to remove primaries.
			puts "\nSecondary RMV-EQPT still in prog ... skip primary for now.";
			incr maxiters -1;
			continue;
		}
		# remove any primary IOMs
		puts "\nHandle RMV-EQPT of Primary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is primary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "pri"} {
				continue;
			}
			# check state of remove
			puts "\nChecking primary IOM-$iom.";
			if {$data(iom,$iom,rmvstate) == "NOTSTARTED"} {
				# check if IOM is already OOS
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nIOM-$iom already OOS.";
					set data(iom,$iom,rmvstate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re "DENY.*Not in Valid State.*;\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom NOT-IN-VALID STATE. Retry.";
					incr data(iom,$iom,resetcounter);
					if {$data(iom,$iom,resetcounter) > $maxresets} {
						puts "\nERROR: Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
						# try to get alarms
						log_user 1;
						catch {
						send "RTRV-ALM-ALL;\r";
						expect {
						-re ";\r\nTelica>" { }
						timeout { }
						eof { }
						} } ignore;
						log_user 0;
						hw_maint_close $spid;
						return "-1 - Maximum attempts of RMV-EQPT::IOM-$iom exceeded.";
					}
					# increment prirmvsinprog so we retry
					# again. see below.
				}
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
					set data(iom,$iom,rmvstate) "INPROG";
				}
				eof {
					puts "\nERROR: RMV-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr prirmvsinprog;
				log_user 0;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT (oosma) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumaflt"} {
					puts "\nFinished RMV-EQPT (oosaumaflt) of IOM-$iom.";
					set data(iom,$iom,rmvstate) "DONE";
				} else {
					puts "\nIn Prog RMV-EQPT of IOM-$iom.";
					incr prirmvsinprog;
				}
			} elseif {$data(iom,$iom,rmvstate) == "DONE"} {
				# ok
				puts "\nDone RMV-EQPT of IOM-$iom.";
			}
		}

		# check if in any rmvs are still going.
		if {$secrmvsinprog == 0 && $prirmvsinprog == 0} {
			set done 1;
			set polltime 0;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		puts "ERROR: time out. unable to remove all IOMs";
		return "-1 - time out. unable to remove all IOMs";
	} else {
		return "0 - success";
	}
}
#
# restore all IOMs
#
proc hw_maint_rstallioms { spid { maxiom 17 } { polltime 30 } { maxtime 900 } { maxresets 5 } } {
	upvar $spid spawn_id;
	# init some data
	puts "\nInitializing RST-EQPT data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,rststate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# restore the IOMs
	puts "\nStart RST-EQPT cycle.";
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set prirstsinprog 0;
		set secrstsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get IOM statuses.";
		set status [hw_maint_rtrv_eqpt spawn_id data];
		if {[isNotOk $status]} {
			return "-1 - hw_maint_rstallioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# restore any secondary IOMs
		puts "\nHandle RST-EQPT of Secondary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is secondary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "sec"} {
				continue;
			}
			# check state of restore
			puts "\nChecking secondary IOM-$iom.";
			if {$data(iom,$iom,rststate) == "NOTSTARTED"} {
				# check if IOM is already IS,ACT
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nIOM-$iom already IS,ACT.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RST-EQPT of IOM-$iom.";
				send "RST-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRST-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRST-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: RST-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RST-EQPT::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,rststate) "INPROG";
				incr secrstsinprog;
			} elseif {$data(iom,$iom,rststate) == "INPROG"} {
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nFinished RST-EQPT of IOM-$iom.";
					set data(iom,$iom,rststate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} else {
					puts "\nIn Prog RST-EQPT of IOM-$iom.";
					incr secrstsinprog;
				}
			} elseif {$data(iom,$iom,rststate) == "DONE"} {
				# ok
				puts "\nDone RST-EQPT of IOM-$iom.";
			}
		}
		#
		if {$secrstsinprog > 0} {
			# let secondary removes finish before starting
			# to remove primaries.
			puts "\nSecondary RST-EQPT still in prog ... skip primary for now.";
			incr maxiters -1;
			continue;
		}
		# remove any primary IOMs
		puts "\nHandle RST-EQPT of Primary IOMs.";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists and is primary
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			} elseif {$data(iom,$iom,protection) != "pri"} {
				continue;
			}
			# check state of remove
			puts "\nChecking primary IOM-$iom.";
			if {$data(iom,$iom,rststate) == "NOTSTARTED"} {
				# check if IOM is already IS,ACT
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nIOM-$iom already IS,ACT.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				}
				#
				log_user 1;
				puts "\nStart RST-EQPT of IOM-$iom.";
				send "RST-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRST-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRST-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: RST-EQPT::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - RST-EQPT::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,rststate) "INPROG";
				incr prirstsinprog;
			} elseif {$data(iom,$iom,rststate) == "INPROG"} {
				if {$data(iom,$iom,state) == "isact" || \
				    $data(iom,$iom,state) == "isactnbk" || \
				    $data(iom,$iom,state) == "isstbyh" || \
				    $data(iom,$iom,state) == "isstbyc"} {
					puts "\nFinished RST-EQPT of IOM-$iom.";
					set data(iom,$iom,rststate) "DONE";
				} elseif {$data(iom,$iom,state) == "oosaumea"} {
					puts "\nIOM-$iom already OOS-AU,MEA.";
					set data(iom,$iom,rststate) "DONE";
					continue;
				} else {
					puts "\nIn Prog RST-EQPT of IOM-$iom.";
					incr prirstsinprog;
				}
			} elseif {$data(iom,$iom,rststate) == "DONE"} {
				# ok
				puts "\nDone RST-EQPT of IOM-$iom.";
			}
		}

		# check if in any rsts are still going.
		if {$secrstsinprog == 0 && $prirstsinprog == 0} {
			set done 1;
			set polltime 0;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms
		log_user 1;
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		log_user 0;
		puts "ERROR: time out. unable to restore all IOMs";
		return "-1 - time out. unable to restore all IOMs";
	} else {
		return "0 - success";
	}
}
#
# get branch and cpu load from the active sp.
#
proc hw_maint_get_cpuload { labid spaip spbip username passwd argdata argbranch argcpuload } {
	upvar $argdata data;
	upvar $argbranch branch;
	upvar $argcpuload cpuload;
	#
	if {$data(sp,a,state) == "isact" || $data(sp,a,state) == "isactnbk"} {
		set activesp "a";
		set activeip $spaip;
	} elseif {$data(sp,b,state) == "isact" || $data(sp,b,state) == "isactnbk"} {
		set activesp "b";
		set activeip $spbip;
	} else {
		return "-1 - unable to determine active SP.";
	}
	# open a telnet session to active sp
	set status [hw_maint_telnet_open spawn_id $activeip $username $passwd];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_telnet_open failed:\n${status}";
	}
	# determine the current load and where it is stored.
	set done 0;
	send "cd /Telica/swCPU/CurrRel\r";
	expect {
	-nocase -re {file.*directory.*doesn't.*exist[^\r\n]*[\r\n]} {
		set branch "";
		set cpuload "";
		return "-1 - CurrRel does not exist";
	}
	-re {(/[^\r\n]*)[\r\n]} {
		set cpuload [file tail $expect_out(1,string)];
		exp_continue;
	}
	-re {COMMAND_IS_DONE>} {
		if {!$done} {
			incr done;
			send "pwd -P\r";
			exp_continue;
		}
	}
	timeout {
		hw_maint_close $spawn_id;
		return "-1 - cd CurrRel timed out:\n$status";
	}
	eof {
		hw_maint_close $spawn_id;
		return "-1 - cd CurrRel eof:\n$status";
	}
	}
	# get branch for this load.
	set status [dbselect obuf loads "cpuload req ^$cpuload\$" "branch"];
	if {[isNotOk $status]} {
		return "-1 - dbselect of relation 'loads' failed: \n${status}";
	}
	if {![info exists obuf] || [llength obuf] == 0} {
		return "-1 - No BRANCH found for CPULOAD $cpuload.";
	}
	set branch [lindex $obuf 0];
	#
	hw_maint_close $spawn_id;
	return "0 - success";
}
#
# rsh to an IOM interface
#
proc hw_maint_iom_rsh_open { spid ip { timeout 30 } } {
	upvar $spid spawn_id;
	#
	set firsttime 1;
	#
	log_user 1;
	send "rsh ${ip}\r";
	expect {
	-re {.*# } {
		# ok;
		log_user 0;
		return "0 - success";
	}
	timeout {
		if {$firsttime} {
			send "\r";
			set firsttime 0;
			exp_continue;
		}
		log_user 0;
		return "-1 - timeout from rsh to ${ip}.";
	}
	eof {
		log_user 0;
		return "-1 - eof from rsh to ${ip}.";
	}
	}
}
#
proc hw_maint_iom_rsh_close { spid { timeout 30 } } {
	upvar $spid spawn_id;
	#
	log_user 1;
	#
	send "exit\r";
	expect {
	-re {.*COMMAND_IS_DONE>} {
		# ok.
		log_user 0;
		puts "";
		return "0 - success";
	}
	timeout {
		log_user 0;
		puts "";
		return "-1 - timeout from rsh exit.";
	}
	eof {
		log_user 0;
		puts "";
		return "-1 - eof from rsh exit.";
	}
	}
}
#
proc hw_maint_iom_rsh_exec { spid cmd { timeout 300 } } {
	upvar $spid spawn_id;
	#
	log_user 1;
	send "${cmd}\r";
	expect {
	-re {.*# } {
		# ok;
		log_user 0;
		return "0 - success";
	}
	timeout {
		log_user 0;
		return "-1 - timeout from cmd ${cmd}.";
	}
	eof {
		log_user 0;
		return "-1 - eof from cmd ${cmd}.";
	}
	}
}
#
# update ioms using update_flash_partition
#
proc hw_maint_update_ioms { labid spaip spbip { tl1username "telica" } { tl1passwd "telica" } { lynxusername "root" } { lynxpasswd "plexus9000" } { iomstates "oosma,oosaumaflt" } { iomlist "" } { maxiom 17 } } {
	#
	puts "\nAttempting to update ${labid} IOMS:";
	# sanity checks
	if {[string length $iomstates] == 0 && [string length $iomlist] == 0} {
		return "-1 - neither IOM states or IOM list was given.";
	}
	# open active TL1 port 
	puts "\nOpening TL1 session for ($labid,$spaip,$spbip).";
	set status [hw_maint_tl1_open tl1spid $spaip $spbip $tl1username $tl1passwd]
	if {[isNotOk $status]} {
		return "-1 - hw_maint_tl1_open failed:\n${status}";
	}
	# do a rtrv-eqpt to get status
	puts "\nCall RTRV-EQPT to get ${labid} IOM statuses.";
	set status [hw_maint_rtrv_eqpt tl1spid data];
	if {[isNotOk $status]} {
		hw_maint_close $tl1spid;
		return "-1 - hw_maint_rtrv_eqpt failed:\n${status}";
	}
	hw_maint_close $tl1spid;
	# generate list of IOMs to update
	set iomcnt 0;
	set checkstate 0;
	if {[string length $iomstates] > 0 && $iomstates != "*"} {
		puts "\nChecking list of IOMs against requested states: ${iomstates}";
		set statelist [split $iomstates ","];
		set checkstate 1;
	}
	if {[string length $iomlist] > 0} {
		puts "\nChecking the given list of IOMs: $iomlist";
		foreach iom [split $iomlist ","] {
			if {![info exists data(iom,$iom,protection)] || \
		     	     [string length $data(iom,$iom,protection)] <= 0} {
				puts "\nIOM $iom does not exist.";
				return "-1 - IOM $iom does not exist.";
			} elseif {$checkstate && [lsearch -exact $statelist $data(iom,$iom,state)] == -1} {
				# not in right state. skip it.
				continue;
			}
			incr iomcnt;
			set ioms($iomcnt) $iom;
		}
	} else {
		puts "\nDetermining list of available IOMs:";
		for {set iom 1} {$iom<=$maxiom} {incr iom} {
			# check if IOM exists 
			if {![info exists data(iom,$iom,protection)] || \
		     	     [string length $data(iom,$iom,protection)] <= 0} {
				continue;
			} elseif {$checkstate && [lsearch -exact $statelist $data(iom,$iom,state)] == -1} {
				# not in right state. skip it.
				continue;
			}
			incr iomcnt;
			set ioms($iomcnt) $iom;
		}
	}
	# any IOMs to update?
	if {$iomcnt <= 0} {
		puts "\nNO IOMs found to update.";
		return "0 - success. NO IOMs found to update.";
	} else {
		puts -nonewline "\n$iomcnt IOMs to update: ";
		for {set idx 1} {$idx<=$iomcnt} {incr idx} {
			puts -nonewline "$ioms($idx) ";
		}
		puts "";
	}
	# get branch and cpu load
	set status [hw_maint_get_cpuload $labid $spaip $spbip $lynxusername $lynxpasswd data branch cpuload];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_get_cpuload failed:\n${status}";
	}
	#
	set data(branch) $branch;
	set data(cpuload) $cpuload;
	puts "\nSwitch CPU load  : $data(cpuload)";
	puts   "Switch CPU branch: $data(branch)";
        # get text file system
	set status [dbselect fsobuf filesystems "branch req ^$branch\$ and type req text" "path"];
	if {[isNotOk $status]} {
		return "-1 - dbselect of relation 'filesystems' failed: \n${status}";
	}
	if {![info exists fsobuf] || [llength fsobuf] == 0} {
		return "-1 - no filesystem found for branch $branch.";
	}
	set filesystem [lindex $fsobuf 0];
	# get images
	set status [dbselect obuf images "branch req ^$branch\$ and cpuload req ^$cpuload\$" "type name"];
	if {[isNotOk $status]} {
		return "-1 - dbselect of relation 'images' failed: \n${status}";
	}
	if {![info exists obuf] || [llength obuf] == 0} {
		return "-1 - No images found for load: $braqnch, $cpuload.";
	}
	#
	puts "\nImages for $branch, $cpuload:";
	foreach tuple $obuf {
		set fields [split $tuple " \t"];
		set type [lindex $fields 0]
		set name [lindex $fields 1]
		set data(files,$type,path) "${filesystem}/${branch}/${type}";
		set data(files,$type,name) $name;
		#
		puts "\nType: $type";
		puts "Path: $data(files,$type,path)";
		puts "Name: $data(files,$type,name)";
	}
	# get files for updates
	global cleis;
	for {set idx 1} {$idx<=$iomcnt} {incr idx} {
		set iom $ioms($idx);
		set clei $data(iom,$iom,clei);
		#
		if {[info exists cleis($branch,$clei)]} {
			set type $cleis($branch,$clei);
		} elseif {[info exists cleis(default,$clei)]} {
			set type $cleis(default,$clei);
		} else {
			return "-1 - Unknown CLEI value $clei for IOM $iom";
		}
		lappend data(types) $type;
		lappend data($type,ioms) $iom;
		set data(iom,$iom,type) $type;
		#
		if {[info exists data(files,$type,name)]} {
			set data(iom,$iom,file) "$data(files,$type,path)/$data(files,$type,name)";;
		} else {
			set data(iom,$iom,file) "UNKNOWN";
		}
		#
		puts "\nIOM $iom data:";
		puts "CLEI: $data(iom,$iom,clei)";
		puts "Type ($branch): $data(iom,$iom,type)";
		puts "File ($branch): $data(iom,$iom,file)";
	}
	#
	puts -nonewline "\nIOM Types to Update:";
	foreach type [lsort $data(types)] {
		if {![info exists known($type)]} {
			lappend uniquetypes $type;
			set known($type) $type;
			puts -nonewline " $type";
		}
	}
	puts "";
	set data(types) $uniquetypes;
	# expand tar files
	puts "\nExpand tar files:";
	foreach type $data(types) {
		set tarpath $data(files,$type,path);
		set tarfilename $data(files,$type,name);
		set tarfile "${tarpath}/${tarfilename}";
		#
		puts "\nExpanding $tarfile (links only):"
		# log_user 1;
		spawn gnutar tzvf $tarfile;
		expect {
		-re {(Telica/sw[^ \t]*)[ \t]*->} {
			set linkpath $expect_out(1,string);
			set link [file tail $expect_out(1,string)];
			set ftype [string tolower [regsub -- {_bin} $link ""]];
			# KLUDGE - fix announcements
			if {$ftype == "announcement"} {
				set ftype "announcements";
			}
			puts "\nFPath: $linkpath";
			puts "FLink: $link";
			puts "FType: $ftype";
			#
			# vs3 contains two sets of tar files, so 
			# i have to append so that i don't lose
			# data. when the update command is finally 
			# constructed, then i have a kludge to handle
			# this special case. keep things as standardized
			# as long as possible.
			#
			lappend data(flinks,$type,$ftype) "/${linkpath}";
			lappend data(ftype,$type,$ftype) ${ftype};
			exp_continue;
		}
		timeout { puts "\ngnutar done (timeout)."; }
		eof { puts "\ngnutar done (eof)."; }
		}
		# log_user 0;
		hw_maint_close $spawn_id;
	}
	#
	# generate the commands to update each required flash partition
	# for each IOM.
	#
	puts "\nUpdating IOM Flash Partitions:";
	if {$data(sp,a,state) == "isact" || \
	    $data(sp,a,state) == "isactnbk"} {
		set activespip "192.168.252.26";
		set extactivespip $spaip;
	} elseif {$data(sp,b,state) == "isact" || \
	    $data(sp,b,state) == "isactnbk"} {
		set activespip "192.168.252.27";
		set extactivespip $spbip;
	} else {
		return "-1 - Unknown active SP.";
	}
	# open telnet port to active sp.
	set status [hw_maint_telnet_open spawn_id $extactivespip $lynxusername $lynxpasswd];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_telnet_open failed:\n${status}";
	}
	#
	global flashparts;
	global cm_cpu_ips;
	for {set idx 1} {$idx<=$iomcnt} {incr idx} {
		set iom $ioms($idx);
		set iomtype $data(iom,$iom,type);
		puts "";
		puts "IOM : $iom";
		puts "TYPE: $iomtype";
		if {$type == "cm"} {
			set mincpu 1;
			set maxcpu 4;
		} else {
			set mincpu 1;
			set maxcpu 1;
		}
		# do a sfui for this iom
		set status [hw_maint_sfui spawn_id $iom];
		if {[isNotOk $status]} {
			hw_maint_close $spawn_id;
			return "-1 - hw_maint_sfui failed:\n${status}";
		}
		# rsh to each cpu and update the silly thing.
		for {set cpu $mincpu} {$cpu<=$maxcpu} {incr cpu} {
			set rsh "rsh $cm_cpu_ips($iom,$cpu)";
			puts "\tIOM CPU: $cpu";
			puts "\tCPU IP : $cm_cpu_ips($iom,$cpu)";
			puts "\tRSH CMD: $rsh";
			#
			set status [hw_maint_iom_rsh_open spawn_id $cm_cpu_ips($iom,$cpu)];
			if {[isNotOk $status]} {
				hw_maint_close $spawn_id;
				return "-1 - hw_maint_iom_rsh_open failed:\n${status}";
			}
			# 
			foreach fp $flashparts(minimal,$iomtype) {
				set linkpath $data(flinks,$iomtype,$fp);
				set ftype $data(ftype,$iomtype,$fp);
				if {[llength $linkpath] > 1} {
					# KLUDGE - check if it's vs3.
					if {$type != "vs3"} {
						hw_maint_iom_rsh_close spawn_id;
						hw_maint_close $spawn_id;
						return "-1 - multiple files in one tar file, and not 'vs3'; it's $type.";
					}
					set lplen [llength $linkpath]]
					for {set l 0} {$l<$lplen} {incr l} {
						set lp [lindex $linkpath $l];
						set ft [lindex $ftype $l];
						if {[regexp -- {^.*swVS3PG.*$} $lp] == 1} {
							set linkpath $lp;
							set ftype $ft;
							break;
						}
					}
				}
				set updcmd "/application/update_flash_partition --v ${activespip} ${linkpath} ${ftype}";
				puts "\t\tFTYPE: $ftype";
				puts "\t\tFPATH: $linkpath";
				puts "\t\tUPD CMD: $updcmd";
				set status [hw_maint_iom_rsh_exec spawn_id $updcmd];
				if {[isNotOk $status]} {
					hw_maint_iom_rsh_close spawn_id;
					hw_maint_close $spawn_id;
					return "-1 - hw_maint_iom_rsh_exec failed:\n${status}";
				}
			}
			#
			hw_maint_iom_rsh_close spawn_id;
		}
	}
	# all done
	hw_maint_close $spawn_id;
	return "0 - success";
}
#
# cpy-mem all IOMs
#
proc hw_maint_cpymem_all_ioms { labid spaip spbip tl1username tl1passwd { recoverioms 0 } { lynxusername "root" } { lynxpasswd "plexus9000" } { maxcpymems 3 } { maxiom 17 } { polltime 30 } { maxtime 1800 } { maxresets 5 } } {
	# start cpy-mem process
	puts "\nStart ${labid} CPY-MEM cycle.";
	# open active TL1 port 
	puts "\nOpening TL1 session for ($labid,$spaip,$spbip).";
	set status [hw_maint_tl1_open spid $spaip $spbip $tl1username $tl1passwd]
	if {[isNotOk $status]} {
		return "-1 - hw_maint_cpymem_all_ioms: hw_maint_tl1_open failed:\n${status}";
	}
	set spawn_id $spid;
	# init some data
	puts "\nInitializing ${labid} CPY-MEM data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,cpymemstate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	puts "\nMaximum simultaneous CPM-MEMs is ${maxcpymems}";
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# verify all IOMs OOS. do a rtrv-eqpt to get status
	puts "\nCall RTRV-EQPT to get ${labid} IOM statuses.";
	set status [hw_maint_rtrv_eqpt spid data];
	if {[isNotOk $status]} {
		hw_maint_close $spid;
		return "-1 - hw_maint_cpymem_all_ioms: hw_maint_rtrv_eqpt failed:\n${status}";
	}
	#
	set notoosioms "";
	set iomcnt 0;
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		# check if IOM exists and is OOS
		if {![info exists data(iom,$iom,protection)] || \
		     [string length $data(iom,$iom,protection)] <= 0} {
			continue;
		} elseif {$data(iom,$iom,state) != "oosma" && \
			  $data(iom,$iom,state) != "oosaumaflt"} {
			set notoosioms "${notoosioms} ${iom}"
		}
		incr iomcnt;
		set ioms($iomcnt) $iom;
	}
	if {[string length "${notoosioms}"] > 0} {
		return "-1 - IOMs ${notoosioms} are not OOS,MA.";
	} elseif {$iomcnt <= 0} {
		return "-1 - NO IOMs found to CPY-MEM.";
	} else {
		puts -nonewline "\n$iomcnt IOMs to CPY-MEM are: ";
		for {set idx 1} {$idx<=$iomcnt} {incr idx} {
			puts -nonewline "$ioms($idx) ";
		}
		puts "";
	}
	# set the initial range of IOMs to cpy-mem
	set minidx 1;
	set maxidx $maxcpymems;
	if {$maxidx>$iomcnt} {
		set maxidx $iomcnt;
	}
	# start cpy-mems
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set cpymemsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get ${labid} IOM statuses.";
		set status [hw_maint_rtrv_eqpt spid data];
		if {[isNotOk $status]} {
			hw_maint_close $spid;
			return "-1 - hw_maint_cpymem_all_ioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# handle IOM cpy-mems
		puts "\nHandle CPY-MEMs of ${labid} IOMs.";
		for {set idx $minidx} {$idx<=$maxidx} {incr idx} {
			# current IOM
			set iom $ioms($idx);
			# check if IOM exists
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			}
			# check state of restore
			puts "\nChecking IOM-$iom.";
			if {$data(iom,$iom,cpymemstate) == "NOTSTARTED"} {
				puts "\nStart CPY-MEM of IOM-$iom.";
				log_user 1;
				send "CPY-MEM::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nCPY-MEM::IOM-$iom COMPLETED";
				}
				-re "<\r\nTelica>" {
					puts "\nCPY-MEM::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nCPY-MEM::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: CPY-MEM::IOM-$iom EOF";
					log_user 0;
					hw_maint_close $spid;
					return "-1 - CPY-MEM::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,cpymemstate) "INPROG";
				incr cpymemsinprog;
			} elseif {$data(iom,$iom,cpymemstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished CPY-MEM of IOM-$iom.";
					set data(iom,$iom,cpymemstate) "DONE";
				} else {
					puts "\nIn Prog CPY-MEM of IOM-$iom.";
					incr cpymemsinprog;
				}
			} elseif {$data(iom,$iom,cpymemstate) == "DONE"} {
				# ok
				puts "\nDone CPY-MEM of IOM-$iom.";
			}
		}
		#
		if {$cpymemsinprog > 0} {
			puts "\nCPY-MEMs still in prog ... ";
			incr maxiters -1;
			continue;
		}
		# done with one set of IOMs. reset IOM limits
		# for the next set, if it exists.
		incr minidx $maxcpymems;
		incr maxidx $maxcpymems;
		if {$minidx>$iomcnt} {
			# done
			set done 1;
			set polltime 0;
		} elseif {$maxidx>$iomcnt} {
			set maxidx $iomcnt;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms
		log_user 1;
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		log_user 0;
		# check if we should try to update manually
		if {!$recoverioms} {
			# don't attempt to recover
			# close TL1 session
			hw_maint_close $spid;
			return "-1 - time out. unable to CPY-MEM all IOMs";
		}
		# close existing tl1 session.
		hw_maint_close $spid;
		# try to manually update IOMS that are OOS and faulted.
		set status [hw_maint_update_ioms $labid $spaip $spbip $tl1username $tl1passwd $lynxusername $lynxpasswd]
		if {[isNotOk $status]} {
			return "-1 - unable to CPY-MEM all IOMs (update_flash_partition failed also)";
		}
	} else {
		# close TL1 session
		hw_maint_close $spid;
	}
	return "0 - success";
}
#
# cpy-mem all IOMs
#
proc hw_maint_cpymemallioms { spid { maxcpymems 3 } { recoverioms 0 } { maxiom 17 } { polltime 30 } { maxtime 1800 } { maxresets 5 } } {
	upvar $spid spawn_id;
	# init some data
	puts "\nInitializing CPY-MEM data.";
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		set data(iom,$iom,cpymemstate) "NOTSTARTED";
		set data(iom,$iom,resetcounter) 0;
	}
	puts "\nMaximum simultaneous CPM-MEMs is ${maxcpymems}";
	# maximum iterations to try
	set maxiters [expr ${maxtime}/${polltime}];
	# verify all IOMs OOS. do a rtrv-eqpt to get status
	puts "\nCall RTRV-EQPT to get IOM statuses.";
	set status [hw_maint_rtrv_eqpt spawn_id data];
	if {[isNotOk $status]} {
		hw_maint_close $spid;
		return "-1 - hw_maint_cpymemallioms: hw_maint_rtrv_eqpt failed:\n${status}";
	}
	#
	set notoosioms "";
	set iomcnt 0;
	for {set iom 1} {$iom<=$maxiom} {incr iom} {
		# check if IOM exists and is OOS
		if {![info exists data(iom,$iom,protection)] || \
		     [string length $data(iom,$iom,protection)] <= 0} {
			continue;
		} elseif {$data(iom,$iom,state) != "oosma" && \
			  $data(iom,$iom,state) != "oosaumaflt"} {
			set notoosioms "${notoosioms} ${iom}"
		}
		incr iomcnt;
		set ioms($iomcnt) $iom;
	}
	if {[string length "${notoosioms}"] > 0} {
		return "-1 - IOMs ${notoosioms} are not OOS,MA.";
	} elseif {$iomcnt <= 0} {
		return "-1 - NO IOMs found to CPY-MEM.";
	} else {
		puts -nonewline "\n$iomcnt IOMs to CPY-MEM are: ";
		for {set idx 1} {$idx<=$iomcnt} {incr idx} {
			puts -nonewline "$ioms($idx) ";
		}
		puts "";
	}
	# set the initial range of IOMs to cpy-mem
	set minidx 1;
	set maxidx $maxcpymems;
	if {$maxidx>$iomcnt} {
		set maxidx $iomcnt;
	}
	# start cpy-mems
	for {set done 0} { ! $done && $maxiters>0 } {sleep $polltime} {
		# counters
		set cpymemsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get IOM statuses.";
		set status [hw_maint_rtrv_eqpt spawn_id data];
		if {[isNotOk $status]} {
			hw_maint_close $spid;
			return "-1 - hw_maint_cpymemallioms: hw_maint_rtrv_eqpt failed:\n${status}";
		}
		# handle IOM cpy-mems
		puts "\nHandle CPY-MEMs of IOMs.";
		for {set idx $minidx} {$idx<=$maxidx} {incr idx} {
			# current IOM
			set iom $ioms($idx);
			# check if IOM exists
			if {![info exists data(iom,$iom,protection)]} {
				continue;
			}
			# check state of restore
			puts "\nChecking IOM-$iom.";
			if {$data(iom,$iom,cpymemstate) == "NOTSTARTED"} {
				puts "\nStart CPY-MEM of IOM-$iom.";
				log_user 1;
				send "CPY-MEM::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nCPY-MEM::IOM-$iom COMPLETED";
				}
				-re "<\r\nTelica>" {
					puts "\nCPY-MEM::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nCPY-MEM::IOM-$iom timeout";
				}
				eof {
					puts "\nERROR: CPY-MEM::IOM-$iom EOF";
					log_user 0;
					return "-1 - CPY-MEM::IOM-$iom EOF";
				}
				}
				log_user 0;
				set data(iom,$iom,cpymemstate) "INPROG";
				incr cpymemsinprog;
			} elseif {$data(iom,$iom,cpymemstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished CPY-MEM of IOM-$iom.";
					set data(iom,$iom,cpymemstate) "DONE";
				} else {
					puts "\nIn Prog CPY-MEM of IOM-$iom.";
					incr cpymemsinprog;
				}
			} elseif {$data(iom,$iom,cpymemstate) == "DONE"} {
				# ok
				puts "\nDone CPY-MEM of IOM-$iom.";
			}
		}
		#
		if {$cpymemsinprog > 0} {
			puts "\nCPY-MEMs still in prog ... ";
			incr maxiters -1;
			continue;
		}
		# done with one set of IOMs. reset IOM limits
		# for the next set, if it exists.
		incr minidx $maxcpymems;
		incr maxidx $maxcpymems;
		if {$minidx>$iomcnt} {
			# done
			set done 1;
			set polltime 0;
		} elseif {$maxidx>$iomcnt} {
			set maxidx $iomcnt;
		}
		incr maxiters -1;
	}
	#
	if {!$done} {
		# try to get alarms
		log_user 1;
		catch {
		send "RTRV-ALM-ALL;\r";
		expect {
		-re ";\r\nTelica>" { }
		timeout { }
		eof { }
		} } ignore;
		log_user 0;
		return "-1 - time out. unable to CPY-MEM all IOMs";
	} else {
		return "0 - success";
	}
}
#
# diagnose and attempt to recover sps
#
proc hw_maint_clear_console_users { { labid unknown } } {
	#
	foreach resource [list lynx-a lynx-b tl1-a tl1-b] {
		# check resource usage
		spawn -noecho rmstat -L ${labid} -t ${resource};
		expect {
		-re {rmstat.*Resource is not in use} {
			# ok;
			puts "\nResource ${resource} is free."
			continue;
		}
		-re "${resource}.*\[0-9]\[0-9]*.*pxmonitor" {
			puts "\nResource ${resource} is IN-USE."
			# kill user
		}
		-re {rmstat.*No such resource for your LABID} {
			puts "\nResource ${resource} not found for ${labid}";
			hw_maint_close $spawn_id;
			return "-1 - Resource ${resource} not found for ${labid}";
		}
		timeout {
			puts "\nTime out waiting for ${labid} ${resource}";
			hw_maint_close $spawn_id;
			return "-1 - Time out waiting for ${labid} ${resource}";
		}
		eof {
			puts "\nEOF waiting for ${labid} ${resource}";
			hw_maint_close $spawn_id;
			return "-1 - EOF waiting for ${labid} ${resource}";
		}
		}
		# remove users
		spawn -noecho pxreset -t ${resource} -L ${labid} -y;
		expect {
		-re "All.*interactive.*connections.*${resource}.*${labid}.*shutdown" {
			# ok;
			puts "\nResource ${resource} released via pxreset."
		}
		-re "ERROR.*No such resource has been configured" {
			puts "\nResource ${resource} not found for ${labid}";
			hw_maint_close $spawn_id;
			return "-1 - Resource ${resource} not found for ${labid}";
		}
		timeout {
			puts "\nTime out waiting for ${labid} ${resource}";
			hw_maint_close $spawn_id;
			return "-1 - Time out waiting for ${labid} ${resource}";
		}
		eof {
			puts "\nEOF waiting for ${labid} ${resource}";
			hw_maint_close $spawn_id;
			return "-1 - EOF waiting for ${labid} ${resource}";
		}
		}
	}
	#
	hw_maint_close $spawn_id;
	#
	return "0 - success";
}
#
proc hw_maint_logon_lynx_consoles { labid allspips lynxusername lynxpasswd spids useskdb { timeout 30 } { maxretries 10 } { retrydelay 45 } } {
	upvar $allspips spips;
	upvar $spids spawn_ids;
	#
	foreach resource [list lynx-a lynx-b] {
		# init all counters
		set retries 0;
		set interrupts 0;
		# set interrupt character to delete, not control-C.
		set stty_init "intr ";
		# logon each sp via the console
		spawn -noecho pxmonitor -L ${labid} -t ${resource};
		#
		set spawn_ids(${resource}) $spawn_id;
		#
		expect {
		-re {Starting.*interactive.*mode} {
			send "\r";
			exp_continue;
		}
		-re {.*login:} {
			send "${lynxusername}\r";
			exp_continue;
		}
		-re {.*user name:} {
			send "${lynxusername}\r";
			exp_continue;
		}
		-re {.*[pP]assword:} {
			send "${lynxpasswd}\r";
			exp_continue;
		}
		-re {.*PS1="COMMAND_IS_DONE>"} {
			exp_continue;
		}
		-re {.*COMMAND_IS_DONE>} {
			# ok.
		}
		-re {ibm750.*->} {
			# UGH. We have an SP stuck in the firmware mode.
			puts "\nRESOURCE ${resource} FOUND AT (ibm*) PROMPT.";
			puts "ATTEMPTING TO RECOVER ${resource}.";
			send "auto\r";
			exp_continue;
		}
		-re {Are.*you.*sure.*reboot.*system} {
			# yup, kick this dog.
			send "y";
			exp_continue;
		}
		-re {.*> } {
			send "PS1=\"COMMAND_IS_DONE>\"\r";
			exp_continue;
		}
		-re {.*# } {
			send "PS1=\"COMMAND_IS_DONE>\"\r";
			exp_continue;
		}
		-re {[\r\n]\* } {
			# SKDB prompt. reboot.
			puts "\nRESOURCE ${resource} FOUND AT skdb PROMPT.";
			puts "ATTEMPTING TO RECOVER ${resource}.";
			send "R\r"
			exp_continue;
		}
		timeout {
			puts "\nTime out waiting for pxmonitor ${labid} ${resource}";
			# maybe something is holding the terminal. try once.
			if {$interrupts <= 0} {
				incr interrupts;
				if {$useskdb} {
					send "";
				} else {
					send "";
				}
				exp_continue;
			}
			incr retries;
			if ($retries>$maxretries) {
				hw_maint_close_all spawn_ids;
				return "-1 - Time out waiting for pxmonitor ${labid} ${resource}";
			}
			puts "\nTime out. Retry $retries for ${resource}."
			hw_maint_close $spawn_id;
			sleep $retrydelay;
			# set interrupt character to delete, not control-C.
			set stty_init "intr ";
			spawn -noecho pxmonitor -L ${labid} -t ${resource};
			set spawn_ids(${resource}) $spawn_id;
			exp_continue;
		}
		eof {
			puts "\nEOF waiting for pxmonitor ${labid} ${resource}";
			incr retries;
			if ($retries>$maxretries) {
				hw_maint_close_all spawn_ids;
				return "-1 - EOF waiting for pxmonitor ${labid} ${resource}";
			}
			puts "\nEOF. Retry $retries for ${resource}."
			hw_maint_close $spawn_id;
			sleep $retrydelay;
			# set interrupt character to delete, not control-C.
			set stty_init "intr ";
			spawn -noecho pxmonitor -L ${labid} -t ${resource};
			set spawn_ids(${resource}) $spawn_id;
			exp_continue;
		}
		}
	}
	#
	return "0 - success";
}
#
proc hw_maint_lynx_exec { resource spids cmd { timeout 30 } } {
	upvar ${spids} spawn_ids;
	#
	set spawn_id $spawn_ids(${resource});
	#
	log_user 1;
	send "${cmd}\r";
	#
	expect {
	-re {.*STATUS=([-0-9]+)[\r\n]*COMMAND_IS_DONE>} {
		log_user 0;
		puts "\nStatus is $expect_out(1,string)";
		set status $expect_out(1,string);
		if {[isNotOk $status]} {
			return "-1 - cmd failed with status $status:\n$cmd";
		} else {
			return "0 - cmd failed with status $status:\n$cmd";
		}
	}
	-re {.*[\r\n]COMMAND_IS_DONE>} {
		send "echo STATUS=$?\r";
		exp_continue;
	}
	timeout {
		log_user 0;
		return "-1 - timeout during cmd:\n$cmd";
	}
	eof {
		log_user 0;
		return "-1 - timeout during cmd:\n$cmd";
	}
	}
	#
	log_user 0;
	return "0 - success";
}
#
proc hw_maint_sp_sanity_checks { labid allspips spids { timeout 15 } } {
	upvar $allspips spips;
	upvar $spids spawn_ids;
	#
	foreach resource [list lynx-a lynx-b] {
		#
		# recover IP connectivity
		#
		puts "\nResetting IP interface for ${resource}:"
		#
		puts "\nIP interface for ${resource} before reset:"
		hw_maint_lynx_exec ${resource} spawn_ids "ifconfig mgt0";
		#
		hw_maint_lynx_exec ${resource} spawn_ids "sed 's/mgt0_ip.*/mgt0_ip=$spips(${resource})/' /Telica/dbCurrent/Telica_IP >/tmp/[exp_pid].out";
		hw_maint_lynx_exec ${resource} spawn_ids "mv /tmp/[exp_pid].out /Telica/dbCurrent/Telica_IP";
		hw_maint_lynx_exec ${resource} spawn_ids "/bin/iprecover";
		#
		puts "\nIP interface for ${resource} after reset:"
		hw_maint_lynx_exec ${resource} spawn_ids "ifconfig mgt0";
		#
		# delete some old files, log and backup files.
		#
		puts "\nDeleting old LOG and BACKUP files for ${resource}:"
		#
		puts "\nDisk usage on ${resource} before deletes:"
		hw_maint_lynx_exec ${resource} spawn_ids "df";
		#
		hw_maint_lynx_exec ${resource} spawn_ids "rm -f /Telica/localbackups*/* 1>/dev/null 2>&1";
		hw_maint_lynx_exec ${resource} spawn_ids "rm -rf /Telica/swCPU/*/oldLog* 1>/dev/null 2>&1";
		#
		puts "\nDisk usage on ${resource} after deletes:"
		hw_maint_lynx_exec ${resource} spawn_ids "df";
		#
		# fix any file system problems
		#
		puts "\nRunning fsck on file systems on ${resource}:"
		#
		hw_maint_lynx_exec ${resource} spawn_ids "echo 'y' >/tmp/[exp_pid].ans";
		hw_maint_lynx_exec ${resource} spawn_ids "fsck -f /dev/hd2b </tmp/[exp_pid].ans";
		hw_maint_lynx_exec ${resource} spawn_ids "fsck -f /dev/hd2c </tmp/[exp_pid].ans";
		hw_maint_lynx_exec ${resource} spawn_ids "fsck -f /dev/hd2d </tmp/[exp_pid].ans";
	}
	#
	return "0 - success";
}
#
proc hw_maint_recover_sps { labid allspips tl1username tl1passwd lynxusername lynxpasswd sps useskdb { maxiom 17 } { polltime 30 } { maxtime 1800 } { maxresets 5 } } {
	upvar $allspips spips;
	# diagnose and recover sps
	puts "\nStart ${labid} SP Diagnostics/Recovery.";
	# release all console users, if any
	set status [hw_maint_clear_console_users $labid];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_recover_sps: hw_maint_clear_console_users failed:\n${status}";
	}
	# attempt to logon the SPs, fix any problems on the way.
	set status [hw_maint_logon_lynx_consoles $labid spips $lynxusername $lynxpasswd spawn_ids $useskdb];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_recover_sps: hw_maint_logon_lynx_consoles failed:\n${status}";
	}
	# check for space, IPs, processes running, etc. fix if any problems.
	set status [hw_maint_sp_sanity_checks $labid spips spawn_ids];
	if {[isNotOk $status]} {
		return "-1 - hw_maint_recover_sps: hw_maint_sp_sanity_checks failed:\n${status}";
	}
	# verification
	puts "\nSP-A Sanity checks ...";
	hw_maint_lynx_exec "lynx-a" spawn_ids "ps xf";
	hw_maint_lynx_exec "lynx-a" spawn_ids "df";
	hw_maint_lynx_exec "lynx-a" spawn_ids "ifconfig mgt0";
	puts "\nSP-B Sanity checks ...";
	hw_maint_lynx_exec "lynx-b" spawn_ids "ps xf";
	hw_maint_lynx_exec "lynx-b" spawn_ids "df";
	hw_maint_lynx_exec "lynx-b" spawn_ids "ifconfig mgt0";
	# close all streams
	hw_maint_close_all spawn_ids;
	# done
	return "0 - success";
}

############################################################################
#
#
