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
proc myflush { } {
	global user_spawn_id;
	flush $user_spawn_id;
}
#
proc vputs { msg } {
	global verbose;
	if {$verbose} {
		puts "\n$msg";
		myflush;
	}
}
#
proc ucondclose { } {
	catch { close; } status;
}
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-u username] \[-p passwd] \[-A] \[-B] \[-a or -m or -b] \[labid]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-V - enable verbose output";
	puts "	-S - delete sync.xml file";
	puts "	-C - remove configuration data";
	puts "	-A - reboot SP-A only, do not reboot SP-B";
	puts "	-B - reboot SP-B only, do not reboot SP-A";
	puts "	-m - boot SP into 'min-cfg' mode; overrides any previous -a.";
	puts "	-a - boot SP into application mode; overrides any previous -m.";
	puts "	-b - reboot SP using current init files, app boots to app,";
	puts "	     min boots to min; overrides any previous -m or -a.";
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
			vputs "ips(SP_A_IP) = $ips(SP_A_IP)";
			vputs "ips(SP_B_IP) = $ips(SP_B_IP)";
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
		vputs "Connection refused to $ip ...";
		set status dead;
		catch { close; wait; } ignore;
		set timeout $savetimeout;
		return $status;
	}
	timeout {
		vputs "Timed out connecting to $ip ...";
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
		vputs "Timed out waiting for username prompt to $ip ...";
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
		vputs "Timed out waiting for passwd prompt to $ip ...";
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
		vputs "Timed out waiting for cmd prompt to $ip ...";
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

#
proc rebootsp { ip } {
	global deletesyncxmlfile;
	global removeconfigdata;
	# simply boot the machine as is.
	#
	telnet_to $ip ip_id;
	if {$deletesyncxmlfile} {
		puts "Deleting sync.xml file ...";
		remote_exec $ip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
	}
	if {$removeconfigdata} {
		puts "Running remove_configuration_data file ...";
		remote_exec $ip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
	}
	remote_exec $ip_id "cd /";
	remote_exec $ip_id "reboot -aN";
	close_telnet $ip_id;
}
#
proc rebootappsp { ip } {
	global deletesyncxmlfile;
	global removeconfigdata;
	# reboot in application mode. first, delete any rc.local
	# file that might be left over. make sure telica.rc.network
	# is executable, then it will be called by /net/rc.network.
	#
	telnet_to $ip ip_id;
	if {$deletesyncxmlfile} {
		puts "Deleting sync.xml file ...";
		remote_exec $ip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
	}
	if {$removeconfigdata} {
		puts "Running remove_configuration_data file ...";
		remote_exec $ip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
	}
	remote_exec $ip_id "cd /";
	remote_exec $ip_id "/bin/rm -f /net/rc.local";
	remote_exec $ip_id "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
	remote_exec $ip_id "reboot -aN";
	close_telnet $ip_id;
}
#
proc rebootminsp { ip } {
	global deletesyncxmlfile;
	global removeconfigdata;
	# since official /net/rc.network calls /net/rc.local if it
	# exists and is executable, use this hook to get the IP
	# network configured. use iprecover as the tool for init'ing 
	# the IP network. to avoid init'ing any applications, then
	# you must make telica.rc.netwok NOT executable.
	#
	global env;
	ftp_put_ascii_file $ip "$env(LCSTOOLSBIN)/iprecover" "/net/rc.local";
	#
	telnet_to $ip ip_id;
	if {$deletesyncxmlfile} {
		puts "Deleting sync.xml file ...";
		remote_exec $ip_id "/bin/rm -f /Telica/dbCurrent/sync.xml 1>/dev/null 2>&1";
	}
	if {$removeconfigdata} {
		puts "Running remove_configuration_data file ...";
		remote_exec $ip_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data proceed 1>/dev/null 2>&1";
	}
	remote_exec $ip_id "cd /";
	remote_exec $ip_id "/bin/chmod 755 /net/rc.local";
	remote_exec $ip_id "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
	remote_exec $ip_id "reboot -aN";
	close_telnet $ip_id;
}
#
proc reboot { labid } {
	# variables
	global env;
	global rebootSPA;
	global rebootSPB;
	global appmode;
	global minmode;
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
		if {$lcsips(SP_A_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_A_IP)];
			if {$spastatus == "alive"} {
				puts "$labid SP_A is alive.";
				myflush;
				logmsg reboot "$labid SP_A is alive.";
				# check if SP-A UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_A_IP)];
				puts "$labid SP_A UNIX is $spastatus.";
				myflush;
				logmsg reboot "$labid SP_A UNIX is $spastatus.";
				# boot if active
				if {$spastatus == "active"} {
					if {$appmode} {
						puts "booting APP mode $labid SP_A.";
						logmsg reboot "booting APP mode $labid SP_A.";
						rebootappsp $lcsips(SP_A_IP);
					} elseif {$minmode} {
						puts "booting MIN mode $labid SP_A.";
						logmsg reboot "booting MIN mode $labid SP_A.";
						rebootminsp $lcsips(SP_A_IP);
					} else {
						puts "booting $labid SP_A.";
						logmsg reboot "booting $labid SP_A.";
						rebootsp $lcsips(SP_A_IP);
					}
				} else {
					puts "skip booting $labid SP_A.";
					logmsg reboot  "skip booting $labid SP_A.";
				}
			} else {
				puts "$labid SP_A is not responding.";
				logmsg reboot  "$labid SP_A is not responding.";
				myflush;
			}
		} else {
			puts "$labid No SP_A_IP found for labid $labid.";
			logmsg reboot "$labid No SP_A_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "skip booting $labid SP_A.";
		logmsg reboot "skip booting $labid SP_A.";
		myflush;
	}
	if {$rebootSPB != 0} {
		if {$lcsips(SP_B_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_B_IP)];
			if {$spastatus == "alive"} {
				puts "$labid SP_B is alive.";
				logmsg reboot "$labid SP_B is alive.";
				myflush;
				# check if SP-B UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_B_IP)];
				puts "$labid SP_B UNIX is $spastatus.";
				logmsg reboot "$labid SP_B UNIX is $spastatus.";
				myflush;
				# boot if active
				if {$spastatus == "active"} {
					if {$appmode} {
						puts "booting APP mode $labid SP_B.";
						logmsg reboot "booting APP mode $labid SP_B.";
						rebootappsp $lcsips(SP_B_IP);
					} elseif {$minmode} {
						puts "booting MIN mode $labid SP_B.";
						logmsg reboot "booting MIN mode $labid SP_B.";
						rebootminsp $lcsips(SP_B_IP);
					} else {
						puts "booting $labid SP_B.";
						logmsg reboot "booting $labid SP_B.";
						rebootsp $lcsips(SP_B_IP);
					}
				} else {
					puts "skip booting $labid SP_B.";
					logmsg reboot "skip booting $labid SP_B.";
				}
			} else {
				puts "$labid SP_B is not responding.";
				logmsg reboot "$labid SP_B is not responding.";
				myflush;
			}
		} else {
			puts "$labid No SP_B_IP found for labid $labid.";
			logmsg reboot "$labid No SP_B_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "skip booting $labid SP_B.";
		logmsg reboot "skip booting $labid SP_B.";
		myflush;
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