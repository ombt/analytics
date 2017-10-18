#!/usr/bin/perl -w
#
# basic tcp server.
#
use strict;
#
use Getopt::Std;
#
# some globals
#
my $cmd = $0;
my $port = -1;
my $service = "";
my $machine = "localhost";
#
#######################################################################
#
sub usage
{
	my ($arg0) = @_;
	print <<EOF;

usage: $arg0 [-?] [-p port] [-s service] [machine or IP]

where:
	-? - print usage
	-p port - tcp accept port
	-s service - service to get port

the machine or IP are for the local machine. the default is 'localhost'.

EOF
}
#
#######################################################################
#
printf "\nWelcome to Bone Head Server:\n";
#
my %opts;
if (getopts('?p:s:', \%opts) != 1)
{
	usage($cmd);
	exit 2;
}
#
foreach my $opt (%opts)
{
	if ($opt eq "?")
	{
		usage($cmd);
		exit 0;
	}
	elsif ($opt eq "p")
	{
		$port = $opts{$opt};
		die "port is not a number." unless ($port =~ m/^\d+$/);
		printf "Port: %d\n", $port;
	}
	elsif ($opt eq "s")
	{
		$service = $opts{$opt};
		printf "Service: %s\n", $service;
		
	}
}
#
unless (($port > 0) || ($service ne ""))
{
	printf "ERROR: Neither port or service was given.\n";
	usage($cmd);
	exit 2;
}
#
exit 0;
