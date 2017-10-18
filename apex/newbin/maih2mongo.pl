#!/usr/bin/perl -w
######################################################################
#
# process a maihime file, create a temp JSON file, and 
# import into MongoDB.
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
my $row_delimiter = "\n";
my $export_to_mongodb = TRUE;
#
my $database_name = undef;
my $collection_name = undef;
#
my $json_path = "ALL.JSON.$$";
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
        [-P JSON file path] \\
        [-d row delimiter] \\
        -D mongo_db_name -C collection_name [-X]
        [maihime-file ...] or reads STDIN

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace
    -P path - JSON file json path, defaults to '${json_path}'
    -d delimiter - row delimiter (new line by default)
    -D mongo_db_name - name of MongoDB database name
    -C collection_name - name of collection in the above database
    -X - DO NOT EXPORT to MongoDB and KEEP JSON file.

Mongo database and collection names must be given. There are no
default values.

EOF
}
#
######################################################################
#
# load and process product files, either CRB or MAI
#
sub export_section_to_json
{
    my ($outfh, $pprod_db, $section, $print_comma) = @_;
    #
    {
        my $pcol_names = $pprod_db->{COLUMN_NAMES}->{$section};
        my $num_col_names = scalar(@{$pcol_names});
        #
        printf $outfh "\n{ \"%s\" : ", $section;
        my $a_comma = "";
        printf $outfh "[\n";
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $out = "";
            my $o_comma = "";
            # printf $log_fh "%d: prow: %s\n", __LINE__, Dumper($prow);
            for (my $i=0; $i<$num_col_names; ++$i)
            {
                my $col_name = $pcol_names->[$i];
                my $value = $prow->{$col_name};
                $value =~ s/\\/\\\\/g;
                $out .= "$o_comma\"$col_name\" : \"$value\"${row_delimiter}";
                $o_comma = ",";
            }
            #
            # translate any '%' to '%%' because of the printf ...
            #
            $out =~ s/%/%%/g;
            printf $outfh "$a_comma\{\n$out\}\n";
            $a_comma = ",";
        }
        printf $outfh "] }";
        printf $outfh "," if ($print_comma == TRUE);
        printf $outfh "\n";
    }
}
#
sub export_to_json
{
    my ($outfh, $prod_file, $pprod_db) = @_;
    #
    $plog->log_vmin("Writing product data to JSON: %s\n", $prod_file);
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    $plog->log_vmin("Product: %s\n", $prod_name);
    #
    printf $outfh "{ \"RECIPE\" : \"%s\",\n\"DATA\" : [ ", $prod_name;
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
            export_section_to_json($outfh,
                                   $pprod_db,
                                   $section,
                                   $print_comma);
        }
        elsif ($pprod_db->{TYPE}->{$section} == SECTION_LIST)
        {
            $plog->log_vmin("List Section: %s\n", $section);
            export_section_to_json($outfh,
                                   $pprod_db,
                                   $section,
                                   $print_comma);
        }
        else
        {
            $plog->log_msg("Unknown type Section: %s\n", $section);
        }
    }
    printf $outfh "\n] }\n";
    #
    return SUCCESS;
}
#
sub process_file
{
    my ($outfh, $prod_file) = @_;
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
    elsif (export_to_json($outfh, $prod_file, \%prod_db) != SUCCESS)
    {
        $plog->log_err("Exporting product file to JSON: %s\n", $prod_file);
    }
    else
    {
        $plog->log_vmin("Success processing product file: %s\n", $prod_file);
        $status = SUCCESS;
    }
    #
    return $status;
}
#
sub export_to_mongo
{
    my ($db, $col) = @_;
    #
    $plog->log_msg("Exporting JSON to DB %s, Collection %s\n", $db, $col);
    #
    my $cmd = sprintf "mongoimport -v --db %s --collection %s --file \"%s\"", $db, $col, $json_path;
    $plog->log_msg("Mongo import CMD: %s\n", $cmd);
    #
    system $cmd;
}
#
######################################################################
#
#     -? or -h - print this usage.
#     -w - enable warning (level=min=1)
#     -W - enable warning and trace (level=mid=2)
#     -v - verbose level: 0=off,1=min,2=mid,3=max
#     -l logfile - log file path
#     -P path - JSON file json path, defaults to '${json_path}'
#     -d delimiter - row delimiter (new line by default)
#     -D mongo_db_name - name of MongoDB database name
#     -C collection_name - name of collection in the above database
#     -X - DO NOT EXPORT to MongoDB and KEEP JSON file.
# 
my %opts;
if (getopts('?ThwWv:P:l:d:D:C:X', \%opts) != 1)
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
    elsif ($opt eq 'P')
    {
        $json_path = $opts{$opt} . '/';
        $plog->log_msg("JSON path: %s\n", $json_path);
    }
    elsif ($opt eq 'd')
    {
        $row_delimiter = $opts{$opt};
    }
    elsif ($opt eq 'D')
    {
        $database_name = $opts{$opt};
    }
    elsif ($opt eq 'C')
    {
        $collection_name = $opts{$opt};
    }
    elsif ($opt eq 'X')
    {
        $export_to_mongodb = FALSE;
    }
}
#
if (( ! defined($database_name)) ||
    ( ! defined($collection_name)) ||
    ( $collection_name eq "") ||
    ( $database_name eq ""))
{
    $plog->log_err("Database or Collection names are undefined.\n");
    usage($cmd);
    exit 2;
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
    open(my $outfh, ">" , $json_path) || 
        die "file is $json_path: $!";
    #
    foreach my $prod_file (@ARGV)
    {
        my $status = process_file($outfh, $prod_file);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $prod_file);
        }
    }
    #
    close($outfh);
}
else
{
    $plog->log_msg("Reading STDIN for list of files ...\n");
    #
    open(my $outfh, ">" , $json_path) || 
        die "file is $json_path: $!";
    #
    while( defined(my $prod_file = <STDIN>) )
    {
        chomp($prod_file);
        my $status = process_file($outfh, $prod_file);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $prod_file);
        }
    }
    #
    close($outfh);
}
# 
if ($export_to_mongodb == TRUE)
{
    export_to_mongo($database_name, $collection_name);
    #
    unlink $json_path unless ($plog->verbose() >= MINVERBOSE);
}
#
exit 0;
