#!/opt/exp/bin/expect
#
# filter official TL1 basescripts to create TL1 scripts for BBB.
#
#########################################################################
#
# library functions
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/db
source $env(LCSTOOLSLIB)/checkretval
#
# globals
#
set children(hardware) { hardware copymem };
set children(copymem) { copymem iproute calldata };
set children(iproute) { iproute calldata };
set children(calldata) { calldata calllines prov_linefeats };
set children(calllines) { callines prov_linefeats };
set children(prov_linefeats) { prov_linefeats };
#
# exit handler
#
exit -onexit {
	puts "\nDone.";
}
#
trap {
	puts "";
	set signame [trap -name];
	set signo [trap -number];
	puts "Got signal <$signame,$signo>";
	exit 2;
} {SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM SIGBUS};
#
proc eofexit { status } {
	global LABID;
	if {[info exists LABID] && [llength LABID] > 0} {
		quietV saveload $LABID;
		unset LABID;
	}
	exit $status;
}
#
# functions
#
proc usage { } {
	global argv0;

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-V] \[-S trace level]";
	puts "	\[-b branch\[,branch...] ] ";
	puts "	\[-L | \[labid \[labid ...] ] ]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-S level - set trace level.";
	puts "	-b branch\[,branch...]  - create scripts for these branches.";
	puts "	-L - create scripts for all labids.";
	puts "";
	puts "create BBB scripts for the given list of labids. if a labid is";
	puts "not given, then use the shell variable LABID. all scripts are";
	puts "created in the LCSSCRIPTS directory. if no branch is given,";
	puts "then all branches for the labid are used.";
}
#
proc myputs { { string "" } } {
	global details;
	if {${details} != 0} {
		puts "${string}";
	}
	return "0 - success";
}
#
proc traverse { labid branch current scripts_name script type number suffix spaces { maxchildnumber 9 } } {
	upvar ${scripts_name} scripts;
	#
	global children;
	#
	myputs "${spaces}CHECK: ${type}-${number}-${script}";
	#
	if {[regexp -- "^.*${type}${number}\[^\.]*(.*)$" "${script}" ignore newsuffix] == 0 && [regexp -- "^.*${type}\[^\.]*(.*)$" "${script}" ignore newsuffix] == 0} {
		set newsuffix "";
	}
	#
	set suffixlen [string length "${suffix}"];
	set newsuffixlen [string length "${newsuffix}"];
	#
	myputs "${spaces}BEFORE: <suffix,newsuffix> - <${suffix},${newsuffix}>";
	if {"${suffix}" == "${newsuffix}"} {
		set ok 1;
	} elseif {${suffixlen} == 0 && ${newsuffixlen} > 0} {
		set ok 1;
	} elseif {${suffixlen} > 0 && ${newsuffixlen} == 0} {
		set ok 1;
		set newsuffix "${suffix}";
	} elseif {[regexp -- "${newsuffix}$" "${suffix}"]} {
		set ok 1;
		set newsuffix "${suffix}";
	} elseif {[regexp -- "${suffix}$" "${newsuffix}"]} {
		set ok 1;
	} else {
		set ok 0;
	}
	myputs "${spaces}AFTER: <suffix,newsuffix,ok> - <${suffix},${newsuffix},${ok}>";
	if {!${ok}} {
		myputs "${spaces}REJECT: ${type}-${number}-${script}";
		# no match
		return "0 - success - no match";
	}
	myputs "${spaces}ACCEPT: ${type}-${number}-${script}";
	puts "${spaces}${type}-${number}-${script}";
	#
	append spaces "  ";
	#
	foreach childtype $children(${type}) {
		if {${childtype} == ${type}} {
			set childnumber ${number};
			incr childnumber;
		} else {
			set childnumber 1;
		}
		for { } {${childnumber}<=${maxchildnumber}} {incr childnumber} {
			if {[info exists scripts(${childtype}${childnumber})]} {

				foreach childscript $scripts(${childtype}${childnumber}) {
					set status [traverse ${labid} ${branch} ${current} scripts $childscript ${childtype} ${childnumber} "${newsuffix}" "${spaces}" ];
					if {[isNotOk $status]} {
						return "-1 - traverse: traverse failed:\n${status}";
					}
				}
				return "0 - success";
			}
		}
	}
	#
	return "0 - success";
}
#
proc makebbb { labid branch current } {
	puts "\nLABID  : ${labid}";
	puts "BRANCH : ${branch}";
	puts "CURRENT: ${current}\n";
	#
	set scripts [glob -nocomplain "${current}/*"];
	if {[string length "${scripts}"] <= 0} {
		puts "\nWARNING: no files found under ${current}.";
		return "0 - success - no files found under ${current}";
	}
	unset scripts;
	#
	foreach script [glob "${current}/*"] {
		if {![file isfile "${script}"]} {
			continue;
		}
		switch -regexp -- "${script}" {
		{^.*hardware([2-9][0-9]*).*$} {
			regexp {^.*hardware([0-9]).*$} "${script}" dummy num;
			lappend scripts(hardware${num}) ${script};
			puts "HARDWARE (${num}) FILE: ${script}";
		}
		{^.*hardware.*$} {
			lappend scripts(hardware1) ${script};
			puts "HARDWARE (1) FILE: ${script}";
		}
		{^.*calldata([2-9][0-9]*).*$} {
			regexp {^.*calldata([0-9][0-9]*).*$} "${script}" dummy num;
			lappend scripts(calldata${num}) ${script};
			puts "CALLDATA (${num}) FILE: ${script}";
		}
		{^.*calldata.*$} {
			lappend scripts(calldata1) ${script};
			puts "CALLDATA (1) FILE: ${script}";
		}
		{^.*copy.*mem([2-9][0-9]*).*$} {
			regexp {^.*copymem([0-9][0-9]*).*$} "${script}" dummy num;
			lappend scripts(copymem${num}) ${script};
			puts "COPYMEM (${num}) FILE: ${script}";
		}
		{^.*copy.*mem.*$} {
			lappend scripts(copymem1) ${script};
			puts "COPYMEM (1) FILE: ${script}";
		}
		{^.*iproute([2-9][0-9]*).*$} {
			regexp {^.*iproute([0-9]).*$} "${script}" dummy num;
			lappend scripts(iproute${num}) ${script};
			puts "IPROUTE (${num}) FILE: ${script}";
		}
		{^.*iproute.*$} {
			lappend scripts(iproute1) ${script};
			puts "IPROUTE (1) FILE: ${script}";
		}
		{^.*calllines([2-9][0-9]*).*$} {
			regexp {^.*calllines([0-9][0-9]*).*$} "${script}" dummy num;
			lappend scripts(calllines${num}) ${script};
			puts "CALLLINES (${num}) FILE: ${script}";
		}
		{^.*calllines.*$} {
			lappend scripts(calllines1) ${script};
			puts "CALLLINES (1) FILE: ${script}";
		}
		{^.*prov_linefeats([2-9][0-9]*).*$} {
			regexp {^.*prov_linefeats([0-9][0-9]*).*$} "${script}" dummy num;
			lappend scripts(prov_linefeats${num}) ${script};
			puts "PROV_LINEFEATS (${num}) FILE: ${script}";
		}
		{^.*prov_linefeats.*$} {
			lappend scripts(prov_linefeats1) ${script};
			puts "PROV_LINEFEATS (1) FILE: ${script}";
		}
		{^.*users.*$} {
			lappend scripts(users) ${script};
			puts "USERS FILE: ${script}";
		}
		{^.*sigdbg.*$} {
			lappend scripts(sigdbg) ${script};
			puts "SIGDBG FILE: ${script}";
		}
		{^.*sigdebug.*$} {
			lappend scripts(sigdbg) ${script};
			puts "SIGDBG FILE: ${script}";
		}
		{^.*add.*$} {
			lappend scripts(addlinks) ${script};
			puts "ADDLINKS FILE: ${script}";
		}
		default {
			puts "UNKNOWN FILE: ${script}";
		}
		}
	}
	#
	# cycle over scripts
	#
	if {![info exists scripts(hardware1)]} {
		puts "\nWARNING: no hardware1 scripts found for ${labid}/${branch}.";
		return "0 - success";
	}
	#
	puts "";
	#
	foreach script $scripts(hardware1) {
		set suffix "";
		set status [traverse ${labid} ${branch} ${current} scripts ${script} hardware 1 "${suffix}" "" ];
		if {[isNotOk $status]} {
			return "-1 - makebbb: traverse failed:\n${status}";
		}
	}
	#
	return "0 - success";
} 
#
#########################################################################
#
puts "\nCreate BBB TL1 Scripts:";
#
# default values
#
set alllabids 0;
set allbranches 1;
set branches "";
set stracelevel 0;
set verbose 0;
set details 0;
#
global env;
#
# get cmd line options
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-b.*} { 
		getoptval $argval branches arg; 
		set branches [string trim "${branches}"];
		set allbranches 0; 
	}
	{^-L} { set alllabids 1; }
	{^-V} { set verbose 1; }
	{^-D} { set details 1; }
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
if {$verbose > 0} {
	puts "\nLogging Enabled ...";
	log_user 1;
} else {
	log_user 0;
}
#
checkenv;
#
checkenvvar LCSBASESCRIPTS;
checkenvvar LCSSCRIPTS;
#
cd $env(LCSBASESCRIPTS);
#
if {${alllabids}} {
	set labids [glob *];
} elseif {${arg}<${argc}} {
	set labids "";
	for { } {${arg}<${argc}} {incr arg} {
		set labid [lindex $argv $arg];
		append labids " ${labid}";
	}
	set labids [string trim "${labids}"];
} else {
	checkenvvar LABID;
	set labids $env(LABID);
}
#
puts "\nLabids: ${labids}";
#
foreach labid [split ${labids} " "] {
	cd $env(LCSBASESCRIPTS);
	if {![file isdirectory "${labid}"]} {
		# skip any file that is not a directory
		puts "\nWARNING: labid '${labid}' is not a directory. Skipping it.";
		continue;
	}
	#
	puts "\nProcessing Labid: ${labid}";
	#
	cd "${labid}";
	#
	if {${allbranches}} {
		set branches [glob *];
	} elseif {[string length "${branches}"] > 0} {
		regsub -all -- "," ${branches} " " branches;
		set branches [string trim "${branches}"];
	} else {
		puts "\nERROR: no branches given or found.";
		exit 2;
	}
	#
	foreach branch [split ${branches} " "] {
		set current ${branch}/current;
		if {![file isdirectory "${current}"]} {
			# does not exist or is not a directory
			puts "\nWARNING: ${current} is not a directory. Skipping it.";
			continue;
		}
		puts "\nScanning Branch Directory: ${current}";
		set status [makebbb ${labid} ${branch} ${current}];
		if {[isNotOk $status]} {
			puts "\nERROR: makebbb failed:\n${status}";
			exit 2;
		}
	}
}
#
exit 0;
