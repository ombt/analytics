#!/usr/bin/perl -w
######################################################################
#
# process a maihime file and write data out as JSON
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
use lib "$binpath/utils";
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
my $delimiter = "\t";
my $row_delimiter = "\n";
#
######################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] [-T] \\ 
        [-d row delimiter] \\
        [maihime-file ...] or reads STDIN

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace
    -d delimiter - row delimiter (new line by default)

EOF
}
#
######################################################################
#
# load and process product files, either CRB or MAI
#
sub export_section_to_json
{
    my ($pjson, $pprod_db, $section, $print_comma) = @_;
    #
    my $pcol_names = $pprod_db->{COLUMN_NAMES}->{$section};
    my $num_col_names = scalar(@{$pcol_names});
    #
    $$pjson .= sprintf "\n{ \"%s\" : ", $section;
    my $a_comma = "";
    $$pjson .= sprintf "[\n";
    foreach my $prow (@{$pprod_db->{DATA}->{$section}})
    {
        my $out = "";
        my $o_comma = "";
        for (my $i=0; $i<$num_col_names; ++$i)
        {
            my $col_name = $pcol_names->[$i];
            $out .= "$o_comma\"$col_name\" : \"$prow->{$col_name}\"${row_delimiter}";
            $o_comma = ",";
        }
        $$pjson .= sprintf "$a_comma\{\n$out\}\n";
        $a_comma = ",";
    }
    $$pjson .= sprintf "] }";
    $$pjson .= sprintf "," if ($print_comma == TRUE);
    $$pjson .= sprintf "\n";
}
#
sub export_to_json
{
    my ($prod_file, $pprod_db) = @_;
    #
    $plog->log_msg("Writing product data to JSON: %s\n", $prod_file);
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    my $json = "";
    #
    $json = sprintf "{ \"RECIPE\" : \"%s\"\n\"DATA\" : [ ", $prod_name;
    #
    my $print_comma = TRUE;
    my $max_isec = scalar(@{$pprod_db->{ORDER}});
    for (my $isec = 0; $isec<$max_isec; ++$isec)
    {
        my $section = $pprod_db->{ORDER}->[$isec];
        $print_comma = FALSE if ($isec >= ($max_isec-1));
        #
        $plog->log_vmin("Writing section: %s\n", $section);
        #
        if ($pprod_db->{TYPE}->{$section} == SECTION_NAME_VALUE)
        {
            $plog->log_vmin("Name-Value Section: %s\n", $section);
            export_section_to_json(\$json,
                                   $pprod_db,
                                   $section,
                                   $print_comma);
        }
        elsif ($pprod_db->{TYPE}->{$section} == SECTION_LIST)
        {
            $plog->log_vmin("List Section: %s\n", $section);
            export_section_to_json(\$json,
                                   $pprod_db,
                                   $section,
                                   $print_comma);
        }
        else
        {
            $plog->log_err("Unknown type Section: %s\n", $section);
        }
    }
    #
    $json .= sprintf "\n] }\n";
    #
    $plog->log_msg("JSON:\n%s\n", $json);
    #
    return SUCCESS;
}
#
sub process_file
{
    my ($prod_file) = @_;
    #
    $plog->log_msg("Processing product File: %s\n", $prod_file);
    #
    my @raw_data = ();
    my %prod_db = ();
    #
    my $status = FAIL;
    if ($putils->read_file($prod_file, \@raw_data) != SUCCESS)
    {
        $plog->log_err("Reading product file: %s\n", $prod_file);
    }
    elsif ($pmaih->process_data($prod_file, \@raw_data, \%prod_db) != SUCCESS)
    {
        $plog->log_err("Processing product file: %s\n", $prod_file);
    }
    elsif (export_to_json($prod_file, \%prod_db) != SUCCESS)
    {
        $plog->log_err("Exporting product file to JSON: %s\n", $prod_file);
    }
    else
    {
        $plog->log_msg("Success processing product file: %s\n", $prod_file);
        $status = SUCCESS;
    }
    #
    return $status;
}
#
######################################################################
#
# usage: $arg0 [-?] [-h]  \\ 
#         [-w | -W |-v level] \\ 
#         [-l logfile] \\ 
#         [-d row delimiter] \\
#         [maihime-file ...] or reads STDIN
#
my %opts;
if (getopts('?hwWv:l:d:', \%opts) != 1)
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
    elsif ($opt eq 'd')
    {
        $row_delimiter = $opts{$opt};
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
        $plog->log_err("No product files given.\n");
        usage($cmd);
        exit 2;
    }
    #
    foreach my $prod_file (@ARGV)
    {
        process_file($prod_file);
    }
    #
}
else
{
    $plog->log_msg("Reading STDIN for list of files ...\n");
    #
    while( defined(my $prod_file = <STDIN>) )
    {
        chomp($prod_file);
        process_file($prod_file);
    }
}
#
exit 0;
