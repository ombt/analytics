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
# message types
#
use constant NO_MSGS => 0;
use constant XML_MSGS => 1;
use constant PM_MSGS => 2;
use constant ALL_MSGS => 3;
#
######################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
# my $xml = new XML::Simple(ForceArray => 1);
my $xml = new XML::Simple();
my $full_trace = TRUE;
my $print_raw = FALSE;
my $trace_msg_type = XML_MSGS;
my $use_private_parser = FALSE;
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
my %trace_msg_types =
(
    none => NO_MSGS(),
    xml  => XML_MSGS(),
    pm   => PM_MSGS(),
    all  => ALL_MSGS()
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
        [-P xml|pm|all] [-p] \\
        panacim-log-file ...

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1).
    -W - enable warning and trace (level=mid=2).
    -v - verbose level: 0=off,1=min,2=mid,3=max.
    -l logfile - log file path to a separate file.
    -t - simple trace, only message command name is listed.
    -T - full trace and translation of messages (default).
    -R - list raw message also. 
    -P xml|pm|all - type of message to trace (XML=default).
    -p - use private parser, if available (only XML for now).

EOF
}
#
######################################################################
#
# read in PanaCIM log file and filter out XML messages to and from LNB.
#
sub print_pm
{
    my ($post_raw_nl, 
        $label,
        $msg_src,
        $msg_dest,
        $msg_class,
        $msg_type,
        $rec) = @_;
    #
    if ($full_trace == TRUE)
    {
        $rec =~ m/^.*(MessageSource\s*=\s[^\s]+\s*,\s*MessageDestination\s*=\s*[^\s]+.*)$/;
        my $pm_rec = $1;
        #
        printf $log_fh "\n%d: %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n\t%s\n", 
               __LINE__, 
               $label,
               $msg_src,
               $msg_dest,
               $msg_class,
               $msg_type,
               join("\n\t", split(",", $pm_rec));
    }
    else
    {
        printf $log_fh "\n%d: %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n", 
               __LINE__, 
               $label,
               $msg_src,
               $msg_dest,
               $msg_class,
               $msg_type;
    }
}
#
sub process_pm
{
    my ($post_raw_nl, $rec) = @_;
    #
    my $done = FALSE;
    #
    if ($rec =~ m/\t([^\s]+)\s*,\s*MessageSource\s*=\s([^\s]+)\s*,\s*MessageDestination\s*=\s*([^\s]+)\s*,\s*MessageClass\s*=\s*([^\s]+)\s*,\s*MessageType\s*=\s*([^\s]+)/)
    {
        my $label = $1;
        my $msg_src = $2;
        my $msg_dest = $3;
        my $msg_class = $4;
        my $msg_type = $5;
        #
        printf $log_fh "\n%d: %s - %s\n", 
               __LINE__, $label, $rec if ($print_raw == TRUE);
        #
        print_pm($post_raw_nl, 
                 $label,
                 $msg_src,
                 $msg_dest,
                 $msg_class,
                 $msg_type,
                 $rec);
        #
        $done = TRUE;
    }
    #
    return($done);
}
#
sub print_xml
{
    my($post_raw_nl, $label, $pbooklist) = @_;
    #
    if ($full_trace == TRUE)
    {
        printf $log_fh "\n%d: %s - %s\n", 
               __LINE__, 
               $label,
               Dumper($pbooklist);
    }
    else
    {
        printf $log_fh "%s%d: %s - %s\n", 
               $post_raw_nl,
               __LINE__, 
               $label,
               $pbooklist->{'Header'}->{'CommandName'};
    }
}
#
sub element_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    while ($$pidx < $maxtoken)
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m?^</[^>]+>$?)
        {
            # end token
        }
        elsif ($token =~ m?^</[^>]+>(.*)$?)
        {
        }
    } 
}
#
sub start_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $$pidx += 1;
        element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        printf $log_fh "\n%d: ERROR - NOT XML 1.0 DOC: <%s>\n", 
               __LINE__, $token;
    }
    #
    return($proot);
}
#
sub parse_xml
{
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    printf $log_fh "\n%d: Tokens: \n\t%s\n", 
               __LINE__, 
               join("\n\t", @tokens) if ($verbose >= MINVERBOSE);
    #
    start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub process_xml
{
    my ($post_raw_nl, $rec) = @_;
    #
    my $done = FALSE;
    my $booklist = undef;
    #
    if ($rec =~ m/\tDATA OUT:\s*(.*)$/)
    {
        my $do_rec = $1;
        printf $log_fh "\n%d: PanaCIM ==>> LNB - %s\n", 
               __LINE__, $do_rec if ($print_raw == TRUE);
        #
        if ($use_private_parser == TRUE)
        {
            $booklist = parse_xml($do_rec);
        }
        else
        {
            $booklist = $xml->XMLin($do_rec);
        }
        #
        print_xml($post_raw_nl, 
                  "PanaCIM ==>> LNB", 
                  $booklist);
        $done = TRUE;
    }
    elsif ($rec =~ m/\tDATA IN:\s*(.*)$/)
    {
        my $di_rec = $1;
        printf $log_fh "\n%d: PanaCIM <<== LNB - %s\n", 
               __LINE__, $di_rec if ($print_raw == TRUE);
        #
        if ($use_private_parser == TRUE)
        {
            $booklist = parse_xml($di_rec);
        }
        else
        {
            $booklist = $xml->XMLin($di_rec);
        }
        #
        print_xml($post_raw_nl, 
                  "PanaCIM <<== LNB", 
                  $booklist);
        $done = TRUE;
    }
    #
    $booklist = undef;
    #
    return($done);
}
#
sub process_other
{
    my ($post_raw_nl, $rec) = @_;
    #
    my $done = FALSE;
    #
    if ($rec =~ m/(STARTING INFO LOGGING)/)
    {
        my $start_rec = $1;
        printf $log_fh "\n%d: PROCESS STARTUP - %s\n", 
               __LINE__, $start_rec;
    }
    #
    return($done);
}
#
# use constant NO_MSGS => 0;
# use constant XML_MSGS => 1;
# use constant PM_MSGS => 2;
# use constant ALL_MSGS => 3;
# my $trace_msg_type = XML_MSGS;
#
sub process_rec
{
    my($post_raw_nl, $rec) = @_;
    #
    if (($trace_msg_type == XML_MSGS) ||
        ($trace_msg_type == ALL_MSGS))
    {
        return if (process_xml($post_raw_nl, $rec) == TRUE);
    }
    if (($trace_msg_type == PM_MSGS) ||
        ($trace_msg_type == ALL_MSGS))
    {
        return if (process_pm($post_raw_nl, $rec) == TRUE);
        
    }
    process_other($post_raw_nl, $rec);
}
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
        process_rec($post_raw_nl, $rec);
    }
    #
    close($infh);
    #
    return;
}
#
######################################################################
#
# usage: $arg0 [-?] [-h]  \\ 
#         [-w | -W |-v level] \\ 
#         [-l logfile] \\ 
#         [-t | -T] [-R] \\ 
#         [-P xml|pm|all] [-p] \\
#
my %opts;
if (getopts('?hwWv:l:tTRP:p', \%opts) != 1)
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
        $full_trace = FALSE;
    }
    elsif ($opt eq 'T')
    {
        $full_trace = TRUE;
    }
    elsif ($opt eq 'R')
    {
        $print_raw = TRUE;
    }
    elsif ($opt eq 'p')
    {
        $use_private_parser = TRUE;
    }
    elsif ($opt eq 'P')
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $trace_msg_type = $opts{$opt};
        }
        elsif (exists($trace_msg_types{$opts{$opt}}))
        {
            $trace_msg_type = $trace_msg_types{$opts{$opt}};
        }
        else
        {
            printf $log_fh "\n%d: Invalid message type: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
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