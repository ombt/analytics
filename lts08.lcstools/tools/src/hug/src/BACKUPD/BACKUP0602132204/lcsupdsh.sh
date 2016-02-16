#!/opt/exp/bin/tclsh
#
# run a script to update a plexus switch.
#
#########################################################################
#
# packages we need 
#
package require Expect
#
# libraries
#
source $env(LCSHUGLIB)/logging
source $env(LCSHUGLIB)/checkenv
source $env(LCSHUGLIB)/getoptval
source $env(LCSHUGLIB)/checkretval
source $env(LCSHUGLIB)/cfgdata
source $env(LCSHUGLIB)/scripts
#
# functions
#
proc usage { } {
	global argv0;

	puts "usage: [file tail $argv0] \[-\?] \[-V] ";
	puts "	\[-S trace level] \[-l logfile] ";
	puts "	\[-s section] \[-c cmdno] script_filename";
	puts "";
	puts "where:";
	puts "	-? - usage message";
	puts "	-V - enable verbose output";
	puts "	-S tracelevel - set trace to given stack level";
	puts "	-l filename - log file name";
	puts "";
	puts "	-s section - section in script to execute";
	puts "	-c cmdno - line# of command in section to start executing.";
	puts "";
	puts "Script file contains update Tl1 and/or Shell commands to";
	puts "update switch. If no section is given, then the first executable";
	puts "section is chosen and the commands in that section are";
	puts "executed one by one.";
	puts "";
	puts "Section types are data, cmds, and script. The type field";
	puts "within each section is required. If the type field is missing,";
	puts "then the script fails the basic sanity checks."
}
#
#########################################################################
#
# default values
#
set stracelevel -1;
set logfile "";
set startcmd 1;
set startsec "";
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
	{^-x} { debug -now; }
	{^-V} { log_user 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-c.*} { getoptval $argval startcmd arg; }
	{^-s.*} { getoptval $argval startsec arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "\nunknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
# check environment
checkenv;
#
# check if logging is requested.
#
if {[string length $logfile] > 0} {
	if {[catch {log_file -noappend -a $logfile; } status]} {
		puts "\nlogging failed for file $logfile:\n$status";
		exit 2;
	}
}
#
# check if function trace is requested.
#
if {$stracelevel >= 0} {
	strace $stracelevel;
}
#
# check if any arguments left.
#
if {$argc < 1} {
	usage
	exit 2;
}
#
# read in script and execute.
#
if {$arg>=$argc} {
	puts "\nNo script file was given.";
	exit 2;
}
set scriptfile [lindex $argv $arg];
#
puts "\nExecuting Script File: $scriptfile";
	#
set status [initCfgData cfgdata];
if {[isNotOk $status]} {
	puts "\ninitCfgData Failed: $status";
	exit 2;
}
#
set status [readCfgDataFile cfgdata $scriptfile];
if {[isNotOk $status]} {
	puts "\nreadCfgDataFile Failed: $status";
	exit 2;
}
#
set status [execScript cfgdata $startsec $startcmd];
if {[isNotOk $status]} {
	puts "\nexecScript Failed: $status";
	exit 2;
}
#
exit 0;
