#!/opt/exp/bin/expect
#
# remotely update files on an SP after a reload.
#
#########################################################################
#
# libraries
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/db
source $env(LCSTOOLSLIB)/chooseone
source $env(LCSTOOLSLIB)/lcsftp
source $env(LCSTOOLSLIB)/logging
#
# functions
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;

	puts "usage: [file tail $argv0] \[-\?] \[-x] \[-S trace level] \[-V]";
	puts "	\[-l logfile] \[-u username] \[-p passwd] ";
	puts "	\[-m] \[-t] \[-s|-d] \[-D|-C] \[-h] \[-c num] \[-a] \[-A] \[-B] \[labid]";
	puts "where:";
	puts "	-? - print usage";
	puts "	-x - enable TCL debugger";
	puts "	-V - set verbose";
	puts "	-S tracelevel - set trace to given stack level ";
	puts "	-l logfile - log all output to a logfile";
	puts "	-u username - set username for logins";
	puts "	-p passwd - passwd for username";
	puts "";
	puts "	-m - update MOTD with load and labid";
	puts "	-s - simplex the lab";
	puts "	-d - duplex the lab";
	puts "	-D - disable Disk Clean Up";
	puts "	-C - enable Disk Clean Up";
	puts "	-h - add extra entries to /etc/hosts (ihgp, lts08, xtm*)";
	puts "	-c num - set number of simultaneous CPY-MEMs to 'num'";
	puts "	-t - set CPU date/time equal to LSP date/time";
	puts "";
	puts "	-a - set options to '-t -m -d -D -h -c 10'";
	puts "";
	puts "	-A - update SP-A ONLY; default is both SPs.";
	puts "	-B - update SP-B ONLY; default is both SPs.";
	puts "";
	puts "	default username = $username";
	puts "	default passwd = $userpasswd";
	puts "	labid is read from variable LABID, unless given.";
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
#########################################################################
#
# default values
#
set username "root";
set userpasswd "plexus9000";
set maxlogons 5;
set stracelevel -1;
set logfile "";
set labid "";
set labmode "";
set hostfiles "";
set motd "";
set diskcleanup "";
set cpymem "";
set cpymemnum 0;
set doSPA 1;
set doSPB 1;
set setdate 0;
#
# get cmd line options
#
log_user 0;
#
puts "\npostlcsreload options:";
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-\?} { usage; exit 0; }
	{^-x} { debug -now; }
	{^-V} { log_user 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-a} { 
		set labmode " -d"; puts "run duplex mode.";
		set diskcleanup " -D"; puts "disable disk cleanup.";
		set doSPA 1; puts "update SP-A.";
		set doSPB 1; puts "update SP-B.";
		set hostfiles " -h"; puts "update /etc/hosts file.";
		set motd " -m"; puts "update message-of-the-day, /etc/motd.";
		set cpymem " -c 10"; puts "set max cpy-mem to 10.";
		set setdate 1; puts "set CPU date/time = LSP date/time.";
	}
	{^-s} { set labmode " -s"; puts "run simplex mode."; }
	{^-d} { set labmode " -d"; puts "run duplex mode."; }
	{^-C} { set diskcleanup " -C"; puts "enable disk cleanup."; }
	{^-D} { set diskcleanup " -D"; puts "disable disk cleanup."; }
	{^-A} { set doSPA 1; set doSPB 0; puts "update SP-A only."; }
	{^-B} { set doSPA 0; set doSPB 1; puts "update SP-B only."; }
	{^-h} { set hostfiles " -h"; puts "update /etc/hosts file."; }
	{^-m} { set motd " -m"; puts "update /etc/motd."; }
	{^-t} { set setdate 1; puts "set CPU date/time = LSP date/time."; }
	{^-c.*} { 
		getoptval $argval cpymemnum arg; 
		set cpymem " -c $cpymemnum"; 
		puts "set max cpy-mem to $cpymemnum.";
	}
	{^--} { incr arg; break; }
	{^-.*} { puts "Unknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
# debugging and sanity checks.
#
if {$stracelevel >= 0} {
	strace $stracelevel;
}
#
if {[string length $logfile] > 0} {
	if {[catch {log_file -noappend -a $logfile; } status]} {
		puts "Logging failed for file $logfile:\n$status";
		exit 2;
	}
	log_user 1;
}
#
checkenv;
#
logusage postlcsreload;
#
# get ip addresses for labid.
#
if {$arg<$argc} {
	set labid [lindex $argv $arg];
} elseif {[info exists env(LABID)]} {
	set labid $env(LABID);
} else {
	puts "LABID is neither set nor given.";
	exit 2;
}
puts "\nStarting postlcsreload of lab $labid:\n";
#
# get SP IPs
#
if {[dbselect obuf chassis "labid req ^$labid\$" "cpu_a_ip cpu_b_ip" ] != 0} {
	puts "postlcsreload: dbselect of relation 'chassis' failed.";
	exit 2;
}
if {![info exists obuf] || [llength obuf] == 0} {
	puts "postlcsreload: no IPs found for labid $labid.";
	exit 2;
}
#
set ips [lindex $obuf 0];
set ipdata [split $ips " \t"];
set cpu_a_ip [lindex $ipdata 0];
set cpu_b_ip [lindex $ipdata 1];
#
# get command line 
#
set cmd "/bin/postlcsreload$labmode$diskcleanup$hostfiles$cpymem";
#
# update SPs.
#
if {$doSPA != 0} {
	set spacmd "$cmd";
	if {$motd == " -m"} {
		set spacmd "$cmd -m \"$labid SP-A\"";
	}
	puts "exec'ing cmd $spacmd on SP-A ...";
	ftp_put_ascii_file $cpu_a_ip "$env(LCSTOOLSBIN)/iprecover" "/bin/iprecover";
	remote_exec $cpu_a_ip "/bin/chmod 755 /bin/iprecover";
	ftp_put_ascii_file $cpu_a_ip "$env(LCSTOOLSBIN)/remotepostlcsreload" "/bin/postlcsreload";
	remote_exec $cpu_a_ip "/bin/chmod 755 /bin/postlcsreload";
	remote_exec $cpu_a_ip "$spacmd";
	if {$setdate != 0} {
		set env(TZ) "US/Central";
		set lsptime [clock format [clock seconds] -format "%Y%m%d%H%M"];
		puts "Setting CPU TIME to LSP TIME: $lsptime";
		remote_exec $cpu_a_ip "/bin/date -d1 -z360 ${lsptime}";
		# set time on SP-A slave CPU
		remote_exec $cpu_b_ip "rsh 192.168.252.30 '/bin/date -d1 -z360 ${lsptime};'";
		#
		# remote_exec $cpu_a_ip "/bin/sed 's/date.*-d.*-z.*/date -d1 -z360/' /bin/rc >/bin/rc.[pid]";
		#
		remote_exec $cpu_a_ip "grep -v 'date.*-d1.*-z360' /.profile >/.profile.[pid]";
		remote_exec $cpu_a_ip "echo '/bin/date -d1 -z360' >>/.profile.[pid]";
		remote_exec $cpu_a_ip "mv /.profile.[pid] /.profile";
	}
}
if {$doSPB != 0} {
	set spbcmd "$cmd";
	if {$motd == " -m"} {
		set spbcmd "$cmd -m \"$labid SP-B\"";
	}
	puts "exec'ing cmd $spbcmd on SP-B ...";
	ftp_put_ascii_file $cpu_b_ip "$env(LCSTOOLSBIN)/iprecover" "/bin/iprecover";
	remote_exec $cpu_b_ip "/bin/chmod 755 /bin/iprecover";
	ftp_put_ascii_file $cpu_b_ip "$env(LCSTOOLSBIN)/remotepostlcsreload" "/bin/postlcsreload";
	remote_exec $cpu_b_ip "/bin/chmod 755 /bin/postlcsreload";
	remote_exec $cpu_b_ip "$spbcmd";
	if {$setdate != 0} {
		set env(TZ) "US/Central";
		set lsptime [clock format [clock seconds] -format "%Y%m%d%H%M"];
		puts "Setting CPU TIME to LSP TIME: $lsptime";
		remote_exec $cpu_b_ip "/bin/date -d1 -z360 ${lsptime}";
		# set time on SP-B slave CPU
		remote_exec $cpu_b_ip "rsh 192.168.252.31 '/bin/date -d1 -z360 ${lsptime};'";
		#
		# remote_exec $cpu_b_ip "/bin/sed 's/date.*-d.*-z.*/date -d1 -z360/' /bin/rc >/bin/rc.[pid]";
		#
		remote_exec $cpu_b_ip "grep -v 'date.*-d1.*-z360' /.profile >/.profile.[pid]";
		remote_exec $cpu_b_ip "echo '/bin/date -d1 -z360' >>/.profile.[pid]";
		remote_exec $cpu_b_ip "mv /.profile.[pid] /.profile";
	}
}
#
exit 0;

