# check lcs upgrade environment
package provide checkenv 1.0
#
proc checkenv { } {
	global env;
	set errno 0;
	#
	foreach shvar [list LCSHUGLIB LCSHUGDATA LCSHUGLIB LCSHUGLOGFILES] {
		if {![info exists env($shvar)]} {
			puts "\n$shvar not defined.";
			incr errno;
		}
	}
	if {$errno > 0} {
		puts "\nMissing required LCS HUG variable(s) found.";
		exit 2;
	}
}
