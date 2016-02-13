#!/usr/bin/perl -w
######################################################################
#
# trace XML msg flow in a PanaCIM log file. typical examples are
# log files for LNB CVT, LNB MI and LNB LM.
#
######################################################################
#
use strict;
#
use Carp;
use Getopt::Std;
use File::Find;
use File::Path qw(mkpath);
use File::Basename;
use File::Path 'rmtree';
use XML::Simple;
use Data::Dumper;
#
######################################################################
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
######################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
# my $xml = new XML::Simple(ForceArray => 1);
my $xml = new XML::Simple();
my $simple_trace = FALSE;
my $print_raw = FALSE;
#
# cmd line options
#
my $logfile = '';
my $verbose = NOVERBOSE;
#
my %verbose_levels =
(
    off => NOVERBOSE(),
    min => MINVERBOSE(),
    mid => MIDVERBOSE(),
    max => MAXVERBOSE()
);
#
######################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [-t | -T] [-R] \\ 
        panacim-log-file ...

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path to a separate file.
    -t - simple trace, only message command name is listed.
    -T - full trace and translation of messages.
    -R - list raw XML message also. 

EOF
}
#
######################################################################
#
# read in PanaCIM log file and filter out XML messages to and from LNB.
#
sub process_file
{
    my ($log_file) = @_;
    #
    printf $log_fh "\n%d: Processing PanaCIM Log File: %s\n", 
                   __LINE__, $log_file;
    #
    open(my $infh, "<", $log_file) || die $!;
    #
    my $post_raw_nl = '';
    $post_raw_nl = "\n" if ($print_raw == TRUE);
    #
    while (my $rec = <$infh>)
    {
        chomp($rec);
        #
        if ($rec =~ m/\tDATA OUT:\s*(.*)$/)
        {
            my $do_rec = $1;
            printf $log_fh "\n%d: PanaCIM ==>> LNB - %s\n", 
                   __LINE__, $do_rec if ($print_raw == TRUE);
            my $booklist = $xml->XMLin($do_rec);
            if ($simple_trace == FALSE)
            {
                printf $log_fh "\n%d: PanaCIM ==>> LNB - %s\n", 
                       __LINE__, Dumper($booklist);
                full_trace($log_fh, "PanaCIM ==>> LNB", $book_list);
            }
            else
            {
                printf $log_fh "%s%d: PanaCIM ==>> LNB - %s\n", 
                       $post_raw_nl,
                       __LINE__, 
                       $booklist->{'Header'}->{'CommandName'};
                simple_trace($log_fh, "PanaCIM ==>> LNB", $book_list);
            }
        }
        elsif ($rec =~ m/\tDATA IN:\s*(.*)$/)
        {
            my $di_rec = $1;
            printf $log_fh "\n%d: PanaCIM <<== LNB - %s\n", 
                   __LINE__, $di_rec if ($print_raw == TRUE);
            my $booklist = $xml->XMLin($di_rec);
            if ($simple_trace == FALSE)
            {
                printf $log_fh "\n%d: PanaCIM <<== LNB - %s\n", 
                       __LINE__, Dumper($booklist);
                full_trace($log_fh, "PanaCIM <<== LNB", $book_list);
            }
            else
            {
                printf $log_fh "%s%d: PanaCIM <<== LNB - %s\n", 
                       $post_raw_nl,
                       __LINE__, 
                       $booklist->{'Header'}->{'CommandName'};
                simple_trace($log_fh, "PanaCIM <<== LNB", $book_list);
            }
        }
        elsif ($rec =~ m/(STARTING INFO LOGGING)/)
        {
            my $start_rec = $1;
            printf $log_fh "\n%d: PROCESS STARTUP - %s\n", 
                   __LINE__, $start_rec;
        }
    }
    #
    close($infh);
    #
    return;
}
#
######################################################################
#
my %opts;
if (getopts('?RtThwWv:l:', \%opts) != 1)
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
    elsif ($opt eq 'w')
    {
        $verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq 't')
    {
        $simple_trace = TRUE;
    }
    elsif ($opt eq 'T')
    {
        $simple_trace = FALSE;
    }
    elsif ($opt eq 'R')
    {
        $print_raw = TRUE;
    }
    elsif ($opt eq 'v')
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $verbose = $opts{$opt};
        }
        elsif (exists($verbose_levels{$opts{$opt}}))
        {
            $verbose = $verbose_levels{$opts{$opt}};
        }
        else
        {
            printf $log_fh "\n%d: Invalid verbose level: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        printf $log_fh "\n%d: Log File: %s\n", __LINE__, $logfile;
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
        printf $log_fh "%d: No log files given.\n", __LINE__;
        usage($cmd);
        exit 2;
    }
    #
    foreach my $panacim_log_file (@ARGV)
    {
        process_file($panacim_log_file);
    }
    #
}
else
{
    printf $log_fh "%d: Reading STDIN for list of files ...\n", __LINE__;
    #
    while ( defined(my $panacim_log_file = <STDIN>) )
    {
        chomp($panacim_log_file);
        process_file($panacim_log_file);
    }
}
#
exit 0;
