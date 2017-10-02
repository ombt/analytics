#!/usr/bin/perl -w
#
######################################################################
#
# process an INF file and store the data in XML files.
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
# required section names
#
use constant INDEX => '[Index]';
use constant INFORMATION => '[Information]';
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
# section types
#
use constant SECTION_UNKNOWN => 0;
use constant SECTION_NAME_VALUE => 1;
use constant SECTION_LIST => 2;
#
# filename to id constants
#
use constant MAX_RECORDS_BEFORE_WRITE => 100;
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
my $verbose = NOVERBOSE;
my $rmv_xml_dir = FALSE;
my $use_same_path = FALSE;
#
my $xml_base_path = "/tmp";
my $xml_rel_path = "XML";
my $xml_path = $xml_base_path . '/' . $xml_rel_path;
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
        [-B base path] \\
        [-R relative path] \\
        [-P path] \\
        [-S] \\
        [-r] \\
        INF-file ...

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -B path - base xml path, defaults to '${xml_base_path}'
    -R path - relative xml path, defaults to '${xml_rel_path}'
    -P path - xml path, defaults to '${xml_path}'
    -S - use same path as original file, but prefix XML_ to the file name.
    -r - remove old XML directory (off by default).

EOF
}
#
######################################################################
#
# load name-value or list section
#
sub load_name_value
{
    my ($praw_data, $section, $pirec, $max_rec, $pinf_db) = @_;
    #
    $pinf_db->{found_data}->{$section} = FALSE;
    $pinf_db->{section_type}->{$section} = SECTION_NAME_VALUE;
    #
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
        push @section_data, $record;
        $$pirec += 1;
    }
    #
    printf $log_fh "%d: <%s>\n", 
        __LINE__, 
        join("\n", @section_data) 
        if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@section_data) <= 0)
    {
        $pinf_db->{$section} = {};
        printf $log_fh "%d: NO NAME-VALUE DATA FOUND IN SECTION %s. Lines read: %d\n", 
            __LINE__, $section, scalar(@section_data);
        return FAIL;
    }
    #
    %{$pinf_db->{$section}->{data}} = 
        map { split /\s*=\s*/, $_, 2 } @section_data;
    #
    # remove any double quotes.
    for my $key (keys %{$pinf_db->{$section}->{data}})
    {
        $pinf_db->{$section}->{data}->{$key} =~ s/^\s*"([^"]*)"\s*$/$1/;
    }
    #
    $pinf_db->{found_data}->{$section} = TRUE;
    #
    printf $log_fh "%d: Number of key-value pairs: %d\n", 
        __LINE__, 
        scalar(keys %{$pinf_db->{$section}->{data}})
        if ($verbose >= MINVERBOSE);
    printf $log_fh "%d: Lines read: %d\n", 
        __LINE__, 
        scalar(@section_data)
        if ($verbose >= MINVERBOSE);
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
            # printf $log_fh "Token ... <%s>\n", $token;
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
        # printf $log_fh "Token ... <%s>\n", $token;
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
    # printf $log_fh "Tokens: \n%s\n", join("\n",@tokens);
    #
    return @tokens;
}
#
sub load_list
{
    my ($praw_data, $section, $pirec, $max_rec, $pinf_db) = @_;
    #
    $pinf_db->{found_data}->{$section} = FALSE;
    $pinf_db->{section_type}->{$section} = SECTION_LIST;
    #
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
        push @section_data, $record;
        $$pirec += 1;
    }
    #
    printf $log_fh "%d: <%s>\n", __LINE__, join("\n", @section_data) 
        if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@section_data) <= 0)
    {
        $pinf_db->{$section} = {};
        printf $log_fh "%d: NO LIST DATA FOUND IN SECTION %s. Lines read: %d\n", 
            __LINE__, 
            $section, scalar(@section_data)
            if ($verbose >= MINVERBOSE);
        return SUCCESS;
    }
    #
    $pinf_db->{$section}->{header} = shift @section_data;
    @{$pinf_db->{$section}->{column_names}} = 
        split / /, $pinf_db->{$section}->{header};
    my $number_columns = scalar(@{$pinf_db->{$section}->{column_names}});
    #
    @{$pinf_db->{$section}->{data}} = ();
    #
    printf $log_fh "%d: Number of Columns: %d\n", 
        __LINE__, 
        $number_columns
        if ($verbose >= MINVERBOSE);
    #
    foreach my $record (@section_data)
    {
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, ' ');
        my $number_tokens = scalar(@tokens);
        #
        printf $log_fh "%d: Number of tokens in record: %d\n", __LINE__, $number_tokens if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pinf_db->{$section}->{column_names}}} = @tokens;
            #
            unshift @{$pinf_db->{$section}->{data}}, \%data;
            printf $log_fh "%d: Current Number of Records: %d\n", __LINE__, scalar(@{$pinf_db->{$section}->{data}}) if ($verbose >= MAXVERBOSE);
        }
        else
        {
            printf $log_fh "%d: ERROR: Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", __LINE__, $section, $number_tokens, $number_columns;
        }
    }
    #
    $pinf_db->{found_data}->{$section} = TRUE;
    #
    return SUCCESS;
}
#
######################################################################
#
# load and process product files
#
sub read_file
{
    my ($inf_file, $praw_data) = @_;
    #
    printf $log_fh "%d: Reading Product file: %s\n", 
                   __LINE__, $inf_file;
    #
    if ( ! -r $inf_file )
    {
        printf $log_fh "%d: ERROR: file $inf_file is NOT readable\n\n", __LINE__;
        return FAIL;
    }
    #
    unless (open(INFD, $inf_file))
    {
        printf $log_fh "%d: ERROR: unable to open $inf_file.\n\n", __LINE__;
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    printf $log_fh "%d: Lines read: %d\n", __LINE__, scalar(@{$praw_data}) if ($verbose >= MINVERBOSE);
    #
    return SUCCESS;
}
#
sub process_data
{
    my ($inf_file, $praw_data, $pinf_db) = @_;
    #
    printf $log_fh "%d: Processing product data: %s\n", 
                   __LINE__, $inf_file;
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        # remove non-ascii garbage characters. the first line contains junk.
        #
        $rec =~ s/[^[:ascii:]]//g;
        #
        printf $log_fh "%d: Record %04d: <%s>\n", 
            __LINE__, $irec, $rec
               if ($verbose >= MINVERBOSE);
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            printf $log_fh "%d: Section %03d: %s\n", 
                __LINE__, ++$sec_no, $section;
                # if ($verbose >= MINVERBOSE);
            #
            $rec = $praw_data->[${irec}+1];
            #
            if ($rec =~ m/^\s*$/)
            {
                $irec += 2;
                printf $log_fh "%d: Empty section - %s\n", 
                               __LINE__, $section;
            }
            elsif ($rec =~ m/.*=.*/)
            {
                load_name_value($praw_data, 
                                $section, 
                               \$irec, 
                                $max_rec,
                                $pinf_db);
            }
            else
            {
                load_list($praw_data, 
                          $section, 
                         \$irec, 
                          $max_rec,
                          $pinf_db);
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
sub name_to_value
{
    my ($pinf_db, $section, $key, $default_value) = @_;
    #
    my $value = $default_value;
    #
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        if (exists($pinf_db->{$section}->{data}->{$key}))
        {
            $value = $pinf_db->{$section}->{data}->{$key};
        }
    }
    #
    return $value;
}
#
sub export_to_xml
{
    my ($inf_file, $pinf_db) = @_;
    #
    printf $log_fh "%d: Writing product data to XML: %s\n", 
                   __LINE__, $inf_file;
    #
    my $prod_name = basename($inf_file);
    # $prod_name =~ tr/a-z/A-Z/;
    #
    my $prod_xml_path = '';
    if ($use_same_path == TRUE)
    {
        my $same_path = dirname($inf_file);
        $prod_xml_path = $same_path . '/XML_' . $prod_name;
    }
    else
    {
        $prod_xml_path = $xml_path . '/XML_' . $prod_name;
    }
    #
    printf $log_fh "%d: product %s XML file: %s\n", 
        __LINE__, $prod_name, $prod_xml_path;
    #
    open(my $outfh, ">" , $prod_xml_path) || die $!;
    #
    printf $outfh '<?xml version="1.0" encoding="utf-8" ?>' . "\n";
    #
    printf $outfh '<iLNB_UIF>' . "\n";
    #
    printf $outfh '<ProductInfo Format="200">' . "\n";
    #
    my $section = '[LotInformation]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        my $LotID = name_to_value($pinf_db, $section, 'Lot', '');
        my $ModelID = name_to_value($pinf_db, $section, 'ModelID', '');
        my $Side = name_to_value($pinf_db, $section, 'Side', '0');
        my $ProductData = name_to_value($pinf_db, $section, 'ProductData', '');
        my $Comment1 = name_to_value($pinf_db, $section, 'Comment1', '');
        my $Comment2 = name_to_value($pinf_db, $section, 'Comment2', '');
        my $Comment3 = name_to_value($pinf_db, $section, 'Comment3', '');
        #
        printf $outfh '<LotInformation LotID="%s" ModelID="%s" Side="%s" ProductData="%s" Comment1="%s" Comment2="%s" Comment3="%s"/>' . "\n", 
            $LotID,
            $ModelID,
            $Side,
            $ProductData,
            $Comment1,
            $Comment2,
            $Comment3;
    }
    #
    $section = '[Information]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        my $DataType = name_to_value($pinf_db, $section, 'Datatype', '0');
        my $Code = name_to_value($pinf_db, $section, 'Code', '0');
        my $ProductData = name_to_value($pinf_db, $section, 'ProductData', '0');
        my $ActualTime = name_to_value($pinf_db, $section, 'ActualTime', '0');
        my $BoardCount = name_to_value($pinf_db, $section, 'BoardCount', '0');
        #
        printf $outfh '<Information DataType="%s" Code="%s" ProductData="%s" ActualTime="%s" BoardCount="%s"/>' . "\n", 
            $DataType,
            $Code,
            $ProductData,
            $ActualTime,
            $BoardCount;
    }
    #
    $section = '[StopTime]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        my $StopTime = name_to_value($pinf_db, $section, 'StopTime', '0');
        my $FWaitTime = name_to_value($pinf_db, $section, 'FWaitTime', '0');
        my $RWaitTime = name_to_value($pinf_db, $section, 'RWaitTime', '0');
        my $PWaitTime = name_to_value($pinf_db, $section, 'PWaitTime', '0');
        my $ErrorStopTime = name_to_value($pinf_db, $section, 'ErrorStopTime', '0');
        #
        printf $outfh '<StopTime StopTime="%s" FWaitTime="%s" RWaitTime="%s" PWaitTime="%s" ErrorStopTime="%s"/>' . "\n",
            $StopTime,
            $FWaitTime,
            $RWaitTime,
            $PWaitTime,
            $ErrorStopTime;
    }
    #
    $section = '[StopCount]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        my $StopCount = name_to_value($pinf_db, $section, 'StopCount', '0');
        my $FWaitCount = name_to_value($pinf_db, $section, 'FWaitCount', '0');
        my $RWaitCount = name_to_value($pinf_db, $section, 'RWaitCount', '0');
        my $PWaitCount = name_to_value($pinf_db, $section, 'PWaitCount', '0');
        my $ErrorStopCount = name_to_value($pinf_db, $section, 'ErrorStopCount', '0');
        #
        printf $outfh '<StopCount StopCount="%s" FWaitCount="%s" RWaitCount="%s" PWaitCount="%s" ErrorStopCount="%s"/>' . "\n",
            $StopCount,
            $FWaitCount,
            $RWaitCount,
            $PWaitCount,
            $ErrorStopCount;
    }
    #
    $section = '[Inspection]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        my $OKCount = name_to_value($pinf_db, $section, 'OKCount', '0');
        my $NGCount = name_to_value($pinf_db, $section, 'NGCount', '0');
        my $PassCount = name_to_value($pinf_db, $section, 'PassCount', '0');
        my $TakeOutCount = name_to_value($pinf_db, $section, 'TakeOutCount', '0');
        #
        printf $outfh '<Inspection OKCount="%s" NGCount="%s" PassCount="%s" TakeOutCount="%s"/>' . "\n",
            $OKCount,
            $NGCount,
            $PassCount,
            $TakeOutCount;
    }
    #
    $section = '[EquipmentSpecific]';
    if ((exists($pinf_db->{found_data}->{$section})) &&
        ($pinf_db->{found_data}->{$section} == TRUE))
    {
        printf $outfh '<EquipmentSpecific>' . "\n";
        #
        foreach my $key (keys %{$pinf_db->{$section}->{data}})
        {
            printf $outfh "%s=%s\n", $key, $pinf_db->{$section}->{data}->{$key};
        }
        #
        printf $outfh '</EquipmentSpecific>' . "\n";
    }
    #
    printf $outfh '</ProductInfo>' . "\n";
    #
    printf $outfh '</iLNB_UIF>' . "\n";
    #
    close($outfh);
    #
    return SUCCESS;
}
#
sub process_file
{
    my ($inf_file) = @_;
    #
    printf $log_fh "\n%d: Processing product File: %s\n", 
                   __LINE__, $inf_file;
    #
    my @raw_data = ();
    my %inf_db = ();
    #
    my $status = FAIL;
    if (read_file($inf_file, \@raw_data) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Reading product file: %s\n", 
                       __LINE__, $inf_file;
    }
    elsif (process_data($inf_file, \@raw_data, \%inf_db) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Processing product file: %s\n", 
                       __LINE__, $inf_file;
    }
    elsif (export_to_xml($inf_file, \%inf_db) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Exporting product file to XML: %s\n", 
                       __LINE__, $inf_file;
    }
    else
    {
        printf $log_fh "%d: Success processing product file: %s\n", 
                       __LINE__, $inf_file;
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
#         [-S] \\
#         [-r] \\
#         INF-file ...
#
my %opts;
if (getopts('?hwWv:l:B:R:P:Sr', \%opts) != 1)
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
        $rmv_xml_dir = TRUE;
    }
    elsif ($opt eq 'S')
    {
        $use_same_path = TRUE;
    }
    elsif ($opt eq 'w')
    {
        $verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
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
            printf $log_fh "\n%d: ERROR: Invalid verbose level: $opts{$opt}\n", __LINE__;
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
    elsif ($opt eq 'P')
    {
        $xml_path = $opts{$opt} . '/';
        printf $log_fh "\n%d: XML path: %s\n", __LINE__, $xml_path;
    }
    elsif ($opt eq 'R')
    {
        $xml_rel_path = $opts{$opt} . '/';
        $xml_path = $xml_base_path . '/' . $xml_rel_path;
        printf $log_fh "\n%d: XML relative path: %s\n", __LINE__, $xml_rel_path;
    }
    elsif ($opt eq 'B')
    {
        $xml_base_path = $opts{$opt} . '/';
        $xml_path = $xml_base_path . '/' . $xml_rel_path;
        printf $log_fh "\n%d: XML base path: %s\n", __LINE__, $xml_base_path;
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
        printf $log_fh "%d: ERROR: No product files given.\n", __LINE__;
        usage($cmd);
        exit 2;
    }
    #
    rmtree($xml_path) if ($rmv_xml_dir == TRUE);
    ( mkpath($xml_path) || die $! ) unless ( -d $xml_path );
    #
    foreach my $inf_file (@ARGV)
    {
        process_file($inf_file);
    }
    #
}
else
{
    printf $log_fh "%d: Reading STDIN for list of files ...\n", __LINE__;
    #
    rmtree($xml_path) if ($rmv_xml_dir == TRUE);
    ( mkpath($xml_path) || die $! ) unless ( -d $xml_path );
    #
    while( defined(my $inf_file = <STDIN>) )
    {
        chomp($inf_file);
        process_file($inf_file);
    }
}
#
exit 0;
