# ftp files to and from.
#
proc send_ftp_cmd { cmd { tmout 0 } } {
	global timeout;
	global spawn_id;
	#
	puts "send_ftp_cmd: cmd is <$cmd>";
	if {$tmout != 0} {
		puts "send_ftp_cmd: setting timeout to $tmout ...";
		set timeout $tmout;
	}
	#
	send "$cmd\r";
	expect {
	-re "\n2.. \[^\r]*\r\nftp> " {
		# nothing to do
	 }
	-re "\n(... \[^\r]*)\r\nftp> " {
		puts "ftp error: $expect_out(1,string)";
		exit 2;
	}
	timeout {
		puts "ftp error: time out waiting for cmd \"$cmd\"";
		exit 2;
	}
	}
}
#
proc ftp_get_binary_file { machine remotefile localfile } {
	#
	global username;
	global userpasswd;
	global timeout;
	global spawn_id;
	#
	set savetimeout $timeout;
	set timeout 60;
	#
	spawn -noecho "ftp" $machine;
	expect {
	"Name" { send "$username\r"; }
	timeout { puts "\ntimeout during ftp login ..."; exit 2; }
	};
	#
	expect {
	"Password:" { send "$userpasswd\r"; }
	timeout { puts "\ntimeout during ftp passwd ..."; exit 2; }
	};
	#
	send_ftp_cmd "binary" 60;
	send_ftp_cmd "get $remotefile $localfile" -1;
	send_ftp_cmd "bye" 60;
	#
	set timeout $savetimeout;
	catch { close; wait; } ignore;
}
#
proc ftp_get_ascii_file { machine remotefile localfile } {
	#
	global username;
	global userpasswd;
	global timeout;
	global spawn_id;
	#
	set savetimeout $timeout;
	set timeout 60;
	#
	spawn -noecho "ftp" $machine;
	expect {
	"Name" { send "$username\r"; }
	timeout { puts "\ntimeout during ftp login ..."; exit 2; }
	};
	#
	expect {
	"Password:" { send "$userpasswd\r"; }
	timeout { puts "\ntimeout during ftp passwd ..."; exit 2; }
	};
	#
	send_ftp_cmd "ascii" 60;
	send_ftp_cmd "get $remotefile $localfile" -1;
	send_ftp_cmd "bye" 60;
	#
	set timeout $savetimeout;
	catch { close; wait; } ignore;
}
#
proc ftp_put_binary_file { machine localfile remotefile } {
	#
	global username;
	global userpasswd;
	global timeout;
	global spawn_id;
	#
	set savetimeout $timeout;
	set timeout 60;
	#
	spawn -noecho "ftp" $machine;
	expect {
	"Name" { send "$username\r"; }
	timeout { puts "\ntimeout during ftp login ..."; exit 2; }
	};
	#
	expect {
	"Password:" { send "$userpasswd\r"; }
	timeout { puts "\ntimeout during ftp passwd ..."; exit 2; }
	};
	#
	send_ftp_cmd "binary" 60;
	send_ftp_cmd "put $localfile $remotefile" -1;
	send_ftp_cmd "bye" 60;
	#
	set timeout $savetimeout;
	catch { close; wait; } ignore;
}
#
proc ftp_put_ascii_file { machine localfile remotefile } {
	#
	global username;
	global userpasswd;
	global timeout;
	global spawn_id;
	#
	set savetimeout $timeout;
	set timeout 60;
	#
	spawn -noecho "ftp" $machine;
	expect {
	"Name" { send "$username\r"; }
	timeout { puts "\ntimeout during ftp login ..."; exit 2; }
	};
	#
	expect {
	"Password:" { send "$userpasswd\r"; }
	timeout { puts "\ntimeout during ftp passwd ..."; exit 2; }
	};
	#
	send_ftp_cmd "ascii" 60;
	send_ftp_cmd "put $localfile $remotefile" -1;
	send_ftp_cmd "bye" 60;
	#
	set timeout $savetimeout;
	catch { close; wait; } ignore;
}
