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
# remove all IOMs
#
proc hw_maint_rmv_all_ioms { labid spaip spbip username passwd { maxiom 17 } { polltime 30 } { maxtime 900 } { maxresets 5 } } {
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
			hw_maint_cleanup $spid;
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
						hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr secrmvsinprog;
				log_user 0;
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
						hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr prirmvsinprog;
				log_user 0;
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
		hw_maint_cleanup $spid;
		puts "ERROR: time out. unable to remove all IOMs";
		return "-1 - time out. unable to remove all IOMs";
	} else {
		# close TL1 session
		hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
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
		hw_maint_cleanup $spid;
		puts "ERROR: time out. unable to restore all IOMs";
		return "-1 - time out. unable to restore all IOMs";
	} else {
		# close TL1 session
		hw_maint_cleanup $spid;
		return "0 - success";
	}
}
#
# remove all IOMs
#
proc hw_maint_rmvallioms { spid { maxiom 17 } { polltime 30 } { maxtime 900 } { maxresets 5 } } {
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
						hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr secrmvsinprog;
				log_user 0;
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
						hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
					return "-1 - RMV-EQPT::IOM-$iom EOF";
				}
				}
				incr prirmvsinprog;
				log_user 0;
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
					hw_maint_cleanup $spid;
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
					hw_maint_cleanup $spid;
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
# cpy-mem all IOMs
#
proc hw_maint_cpymem_all_ioms { labid spaip spbip username passwd { maxcpymems 3 } { maxiom 17 } { polltime 30 } { maxtime 1800 } { maxresets 5 } } {
	# start cpy-mem process
	puts "\nStart ${labid} CPY-MEM cycle.";
	# open active TL1 port 
	puts "\nOpening TL1 session for ($labid,$spaip,$spbip).";
	set status [hw_maint_tl1_open spid $spaip $spbip $username $passwd]
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
		} elseif {$data(iom,$iom,state) != "oosma"} {
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
					hw_maint_cleanup $spid;
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
		# close TL1 session
		hw_maint_cleanup $spid;
		return "-1 - time out. unable to CPY-MEM all IOMs";
	} else {
		# close TL1 session
		hw_maint_cleanup $spid;
		return "0 - success";
	}
}
#
# cpy-mem all IOMs
#
proc hw_maint_cpymemallioms { spid { maxcpymems 3 } { maxiom 17 } { polltime 30 } { maxtime 1800 } { maxresets 5 } } {
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
		} elseif {$data(iom,$iom,state) != "oosma"} {
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

