#!/opt/exp/bin/expect
#
puts "PID is [pid]";
#
trap SIG_IGN SIGBUS;
#
sleep 30;
#
trap SIG_DFL SIGBUS;
#
exit 2;
