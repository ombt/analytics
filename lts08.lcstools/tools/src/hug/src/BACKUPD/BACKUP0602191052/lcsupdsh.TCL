#!/opt/exp/bin/tclsh
#
# run a script to update a plexus switch.
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
package require logging
package require checkenv
package require getoptval
package require checkretval
package require cfgdata
package require scripts
#
# functions
#
proc usage { } {
	global argv0;

	puts "usage: [file tail $argv0] \[-\?] \[-V] ";
	puts "	\[-S trace level] \[-L logfile] ";
	puts "	\[-p] \[-l] \[-s section] \[-c cmdno] script_filename";
	puts "";
	puts "where:";
	puts "	-? - usage message";
	puts "	-V - enable verbose output";
	puts "	-S tracelevel - set trace to given stack level";
	puts "	-L filename - log file name";
	puts "";
	puts "	-s section - section in script to execute";
	puts "	-c cmdno - line# of command in section to start executing.";
	puts "	-p - print cfg data."
	puts "	-l - list all cmds after source files are read."
	puts "";
	puts "Script file contains Tl1 or Shell commands to update a switch."
	puts "If no section is given, then the first executable section is";
	puts "chosen and the commands in that section are executed one by one.";
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
set printdata 0;
set printcmds 0;
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
	{^-p} { set printdata 1; }
	{^-l} { set printcmds 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-L.*} { getoptval $argval logfile arg; }
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
	puts "\ninitCfgData Failed: \n$status";
	exit 2;
}
#
set status [initCmdData cmddata];
if {[isNotOk $status]} {
	puts "\ninitCmdData Failed: \n$status";
	exit 2;
}
#
set status [readCfgDataFile cfgdata cmddata $scriptfile];
if {[isNotOk $status]} {
	puts "\nreadCfgDataFile Failed: \n$status";
	exit 2;
}
#
if {$printdata != 0} {
	printCfgData cfgdata;
}
if {$printcmds != 0} {
	printCmdData cmddata;
}
if {$printdata == 0 && $printcmds == 0} {
	set status [execScript cfgdata $startsec $startcmd];
	if {[isNotOk $status]} {
		puts "\nexecScript Failed: \n$status";
		exit 2;
	}
}
#
exit 0;

