#!/opt/exp/bin/expect
#
source $env(LCSTOOLSLIB)/lock
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/checkenv
#
proc usage { } {
	global argv0;
	puts "usage: [file tail $argv0] \[-\?] \[-t tracelevel] \[-V|-P] locktype labid";
}
#
########################################################################
#
set oper "";
log_user 1;
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-t.*} {
		getoptval $argval stracelevel arg;
		if {$stracelevel >= 0} {
			strace $stracelevel;
		}
	}
	{^-\?} { usage; exit 0; }
	{^-P} { set oper "PP"; }
	{^-V} { set oper "VV"; }
	{^--} { incr arg; break; }
	{^-.*} { puts "unknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
checkenv;
#
if {($arg+1)<$argc} {
	set locktype [lindex $argv $arg];
	set labid [lindex $argv [incr arg] ];
} else {
	puts "locktype and/or labd were not given.";
	usage;
	exit 2;
}
#
if {$oper == "VV"} {
	set status [V $locktype $labid];
	if {$status} {
		puts "V($locktype $labid) succeeded ...";
	} else {
		puts "V($locktype $labid) failed ...";
	}
} elseif {$oper == "PP"} {
	set status [P $locktype $labid ];
	if {$status} {
		puts "P($locktype $labid) succeeded ...";
	} else {
		puts "P($locktype $labid) failed ...";
	}
} else {
	puts "unknown lock operation: $oper.";
	exit 2;
}
#
exit 0;
