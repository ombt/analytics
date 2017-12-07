#!/usr/bin/perl -w
#
################################################################
#
# test LNB XML message modules
#
################################################################
#
use strict;
#
################################################################
#
# load libraries
#
my $binpath;
#
BEGIN
{
    use File::Basename;
    #
    $binpath = dirname($0);
    $binpath = "." if ($binpath eq "");
}
#
use Getopt::Std;
use Data::Dumper;
#
use lib "$binpath";
use lib "$binpath/myutils";
#
use myconstants;
use mylogger;
use myxml;
use myutils;
#
################################################################
#
# globals
#
my $cmd = $0;
my $use_new_parser = TRUE;
#
my $plog = mylogger->new();
my $putils = myutils->new($plog);
#
################################################################
#
# functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h] \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [-O] \\
        XML-file [tag_name [tag_name2 ...]]

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -O - use old XML parser

EOF
}
#
sub process_file
{
    my $xml_file = shift;
    my @tag_names = @_;
    #
    $plog->log_msg("Processing XML file: %s\n", $xml_file);
    #
    my $pbuffer = [];
    if ($putils->read_file($xml_file, $pbuffer) != SUCCESS)
    {
        $plog->log_err("Failed to read XML file: %s\n", $xml_file);
        return FAIL;
    }
    #
    my $pxml = myxml->new($pbuffer, $plog, $use_new_parser);
    $pxml->skip_xml_header(TRUE());
    if ($pxml->parse() != SUCCESS)
    {
        $plog->log_err("Parsing failed for XML file: %s\n", $xml_file);
        return FAIL;
    }
    $plog->log_vmin("Dumper: %s\n", Dumper($pxml->booklist()));
    #
    $plog->log_msg("Deparsed XML: %s\n", $pxml->deparse());
    #
    if (scalar(@tag_names) > 0)
    {
        my $tag_value = $pxml->names_to_value(@tag_names);
        if (defined($tag_value))
        {
            $plog->log_msg("%s => %s\n", join(' => ', @tag_names), $tag_value);
            $plog->log_vmin("Dumper: %s\n", Dumper($tag_value));
        }
        else
        {
            $plog->log_msg("%s => undef\n", join(' => ', @tag_names));
        }
    }
    else
    {
        $plog->log_msg("Dumper: %s\n", Dumper($pxml->booklist()));
    }
    #
    $pxml = undef;
    #
    return SUCCESS;
}
#
################################################################
#
# start of main
#
$plog->disable_stdout_buffering();
#
my %opts;
if (getopts('?hwWv:l:O', \%opts) != 1)
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
    elsif ($opt eq 'O')
    {
        $use_new_parser = FALSE;
    }
}
#
if (scalar(@ARGV) == 0)
{
    $plog->log_err("No XML files given.\n");
    usage($cmd);
    exit 2;
}
#
if (process_file(@ARGV) == SUCCESS)
{
    $plog->log_msg("Processing PASSED.\n");
}
else
{
    $plog->log_err("Processing FAILED.\n");
}
#
exit 0;
