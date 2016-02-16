#!/opt/exp/bin/expect
#
# run a TL1 script remotely
#
#########################################################################
#
# libraries
#
source $env(LCSTOOLSLIB)/logging
source $env(LCSTOOLSLIB)/checkenv
#
# functions
#
proc ucondclose { } {
	global spawn_id;
	catch { close; wait; } status;
}
#
proc traceputs { msg } {
	global traceflag;
	if {$traceflag} {
		puts "$msg";
	}
}
#
proc getoptval { argval varname argname } {
	global argv;
	upvar $varname var;
	upvar $argname arg;
	#
	if {[string length $argval] == 2} {
		incr arg;
		set var [lindex $argv $arg];
	} else {
		set var [string range $argval 2 end];
	}
}
#
proc stripcmd { cmd } {
	traceputs "stripcmd: cmd is <$cmd>";
	set cmd [string trim $cmd];
	traceputs "stripcmd: strip leading/trailing whitespace, cmd is <$cmd>";
	set cmd [string trim $cmd "\""];
	traceputs "stripcmd: strip leading/trailing \", cmd is <$cmd>";
	set cmd [string trimright $cmd ";"];
	traceputs "stripcmd: strip trailing ;, cmd is <$cmd>";
	return $cmd;
}
#
proc usage { } {
	global argv0;
	global maxlogons;
	global username;
	global userpasswd;
	global ipaddr;

	puts "usage: [file tail $argv0] \[-\?] \[-x] \[-T] \[-V] \[-t tid] \[-m max_logon_attempts]";
	puts "              \[-S trace level] \[-l logfile] \[-u username] \[-p passwd] \[-i ip-addr] scriptname";
	puts "where:";
	puts "	-x - enable TCL debugger";
	puts "	-T - enable trace messages";
	puts "	-V - enable verbose output";
	puts "	-D - exit upon first failure (DENY)";
	puts "	-S tracelevel - set trace to given stack level ";
	puts "";
	puts "	default max_logon_attempts = $maxlogons";
	puts "	default username = $username";
	puts "	default passwd = $userpasswd";
	puts "	default ip-addr = $ipaddr";
	puts "	logging is not enabled by default";
	puts "	if logging is enable with a -l cmd, all cmds that are ";
	puts "	executed will be logged in five files in the home directory.";
	puts "	the files are completed.tl1exec, denied.tl1exec, inprogress.tl1exec,";
	puts "	timedout.tl1exec and misc.tl1exec. outpur is appended to the files.";
	puts "	each new session starts with a timestamp.";
}
#
proc initcounters { arrayname } {
	upvar $arrayname counters;
	set counters(COMPLETED) 0;
	set counters(DENIED) 0;
	set counters(INPROGRESS) 0;
	set counters(TIMEOUT) 0;
	set counters(EXECUTED) 0;
	set counters(MISCELLANEOUS) 0;
	set counters(SLEEP) 0;
	set counters(COMMENTS) 0;
}
#
proc dumpcounters { arrayname } {
	upvar $arrayname counters;
	set counternames [array names counters]
	set maxlen 0;
	puts "\n\nCMD RESULTS SUMMARY:";
	foreach cname $counternames {
		set cnamelen [string length $cname];
		if {$maxlen < $cnamelen} {
			set maxlen $cnamelen;
		}
	}
	if {$maxlen <= 0} {
		return;
	}
	puts "";
	foreach cname $counternames {
		puts [format "%-${maxlen}s: %d" $cname $counters($cname)];
	}
}
#
#########################################################################
#
# default values
#
set tid "telica";
set username "telica";
set userpasswd "telica";
set ipaddr "127.0.0.1"
set scriptname "";
set maxlogons 10;
set traceflag 0;
set verbose 0;
set exitondeny 0;
set stracelevel -1;
set logfile "";
#
# get cmd line options
#
set argc [llength $argv];
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-T} { set traceflag 1; }
	{^-V} { set verbose 1; }
	{^-D} { set exitondeny 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-m.*} { getoptval $argval maxlogons arg; }
	{^-t.*} { getoptval $argval tid arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-i.*} { getoptval $argval ipaddr arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "\nunknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
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
} else {
	puts "tid    : $tid";
	puts "ipaddr : $ipaddr";
	puts "login  : $username";
	puts "passwd : [regsub -all -- "." $userpasswd "X"]";
	puts "logfile: $logfile";
}
#
checkenv;
#
# check if logging is enabled.
#
if {[string length $logfile] > 0} {
	if {[catch {log_file -noappend -a $logfile; } status]} {
		puts "\nlogging failed for file $logfile:\n$status";
		exit 2;
	}
}
#
# read file into a list
#
set filename [lindex $argv $arg];
if {![file readable $filename]} {
	puts "\nfile $filename is not readable.";
	exit 2;
}
#
if {[catch {set fd [open $filename "r"]} status]} {
	puts "\nunable to open for read:\n$status";
	exit 2;
}
#
# act-user MUST always be cmd 0.
#
set actuser "act-user::USERNAME:::USERPASSWD"
regsub -- "USERNAME" $actuser "$username" actuser;
regsub -- "USERPASSWD" $actuser "$userpasswd" actuser;
lappend tl1cmds "$actuser";
while {[gets $fd inbuf] > 0} {
	traceputs "$inbuf";
	traceputs "stripped cmd is [stripcmd $inbuf]";
	lappend tl1cmds "[stripcmd $inbuf]";
}
catch { close $fd; wait; } ignore;
#
# open tl1 interface ...
#
if {$verbose} {
	log_user 1;
} else {
	log_user 0;
}
set id "";
set timeout 5;
set tl1port 2361;
set tl1_id "";
#
traceputs "\nconnecting to machine $ipaddr ...";
for {set i 0} {$i<$maxlogons} {incr i} {
	traceputs "\nattempt $i to logon machine $ipaddr ...";
	#
	spawn -noecho telnet $ipaddr $tl1port;
	expect {
	"Connected to " {
		traceputs "\nconnected to $ipaddr at port $tl1port ...";
		set tl1_id $spawn_id;
		break;
	}
	"Connection refused" {
		traceputs "sleep 2 sec, and try again ..."
		set tl1_id "";
		sleep 2;
	}
	timeout {
		puts "\ntimeout during login ...";
		set tl1_id "";
		exit 2;
	}
	}
}
#
if {([string length $tl1_id] <= 0) || ($i>=$maxlogons)} {
	puts "\nunable to telnet to machine $ipaddr, port $tl1port.";
	exit 2;
}
#
send "\r";
expect {
"Telica>" {
	traceputs "\nTL1 prompt received ..."
}
timeout {
	puts "\ntimeout trying to get TL1 prompt ...";
	exit 2;
}
}
#
# log cmds according to final status.
#
if {[string length $logfile] > 0} {
	set home $env(HOME);
	logopen "${home}/inprogress.tl1exec" inprogressfd;
	logopen "${home}/completed.tl1exec" completedfd;
	logopen "${home}/denied.tl1exec" deniedfd;
	logopen "${home}/timedout.tl1exec" timedoutfd;
	logopen "${home}/misc.tl1exec" miscfd;
}
#
# start executing TL1 cmds
#
initcounters counters;
#
if {$verbose} {
	log_user 1;
} else {
	log_user 0;
}
set timeout 10;
set status "";
set maxactusercmds 3;
#
catch {
set cmdcnt [llength $tl1cmds];
for {set cmd 0; set actusercnt 0; } \
    {($cmd<$cmdcnt) && ($actusercnt<$maxactusercmds)} { } {
	#
	set tl1cmd [lindex $tl1cmds $cmd];
	#
	if {$verbose} {
		log_user 1;
	} else {
		log_user 0;
	}
	# enable if a rtrv cmd.
	switch -regexp -- ${tl1cmd} {
	{[rR][tT][rR][vV]-} {
		log_user 1;
	}
	{^[ \t]*$} {
		# skip empty lines
		continue;
	}
	{^[ \t]*#} {
		# skip comments
		incr counters(COMMENTS);
		incr cmd;
		continue;
	}
	}
	# check for request to sleep.
	if {[regexp -- {^[ \t]*sleep[ \t]+([0-9]+)} $tl1cmd mstr submstr] == 1} {
		incr counters(SLEEP);
		sleep $submstr;
		incr cmd;
		continue;
	}
	#
	if {$cmd > 0} {
		puts "\nTL1 cmd <$tl1cmd> ...";
	} else {
		puts "\nTL1 cmd <act-user::${username}:::[regsub -all -- "." $userpasswd "X"] > ...";
	}
	incr counters(EXECUTED);
	send "$tl1cmd;\r";
	#
	set checkforprompt 1;
	set checkfordeny 0;
	set incrflag 1;
	#
	expect {
	-re "M.*\[0-9]+.*COMPLD" {
		incr counters(COMPLETED);
		puts "\nCOMPLETED received ...";
		if {[string length $logfile] > 0} {
			logwrite $completedfd "$tl1cmd";
		}
	}
	-re "M.*\[0-9]+.*IP" {
		incr counters(INPROGRESS);
		puts "\nIN PROGRESS received ...";
		if {[string length $logfile] > 0} {
			logwrite $inprogressfd "$tl1cmd";
		}
	}
	-re "M.*\[0-9]+.*DENY" {
		incr counters(DENIED);
		puts "\nDENY received ...";
		set checkfordeny 1;
		if {[string length $logfile] > 0} {
			logwrite $deniedfd "$tl1cmd";
		}
		if {$exitondeny} {
			puts "\nEXITING ON FIRST FAILURE ...\n";
			exit 2;
		}
	}
	-re ";\r\nTelica>" {
		incr counters(MISCELLANEOUS);
		set checkforprompt 0;
		traceputs "\nTelica prompt received ...";
		if {[string length $logfile] > 0} {
			logwrite $miscfd "$tl1cmd";
		}
	}
	timeout {
		incr counters(TIMEOUT);
		puts "\ntimeout waiting for a response ...";
		if {[string length $logfile] > 0} {
			logwrite $timedoutfd "$tl1cmd";
		}
	}
	}
	#
	if {$checkforprompt} {
		expect {
		-re ";\r\nTelica>" {
			traceputs "\nTelica prompt received ...";
			if {$checkfordeny} {
				if {[regexp "Host is in Standby Mode" $expect_out(buffer)] == 1} {
					puts "\n$ipaddr is the STANDBY MACHINE.";
					ucondclose;
					exit 2;
				} elseif {[regexp "This is the PROTECTION System Processor" $expect_out(buffer)] == 1} {
					puts "\n$ipaddr is the STANDBY MACHINE.";
					ucondclose;
					exit 2;
				} elseif {[regexp "Login Not Active" $expect_out(buffer)] == 1} {
					puts "\nLogin not active on machine $ipaddr.";
					ucondclose;
					exit 2;
				} elseif {[regexp "Can't login" $expect_out(buffer)] == 1} {
					puts "\nNot able to logon machine $ipaddr.";
					if {$cmd != 0} {
						ucondclose;
						exit 2;
					} else {
						# remember, cmd 0 is act-user.
						# since act-user failed, try again.
						puts "retry act-user on machine $ipaddr.";
						sleep 5;
						set incrflag 0;
						incr actusercnt;
					}
				}
			}
		}
		timeout {
			incr counters(TIMEOUT);
			puts "\ntimeout waiting for a response ...";
		}
		}
	}
	#
	# increment to next cmd
	#
	if {$incrflag} { incr cmd; }
}
} status;
if {[string length $status] > 0} {
	# puts "\nCAUGHT ERROR: $status";
	set finalstatus 2;
} else {
	dumpcounters counters;
	set finalstatus 0;
}
#
if {[string length $logfile] > 0} {
	logclose $inprogressfd;
	logclose $completedfd;
	logclose $deniedfd;
	logclose $timedoutfd;
	logclose $miscfd;
}
#
ucondclose;
#
exit $finalstatus
