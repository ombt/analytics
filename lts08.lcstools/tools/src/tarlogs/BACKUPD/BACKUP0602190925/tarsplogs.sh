#!/opt/exp/bin/expect
#
# tar all SP log files.
#
#########################################################################
#
# libraries
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/db
source $env(LCSTOOLSLIB)/chooseone
source $env(LCSTOOLSLIB)/lcstelnet
source $env(LCSTOOLSLIB)/lcsftp
#
# data
#
source $env(LCSTOOLSLIB)/mgcips
#
# functions
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;
	#
	puts "";
	puts "usage: [file tail $argv0] \[-\?] \[-x] \[-V]";
	puts "	\[-S trace level] \[-l logfile] ";
	puts "	\[-A | -B] \[-u username] \[-p passwd] \[-L labid] ";
	puts "	\[-F ftp_path] ";
	puts "";
	puts "where:";
	puts "	-x - enable TCL debugger";
	puts "	-V - verbose mode";
	puts "	-S tracelevel - set trace to given stack level ";
	puts "	-l logfile - log all output to a logfile";
	puts "	-A - choose SP-A";
	puts "	-B - choose SP-B";
	puts "	-L labid - set labid";
	puts "	-F ftp_path - local path to store TAR files";
	puts "";
	puts "	default username = $username";
	puts "	default passwd = $userpasswd";
	puts "";
	puts "labid is read from variable LABID, unless given.";
	puts "If the -F option is used, then the tar files are copied ";
	puts "locally. If -F is not used, then the tar files are left on ";
	puts "the SP.";
}
#
proc getcmlogfile { labid activesp activeip cm ftppath } {
	global cm_cpu_ips;
	global sp_cpu_ips;
	#
	puts "";
	puts "Retrieving $activesp CM $cm log files:";
	#
	telnet_to $activeip ip_id;
	#
	for {set cpu 1} {$cpu<=4} {incr cpu} {
		if {![info exists cm_cpu_ips($cm,$cpu)]} {
			puts "CM $cm CPU $cpu IP: DOES NOT EXIST";
			continue;
		}
		set cm_cpu_ip $cm_cpu_ips($cm,$cpu);
		puts "CM $cm CPU $cpu IP: $cm_cpu_ip";
		#
		remote_exec $ip_id "cd /home";
		remote_exec $ip_id "rsh $cm_cpu_ip \"tar czf - /procLogCore/log /procLogCore/oldLog*\" >/home/${labid}_cm${cm}_cpu${cpu}_log.tar.gz " 300;
	}
	remote_exec $ip_id "tar cf /home/${labid}_cm${cm}_allcpu_log.tar /home/${labid}_cm${cm}_cpu*_log.tar.gz " 300;
	remote_exec $ip_id "rm -f /home/${labid}_cm${cm}_cpu*_log.tar.gz 1>/dev/null 2>&1" ;
	#
	close_telnet $ip_id;
	#
	if {$ftppath != ""} {
		ftp_get_binary_file $activeip "/home/${labid}_cm${cm}_allcpu_log.tar" "${ftppath}/${labid}_cm${cm}_allcpu_log.tar";
	}
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
set activeip "";
set labid "";
set verbose 0;
set sp "";
set ftppath "";
#
set pwd $env(PWD);
#
log_user 0;
#
# get cmd line options
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-V} { set verbose 1; }
	{^-A} { set sp "A"; }
	{^-B} { set sp "B"; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-L.*} { getoptval $argval labid arg; }
	{^-F.*} { getoptval $argval ftppath arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "\nunknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
# function tracing
#
if {$stracelevel >= 0} {
	strace $stracelevel;
}
#
# check if logging is enabled.
#
if {[string length $logfile] > 0} {
	cd ${pwd};
	if {[catch {log_file -noappend -a $logfile; } status]} {
		puts "\nlogging failed for file $logfile:\n$status";
		exit 2;
	}
}
if {$verbose > 0} {
	log_user 1;
}
#
checkenv;
#
# get ip addresses for labid.
#
if {$labid == ""} {
	if {[info exists env(LABID)]} {
		set labid $env(LABID);
	} else {
		puts "LABID is neither set nor given.";
		exit 2;
	}
}
#
if {[dbselect obuf chassis "labid req ^$labid\$" "cpu_a_ip cpu_b_ip" ] != 0} {
	puts "tarcmlogs: dbselect of relation 'chassis' failed.";
	exit 2;
}
if {![info exists obuf] || [llength obuf] == 0} {
	puts "tarcmlogs: no IPs found for labid $labid.";
	exit 2;
}
#
set ips [lindex $obuf 0];
set ipdata [split $ips " \t"];
set cpu_a_ip [lindex $ipdata 0];
set cpu_b_ip [lindex $ipdata 1];
#
if {$sp == "A"} {
	set activeip "SP-A $cpu_a_ip";
} elseif {$sp == "B"} {
	set activeip "SP-B $cpu_b_ip";
} else {
	lappend choices "SP-A $cpu_a_ip" "SP-B $cpu_b_ip";
	set choices [linsert $choices 0 "QUIT"];
	chooseone "Choose active SP-IP: " choices activeip;
	if {$activeip == "QUIT"} {
		puts "exiting tarcmlogs.";
		exit 0;
	}
}
#
set ipdata [split $activeip " \t"];
set activesp [lindex $ipdata 0];
set activeip [lindex $ipdata 1];
#
if {[dbselect obuf hwioms "labid req ^$labid\$ and type req ^cm\$" "iom" ] != 0} {
	puts "tarcmlogs: dbselect of relation 'hwioms' failed.";
	exit 2;
}
if {![info exists obuf] || [llength obuf] == 0} {
	puts "tarcmlogs: no CMs found for labid $labid.";
	exit 2;
}
foreach cm $obuf {
	set cms($cm) $cm;
}
#
# get log files
#
puts "";
puts "Retrieving CM log files for $labid:";
puts "";
puts "All log files are under $activesp /home.";
#
if {$arg<$argc} {
	for { } {$arg<$argc} {incr arg} {
		set cm [lindex $argv $arg];
		if {![info exists cms($cm)]} {
			puts "";
			puts "CM $cm DOES NOT EXIST. SKIPPING IT.";
			continue;
		}
		getcmlogfile $labid $activesp $activeip $cm $ftppath;
	}
} else {
	for {set cm 1} {$cm<=20} {incr cm} {
		if {![info exists cms($cm)]} {
			continue;
		}
		getcmlogfile $labid $activesp $activeip $cm $ftppath;
	}
}
#
puts "exiting tarcmlogs.";
exit 0
