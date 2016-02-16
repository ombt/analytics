# telnet to a machine and exec cmds.
#
#########################################################################
#
proc telnet_to { ip spawn_id_name {deftmout 30} } {
	global username;
	global userpasswd;
	global timeout;
	#
	upvar $spawn_id_name spawn_id;
	#
	set loginseen 0;
	set savetimeout $timeout;
	set timeout $deftmout;
	#
	spawn -noecho "/usr/bin/telnet" "-l $username" $ip;
	expect {
	-re ".*login:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*user name:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*\[Pp]assword:" {
		set loginseen 0;
		send "$userpasswd\r";
	}
	timeout {
		puts "\nERROR: timeout during login ...";
		exit 2;
	}
	eof {
		puts "\nERROR: eof during login ...";
		exit 2;
	}
	};
	#
	if {$loginseen} {
		expect {
		-re ".*\[Pp]assword:" {
			send "$userpasswd\r";
		}
		timeout {
			puts "\nERROR: timeout during passwd ...";
			exit 2;
		}
		eof {
			puts "\nERROR: eof during passwd ...";
			exit 2;
		}
		};
	}
	#
# exp_internal 1;
	expect {
	-re ".*> " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	-re ".*\$ " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	-re ".*# " {
		send "PS1=\"COMMAND_IS_DONE>\"\r";
	}
	timeout {
		puts "\nERROR: timeout during PS1= ...";
		exit 2;
	}
	eof {
		puts "\nERROR: eof during PS1= ...";
		exit 2;
	}
	};
# exp_internal 0;
	#
	expect {
	-re ".*COMMAND_IS_DONE>" {
		# ok.
	}
	timeout {
		puts "\nERROR: timeout during cd ...";
		exit 2;
	}
	eof {
		puts "\nERROR: eof during cd ...";
		exit 2;
	}
	};
	#
	set timeout $savetimeout;
}
#
proc interactive_telnet_to { ip spawn_id_name { telnetport 23 } { deftmout 30 } } {
	global username;
	global userpasswd;
	global timeout;
	#
	upvar $spawn_id_name spawn_id;
	#
	set loginseen 0;
	set savetimeout $timeout;
	set timeout $deftmout;
	#
	spawn -noecho "/usr/bin/telnet" "-l $username" $ip $telnetport;
	expect {
	-re ".*login:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*user name:" {
		set loginseen 1;
		send "$username\r";
	}
	-re ".*\[Pp]assword:" {
		set loginseen 0;
		send "$userpasswd\r";
	}
	timeout {
		puts "\nERROR: timeout during login ...";
		exit 2;
	}
	eof {
		puts "\nERROR: eof during login ...";
		exit 2;
	}
	};
	#
	if {$loginseen} {
		expect {
		-re ".*\[Pp]assword:" {
			send "$userpasswd\r";
		}
		timeout {
			puts "\nERROR: timeout during passwd ...";
			exit 2;
		}
		eof {
			puts "\nERROR: eof during passwd ...";
			exit 2;
		}
		};
	}
	#
	expect {
	-re ".*# " {
		# ok
	}
	-re ".*> " {
		# ok
	}
	-re ".*\$ " {
		# ok
	}
	timeout {
		puts "\nERROR: timeout waiting for prompt ...";
		exit 2;
	}
	eof {
		puts "\nERROR: eof waiting for prompt ...";
		exit 2;
	}
	};
	#
	set timeout $savetimeout;
}
# synchronous remote execuation of cmd
proc remote_exec { id cmd { localtimeout 30 } } {
	#
	global timeout;
	set savetimeout $timeout;
	set timeout $localtimeout;
	#
	send -i $id "$cmd\r"
	#
	expect {
	-i $id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		# ok
		puts "\ntimeout during $cmd ...";
		return 2;
	}
	eof {
		# ok
		puts "\neof during $cmd ...";
		return 2;
	}
	};
	#
	set timeout $savetimeout;
	return 0;
}
#
proc close_telnet { id } {
	# catch { close $id; } ignore;
	set spawn_id $id;
	catch { close; } ignore
	catch { exec kill -9 [exp_pid]; wait; } ignore;
}
# asynchronous remote execution of cmd, don't wait for response
proc remote_exec_nowait { id cmd } {
	#
	send -i $id "$cmd\r"
	#
	return 0;
}
# wait for response after async remote exec.
proc synchronize { id cmd { localtimeout 30 } } {
	#
	global timeout;
	set savetimeout $timeout;
	set timeout $localtimeout;
	#
	expect {
	-i $id -re ".*COMMAND_IS_DONE>" {
		# ok
	}
	timeout {
		# ok
		puts "\ntimeout during $cmd ...";
		return 2;
	}
	eof {
		# ok
		puts "\neof during $cmd ...";
		return 2;
	}
	};
	#
	set timeout $savetimeout;
	return 0;
}
