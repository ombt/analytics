#!/opt/exp/bin/perl -w 
#
# test for TCP connections.
#
############################################################################
#
use Socket;
use Fcntl;
#
my $tcpproto = getprotobyname('tcp');
#
socket(SIPTCP, PF_INET, SOCK_STREAM, $tcpproto);
setsockopt(SIPTCP, SOL_SOCKET, SO_REUSEADDR, 1);
#
my ($ip, $port, $delta) = @ARGV;
if (!defined($ip) || !defined($port) || !defined($delta)) {
	print STDERR "IP or PORT was not given.\n";
	print STDERR "usage: tcp IP PORT SLEEP\n";
	exit 2;
}
#
my $ipaddr = gethostbyname($ip);
defined($ipaddr) or die "gethostbyname: $!";
my $paddr = sockaddr_in($port, $ipaddr);
defined($paddr) or die "sockaddr_in: $!";
#
bind(SIPTCP, $paddr) or die "bind: $!";
#
listen(SIPTCP, SOMAXCONN) or die "listen: $!";
#
my $rin = '';
vec($rin, fileno(SIPTCP), 1) = 1;
my $rout = '';
#
my $flags = fcntl(SIPTCP, F_GETFL, 0);
fcntl(SIPTCP, F_SETFL, $flags | O_NONBLOCK);
#
while ( 1 ) {
	print STDERR "calling select ...\n";
	#
	my ($nf, $timeleft) = select($rout=$rin, undef, undef, $delta);
	if (vec($rout, fileno(SIPTCP), 1)) {
		my $client = accept(CLIENT, SIPTCP);
		my ($client_port, $client_ip) = sockaddr_in($client);
		my $client_ascii_ip = inet_ntoa($client_ip);
		#
		print STDERR "client ip  : $client_ascii_ip\n";
		print STDERR "client port: $client_port\n";
	}
}
#
exit 0;
