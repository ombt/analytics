#!/opt/exp/bin/expect
#
# test database interface
#
#########################################################################
#
source $env(LCSTOOLSLIB)/ndb
#
if {[dbdelete junk "A req ^1$ and B req ^2$"] != 0} {
	puts "dbdelete failed.";
} else {
	puts "dbdelete succeeded.";
}
exit 0;

