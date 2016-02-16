#!/opt/exp/bin/expect
#
# save a load from a build machine to the local repository.
#
#########################################################################
#
# library functions
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/chooseone
source $env(LCSTOOLSLIB)/db
source $env(LCSTOOLSLIB)/lcsftp
source $env(LCSTOOLSLIB)/lcstelnet
source $env(LCSTOOLSLIB)/logging
#
# functions
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-U] \[-V] \[-S trace level] \[-u username] \[-p passwd]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-U - unconditional installation; remove local file when it exists.";
	puts "	-V - enable verbose output";
}
#
proc getimages { branch imagesname } {
	global env;
	upvar $imagesname images;
	# get remaining data
	if {[dbselect record buildmachines "branch req ^${branch}$" "branch machine directory type"] != 0} {
		puts "saveload: dbselect of relation 'buildmachines' failed.";
		exit 2;
	}
	#
	set record [lindex $record 0];
	set bdata [split $record " \t"];
	set machine [lindex $bdata 1];
	set directory [lindex $bdata 2];
	set btype [lindex $bdata 3];
	set toolsbin $env(LCSTOOLSBIN);
	#
	puts "";
	puts "Branch   : ${branch}";
	puts "Machine  : ${machine}";
	puts "Directory: ${directory}";
	puts "Type     : ${btype}";
	puts "";
	#
	set mypid [pid];
	# copy tool to determine the list of loads.
	ftp_put_binary_file $machine "${toolsbin}/load2images" "/tmp/load2images${mypid}";
	# run it remotely
	set outfile "/tmp/load2images.out.${mypid}";
	#
	telnet_to $machine remote_ip;
	remote_exec $remote_ip "/bin/chmod 777 /tmp/load2images${mypid}";
	remote_exec $remote_ip "/tmp/load2images${mypid} ${branch} $btype all  1>${outfile} 2>&1";
	close_telnet $remote_ip;
	# get results
	ftp_get_binary_file $machine "${outfile}" "${outfile}";
	# read results
	set infd [open $outfile "r"];
	while {[gets $infd line] != -1} { 
		# store images data. remove "NONE" entries.
		switch -regexp -- $line {
		{^.*NONE$} { #skip this; }
		default { lappend images $line; }
		}
	}
	close $infd;
	#
	if {[file exists $outfile]} {
		file delete -force -- $outfile;
	}
}
#
proc saveimages { branch ilist savecntname filesysname } {
	global env;
	global expect_out;
	global ucond;
	#
	upvar $ilist images;
	upvar $savecntname savecnt;
	upvar $filesysname filesys;
	#
	# get remaining data
	if {[dbselect record buildmachines "branch req ^${branch}$" "branch machine directory type"] != 0} {
		puts "saveimages: dbselect of relation 'buildmachines' failed.";
		exit 2;
	}
	#
	set record [lindex $record 0];
	#
	set bdata [split $record " \t"];
	set machine [lindex $bdata 1];
	set directory [lindex $bdata 2];
	set btype [lindex $bdata 3];
	#
	set savecnt 0;
	#
	# text file system
	#
	if {[dbselect fsobuf filesystems "branch req ^$branch\$ and type req text" "path" ] != 0} {
		puts "saveimages: dbselect of relation 'filesystems' failed.";
		exit 2;
	}
	if {![info exists fsobuf] || [llength fsobuf] == 0} {
		puts "saveimages: no filesystem found for branch $branch.";
		exit 2;
	}
	set choices $fsobuf;
	set choices [linsert $choices 0 "QUIT"];
	chooseone "Choose a file system: " choices rootfilesys;
	if {$rootfilesys == "QUIT"} {
		puts "exiting saveload.";
		exit 0;
	}
	set filesys $rootfilesys;
	#
	foreach imagetype [array names images] {
		#
		set fromfile $images($imagetype);
		set tofilepath "$rootfilesys/$branch/$imagetype";
		set image [file tail $images($imagetype)];
		set tofile "$rootfilesys/$branch/$imagetype/$image";
		#
		if {![file isdirectory $tofilepath]} {
			file mkdir $tofilepath;
		}
		if {[file exists $tofile]} {
			puts "\n$tofile exists locally.";
			if {$ucond} {
				puts "===>>> deleting local file ...";
				file delete -force -- $tofile;
			} else {
				puts "===>>> skipping local file ...";
				continue;
			}
		}
		#
		puts "\nSAVING IMAGE TYPE $imagetype:"
		puts "FROM FILE: $machine!$fromfile";
		puts "TO FILE  : $tofile";
		#
		ftp_get_binary_file $machine $fromfile $tofile
		incr savecnt +1;
	}
}
#
proc getcpuload { branch cpuloadname } {
	upvar $cpuloadname cpuload;
	#
	if {[dbselect cpuloadlist loads "branch req ^${branch}$" cpuload] != 0} {
		puts "saveload: dbselect of relation 'loads' failed.";
		exit 2;
	}
	#
	if {![info exists cpuloadlist]} {
		puts "no cpuloads found for branch $branch.";
		exit 2;
	} else {
		set choices $cpuloadlist;
		set choices [linsert $choices 0 "QUIT"];
		chooseone "Choose a cpu-load: " choices answer;
		if {$answer == "QUIT"} {
			puts "exiting saveload.";
			exit 0;
		}
		set cpuload $answer;
	}
}
#
proc insertimages { branch cpuload imagetype image } {
	if {[dbselect names images "branch req ^${branch}$ and cpuload req ^${cpuload}$ and type req ^${imagetype}$ and name req ^${image}$" "name"] != 0} {
		puts "insertimages: dbselect of relation 'images' failed.";
		exit 2;
	}
	if {[info exists names] && [llength names] > 0} {
		puts "insertimages: tuple <$branch,$cpuload,$imagetype,$image> exists.";
		return 0;
	} 
	set namevalue(branch) $branch;
	set namevalue(cpuload) $cpuload;
	set namevalue(type) $imagetype;
	set namevalue(name) $image;
	if {[dbinsert images namevalue] != 0} {
		puts "insertimages: dbinsert of relation 'images' failed.";
		exit 2;
	}
	return 0;
}
#
proc insertloads { branch cpuload rootfilesys } {
	if {[dbselect filesys loads "branch req ^${branch}$ and cpuload req ^${cpuload}$ and basedir req ^${rootfilesys}$" "basedir"] != 0} {
		puts "insertloads: dbselect of relation 'loads' failed.";
		exit 2;
	}
	if {[info exists filesys] && [llength filesys] > 0} {
		puts "insertloads: tuple <$branch,$cpuload,$rootfilesys> exists.";
		return 0;
	} 
	set namevalue(branch) $branch;
	set namevalue(cpuload) $cpuload;
	set namevalue(basedir) $rootfilesys;
	if {[dbinsert loads namevalue] != 0} {
		puts "insertloads: dbinsert of relation 'loads' failed.";
		exit 2;
	}
	return 0;
}
#
proc createdbentries { branch ilist rootfilesys } {
	global env;
	global expect_out;
	#
	upvar $ilist images;
	#
	puts "\ncreating database entries ...";
	#
	puts "branch: $branch";
	#
	# get swCPU load
	#
	if {![info exists images(cpu)] || [llength images(cpu)] == 0} {
		# we need a cpu load to store the data. ask the user.
		getcpuload $branch cpuload;
	} elseif {[regexp -nocase -- "/(\[0-9A-Z\.]*)_cpu\.tar\.gz$" $images(cpu) ignore cpuload] != 1 } {
		puts "createdbentries: unable to get cpu-load.";
		exit 2;
	}
	puts "cpu-load: $cpuload";
	#
	# insert any new images tuples
	#
	foreach imagetype [array names images] {
		set image [file tail $images($imagetype)];
		insertimages $branch $cpuload $imagetype $image;
	}
	#
	# insert any new loads tuple
	#
	insertloads $branch $cpuload $rootfilesys;
}
#
proc saveload { } {
	global env;
	global expect_out;
	global spawn_id;
	#
	# get list of supported releases
	#
	if {[dbselect branches buildmachines "" "branch"] != 0} {
		puts "saveload: dbselect of relation 'buildmachines' failed.";
		exit 2;
	}
	#
	# ask user to choose a release
	#
	set choices $branches;
	set choices [linsert $choices 0 "QUIT"];
	chooseone "Choose a branch: " choices branch;
	if {$branch == "QUIT"} {
		puts "exiting saveload.";
		exit 0;
	}
	unset choices;
	#
	# get files for this release.
	#
	getimages $branch images;
	#
	foreach image $images {
		# puts "image: <$image>";
		#
		set data [split $image " \t"];
		set imagetype [lindex $data 0];
		set image [lindex $data 1];
		#
		lappend imagesbytype($imagetype) $image;
	}
	#
	set imagessaved 0;
	#
	foreach imagetype [array names imagesbytype] {
		puts "imagesubtype is <$imagetype>.";
		#
		set prompt "Choose an $imagetype image to save: ";
		lappend choices "QUIT" "NONE";
		#
		foreach imagefile $imagesbytype($imagetype) {
			lappend choices $imagefile;
		}
		#
		set image2save "";
		chooseone "${prompt}" choices image2save;
		if {$image2save == "QUIT"} {
			puts "exiting saveload.";
			exit 0;
		}
		if {$image2save != "NONE"} {
			lappend images2save($imagetype) $image2save;
			puts "";
			puts "Will save image:";
			puts "$images2save($imagetype).";
			puts "";
			incr imagessaved +1;
		}
		unset choices;
	}
	if {$imagessaved <= 0} {
		puts "No images saved. Exiting saveload.";
		exit 0;
	}
	#
	logmsg saveload "START: saveimages for $branch.";
	saveimages $branch images2save savecount filesys;
	logmsg saveload "END: saveimages - $savecount $branch images saved";
	#
	puts "$savecount images saved; will create DB entries.";
	createdbentries $branch images2save $filesys;
}
#
#########################################################################
#
# default values
#
set username "lcstools";
set userpasswd "plexus9000";
set verbose 0;
set ucond 0;
set stracelevel -1;
#
# get cmd line options
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-V} { set verbose 1; }
	{^-U} { set ucond 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
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
if {$verbose} {
	log_user 1;
} else {
	log_user 0;
}
#
checkenv;
#
logusage saveload;
#
saveload;
#
logmsg saveload "END: saveload NORMAL termination";
#
exit 0;

