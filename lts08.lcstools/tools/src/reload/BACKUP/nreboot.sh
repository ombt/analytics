#!/opt/exp/bin/expect
#
# reboot one or both SPs of an LCS.
#
#########################################################################
#
# library
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/lcsftp
source $env(LCSTOOLSLIB)/lcstelnet
source $env(LCSTOOLSLIB)/logging
#
# functions
#
proc ucondclose { } {
	catch { close; } status;
}
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-u username] \[-p passwd] ";
	puts "\t\[-U] \[-A] \[-B] \[-a or -m or -b] \[labid]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-V - enable verbose output";
	puts "	-U - unconditional - don't run sanity checks before booting.";
	puts "	-S - delete sync.xml file";
	puts "	-C - remove configuration data";
	puts "	-A - reboot SP-A only, do not reboot SP-B";
	puts "	-B - reboot SP-B only, do not reboot SP-A";
	puts "	-m - boot SP into 'min-cfg' mode; overrides any previous -a.";
	puts "	-a - boot SP into application mode; overrides any previous -m.";
	puts "	-b - reboot SP using current init files, app boots to app,";
	puts "	     min boots to min; overrides any previous -m or -a.";
	puts "	-u username - Unix login name."
	puts "	-p passwd - Unix login password."
	puts "";
	puts "	default UNIX username = $username";
	puts "	default UNIX passwd = $userpasswd";
	puts "	default labid is from variable LABID";
	puts "";
	puts "If both -A and -B are given, the last option given in the";
	puts "cmd line takes effect. By default, both SPs are rebooted.";
	puts "-a is the default. Use -b to boot using the current setup.";
	puts "";
}
#
proc getlabidips { labid iparray } {
	global env;
	global expect_out;
	global spawn_id;
	upvar $iparray ips;
	#
	set errmsg "";
	if {[catch {
		cd $env(LCSTOOLSDATA);
		set timeout 3;
		spawn -noecho "uprintf" -q "-f%s %s\n" cpu_a_ip cpu_b_ip in chassis where labid req ^$labid\$;
		expect {
		eof {
			set ips(SP_A_IP) [lindex $expect_out(buffer) 0];
			set ips(SP_B_IP) [lindex $expect_out(buffer) 1];
			# puts "ips(SP_A_IP) = $ips(SP_A_IP)";
			# puts "ips(SP_B_IP) = $ips(SP_B_IP)";
		}
		timeout {
			puts "\nERROR: timeout during uprintf ...";
			exit 2;
		}
		};
	} errmsg] != 0} {
		if {[string length $errmsg] > 0} {
			puts "\nERROR: CAUGHT ERROR IN getlabidips: $errmsg";
		} else {
			puts "\nERROR: CAUGHT ERROR IN getlabidips.";
		}
		exit 2;
	}
}
#
proc lcsping { ip } {
	global timeout;
	set status dead;
	set savetimeout $timeout;
	#
	set timeout 3;
	spawn ping $ip;
	#
	expect {
	"alive" { set status alive; } 
	timeout { set status dead; }
	}
	#
	catch { close; wait; } ignore;
	#
	set timeout $savetimeout;
	#
	return $status;
}
#
#
proc lcsunixactive { ip } {
	global username;
	global userpasswd;
	global timeout;
	#
	set status dead;
	set savetimeout $timeout;
	set timeout 30;
	#
	spawn -noecho telnet $ip 
	expect {
	"Connected to " {
		set status alive;
	}
	"Connection refused" {
		# puts "Connection refused to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	timeout {
		# puts "Timed out connecting to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	}
	#
	expect {
	"user name:" {
		send "$username\r";
	}
	timeout {
		# puts "Timed out waiting for username prompt to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	}
	#
	expect {
	"password:" {
		send "$userpasswd\r";
	}
	timeout {
		# puts "Timed out waiting for passwd prompt to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	}
	#
	expect {
	-re "\[a-z]*\[0-9]+\[ab]#" {
		set status active;
	}
	-re "\[a-zA-Z0-9_-]+#" {
		set status active;
	}
	-re "unnamed_system#" {
		set status active;
	}
	timeout {
		# puts "Timed out waiting for cmd prompt to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	}
	#
	catch { close; wait; } ignore;
	#
	set timeout $savetimeout;
	#
	return $status;
}
#
proc reboot { labid } {
	# variables
	global env;
	global rebootSPA;
	global rebootSPB;
	global appmode;
	global minmode;
	global deletesyncxmlfile;
	global removeconfigdata;
	global unconditional;
	#
	set bootspa 0;
	set bootspb 0;
	#
	set lcsips(0) 0;
	set lcsips(1) 0;
	# check required environent variables
	if {![info exists env(LCSTOOLSDATA)]} {
		puts "\nERROR: LCSTOOLSDATA is not set.";
		exit 2;
	}
	# get ip addresses for labid.
	getlabidips $labid lcsips;
	#
	if {$rebootSPA != 0} {
		if {$lcsips(SP_A_IP) != "" && $unconditional} {
			puts "\nUnconditional reboot. Skipping sanity checks for $labid SP_A.";
			logmsg reboot "Unconditional reboot. Skipping sanity checks for $labid SP_A.";
			set bootspa 1;
		} elseif {$lcsips(SP_A_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_A_IP)];
			if {$spastatus == "alive"} {
				puts "\n$labid SP_A is alive.";
				logmsg reboot "$labid SP_A is alive.";
				# check if SP-A UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_A_IP)];
				puts "\n$labid SP_A UNIX is $spastatus.";
				logmsg reboot "$labid SP_A UNIX is $spastatus.";
				# boot if active
				if {$spastatus == "active"} {
					set bootspa 1;
				} else {
					puts "\nskip booting $labid SP_A.";
					logmsg reboot  "skip booting $labid SP_A.";
				}
			} else {
				puts "\n$labid SP_A is not responding.";
				logmsg reboot  "$labid SP_A is not responding.";
			}
		} else {
			puts "\n$labid No SP_A_IP found for labid $labid.";
			logmsg reboot "$labid No SP_A_IP found for labid $labid.";
		}
	} else {
		puts "\nskip booting $labid SP_A.";
		logmsg reboot "skip booting $labid SP_A.";
	}
	if {$rebootSPB != 0} {
		if {$lcsips(SP_B_IP) != "" && $unconditional} {
			puts "\nUnconditional reboot. Skipping sanity checks for $labid SP_B.";
			logmsg reboot "Unconditional reboot. Skipping sanity checks for $labid SP_B.";
			set bootspb 1;
		} elseif {$lcsips(SP_B_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_B_IP)];
			if {$spastatus == "alive"} {
				puts "\n$labid SP_B is alive.";
				logmsg reboot "$labid SP_B is alive.";
				# check if SP-B UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_B_IP)];
				puts "\n$labid SP_B UNIX is $spastatus.";
				logmsg reboot "$labid SP_B UNIX is $spastatus.";
				# boot if active
				if {$spastatus == "active"} {
					set bootspb 1;
				} else {
					puts "\nskip booting $labid SP_B.";
					logmsg reboot "skip booting $labid SP_B.";
				}
			} else {
				puts "\n$labid SP_B is not responding.";
				logmsg reboot "$labid SP_B is not responding.";
			}
		} else {
			puts "\n$labid No SP_B_IP found for labid $labid.";
			logmsg reboot "$labid No SP_B_IP found for labid $labid.";
		}
	} else {
		puts "\nskip booting $labid SP_B.";
		logmsg reboot "skip booting $labid SP_B.";
	}
	#
	# now boot the SPs in parallel. minimize the time
	# between boot commands to minimize the chance that one SP
	# causes the other SP to boot before the second boot command
	# is isssued from here.
	#
	if {$bootspa && $bootspb} {
		set spaip $lcsips(SP_A_IP);
		set spbip $lcsips(SP_B_IP);
		#
		if {$appmode} {
			#
			# reboot in application mode. first, delete any 
			# rc.local file that might be left over. make sure 
			# telica.rc.network is executable, then it will be 
			# called by /net/rc.network.
			#
			puts "\nbooting APP mode $labid SP_A and SP_B.";
			logmsg reboot "booting APP mode $labid SP_A and SP_B.";
			#
			telnet_to $spaip spaip_id;
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
	}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			remote_exec $spaip_id "/bin/rm -f /net/rc.local";
			remote_exec $spaip_id "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			remote_exec $spbip_id "cd /";
			remote_exec $spbip_id "/bin/rm -f /net/rc.local";
			remote_exec $spbip_id "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spaip_id;
			close_telnet $spbip_id;
		} elseif {$minmode} {
			#
			# since the official /net/rc.network calls 
			# /net/rc.local if it exists and is executable, use 
			# this hook to get the IP network configured. use 
			# iprecover as the tool for init'ing the IP network. 
			# to avoid init'ing any applications, then you must 
			# make telica.rc.netwok NOT executable.
			#
			puts "\nbooting MIN mode $labid SP_A and SP_B.";
			logmsg reboot "booting MIN mode $labid SP_A and SP_B.";
			#
			ftp_put_ascii_file $spaip "$env(LCSTOOLSBIN)/iprecover" "/net/rc.local";
			ftp_put_ascii_file $spbip "$env(LCSTOOLSBIN)/iprecover" "/net/rc.local";
			#
			telnet_to $spaip spaip_id;
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			remote_exec $spaip_id "/bin/chmod 755 /net/rc.local";
			remote_exec $spaip_id "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			remote_exec $spbip_id "cd /";
			remote_exec $spbip_id "/bin/chmod 755 /net/rc.local";
			remote_exec $spbip_id "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spaip_id;
			close_telnet $spbip_id;
		} else {
			#
			# simply boot the machine as is.
			#
			puts "\nbooting $labid SP_A and SP_B.";
			logmsg reboot "booting $labid SP_A and SP_B.";
			#
			telnet_to $spaip spaip_id;
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			remote_exec $spbip_id "cd /";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spaip_id;
			close_telnet $spbip_id;
		}
	} elseif {$bootspa && !$bootspb} {
		set spaip $lcsips(SP_A_IP);
		#
		if {$appmode} {
			#
			# reboot in application mode. first, delete any 
			# rc.local file that might be left over. make sure 
			# telica.rc.network is executable, then it will be 
			# called by /net/rc.network.
			#
			puts "\nbooting APP mode $labid SP_A.";
			logmsg reboot "booting APP mode $labid SP_A.";
			#
			telnet_to $spaip spaip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			remote_exec $spaip_id "/bin/rm -f /net/rc.local";
			remote_exec $spaip_id "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			#
			close_telnet $spaip_id;
		} elseif {$minmode} {
			#
			# since the official /net/rc.network calls 
			# /net/rc.local if it exists and is executable, use 
			# this hook to get the IP network configured. use 
			# iprecover as the tool for init'ing the IP network. 
			# to avoid init'ing any applications, then you must 
			# make telica.rc.netwok NOT executable.
			#
			puts "\nbooting MIN mode $labid SP_A.";
			logmsg reboot "booting MIN mode $labid SP_A.";
			#
			ftp_put_ascii_file $spaip "$env(LCSTOOLSBIN)/iprecover" "/net/rc.local";
			#
			telnet_to $spaip spaip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			remote_exec $spaip_id "/bin/chmod 755 /net/rc.local";
			remote_exec $spaip_id "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			#
			close_telnet $spaip_id;
		} else {
			#
			# simply boot the machine as is.
			#
			puts "\nbooting $labid SP_A.";
			logmsg reboot "booting $labid SP_A.";
			#
			telnet_to $spaip spaip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spaip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spaip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spaip_id "cd /";
			#
			remote_exec_nowait $spaip_id "reboot -aN";
			#
			synchronize $spaip_id "reboot -aN of SP_A";
			#
			close_telnet $spaip_id;
		}
	} elseif {!$bootspa && $bootspb} {
		set spbip $lcsips(SP_B_IP);
		if {$appmode} {
			#
			# reboot in application mode. first, delete any 
			# rc.local file that might be left over. make sure 
			# telica.rc.network is executable, then it will be 
			# called by /net/rc.network.
			#
			puts "\nbooting APP mode $labid SP_B.";
			logmsg reboot "booting APP mode $labid SP_B.";
			#
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
	}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spbip_id "cd /";
			remote_exec $spbip_id "/bin/rm -f /net/rc.local";
			remote_exec $spbip_id "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spbip_id;
		} elseif {$minmode} {
			#
			# since the official /net/rc.network calls 
			# /net/rc.local if it exists and is executable, use 
			# this hook to get the IP network configured. use 
			# iprecover as the tool for init'ing the IP network. 
			# to avoid init'ing any applications, then you must 
			# make telica.rc.netwok NOT executable.
			#
			puts "\nbooting MIN mode $labid SP_B.";
			logmsg reboot "booting MIN mode $labid SP_B.";
			#
			ftp_put_ascii_file $spbip "$env(LCSTOOLSBIN)/iprecover" "/net/rc.local";
			#
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spbip_id "cd /";
			remote_exec $spbip_id "/bin/chmod 755 /net/rc.local";
			remote_exec $spbip_id "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
			#
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spbip_id;
		} else {
			#
			# simply boot the machine as is.
			#
			puts "\nbooting $labid SP_B.";
			logmsg reboot "booting $labid SP_B.";
			#
			telnet_to $spbip spbip_id;
			#
			if {$deletesyncxmlfile} {
				puts "\nDeleting sync.xml file ...";
				remote_exec $spbip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
			}
			if {$removeconfigdata} {
				puts "\nRunning remove_configuration_data file ...";
				remote_exec $spbip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
			}
			#
			remote_exec $spbip_id "cd /";
			#
			remote_exec_nowait $spbip_id "reboot -aN";
			#
			synchronize $spbip_id "reboot -aN of SP_B";
			#
			close_telnet $spbip_id;
		}
	} else {
		puts "\nno $labid SPs will be booted.";
		logmsg reboot "no $labid SPs will be booted.";
	}
	return;
}
#
#########################################################################
#
# default values
#
set tid "telica";
set username "root";
set userpasswd "plexus9000";
set verbose 0;
set logfile "";
set rebootSPA 1;
set rebootSPB 1;
set appmode 1;
set minmode 0;
set unconditional 0;
set deletesyncxmlfile 0;
set removeconfigdata 0;
#
# get cmd line options
#
set argc [llength $argv];
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-V} { set verbose 1; }
	{^-U} { set unconditional 1; }
	{^-S} { set deletesyncxmlfile 1; }
	{^-C} { set removeconfigdata 1; }
	{^-A} { set rebootSPA 1; set rebootSPB 0; }
	{^-B} { set rebootSPB 1; set rebootSPA 0; }
	{^-a} { set appmode 1; set minmode 0; }
	{^-m} { set minmode 1; set appmode 0; }
	{^-b} { set minmode 0; set appmode 0; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "\nERROR: unknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
# check LCSTOOLS variables
#
checkenv
#
# logging on or off?
#
if {$verbose} {
	log_user 1;
} else {
	log_user 0;
}
#
if {[string length $logfile] > 0} {
	log_user 1;
	if {[catch {log_file -noappend -a $logfile; } status]} {
		puts "\nERROR: logging failed for file $logfile:\n$status";
		exit 2;
	}
}
#
# boot lab SPs
#
logusage reboot;
#
if {$arg >= $argc} {
	# boot the lab for the current labid
	checklabid
	set labid $env(LABID);
	reboot $labid;
} else {
	# boot the labs for the given labids
	for { } {$arg<$argc} {incr arg} {
		set labid [lindex $argv $arg];
		reboot $labid;
	}
}
#
# done
#
exit 0
