# check lcs environment
proc checkenv { } {
	global env;
	if {![info exists env(LCSTOOLS)]} {
		puts "LCSTOOLS not defined."
		exit 2;
	}
	if {![info exists env(LCSTOOLSBIN)]} {
		puts "LCSTOOLSBIN not defined."
		exit 2;
	}
	if {![info exists env(LCSTOOLSDATA)]} {
		puts "LCSTOOLSDATA not defined."
		exit 2;
	}
	if {![info exists env(LCSTOOLSLIB)]} {
		puts "LCSTOOLSLIB not defined."
		exit 2;
	}
}
# check labid
proc checklabid { } {
	global env;
	if {![info exists env(LABID)]} {
		puts "LABID not defined."
		exit 2;
	}
}
# check a variable
proc checkenvvar { { varname "VARNAME" } } {
	global env;
	if {![info exists env(${varname})]} {
		puts "${varname} not defined."
		exit 2;
	}
}
