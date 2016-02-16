#!/opt/exp/bin/tclsh
#
package require Expect
#
global env;
#
puts "\nGDB Front-End:\n";
#
set debugfile [lindex $argv 0];
set corefile [lindex $argv 1];
#
puts "\nDebug File: ${debugfile}";
puts "Core File : ${corefile}";
#
log_user 1;
set timeout 60;
#
spawn -noecho gdb ${debugfile} ${corefile};
#
expect {
-re {.*[\r\n]*\(gdb\)[\t ]*} {
	puts "\nSending backtrace ... \n";
	send "bt\r";
}
timeout {
	puts "\nERROR: time out while waiting for gdb to initialize.\n";
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
	exit 2;
}
eof {
	puts "\nERROR: EOF while waiting for gdb to initialize.\n";
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
	exit 2;
}
}
#
set maxstackframe 0;
#
expect {
-re {.*[\r\n][^#]*#([0-9][0-9]*)  *0x[0-9a-fA-F]} {
	set maxstackframe $expect_out(1,string);
	exp_continue;
}
-re {.*[\r\n]*---.*Type.*to *continue.*or.*q.*to.*quit.*---} {
	puts "\nSending <CR> to continue ... \n";
	send "\r";
	exp_continue;
}
-re {.*[\r\n]*\(gdb\)[\t ]*} {
	puts "\nBack trace is done.\n";
	# ok
}
timeout {
	puts "\nERROR: time out while waiting for bt to complete.\n";
	catch { send "quit\r"; sleep 0.5; } ignore;
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
	exit 2;
}
eof {
	puts "\nERROR: EOF while waiting for bt to complete.\n";
	catch { close; } ignore;
	catch { exec kill -9 [exp_pid]; } ignore;
	catch { wait -nowait; } ignore;
	exit 2;
}
}
#
puts "\nMax Stack Frame is -- ${maxstackframe}\n";
#
set cmd 0;
set cmds([incr cmd]) "dumplog";
set cmds([incr cmd]) "info threads";
set cmds([incr cmd]) "info registers";
#
for {set icmd 1} {[info exists cmds(${icmd})]} {incr icmd} {
	set cmd $cmds(${icmd});
	#
	puts "\nSending ${cmd} ... \n";
	send "${cmd}\r";
	#
	expect {
	-re {.*[\r\n]*---.*Type.*to *continue.*or.*q.*to.*quit.*---} {
		puts "\nSending <CR> to continue ... \n";
		send "\r";
		exp_continue;
	}
	-re {.*[\r\n]*\(gdb\)[\t ]*} {
		# ok
	}
	timeout {
		puts "\nERROR: time out while waiting for '${cmd}' to complete.\n";
		catch { send "quit\r"; sleep 0.5; } ignore;
		catch { close; } ignore;
		catch { exec kill -9 [exp_pid]; } ignore;
		catch { wait -nowait; } ignore;
		exit 2;
	}
	eof {
		puts "\nERROR: EOF while waiting for '${cmd}' to complete.\n";
		catch { close; } ignore;
		catch { exec kill -9 [exp_pid]; } ignore;
		catch { wait -nowait; } ignore;
		exit 2;
	}
	}
}
#
set cmd 0;
set stackcmds([incr cmd]) "frame %d";
set stackcmds([incr cmd]) "info frame";
set stackcmds([incr cmd]) "info args";
set stackcmds([incr cmd]) "info locals";
#
for {set stackframe 0} {${stackframe}<=${maxstackframe}} {incr stackframe} {
	puts "\nFrame ${stackframe} ... \n";
	for {set stackcmd 1} {[info exists stackcmds(${stackcmd})]} {incr stackcmd} {
		set cmd $stackcmds(${stackcmd});
		#
		set fcmd [format ${cmd} ${stackframe}];
		puts "\nSending ${fcmd} ... \n";
		send "${fcmd}\r";
		#
		expect {
		-re {.*[\r\n]*---.*Type.*to *continue.*or.*q.*to.*quit.*---} {
			puts "\nSending <CR> to continue ... \n";
			send "\r";
			exp_continue;
		}
		-re {.*[\r\n]*\(gdb\)[\t ]*} {
			# ok
		}
		timeout {
			puts "\nERROR: time out while waiting for '${cmd}' to complete.\n";
			catch { send "quit\r"; sleep 0.5; } ignore;
			catch { close; } ignore;
			catch { exec kill -9 [exp_pid]; } ignore;
			catch { wait -nowait; } ignore;
			exit 2;
		}
		eof {
			puts "\nERROR: EOF while waiting for '${cmd}' to complete.\n";
			catch { close; } ignore;
			catch { exec kill -9 [exp_pid]; } ignore;
			catch { wait -nowait; } ignore;
			exit 2;
		}
		}
	}
}
#
puts "\nSending quit ... \n";
send "quit\r";
#
#
catch { close; } ignore;
catch { exec kill -9 [exp_pid]; } ignore;
catch { wait -nowait; } ignore;
#
puts "\nDone.\n";
#
exit 0;
