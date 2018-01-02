#!/usr/bin/perl -w
######################################################################
#
# process a maihime file and store the data in JSON files.
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
#
######################################################################
#
# required section names
#
use constant INDEX => '[Index]';
use constant INFORMATION => '[Information]';
#
# section types
#
use constant SECTION_UNKNOWN => 0;
use constant SECTION_NAME_VALUE => 1;
use constant SECTION_LIST => 2;
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
# cmd line options
#
my $logfile = '';
my $verbose = NOVERBOSE;
my $rmv_json_dir = FALSE;
my $delimiter = "\t";
my $row_delimiter = "\n";
my $debug_mode = FALSE;
my $row_separator = "\n";
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
$json_rel_path = "JSON_COMBINED" 
    unless (defined($json_rel_path) and ($json_rel_path ne ""));
#
my $json_path = $json_base_path . '/' . $json_rel_path;
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
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] [-T] \\ 
        [-B base path] \\
        [-R relative path] \\
        [-P path] \\
        [-r] \\
        [-d row delimiter] \\
        [maihime-file ...] or reads STDIN

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -B path - base json path, defaults to '${json_base_path}'
              or use environment variable OMBT_JSON_BASE_PATH.
    -R path - relative json path, defaults to '${json_rel_path}'
              or use environment variable OMBT_JSON_REL_PATH.
    -P path - json path, defaults to '${json_path}'
    -r - remove old JSON directory (off by default).
    -d delimiter - row delimiter (new line by default)

EOF
}
#
######################################################################
#
# load name-value or list section
#
sub load_name_value
{
    my ($praw_data, $section, $pirec, $max_rec, $pprod_db) = @_;
    #
    push @{$pprod_db->{ORDER}}, $section;
    $pprod_db->{TYPE}->{$section} = SECTION_NAME_VALUE;
    $pprod_db->{DATA}->{$section} = [];
    #
    my $start_irec = $$pirec;
    $$pirec += 1; # skip section name
    #
    for ( ; $$pirec < $max_rec; )
    {
        my $record = $praw_data->[$$pirec];
        #
        if ($record =~ m/^\s*$/)
        {
            $$pirec += 1;
            last;
        }
        elsif ($record =~ m/^\[[^\]]*\]/)
        {
            # section is corrupted. it lacks the required empty
            # line to indicate the end of the section.
            last;
        }
        else
        {
            next unless ($record =~ m/^\s*([^=]*)\s*=\s*([^=]*)\s*$/);
            #
            my $name = $1;
            $name =~ s/^\s*"([^"]*)"\s*$/$1/;
            #
            my $value = $2;
            $value =~ s/^\s*"([^"]*)"\s*$/$1/;
            push @{$pprod_db->{DATA}->{$section}}, "${name}${delimiter}${value}";
            #
            $$pirec += 1;
        }
    }
    #
    $plog->log_vmax("<%s>\n", join("\n", @{$pprod_db->{DATA}->{$section}}));
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        $plog->log_msg("NO NAME-VALUE DATA FOUND IN SECTION %s. Lines read: %d\n", $section, ($$pirec - $start_irec));
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = "NAME${delimiter}VALUE";
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split /${delimiter}/, $pprod_db->{HEADER}->{$section};
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $plog->log_vmin("Number of Columns: %d\n", $number_columns);
    #
    my $nrecs = scalar(@{$pprod_db->{DATA}->{$section}});
    #
    for (my $irec = 0; $irec<$nrecs; ++$irec)
    {
        my $record = $pprod_db->{DATA}->{$section}->[$irec];
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, "${delimiter}");
        my $number_tokens = scalar(@tokens);
        #
        $plog->log_vmax("Number of tokens in record: %d\n", $number_tokens);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pprod_db->{COLUMN_NAMES}->{$section}}} = @tokens;
            #
            $pprod_db->{DATA}->{$section}->[$irec] = \%data;
        }
        else
        {
            $plog->log_err("Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $section, $number_tokens, $number_columns);
        }
    }
    #
    $plog->log_vmin("Number of key-value pairs: %d\n", 
                    scalar(@{$pprod_db->{DATA}->{$section}}));
    $plog->log_vmin("Lines read: %d\n", ($$pirec - $start_irec));
    #
    return SUCCESS;
}
#
sub split_quoted_string
{
    my $rec = shift;
    my $separator = shift;
    #
    my $rec_len = length($rec);
    #
    my $istart = -1;
    my $iend = -1;
    my $in_string = 0;
    #
    my @tokens = ();
    my $token = "";
    #
    for (my $i=0; $i<$rec_len; $i++)
    {
        my $c = substr($rec, $i, 1);
        #
        if ($in_string == 1)
        {
            if ($c eq '"')
            {
                $in_string = 0;
            }
            else
            {
                $token .= $c;
            }
        }
        elsif ($c eq '"')
        {
            $in_string = 1;
        }
        elsif ($c eq $separator)
        {
            push (@tokens, $token);
            $token = '';
        }
        else
        {
            $token .= $c;
        }
    }
    #
    if (length($token) > 0)
    {
        push (@tokens, $token);
        $token = '';
    }
    else
    {
        # null-length string
        $token = '';
        push (@tokens, $token);
    }
    #
    return @tokens;
}
#
sub load_list
{
    my ($praw_data, $section, $pirec, $max_rec, $pprod_db) = @_;
    #
    push @{$pprod_db->{ORDER}}, $section;
    $pprod_db->{TYPE}->{$section} = SECTION_LIST;
    $pprod_db->{DATA}->{$section} = [];
    #
    my $start_irec = $$pirec;
    $$pirec += 1; # skip section name
    #
    my @section_data = ();
    for ( ; $$pirec < $max_rec; )
    {
        my $record = $praw_data->[$$pirec];
        #
        if ($record =~ m/^\s*$/)
        {
            $$pirec += 1;
            last;
        }
        elsif ($record =~ m/^\[[^\]]*\]/)
        {
            # section is corrupted. it lacks the required empty
            # line to indicate the end of the section.
            last;
        }
        else
        {
            push @{$pprod_db->{DATA}->{$section}}, $record;
            $$pirec += 1;
        }
    }
    #
    $plog->log_vmax("<%s>\n", join("\n", @{$pprod_db->{DATA}->{$section}}));
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        $plog->log_msg("NO LIST DATA FOUND IN SECTION %s. Lines read: %d\n", 
                       $section, ($$pirec - $start_irec));
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = 
        shift @{$pprod_db->{DATA}->{$section}};
    #
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split / /, $pprod_db->{HEADER}->{$section};
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $plog->log_msg("Number of Columns: %d\n", $number_columns);
    #
    my $nrecs = scalar(@{$pprod_db->{DATA}->{$section}});
    #
    for (my $irec = 0; $irec<$nrecs; ++$irec)
    {
        my $record = $pprod_db->{DATA}->{$section}->[$irec];
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, ' ');
        my $number_tokens = scalar(@tokens);
        #
        $plog->log_vmax("Number of tokens in record: %d\n", $number_tokens);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pprod_db->{COLUMN_NAMES}->{$section}}} = @tokens;
            #
            $pprod_db->{DATA}->{$section}->[$irec] = \%data;
        }
        else
        {
            $plog->log_err("Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $section, $number_tokens, $number_columns);
        }
    }
    #
    return SUCCESS;
}
#
######################################################################
#
# load and process product files, either CRB or MAI
#
sub process_data
{
    my ($prod_file, $praw_data, $pprod_db) = @_;
    #
    $plog->log_msg("Processing product data: %s\n", $prod_file);
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        $plog->log_vmin("Record %04d: <%s>\n", $irec, $rec);
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            $plog->log_vmin("Section %03d: %s\n", ++$sec_no, $section);
            #
            $rec = $praw_data->[${irec}+1];
            #
            if ($rec =~ m/^\s*$/)
            {
                $irec += 2;
                $plog->log_msg("Empty section - %s\n", $section);
            }
            elsif ($rec =~ m/.*=.*/)
            {
                load_name_value($praw_data, 
                                $section, 
                               \$irec, 
                                $max_rec,
                                $pprod_db);
            }
            else
            {
                load_list($praw_data, 
                          $section, 
                         \$irec, 
                          $max_rec,
                          $pprod_db);
            }
        }
        else
        {
            $irec += 1;
        }
    }
    #
    return SUCCESS;
}
#
sub export_section_to_json
{
    my ($outfh, $pprod_db, $section, $print_comma) = @_;
    #
    if ($debug_mode == TRUE)
    {
        printf $outfh "\n%s\n", $section;
        #
        my $pcols = $pprod_db->{COLUMN_NAMES}->{$section};
        my $comma = "";
        foreach my $col (@{$pcols})
        {
            printf $outfh "%s%s", $comma, $col;
            $comma = ',';
        }
        printf $outfh "\n";
        #
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $comma = "";
            foreach my $col (@{$pcols})
            {
                printf $outfh "%s%s", $comma, $prow->{$col};
                $comma = ',';
            }
            printf $outfh "\n";
        }
    }
    else
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
    my ($prod_file, $pprod_db) = @_;
    #
    $plog->log_msg("Writing product data to JSON: %s\n", $prod_file);
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    my $prod_json_path = $json_path . '/' . $prod_name . '.JSON';
    $plog->log_msg("Product %s, JSON path: %s\n", 
                   $prod_name, $prod_json_path);
    #
    open(my $outfh, "+>>" , $prod_json_path) || 
        die "file is $prod_json_path: $!";
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
            $plog->log_err("Unknown type Section: %s\n", $section);
        }
    }
    printf $outfh "\n] }\n";
    #
    close($outfh);
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
    elsif (process_data($prod_file, \@raw_data, \%prod_db) != SUCCESS)
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
#         [-B base path] \\
#         [-R relative path] \\
#         [-P path] \\
#         [-r]  \\
#         [-d row delimiter] \\
#         [maihime-file ...] or reads STDIN
#
my %opts;
if (getopts('?ThwWv:B:R:P:l:rd:', \%opts) != 1)
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
    elsif ($opt eq 'r')
    {
        $rmv_json_dir = TRUE;
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
    elsif ($opt eq 'R')
    {
        $json_rel_path = $opts{$opt} . '/';
        $json_path = $json_base_path . '/' . $json_rel_path;
        $plog->log_msg("JSON relative path: %s\n", $json_rel_path);
    }
    elsif ($opt eq 'B')
    {
        $json_base_path = $opts{$opt} . '/';
        $json_path = $json_base_path . '/' . $json_rel_path;
        $plog->log_msg("JSON base path: %s\n", $json_base_path);
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
    rmtree($json_path) if ($rmv_json_dir == TRUE);
    ( mkpath($json_path) || die $! ) unless ( -d $json_path );
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
    rmtree($json_path) if ($rmv_json_dir == TRUE);
    ( mkpath($json_path) || die $! ) unless ( -d $json_path );
    #
    while( defined(my $prod_file = <STDIN>) )
    {
        chomp($prod_file);
        process_file($prod_file);
    }
}
#
exit 0;
