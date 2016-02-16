# functions related to hardware maintenance
package provide hwmaint 1.0
#
package require checkretval
#
# clean up routine ...
#
proc hw_maint_cleanup { spawn_id } {
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
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
				hw_maint_cleanup $spawn_id;
				puts "\nConnection refused. Sleep and retry.";
				sleep 5;
			}
			timeout {
				hw_maint_cleanup $spawn_id;
				puts "\nTime out. Sleep and retry.";
				sleep 5;
			}
			eof {
				hw_maint_cleanup $spawn_id;
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
			hw_maint_cleanup $spawn_id;
			puts "\nTimeout waiting for Telica prompt ($spip,$username).";
			continue;
		}
		eof {
			hw_maint_cleanup $spawn_id;
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
			hw_maint_cleanup $spawn_id;
			continue;
		}
		-re "This is the PROTECTION System Processor.*;\r\nTelica>" {
			puts "\nThis is the PROTECTION System Processor ($spip,$username).";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		-re "Login Not Active.*;\r\nTelica>" {
			puts "\nLogin Not Active ($spip,$username).";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		-re "Can't login.*;\r\nTelica>" {
			puts "\nCan't login ($spip,$username).";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		-re ".*;\r\nTelica>" {
			puts "\nUnknown error ($spip,$username).";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		timeout {
			puts "\ntimeout waiting for a response ...";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		eof {
			puts "\neof waiting for a response ...";
			hw_maint_cleanup $spawn_id;
			continue;
		}
		}
	}
	#
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
		return "-1 - RTRV-EQPT EOF";
	}
	}
	#
	# exp_internal 0;
	#
	return "0 - success";
}
#
# remove all IOMs
#
proc hw_maint_rmv_all_ioms { labid spaip spbip username passwd { maxiom 17 } { polltime 30 } } {
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
	}
	# remove the IOMs
	puts "\nStart ${labid} RMV-EQPT cycle.";
	for {set done 0} { ! $done} {sleep $polltime} {
		# counters
		set prirmvsinprog 0;
		set secrmvsinprog 0;
		# rtrv-eqpt to get status
		puts "\nCall RTRV-EQPT to get IOM statuses.";
		set status [hw_maint_rtrv_eqpt spid data];
		if {[isNotOk $status]} {
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
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nRMV-EQPT::IOM-$iom EOF";
				}
				}
				set data(iom,$iom,rmvstate) "INPROG";
				incr secrmvsinprog;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT of IOM-$iom.";
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
				puts "\nStart RMV-EQPT of IOM-$iom.";
				send "RMV-EQPT::IOM-$iom;\r";
				expect {
				-re ";\r\nTelica>" {
					puts "\nRMV-EQPT::IOM-$iom COMPLETED";
				}
				timeout {
					puts "\nRMV-EQPT::IOM-$iom timeout";
				}
				eof {
					puts "\nRMV-EQPT::IOM-$iom EOF";
				}
				}
				set data(iom,$iom,rmvstate) "INPROG";
				incr prirmvsinprog;
			} elseif {$data(iom,$iom,rmvstate) == "INPROG"} {
				if {$data(iom,$iom,state) == "oosma"} {
					puts "\nFinished RMV-EQPT of IOM-$iom.";
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
	}
	# close TL1 session
	hw_maint_cleanup $spid;
	#
	return "0 - success";
}
#
# restore all IOMs
#
proc hw_maint_rst_all_ioms { labid spaip spbip username passwd { maxiom 17 } { polltime 30 } } {
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
	}
	# restore the IOMs
	puts "\nStart ${labid} RST-EQPT cycle.";
	for {set done 0} { ! $done} {sleep $polltime} {
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
					puts "\nRST-EQPT::IOM-$iom EOF";
				}
				}
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
					puts "\nRST-EQPT::IOM-$iom EOF";
				}
				}
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
	}
	# close TL1 session
	hw_maint_cleanup $spid;
	#
	return "0 - success";
}
#

