#!/opt/exp/bin/tclsh
#
# update IOMs in a lab using update_flash_partition
#
#########################################################################
#
lappend auto_path [file join [file dirname [info script]] ../lib]
#
# packages we need 
#
package require Expect
#
# libraries
#
package require db
package require checkenv
package require getoptval
package require checkretval
package require chooseone
package require hwmaint
package require cleis
#
# signal handler
#
trap {
	global startok;
	puts "";
	set signame [trap -name];
	set signo [trap -number];
	puts "\nERROR: Got signal <$signame,$signo>";
	exit 2;
} {SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM SIGBUS};
#
# functions
#
proc usage { } {
	global argv0;
	#
	puts "usage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-s trace level]";
	puts "	\[-u TL1 username] \[-p TL1 passwd] \[-U username] \[-P passwd]";
	puts "	\[+S] \[-S iomstate \[,iomstate2 ,...] | -I iom1 \[,iom2 ,...]] \[labid]";
	puts "";
	puts "where:";
	puts "	-? - usage message";
	puts "	-V - enable verbose output";
	puts "	-s tracelevel - set trace to given stack level";
	puts "	-u username - TL1 login (default is telica)";
	puts "	-p passwd - TL1 passwd (default is telica)";
	puts "	-U username - Lynx-OS login (default is root)";
	puts "	-P passwd - Lynx-OS passwd (default is plexus9000)";
	puts "	+S - disable IOM states checks";
	puts "	-S state,... - list of IOM states (defaults are oosma and ";
	puts "	               oosaumaflt; use +X to disable checks).";
	puts "	-I iom1,... - list of IOMs to update.";
	puts "";
	puts "update all IOMS with the given states or from the given list";
	puts "of IOMs. by default, the IOMs-to-update are determined by state";
	puts "using the default states of oosma and oosaumaflt. labid is";
	puts "determined from the command line or from the environment";
	puts "variable LABID. here are some examples.";
	puts "";
	puts "to update all IOMs, you need to turn off IOM state checks:";
	puts "	$ updateioms +S";
	puts "to update faulted IOMs that were manually removed (default):";
	puts "	$ updateioms";
	puts "to update IOMs 1 and 3, regardless of state:";
	puts "	$ updateioms -I 1,3 +S ";
	puts "to update IOMs that are standby cold:";
	puts "	$ updateioms -S isstbyc";
	puts "to update IOMs that are manually OOS and faulted:";
	puts "	$ updateioms -S oosaumaflt";
	puts "to update IOMs that are manually OOS:";
	puts "	$ updateioms -S oosma";
	puts "";
}
#
#########################################################################
#
# declarations and default values.
#
global env;
set stracelevel -1;
set tl1username "telica";
set tl1passwd "telica";
set lynxusername "root";
set lynxpasswd "plexus9000";
set iomstates "oosma,oosaumaflt";
set iomlist "";
#
log_user 0;
#
# get cmd line options
#
set argc [llength $argv];
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} {
		# enable TCL debugger
		debug -now;
	}
	{^-V} {
		# turn on verbose
		log_user 1;
	}
	{^-R} {
		# recover failed IOMs
		set recoverioms 1;
	}
	{^-s.*} {
		# set function/stack trace level
		getoptval $argval stracelevel arg;
		if {$stracelevel >= 0} {
			strace $stracelevel;
		}
	}
	{^-u.*} {
		# get TL1 user name
		getoptval $argval tl1username arg;
	}
	{^-p.*} {
		# get TL1 passwd
		getoptval $argval tl1passwd arg;
	}
	{^-U.*} {
		# get Lynx-OS user name
		getoptval $argval lynxusername arg;
	}
	{^-P.*} {
		# get Lynx-OS passwd
		getoptval $argval lynxpasswd arg;
	}
	{^-I.*} {
		# list of ioms
		getoptval $argval iomlist arg;
	}
	{^\+S} {
		# turn off iom states checks
		set iomstates "*";
	}
	{^-S.*} {
		# list of iom states
		getoptval $argval iomstates arg;
	}
	{^-\?} {
		# print help message and quit
		usage; 
		exit 0;
	}
	{^--} {
		# skip and done
		incr arg;
		break;
	}
	{^-.*} {
		puts "\nunknown option: $argval\n";
		usage; 
		exit 2;
	}
	default {
		# unknown and done
		break;
	}
	}
}
#
# check environment
checkenv;
#
set logfile "/lcsl100/tmp/updateioms.[pid]";
puts "\nDefault logfile is ${logfile}.";
if {[catch {log_file -noappend -a $logfile; } status]} {
	puts "\nWARNING: Logging failed for file $logfile:\n$status";
}
catch { system /usr/bin/chmod 777 $logfile; } ignore;
#
set status [initCleiData];
if {[isNotOk $status]} {
	puts "\nERROR: initCleiData Failed: \n$status";
	exit 2;
}
#
global argv0;
global argv;
catch { system "lcssyslog -q syslog \"Starting $argv0 $argv.\""; } ignore;
#
# get labid 
#
if {$arg<$argc} {
	set labid [lindex $argv $arg];
} elseif {[info exists env(LABID)]} {
	set labid $env(LABID);
} else {
	puts "\nERROR: LABID is neither set nor given.";
	exit 2;
}
#
#
global argv0;
catch { system "lcssyslog -q syslog \"Starting $argv0 for $labid.\""; } ignore;
#
# get the lab IPs.
#
set status [dbselect obuf chassis "labid req ^$labid\$" "cpu_a_ip cpu_b_ip"];
if {[isNotOk $status]} {
	puts "\nERROR: dbselect of relation 'chassis' failed: \n${status}";
	exit 2;
}
if {![info exists obuf] || [llength obuf] == 0} {
	puts "\nERROR: No IPs found for labid $labid. Unknown labid.";
	exit 2;
}
#
set ips [lindex $obuf 0];
set ipdata [split $ips " \t"];
set sp_a_ip [lindex $ipdata 0];
set sp_b_ip [lindex $ipdata 1];
#
puts "";
puts "Updating IOMs for LABID ${labid}:"
puts "";
puts "SP-A IP    : ${sp_a_ip}";
puts "SP-B IP    : ${sp_b_ip}";
puts "TL1 Login  : ${tl1username}";
puts "TL1 Passwd : ${tl1passwd}";
puts "Lynx Login : ${lynxusername}";
puts "Lynx Passwd: ${lynxpasswd}";
puts "IOM states : ${iomstates}";
puts "IOM list   : ${iomlist}";
#
# update the ioms
#
set status [hw_maint_update_ioms ${labid} ${sp_a_ip} ${sp_b_ip} ${tl1username} ${tl1passwd} ${lynxusername} ${lynxpasswd} "${iomstates}" "${iomlist}" ];
if {[isNotOk $status]} {
	puts "\nERROR: hw_maint_update_ioms failed: \n${status}";
	exit 2;
}
#
# all done
#
puts "\nDone.";
exit 0;
