#!/opt/exp/bin/expect
#
# get the status of a LCS.
#
#########################################################################
#
# library
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/lcsftp
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

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-u username] \[-p passwd] \[-A] \[-B] \[-a or -m] \[labid]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-V - enable verbose output";
	puts "	-A - reboot SP-A only, do not reboot SP-B";
	puts "	-B - reboot SP-B only, do not reboot SP-A";
	puts "	-m - boot SP into 'min-cfg' mode; overrides any previous -a.";
	puts "	-a - boot SP into application mode; overrides any previous -m.";
	puts "";
	puts "	default UNIX username = $username";
	puts "	default UNIX passwd = $userpasswd";
	puts "	default labid is from variable LABID";
	puts "";
	puts "If both -A and -B are given, the last option given in the";
	puts "cmd line takes effect. By default, both SPs are rebooted.";
	puts "If neither -a nor -m is given, then the current setup is used.";
	puts "";
}
#
proc remote_exec { machine cmd } {
	global username;
	global userpasswd;
	global timeout;
	#
	set loginseen 0;
	set savetimeout $timeout;
	set timeout 5;
	#
	spawn -noecho "/usr/bin/telnet" "-l $username" $machine;
	expect {
	-re ".*user name:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*password:" {
		set loginseen 0;
		send "$userpasswd\r";
	}
	timeout {
		puts "\ntimeout during telnet ...";
		exit 2;
	}
	};
	#
	if {$loginseen} {
		expect {
		-re ".*password:" {
			send "$userpasswd\r";
		}
		timeout {
			puts "\ntimeout during telnet, waiting for password: ...";
			exit 2;
		}
		};
	}
	#
	expect {
	-re ".*# " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	timeout {
		puts "\ntimeout during prompt ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		send "cd /\r";
	}
	timeout {
		puts "\ntimeout during PS1= ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		send "$cmd\r";
	}
	timeout {
		puts "\ntimeout during cd ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		# ok
		send "exit\r";
	}
	timeout {
		puts "\ntimeout during $cmd ...";
		exit 2;
	}
	};
	#
	catch { close; wait; } ignore;
	#
	set timeout $savetimeout;
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
			puts "\ntimeout during uprintf ...";
			exit 2;
		}
		};
	} errmsg] != 0} {
		if {[string length $errmsg] > 0} {
			puts "\nCAUGHT ERROR IN getlabidips: $errmsg";
		} else {
			puts "\nCAUGHT ERROR IN getlabidips.";
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
	set timeout 3;
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
	-re "m\[0-9]+\[ab]#" {
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
	# simply boot the machine as is.
	#
	remote_exec $ip "reboot -aN";
}
#
proc rebootappsp { ip } {
	# reboot in application mode. first, delete any rc.local
	# file that might be left over. make sure telica.rc.network
	# is executable, then it will be called by /net/rc.network.
	#
	remote_exec $ip "/bin/rm -f /net/rc.local";
	remote_exec $ip "/bin/chmod 755 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
	remote_exec $ip "reboot -aN";
}
#
proc rebootminsp { ip } {
	# since official /net/rc.network calls /net/rc.local if it
	# exists and is executable, use this hook to get the IP
	# network configured. use iprecover as the tool for init'ing 
	# the IP network. to avoid init'ing any applications, then
	# you must make telica.rc.netwok NOT executable.
	#
	ftp_put_ascii_file $ip "/home/lcstools/tools/bin/iprecover" "/net/rc.local";
	remote_exec $ip "/bin/chmod 755 /net/rc.local";
	remote_exec $ip "/bin/chmod 644 /Telica/swCPU/CurrRel/system/scripts/telica.rc.network";
	remote_exec $ip "reboot -aN";
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
		puts "\nLCSTOOLSDATA is not set.";
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
				# check if SP-A UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_A_IP)];
				puts "$labid SP_A UNIX is $spastatus.";
				myflush;
				# boot if active
				if {$spastatus == "active"} {
					if {$appmode} {
						puts "booting APP mode $labid SP_A.";
						rebootappsp $lcsips(SP_A_IP);
					} elseif {$minmode} {
						puts "booting MIN mode $labid SP_A.";
						rebootminsp $lcsips(SP_A_IP);
					} else {
						puts "booting $labid SP_A.";
						rebootsp $lcsips(SP_A_IP);
					}
				} else {
					puts "skip booting $labid SP_A.";
				}
			} else {
				puts "$labid SP_A is not responding.";
				myflush;
			}
		} else {
			puts "$labid No SP_A_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "skip booting $labid SP_A.";
		myflush;
	}
	if {$rebootSPB != 0} {
		if {$lcsips(SP_B_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_B_IP)];
			if {$spastatus == "alive"} {
				puts "$labid SP_B is alive.";
				myflush;
				# check if SP-B UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_B_IP)];
				puts "$labid SP_B UNIX is $spastatus.";
				myflush;
				# boot if active
				if {$spastatus == "active"} {
					if {$appmode} {
						puts "booting APP mode $labid SP_B.";
						rebootappsp $lcsips(SP_B_IP);
					} elseif {$minmode} {
						puts "booting MIN mode $labid SP_B.";
						rebootminsp $lcsips(SP_B_IP);
					} else {
						puts "booting $labid SP_B.";
						rebootsp $lcsips(SP_B_IP);
					}
				} else {
					puts "skip booting $labid SP_B.";
				}
			} else {
				puts "$labid SP_B is not responding.";
				myflush;
			}
		} else {
			puts "$labid No SP_B_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "skip booting $labid SP_B.";
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
	{^-A} { set rebootSPA 1; set rebootSPB 0; }
	{^-B} { set rebootSPB 1; set rebootSPA 0; }
	{^-a} { set appmode 1; set minmode 0; }
	{^-m} { set minmode 1; set appmode 0; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "\nunknown option: $argval\n"; usage; exit 2 }
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
		puts "\nlogging failed for file $logfile:\n$status";
		exit 2;
	}
}
#
# boot lab SPs
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
