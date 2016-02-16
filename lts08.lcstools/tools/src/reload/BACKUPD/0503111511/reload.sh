#!/opt/exp/bin/expect
#
# reload a lab from local load repository.
#
#########################################################################
#
# libraries
#
source $env(LCSTOOLSLIB)/checkenv
source $env(LCSTOOLSLIB)/getoptval
source $env(LCSTOOLSLIB)/db
source $env(LCSTOOLSLIB)/chooseone
source $env(LCSTOOLSLIB)/lcsftp
source $env(LCSTOOLSLIB)/logging
#
# functions
#
proc usage { } {
	global argv0;
	global username;
	global userpasswd;

	puts "usage: [file tail $argv0] \[-\?] \[-x]";
	puts "\[-S trace level] \[-l logfile] \[-u username] \[-p passwd] \[labid] ";
	puts "where:";
	puts "	-x - enable TCL debugger";
	puts "	-S tracelevel - set trace to given stack level ";
	puts "	-l logfile - log all output to a logfile";
	puts "";
	puts "	default username = $username";
	puts "	default passwd = $userpasswd";
	puts "	labid is read from variable LABID, unless given.";
}
#
proc getimages2load { labid bname lname ilistname } {
	upvar $ilistname imagelist;
	upvar $bname branch;
	upvar $lname cpuload;
	#
	if {[dbselect llobuf labloads "labid req ^$labid\$" "branch cpuload" ] != 0} {
		puts "getimages2load: dbselect of relation 'labloads' failed.";
		exit 2;
	}
	if {![info exists llobuf] || [llength llobuf] == 0} {
		puts "getimages2load: no loads found for labid $labid.";
		exit 2;
	}
	#
	set choices $llobuf;
	set choices [linsert $choices 0 "QUIT"];
	chooseone "Choose a load to reload: " choices choice;
	if {$choice == "QUIT"} {
		puts "exiting reload.";
		exit 0;
	}                                                                       
	#
	set ldata [split $choice " \t"];
	set branch [lindex $ldata 0];
	set cpuload [lindex $ldata 1];
	#
	puts "Will reload load <$branch, $cpuload>.";
	#
	if {[dbselect iobuf images "branch req ^$branch\$ and cpuload req ^$cpuload\$" "type name" ] != 0} {
		puts "getimages2load: dbselect of relation 'images' failed.";
		exit 2;
	}
	if {![info exists iobuf] || [llength iobuf] == 0} {
		puts "getimages2load: no images found for <$branch, $cpuload>.";
		exit 2;
	}
	#
	set timeout -1;
	if {[info exists imagelist]} {
		unset imagelist;
	}
	foreach image $iobuf {
		send_user "\nReload this image <$image>? \[y/n/cr=n] ";
		expect_user {
		-re "y\n" {
			lappend imagelist $image;
			send_tty "Will reload $image ...\n";
		}
		-re "\[^\n]*\n" {
			send_tty "Will NOT reload $image ...\n";
		}
		eof {
			send_tty "END-OF-FILE. exiting reload.\n";
			exit 2;
		}
		}
	}
}
#
proc remove_remote_file { machine remotefile } {
	global username;
	global userpasswd;
	global timeout;
	#
	set loginseen 0;
	set savetimeout $timeout;
	set timeout 15;
	#
	spawn -noecho "/usr/bin/telnet" "-l $username" $machine;
	expect {
	-re ".*user name:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*password:" {
		set loginseen 0;
		send "$userpasswd\r";
	}
	timeout {
		puts "\ntimeout during login ...";
		exit 2;
	}
	};
	#
	if {$loginseen} {
		expect {
		-re ".*password:" {
			send "$userpasswd\r";
		}
		timeout {
			puts "\ntimeout during passwd ...";
			exit 2;
		}
		};
	}
	#
	expect {
	-re ".*# " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	timeout {
		puts "\ntimeout during cd ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		send "cd /\r";
	}
	timeout {
		puts "\ntimeout during cd ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		send "/bin/rm -f $remotefile 1>/dev/null 2>&1";
	}
	timeout {
		puts "\ntimeout during rm ...";
		exit 2;
	}
	};
	#
	catch { close; wait; } ignore;
	#
	set timeout $savetimeout;
}
#
proc loadimage { labid cpu_ip branch cpuload ilistname } {
	upvar $ilistname images2load;
	# get text file system
	if {[dbselect fsobuf filesystems "branch req ^$branch\$ and type req text" "path" ] != 0} {
		puts "loadimage: dbselect of relation 'filesystems' failed.";
		exit 2;
	}
	if {![info exists fsobuf] || [llength fsobuf] == 0} {
		puts "loadimage: no filesystem found for branch $branch.";
		exit 2;
	}
	set filesystem [lindex $fsobuf 0];
	#
	foreach imagedata $images2load {
		set idata [split $imagedata " \t"];
		set swtype [lindex $idata 0];
		set swfile [lindex $idata 1];
		#
		if {[regexp "^sw(.*)$" $swtype ignore itype] != 1} {
			puts "loadimage: invalid image type - $swtype.";
			exit 2;
		}
		#
		if {[regexp -nocase -- "(${itype}.*)\.tar\.gz$" $swfile ignore subitype] != 1} {
			puts "loadimage: unknown image - $swfile.";
			exit 2;
		}
		#
		set fromfile "$filesystem/$branch/$swtype/$swfile";
		set tofile "/$swfile";
		#
		puts ""
		puts "CPU-IP    : $cpu_ip";
		puts "Image Type: $subitype";
		puts "From file : $fromfile";
		puts "To file   : $tofile";
		#
		puts ""
		puts "Removing file /*${subitype}.tar.gz ..."
		remove_remote_file $cpu_ip "/*${subitype}.tar.gz";
		#
		puts ""
		puts "Loading file $tofile ..."
		ftp_put_binary_file $cpu_ip $fromfile $tofile;
	}
}
#
proc do_we_reload { labid sp cpu_ip_name } {
	upvar $cpu_ip_name cpu_ip;
	puts "\nReloading lab $labid $sp $cpu_ip.";
	send_user "Is this correct? \[y/n/cr=n] ";
	expect_user {
	-re "y\n" {
		send_tty "Will reload lab $labid $sp.\n\n";
	}
	-re "(\[^\n]*)\n" {
		send_tty "Will NOT reload lab $labid.\n\n";
		set cpu_ip "";
	}
	eof {
		send_tty "END-OF-FILE. exiting reload.\n";
		exit 2;
	}
	}
}
#
proc telnet_to { ip spawn_id_name } {
	global username;
	global userpasswd;
	global timeout;
	#
	upvar $spawn_id_name spawn_id;
	#
	set loginseen 0;
	set savetimeout $timeout;
	set timeout 15;
	#
	spawn -noecho "/usr/bin/telnet" "-l $username" $ip;
	expect {
	-re ".*user name:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*password:" {
		set loginseen 0;
		send "$userpasswd\r";
	}
	timeout {
		puts "\ntimeout during login ...";
		exit 2;
	}
	};
	#
	if {$loginseen} {
		expect {
		-re ".*password:" {
			send "$userpasswd\r";
		}
		timeout {
			puts "\ntimeout during passwd ...";
			exit 2;
		}
		};
	}
	#
	expect {
	-re ".*# " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	timeout {
		puts "\ntimeout during PS1= ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		send "cd /\r";
	}
	timeout {
		puts "\ntimeout during cd ...";
		exit 2;
	}
	};
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		# ok.
	}
	timeout {
		puts "\ntimeout during cd ...";
		exit 2;
	}
	};
	#
	set timeout $savetimeout;
}
#
proc killemf { cpu_a_ip cpu_b_ip } {
	global username;
	global userpasswd;
	global timeout;
	#
	if {$cpu_a_ip != "" && $cpu_b_ip != ""} {
		puts "\nKilling emf on $cpu_a_ip and $cpu_b_ip.\n";
		#
		set cpu_a_killed 0;
		set cpu_b_killed 0;
		#
		telnet_to $cpu_a_ip cpu_a_id;
		telnet_to $cpu_b_ip cpu_b_id;
		#
		set timeout 10;
		send -i $cpu_a_id "ps xf | grep './emf' | cut -d' ' -f1 | xargs kill -9\r";
		send -i $cpu_b_id "ps xf | grep './emf' | cut -d' ' -f1 | xargs kill -9\r";
		expect {
		-i $cpu_a_id -re ".*COMMAND_IS_DONE>" {
			if {!$cpu_b_killed} {
				set cpu_a_killed 1;
				exp_continue;
			}
		}
		-i $cpu_b_id -re ".*COMMAND_IS_DONE>" {
			if {!$cpu_a_killed} {
				set cpu_b_killed 1;
				exp_continue;
			}
		}
		timeout {
			# ok
		}
		}
		#
		catch { close $cpu_a_id; } ignore;
		catch { close $cpu_b_id; } ignore;
		#
		return;
	} elseif {$cpu_a_ip != ""} {
		set cpu_ip $cpu_a_ip;
	} elseif {$cpu_b_ip != ""} {
		set cpu_ip $cpu_b_ip;
	} else  {
		puts "killemf: both CPU IPs are NULL.";
		return;
	}
	#
	puts "\nKilling emf on $cpu_ip.\n";
	#
	telnet_to $cpu_ip cpu_id;
	#
	set timeout 10;
	send -i $cpu_id "ps xf | grep './emf' | cut -d' ' -f1 | xargs kill -9\r";
	expect {
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		# ok
	}
	}
	#
	catch { close $cpu_id; } ignore;
	return;
}
#
proc removeoldload { cpu_ip ilistname } {
	upvar $ilistname images2load;
	#
	global username;
	global userpasswd;
	global timeout;
	#
	puts "\nRemoving load from $cpu_ip.\n";
	#
	telnet_to $cpu_ip cpu_id;
	#
	set timeout 30;
	send -i $cpu_id "/Telica/swCPU/CurrRel/system/scripts/remove_configuration_data\r";
	expect {
	-i $cpu_id -re "Operation. " {
		send -i $cpu_id "proceed\r";
	}
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		puts "removeoldload: remove_configuration_data not executed.";
	}
	timeout {
		puts "removeoldload: timeout during remove_configuration_data.";
	}
	}
	#
	expect {
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		send -i $cpu_id "/opt/TimesTen4.1/32/bin/setup.sh -uninstall\r";
		expect {
		-i $cpu_id -re ".*completely.*remove.*TimesTen.*yes " {
			send -i $cpu_id "yes\r";
			expect {
			-i $cpu_id -re "remove.*all.*files.*in.*no " {
				send -i $cpu_id "yes\r";
				expect {
				-i $cpu_id -re "remove.*remaining.*system.*files.*no " {
					send -i $cpu_id "yes\r";
				}
				-i $cpu_id -re ".*COMMAND_IS_DONE>" {
					puts "removeoldload: (3nd yes) setup.sh not executed.";
				}
				timeout {
					puts "removeoldload: timeout during 2nd yes of setup.sh.";
				}
				}
			}
			-i $cpu_id -re ".*COMMAND_IS_DONE>" {
				puts "removeoldload: (2nd yes) setup.sh not executed.";
			}
			timeout {
				puts "removeoldload: timeout during 2nd yes of setup.sh.";
			}
			}
		}
		-i $cpu_id -re ".*COMMAND_IS_DONE>" {
			puts "removeoldload: setup.sh not executed.";
		}
		timeout {
			puts "removeoldload: timeout during setup.sh.";
		}
		}
	}
	timeout {
		puts "removeoldload: timeout waiting after 'proceed'.";
		send -i $cpu_id "/opt/TimesTen4.1/32/bin/setup.sh -uninstall\r";
		expect {
		-i $cpu_id -re ".*completely.*remove.*TimesTen.*yes " {
			send -i $cpu_id "yes\r";
			expect {
			-i $cpu_id -re "remove.*all.*files.*in.*no " {
				send -i $cpu_id "yes\r";
				expect {
				-i $cpu_id -re "remove.*remaining.*system.*files.*no " {
					send -i $cpu_id "yes\r";
				}
				-i $cpu_id -re ".*COMMAND_IS_DONE>" {
					puts "removeoldload: (3nd yes) setup.sh not executed.";
				}
				timeout {
					puts "removeoldload: timeout during 2nd yes of setup.sh.";
				}
				}
			}
			-i $cpu_id -re ".*COMMAND_IS_DONE>" {
				puts "removeoldload: (2nd yes) setup.sh not executed.";
			}
			timeout {
				puts "removeoldload: timeout during 2nd yes of setup.sh.";
			}
			}
		}
		-i $cpu_id -re ".*COMMAND_IS_DONE>" {
			puts "removeoldload: setup.sh not executed.";
		}
		timeout {
			puts "removeoldload: timeout during setup.sh.";
		}
		}
	}
	}
	#
	expect {
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		puts "removeoldload: timeout waiting after 'setup.sh'.";
	}
	}
	#
	set timeout 15;
	foreach imagedata $images2load {
		set idata [split $imagedata " \t"];
		set swtype [lindex $idata 0];
		set swfile [lindex $idata 1];
		#
		puts ""
		puts "Removing type $swtype ...";
		send -i $cpu_id "rm -rf /Telica/${swtype}/* 1>/dev/null 1>&2\r";
		#
		expect {
		-i $cpu_id -re ".*COMMAND_IS_DONE>" {
			# ok
		}
		timeout {
			puts "removeoldload: timeout during rm of '$swtype'.";
		}
		}
	}
	#
	catch { close $cpu_id; } ignore;
	return;
}
#
proc installnewload { cpu_ip cpu_load ilistname } {
	upvar $ilistname images2load;
	#
	global username;
	global userpasswd;
	global timeout;
	#
	telnet_to $cpu_ip cpu_id;
	#
	set timeout 900;
	#
	foreach imagedata $images2load {
		set idata [split $imagedata " \t"];
		set swtype [lindex $idata 0];
		set swfile [lindex $idata 1];
		#
		set tarfile "/$swfile";
		#
		puts ""
		puts "Expanding file $tarfile ...";
		send -i $cpu_id "/bin/tar xzvf $tarfile\r";
		#
		expect {
		-i $cpu_id -re ".*COMMAND_IS_DONE>" {
			# ok
		}
		timeout {
			puts "installnewload: timeout during 'tar xzvf $tarfile'.";
		}
		}
	}
	#
	puts ""
	puts "Linking $cpu_load to CurrRel ...";
	send -i $cpu_id "/bin/ln -s /Telica/swCPU/${cpu_load} /Telica/swCPU/CurrRel\r";
	#
	expect {
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		puts "installnewload: timeout during 'ln -s ...'.";
	}
	}
	#
	puts ""
	puts "Running uprev.sh ...";
	send -i $cpu_id "/Telica/swCPU/CurrRel/system/scripts/uprev.sh\r";
	#
	expect {
	-i $cpu_id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		puts "installnewload: timeout during 'uprev.sh'.";
	}
	}
	#
	catch { close $cpu_id; } ignore;
	return;
}
#
#########################################################################
#
# default values
#
set username "root";
set userpasswd "plexus9000";
set maxlogons 5;
set stracelevel -1;
set logfile "";
set labid "";
#
# get cmd line options
#
log_user 0;
#
for {set arg 0} {$arg<$argc} {incr arg} {
	set argval [lindex $argv $arg];
	switch -regexp -- $argval {
	{^-x} { debug -now; }
	{^-S.*} { getoptval $argval stracelevel arg; }
	{^-l.*} { getoptval $argval logfile arg; }
	{^-u.*} { getoptval $argval username arg; }
	{^-p.*} { getoptval $argval userpasswd arg; }
	{^-\?} { usage; exit 0; }
	{^--} { incr arg; break; }
	{^-.*} { puts "Unknown option: $argval\n"; usage; exit 2 }
	default { break; }
	}
}
#
# debugging and sanity checks.
#
if {$stracelevel >= 0} {
	strace $stracelevel;
}
#
if {[string length $logfile] > 0} {
	if {[catch {log_file -a $logfile; } status]} {
		puts "Logging failed for file $logfile:\n$status";
		exit 2;
	}
	log_user 1;
}
#
checkenv;
#
logusage reload;
#
# get ip addresses for labid.
#
if {$arg<$argc} {
	set labid [lindex $argv $arg];
} elseif {[info exists env(LABID)]} {
	set labid $env(LABID);
} else {
	puts "LABID is neither set nor given.";
	exit 2;
}
puts "\nStarting reload of lab $labid:\n";
#
if {[dbselect obuf chassis "labid req ^$labid\$" "cpu_a_ip cpu_b_ip" ] != 0} {
	puts "reload: dbselect of relation 'chassis' failed.";
	exit 2;
}
if {![info exists obuf] || [llength obuf] == 0} {
	puts "reload: no IPs found for labid $labid.";
	exit 2;
}
#
getimages2load $labid branch cpuload images2load;
if {![info exists images2load] || [llength images2load] == 0} {
	puts "reload: no images chosen for reload. Exiting reload.";
	exit 2;
}
#
set ips [lindex $obuf 0];
set ipdata [split $ips " \t"];
set cpu_a_ip [lindex $ipdata 0];
set cpu_b_ip [lindex $ipdata 1];
#
set timeout -1;
#
do_we_reload $labid "SP-A" cpu_a_ip;
do_we_reload $labid "SP-B" cpu_b_ip;
#
if {$cpu_a_ip != "" && $cpu_b_ip != ""} {
	loadimage $labid $cpu_a_ip $branch $cpuload images2load;
	loadimage $labid $cpu_b_ip $branch $cpuload images2load;
	killemf $cpu_a_ip $cpu_b_ip;
	removeoldload $cpu_a_ip images2load;
	removeoldload $cpu_b_ip images2load;
	installnewload $cpu_a_ip $cpuload images2load;
	installnewload $cpu_b_ip $cpuload images2load;
} elseif {$cpu_a_ip != ""} {
	loadimage $labid $cpu_a_ip $branch $cpuload images2load;
	killemf $cpu_a_ip "";
	removeoldload $cpu_a_ip images2load;
	installnewload $cpu_a_ip $cpuload images2load;
} elseif {$cpu_b_ip != ""} {
	loadimage $labid $cpu_b_ip $branch $cpuload images2load;
	killemf $cpu_b_ip "";
	removeoldload $cpu_b_ip images2load;
	installnewload $cpu_b_ip $cpuload images2load;
} else {
	puts "Nothing to reload.";
}
#
puts "Exiting reload.";
#
exit 0
