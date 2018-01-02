#!/usr/bin/perl -w
######################################################################
#
# parse an MAIH file name. known types are : u01, u03, mpr. all other
# file names are just echoed as is.
#
######################################################################
#
use strict;
use warnings;
#
my $binpath = undef;
#
BEGIN {
    use File::Basename;
    #
    $binpath = dirname($0);
    $binpath = "." if ($binpath eq "");
}
#
use Carp;
use Getopt::Std;
use File::Find;
use File::Path qw(mkpath);
use File::Path 'rmtree';
use Data::Dumper;
#
# my mods
#
use lib "$binpath";
use lib "$binpath/myutils";
#
use myconstants;
use mylogger;
use myutils;
use mymaihparser;
#
######################################################################
#
# globals
#
my $cmd = $0;
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $putils = myutils->new($plog);
die "Unable to create utils: $!" unless (defined($putils));
#
my $pmaih = mymaihparser->new($plog);
die "Unable to create maih parser: $!" unless (defined($pmaih));
#
# cmd line options
#
my $logfile = '';
#
######################################################################
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] [-T] \\ 
        [file ...] or reads STDIN

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace

EOF
}
#
######################################################################
#
# -? or -h - print this usage.
# -w - enable warning (level=min=1)
# -W - enable warning and trace (level=mid=2)
# -v - verbose level: 0=off,1=min,2=mid,3=max
# -l logfile - log file path
# -T - turn on trace
# 
my %opts;
if (getopts('?hwWv:l:T', \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (%opts)
{
    if (($opt eq 'h') or ($opt eq '?'))
    {
        usage($cmd);
        exit 0;
    }
    elsif ($opt eq 'T')
    {
        $plog->trace(TRUE);
    }
    elsif ($opt eq 'w')
    {
        $plog->verbose(MINVERBOSE);
    }
    elsif ($opt eq 'W')
    {
        $plog->verbose(MIDVERBOSE);
    }
    elsif ($opt eq 'v')
    {
        if (!defined($plog->verbose($opts{$opt})))
        {
            $plog->log_err("Invalid verbose level: $opts{$opt}\n");
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        $plog->logfile($opts{$opt});
        $plog->log_msg("Log File: %s\n", $opts{$opt});
    }
}
#
if ( -t STDIN )
{
    #
    # getting a list of files from command line.
    #
    if (scalar(@ARGV) == 0)
    {
        $plog->log_err("No file names given.\n");
        usage($cmd);
        exit 2;
    }
    #
    foreach my $file_name (@ARGV)
    {
        $plog->log_msg("File Name: %s\n", $file_name);
        my $ext = "";
        my @parts = undef;
        my $tstamp = 0;
        my $status = $pmaih->parse_filename($file_name, \$ext, \$tstamp, \@parts);
        if ($status != SUCCESS)
        {
            $plog->log_err("Failed to process %s.\n", $file_name);
        }
        else
        {
            $plog->log_msg("File Name Parts (ext=<%s>, tstamp=<%s>): %s\n", $ext, $tstamp, join("\n", @parts));
        }
    }
}
else
{
    $plog->log_msg("Reading STDIN for list of files ...\n");
    #
    while( defined(my $file_name = <STDIN>) )
    {
        $plog->log_msg("File Name: %s\n", $file_name);
        chomp($file_name);
        my $ext = "";
        my @parts = undef;
        my $tstamp = 0;
        my $status = $pmaih->parse_filename($file_name, \$ext, \$tstamp, \@parts);
        if ($status != SUCCESS)
        {
            $plog->log_err("Failed to process %s.\n", $file_name);
        }
        else
        {
            $plog->log_msg("File Name Parts (ext=<%s>, tstamp=<%s>): %s\n", $ext, $tstamp, join("\n", @parts));
        }
    }
}
# 
exit 0;
