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
source $env(LCSTOOLSLIB)/lock
#
# exit handler
#
exit -onexit {
	global LABID;
	if {[info exists LABID] && [llength LABID] > 0} {
		V saveload $LABID;
	}
}
#
trap {
	global LABID;
	puts "";
	set signame [trap -name];
	set signo [trap -number];
	puts "Got signal <$signame,$signo)";
	if {[info exists LABID] && [llength LABID] > 0} {
		V saveload $LABID;
		unset LABID;
	}
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
	global username;
	global userpasswd;

	puts "\nusage: [file tail $argv0] \[-\?] \[-x] \[-t] \[-B] \[-R] \[-U] \[-V] \[-S trace level]";
	puts "	\[-G] \[-b branch_to_save] \[-u username] \[-p passwd] \[labid \[labid ...] ]";
	puts "where:";
	puts "	-? - print usage message";
	puts "	-x - enable TCL debugger";
	puts "	-t - test-mode.";
	puts "	-U - unconditional installation; remove local file when it exists.";
	puts "	-V - enable verbose output";
	puts "	-R - remove saveload lock";
	puts "	-B - run saveload in the background.";
	puts "	-G - get the latest file for CPU and IOMs.";
	puts "	-b branch - BRANCH load to save.";
	puts "";
	puts "The load will be turned on for any labid listed in the command line.";
	puts "";
}
#
proc getimages { branch imagesname } {
	global env;
	upvar $imagesname images;
	# get remaining data
	if {[dbselect record buildmachines "branch req ^${branch}$" "branch machine directory type"] != 0} {
		puts "saveload: dbselect of relation 'buildmachines' failed.";
		logmsg saveload "END: saveload: dbselect of relation 'buildmachines' failed.";
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
		{^.*NONE$} {
			#skip this;
		}
		{^.*ERROR:} {
			puts "load2images: $line";
			logmsg saveload "END: load2images: $line";
			exit 2;
		}
		default {
			lappend images $line;
		}
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
		logmsg saveload "END: saveimages: dbselect of relation 'buildmachines' failed.";
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
		logmsg saveload "END: saveimages: dbselect of relation 'filesystems' failed.";
		exit 2;
	}
	if {![info exists fsobuf] || [llength fsobuf] == 0} {
		puts "saveimages: no filesystem found for branch $branch.";
		logmsg saveload "END: saveimages: no filesystem found for branch $branch.";
		exit 2;
	}
	set choices $fsobuf;
	set choices [linsert $choices 0 "QUIT"];
	chooseone "Choose a file system: " choices rootfilesys;
	if {$rootfilesys == "QUIT"} {
		puts "exiting saveload.";
		logmsg saveload "END: exiting saveload.";
		exit 0;
	}
	set filesys $rootfilesys;
	#
	# at this point, if we are doing the work in the 
	# background, then disconnect.
	#
	global background;
	if {$background != 0} {
		if {[fork] != 0} {
			puts "Backgrounding. Parent saveload exiting.";
			logmsg saveload "END: Backgrounding. Parent saveload exiting.";
			global LABID;
			unset LABID;
			exit 0;
		}
		disconnect;
	}
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
				logmsg saveload "===>>> deleting local file ...";
				file delete -force -- $tofile;
			} else {
				puts "===>>> skipping local file ...";
				logmsg saveload "===>>> skipping local file ...";
				continue;
			}
		}
		#
		puts "\nSAVING IMAGE TYPE $imagetype:"
		puts "FROM FILE: $machine!$fromfile";
		puts "TO FILE  : $tofile";
		#
		logmsg saveload "SAVING IMAGE TYPE $imagetype:"
		logmsg saveload "FROM FILE: $machine!$fromfile";
		logmsg saveload "TO FILE  : $tofile";
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
		logmsg saveload "END: saveload: dbselect of relation 'loads' failed.";
		exit 2;
	}
	#
	if {![info exists cpuloadlist]} {
		puts "no cpuloads found for branch $branch.";
		logmsg saveload "END: no cpuloads found for branch $branch.";
		exit 2;
	} else {
		set choices $cpuloadlist;
		set choices [linsert $choices 0 "QUIT"];
		chooseone "Choose a cpu-load: " choices answer;
		if {$answer == "QUIT"} {
			puts "exiting saveload.";
			logmsg saveload "END: exiting saveload.";
			exit 0;
		}
		set cpuload $answer;
	}
}
#
proc insertimages { branch cpuload imagetype image } {
	if {[dbselect names images "branch req ^${branch}$ and cpuload req ^${cpuload}$ and type req ^${imagetype}$ and name req ^${image}$" "name"] != 0} {
		puts "insertimages: dbselect of relation 'images' failed.";
		logmsg saveload "END: insertimages: dbselect of relation 'images' failed.";
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
		logmsg saveload "END: insertimages: dbinsert of relation 'images' failed.";
		exit 2;
	}
	return 0;
}
#
proc insertloads { branch cpuload rootfilesys } {
	if {[dbselect filesys loads "branch req ^${branch}$ and cpuload req ^${cpuload}$ and basedir req ^${rootfilesys}$" "basedir"] != 0} {
		puts "insertloads: dbselect of relation 'loads' failed.";
		logmsg saveload "END: insertloads: dbselect of relation 'loads' failed.";
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
		logmsg saveload "END: insertloads: dbinsert of relation 'loads' failed.";
		exit 2;
	}
	return 0;
}
#
proc createdbentries { branch ilist rootfilesys cpuload } {
	global env;
	global expect_out;
	#
	upvar $ilist images;
	#
	puts "\ncreating database entries ...";
	#
	puts "branch: $branch";
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
proc sendemail { branch operation status subject { msg "" } } {
	global env;
	global testmode;
	#
	if {$msg == ""} {
		set msg $subject;
	}
	if {$testmode != 0} {
		set status "test";
	}
	set cmd "/usr/bin/ksh $env(LCSTOOLSBIN)/lcssendemail $branch $operation $status \"$subject\" \"$msg\" ";
	# puts "$cmd";
	catch { system "$cmd"; } ignore;
	catch { wait -nowait; } ignore;
	return 0;
}
#
proc saveload { } {
	global env;
	global expect_out;
	global spawn_id;
	global getlatest;
	global branch2save;
	#
	# get list of supported releases
	#
	if {$branch2save == ""} {
		if {[dbselect branches buildmachines "" "branch"] != 0} {
			puts "saveload: dbselect of relation 'buildmachines' failed.";
			logmsg saveload "END: saveload: dbselect of relation 'buildmachines' failed.";
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
			logmsg saveload "END: saveload NORMAL termination";
			exit 0;
		}
		unset choices;
	} else {
		if {[dbselect branches buildmachines "branch req ^${branch2save}$" "branch"] != 0} {
			puts "saveload: dbselect of relation 'buildmachines' failed.";
			logmsg saveload "END: saveload: dbselect of relation 'buildmachines' failed.";
			exit 2;
		}
		if {![info exists branches]} {
			puts "saveload: branch-to-save $branch2save does not exist in relation 'buildmachines'.";
			logmsg saveload "END: saveload: branch-to-save $branch2save does not exist in relation 'buildmachines'.";
			exit 2;
		}
		set branch [lindex $branches 0]
		if {[string length $branch] <= 0} {
			puts "saveload: branch-to-save $branch2save does not exist in relation 'buildmachines'.";
			logmsg saveload "END: saveload: branch-to-save $branch2save does not exist in relation 'buildmachines'.";
			exit 2;
		}
	}
	#
	global global_branch;
	set global_branch $branch;
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
		if {$getlatest == 0} {
			# ask user to choose file.
			chooseone "${prompt}" choices image2save;
		} else {
			# choose the latest file, if it exists.
			# remember, the files are listed newest first.
			set image2save [lindex $choices 2]
			if {![info exists image2save] || \
			    [string length $image2save] <= 0} {
				set image2save "NONE";
			} else {
				puts "==>> defaulting to newest file.";
			}
		}
		if {$image2save == "QUIT"} {
			puts "exiting saveload.";
			logmsg saveload "END: saveload NORMAL termination";
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
		logmsg saveload "END: No images saved. Exiting saveload.";
		exit 0;
	}
	#
	# get swCPU load
	#
	if {(![info exists images2save(cpu)]) || ([llength images2save(cpu)] == 0)} {
		# we need a cpu load to store the data. ask the user.
		getcpuload $branch cpuload;
	} elseif {[regexp -nocase -- "/(\[0-9A-Z\.]*)_cpu\.tar\.gz$" $images2save(cpu) ignore cpuload] != 1 } {
		puts "createdbentries: unable to get cpu-load.";
		logmsg saveload "END: createdbentries: unable to get cpu-load.";
		exit 2;
	}
	puts "cpu-load: $cpuload";
	global global_cpuload;
	set global_cpuload $cpuload;
	#
	logmsg saveload "START: saveimages for $branch.";
	# saveimages $branch images2save savecount filesys;
	# logmsg saveload "END: saveimages - $savecount $branch images saved";
	#
	# puts "$savecount images saved; will create DB entries.";
	# createdbentries $branch images2save $filesys $cpuload;
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
set removelock 0;
set background 0;
set testmode 0;
set getlatest 0;
set branch2save "";
#
global env;
#
set global_branch "";
set global_cpuload "";
#
# get cmd line options
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-t} { set testmode 1; }
	{^-G} { set getlatest 1; }
	{^-V} { set verbose 1; }
	{^-B} { set background 1; }
	{^-U} { set ucond 1; }
	{^-R} { set removelock 1; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-b.*} { getoptval $argval branch2save arg; }
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
logusage saveload;
#
set LABID "all";
if {$removelock != 0} {
        puts "WARNING: Forced removal of saveload LOCK file.";
        logmsg saveload "WARNING: Forced removal of saveload LOCK.";
        set status [V saveload $LABID];
        logmsg saveload "WARNING: status of removal of saveload LOCK: $status";
}
#
set status [P saveload $LABID];
if {$status == 0} {
	puts "Another saveload in progress.";
	logmsg saveload "END: another saveload in progress.";
	unset LABID;
	exit 2;
}
#
saveload;
#
if {[string length $global_branch] > 0 && [string length $global_cpuload] > 0} {
	set alllabids "";
	#
	for { } {$arg<$argc} {incr arg} {
		set argval [lindex $argv $arg];
		#
		puts "Enabling $global_branch/$global_cpuload for lab $argval.";
		set cmd "/usr/bin/ksh $env(LCSTOOLSBIN)/lcsconfigure -a $global_branch $global_cpuload $argval";
		# puts "$cmd";
		if {[catch { system "$cmd"; } errmsg] != 0} {
			if {[string length $errmsg] > 0} {
				puts "\nlcsconfigure: $errmsg";
				logmsg saveload "ERROR: lcsconfigure: $errmsg";
			} else {
				puts "\nlcsconfigure: unknown error.";
				logmsg saveload "ERROR: lcsconfigure: unknown error.";
			}
		}
		catch { wait -nowait; } ignore;
		#
		puts "Copying $global_branch/$global_cpuload scripts for lab $argval.";
		set cmd "/usr/bin/ksh $env(LCSTOOLSBIN)/lcscopytl1 -b $global_branch $global_branch $global_cpuload $argval";
		# puts "$cmd";
		if {[catch { system "$cmd"; } errmsg] != 0} {
			if {[string length $errmsg] > 0} {
				puts "\nlcscopytl1: $errmsg";
				logmsg saveload "ERROR: lcscopytl1: $errmsg";
			} else {
				puts "\nlcscopytl1: unknown error.";
				logmsg saveload "ERROR: lcscopytl1: unknown error.";
			}
		}
		catch { wait -nowait; } ignore;
		#
		append alllabids " " $argval;
	}
	#
	logmsg saveload "SAVELOAD: load $global_branch/$global_cpuload saved for reload: $alllabids";
	# 
	# sendemail $global_branch "saveload" "success" "SAVELOAD: load $global_branch/$global_cpuload saved for reload: $alllabids";
}
#
logmsg saveload "END: saveload NORMAL termination";
#
exit 0;

