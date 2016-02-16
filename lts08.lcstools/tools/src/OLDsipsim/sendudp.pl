#!/opt/exp/bin/perl -w
#
# send a UDP msg.
#
########################################################################
#
# uses these modules
#
use Getopt::Std;
use IO::Socket;
#
# get IP address and port from cmd line.
#
print "Send UDP Msg:\n";
#
$mflag = 0;
#
my %opts;
getopts('m', \%opts);
foreach my $opt (%opts) {
	if ($opt eq "m") {
		$mflag = 1;
	}
}
#
(my $udpip, my $udpport, my @udpmsgs) = @ARGV;
if (!defined($udpip) || !defined($udpport)) {
	print STDERR "usage: sendudp IP PORT msg ... \n";
	exit 2;
} else {
	print "Remote IP addr: $udpip\n";
	print "Remote IP port: $udpport\n";
}
#
print "Creating UDP Socket ...\n";
my $proto = getprotobyname('udp');
defined($proto) or die "getprotobyname: $!";
socket(SOCKET, PF_INET, SOCK_DGRAM, $proto) or die "socket: $!";
#
my $ipaddr = gethostbyname($udpip);
defined($ipaddr) or die "gethostbyname: $!";
my $paddr = sockaddr_in($udpport, $ipaddr);
defined($paddr) or die "getprotobyname: $!";
#
print "Sending msg ...\n";
if ($mflag) {
	$udpmsg = join("\n", @udpmsgs);
	defined(send(SOCKET, $udpmsg, 0, $paddr)) or die "send: $!";
} else {
	foreach $udpmsg (@udpmsgs) {
		defined(send(SOCKET, $udpmsg, 0, $paddr)) or die "send: $!";
	}
}
#
close(SOCKET);
#
exit 0;
