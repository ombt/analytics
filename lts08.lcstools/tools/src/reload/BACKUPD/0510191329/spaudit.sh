#!/opt/exp/bin/expect
#
# audit files on one or both SPs. compare the files on the SPs with
# the files in the repository.
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

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-u username] \[-p passwd] \[-A] \[-B] \[-c or -i] \[labid]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-V - enable verbose output";
	puts "";
	puts "	-A - audit SP-A only, do not audit SP-B";
	puts "	-B - audit SP-B only, do not audit SP-A";
	puts "	-c - audit CPU files only";
	puts "	-i - audit IOM files only";
	puts "";
	puts "	default UNIX username = $username";
	puts "	default UNIX passwd = $userpasswd";
	puts "	default labid is from variable LABID";
	puts "";
	puts "If both -A and -B are given, the last option given in the";
	puts "cmd line takes effect. By default, both SPs are audited.";
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
proc parse_cpu_load { fname } {
	# open file
	set cpu_load "unknown";
	set infd [open $fname "r"];
	while {[gets $infd line] != -1} {
		if {[regexp -nocase -- ".*/Telica/swCPU/CurrRel *-> */Telica/swCPU/(.*)" $line ignore cpu_load] != -1} {
			close $infd;
			return $cpu_load;
		} elseif {[regexp -nocase -- ".*/Telica/swCPU/CurrRel *-> *(.*)" $line ignore cpu_load] != -1} {
			close $infd;
			return $cpu_load;
		}
	}
	close $infd;
	return "unknown";
}
#
proc auditsp { labid sp ip audtype verbose } {
	#
	# local PID for file names
	#
	append tfile "/tmp/out" [pid];
	append tfile2 "/tmp/out2" [pid];
	#
	# login remotely
	#
	telnet_to $ip ip_id;
	#
	# get the swCPU load name first.
	#
	set status [remote_exec $ip_id "ls -dl /Telica/swCPU/CurrRel 1>$tfile 2>/dev/null"];
	if {$status != 0} {
		puts "\nremote_exec failed getting CurrRel.";
		return 2;
	}
	ftp_get_ascii_file $ip "$tfile" "$tfile" 0777;
	set cpu_load [parse_cpu_load $tfile];
	if {"$cpu_load" == "unknown"} {
		puts "\nUnable to get CPU load for $labid $sp $ip.";
		close_telnet $ip_id;
		catch {
			file delete -force -- $tfile;
			file delete -force -- $tfile2;
		} ignore;
		return 2;
	}
	puts "\nIP $ip has CPU load $cpu_load.";
	#
	# get list of files on SP.
	#
	set status [remote_exec $ip_id "find /Telica/sw* -type f -exec ls -l \{\} \\; >$tfile2"];
	if {$status != 0} {
		puts "\nremote_exec failed running 'find ...'.";
		return 2;
	}
	ftp_get_ascii_file $ip "$tfile2" "$tfile2" 0777;
	#
	# call local audit to compare files.
	#
	catch { 
		system "/home/lcstools/tools/bin/comparefiles $labid $sp $cpu_load $tfile2 $audtype $verbose";
	} ignore;
	#
	# close connection and clean up.
	#
	close_telnet $ip_id;
	catch {
		file delete -force -- $tfile;
		file delete -force -- $tfile2;
	} ignore;
	#
	return 0;
}
#
proc faudit { labid audtype } {
	# variables
	global env;
	global auditSPA;
	global auditSPB;
	global appmode;
	global minmode;
	global verbose;
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
	if {$auditSPA != 0} {
		if {$lcsips(SP_A_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_A_IP)];
			if {$spastatus == "alive"} {
				puts "\n$labid SP_A is alive.";
				myflush;
				# check if SP-A UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_A_IP)];
				puts "$labid SP_A UNIX is $spastatus.";
				myflush;
				# audit if active
				if {$spastatus == "active"} {
					puts "\nauditing $labid SP_A.";
					auditsp $labid "SP_A" $lcsips(SP_A_IP) $audtype $verbose;
				} else {
					puts "\nskip auditing $labid SP_A.";
				}
			} else {
				puts "\n$labid SP_A is not responding.";
				myflush;
			}
		} else {
			puts "\n$labid No SP_A_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "\nskip audit $labid SP_A.";
		myflush;
	}
	if {$auditSPB != 0} {
		if {$lcsips(SP_B_IP) != ""} {
			# check if responding on network
			set spastatus [lcsping $lcsips(SP_B_IP)];
			if {$spastatus == "alive"} {
				puts "\n$labid SP_B is alive.";
				myflush;
				# check if SP-B UNIX is active
				set spastatus [lcsunixactive $lcsips(SP_B_IP)];
				puts "$labid SP_B UNIX is $spastatus.";
				myflush;
				# audit if active
				if {$spastatus == "active"} {
					puts "\nauditing $labid SP_B.";
					auditsp $labid "SP_B" $lcsips(SP_B_IP) $audtype $verbose;
				} else {
					puts "\nskip auditing $labid SP_B.";
				}
			} else {
				puts "\n$labid SP_B is not responding.";
				myflush;
			}
		} else {
			puts "\n$labid No SP_B_IP found for labid $labid.";
			myflush;
		}
	} else {
		puts "\nskip auditing $labid SP_B.";
		myflush;
	}
	return;
}
#
#########################################################################
#
# default values
#
set username "root";
set userpasswd "plexus9000";
set verbose 0;
set logfile "";
set auditSPA 1;
set auditSPB 1;
set audtype "all";
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
	{^-c} { set audtype "cpu"; }
	{^-i} { set audtype "iom"; }
	{^-A} { set auditSPA 1; set auditSPB 0; }
	{^-B} { set auditSPB 1; set auditSPA 0; }
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
logusage lcsspaudit;
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
# audit lab SPs
#
if {$arg >= $argc} {
	# audit the lab for the current labid
	checklabid
	set labid $env(LABID);
	faudit $labid $audtype;
} else {
	# audit the labs for the given labids
	for { } {$arg<$argc} {incr arg} {
		set labid [lindex $argv $arg];
		faudit $labid $audtype;
	}
}
#
# done
#
exit 0
