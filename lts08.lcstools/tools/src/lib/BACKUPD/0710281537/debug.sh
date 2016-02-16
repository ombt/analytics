# basic debugging commands
proc stacktrace { {file stdout} } {
	puts $file "TCL Call Trace:";
	for {set x [expr [info level]-1]} {$x>0} {incr x -1} {
		puts $file "${x}: [info level $x]";
	}
	return "0 - success";
}
