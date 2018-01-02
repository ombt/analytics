#!/usr/bin/perl -w
######################################################################
#
# read a list of csv files and create JSON files.
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
#
# my mods
#
use lib "$binpath";
use lib "$binpath/myutils";
#
use myconstants;
#
######################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
#
# cmd line options
#
my $logfile = '';
my $rmv_old_json = FALSE;
my $delimiter = "\t";
#
my $json_base_path = undef;
$json_base_path = $ENV{'OMBT_JSON_BASE_PATH'} 
    if (exists($ENV{'OMBT_JSON_BASE_PATH'}));
$json_base_path = "." 
    unless (defined($json_base_path) and ($json_base_path ne ""));
#
my $json_rel_path = undef;
$json_rel_path = $ENV{'OMBT_JSON_REL_PATH'} 
    if (exists($ENV{'OMBT_JSON_REL_PATH'}));
$json_rel_path = "JSON" 
    unless (defined($json_rel_path) and ($json_rel_path ne ""));
#
my $json_path = $json_base_path . '/' . $json_rel_path;
#
######################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h] 
        [-l logfile]
        [-B base path]
        [-R relative path]
        [-P path]
        [-d delimiter]
        [-r] 
        CSV-file ...

where:
    -? or -h - print this usage.
    -l logfile - log file path
    -B path - base db path, defaults to '${json_base_path}'
              or use environment variable OMBT_JSON_BASE_PATH.
    -R path - relative db path, defaults to '${json_rel_path}'
              or use environment variable OMBT_JSON_REL_PATH.
    -P path - db path, defaults to '${json_path}'
    -d delimiter - CSV delimiter characer. default is a tab.
    -r - remove old JSON

EOF
}
#
######################################################################
#
sub process_file
{
    my ($csv_file) = @_;
    #
    printf $log_fh "\n%d: Processing CSV File: %s\n", __LINE__, $csv_file;
    #
    # open CSV file and column names from first row.
    #
    open(my $infh, "<" , $csv_file) || 
        die "Failed to open $csv_file for read: $!";
    #
    my $header = <$infh>;
    chomp($header);
    $header =~ s/\r//g;
    $header =~ s/\./_/g;
    $header =~ s/ /_/g;
    my @col_names = split /${delimiter}/, $header;
    my $num_col_names = scalar(@col_names);
    #
    unless ($num_col_names > 0)
    {
        printf $log_fh "\n%d: Skipping empty file: %s\n", 
                        __LINE__, $csv_file;
        return;
    }
    #
    # get json file name
    #
    (my $json_name = $csv_file) =~ s/\.csv$//i;
    $json_name =~ s/\./_/g;
    $json_name = basename($json_name);
    my $json_full_path = $json_path . "/" . $json_name . ".json";
    printf $log_fh "%d: JSON Path: %s\n", __LINE__, $json_full_path;
    #
    open(my $outfh, "+>>" , $json_full_path) || 
        die "Failed to open file $json_full_path for write: $!";
    #
    my $a_comma = "";
    printf $outfh "[\n";
    while (my $row = <$infh>)
    {
        chomp($row);
        $row =~ s/\r//g;
        #
        my @data = split /${delimiter}/, $row, -1;
        next unless (scalar(@data) == $num_col_names);
        #
        my $out = "";
        my $o_comma = "";
        for (my $i=0; $i<$num_col_names; ++$i)
        {
            $out .= "$o_comma\"$col_names[$i]\" : \"$data[$i]\"\n";
            $o_comma = ",";
        }
        printf $outfh "$a_comma\{\n$out\}\n";
        $a_comma = ",";
    }
    printf $outfh "]\n";
    #
    close($infh);
    close($outfh);
    #
    return;
}
#
######################################################################
#
my %opts;
if (getopts('?hB:R:P:l:d:r', \%opts) != 1)
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
    elsif ($opt eq 'P')
    {
        $json_path = $opts{$opt} . '/';
        printf $log_fh "\n%d: JSON path: %s\n", __LINE__, $json_path;
    }
    elsif ($opt eq 'R')
    {
        $json_rel_path = $opts{$opt};
        $json_path = $json_base_path . '/' . $json_rel_path;
        printf $log_fh "\n%d: JSON relative path: %s\n", __LINE__, $json_rel_path;
    }
    elsif ($opt eq 'B')
    {
        $json_base_path = $opts{$opt} . '/';
        $json_path = $json_base_path . '/' . $json_rel_path;
        printf $log_fh "\n%d: JSON base path: %s\n", __LINE__, $json_base_path;
    }
    elsif ($opt eq 'r')
    {
        $rmv_old_json = TRUE;
    }
    elsif ($opt eq 'l')
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        printf $log_fh "\n%d: Log File: %s\n", __LINE__, $logfile;
    }
    elsif ($opt eq 'd')
    {
        $delimiter = $opts{$opt};
        $delimiter = "\t" if ( $delimiter =~ /^$/ );
    }
}
#
# check if remove old data.
#
rmtree($json_path) if ($rmv_old_json == TRUE);
#
# create json path if needed.
#
( mkpath($json_path) || die "Unable to create $json_path: $!" ) 
    unless ( -d $json_path );
#
# process each file and place data into db.
#
if ( -t STDIN )
{
    #
    # getting a list of files from command line.
    #
    if (scalar(@ARGV) == 0)
    {
        printf $log_fh "%d: ERROR: No csv files given.\n", __LINE__;
        usage($cmd);
        exit 2;
    }
    #
    foreach my $csv_file (@ARGV)
    {
        process_file($csv_file);
    }
}
else
{
    printf $log_fh "%d: Reading STDIN for list of files ...\n", __LINE__;
    #
    while( defined(my $csv_file = <STDIN>) )
    {
        chomp($csv_file);
        process_file($csv_file);
    }
}
#
printf $log_fh "\n%d: Done with JSON: %s.\n", __LINE__, $json_path;
#
exit 0;
