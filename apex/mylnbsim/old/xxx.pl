#!/usr/bin/perl -w
#
use Data::Dumper;
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
sub read_file
{
    my ($inf_file, $praw_data) = @_;
    #
    printf "%d: Reading file: %s\n", __LINE__, $inf_file;
    #
    if ( ! -r $inf_file )
    {
        printf "%d: ERROR: file $inf_file is NOT readable\n\n", __LINE__;
        return FAIL;
    }
    #
    unless (open(INFD, $inf_file))
    {
        printf "%d: ERROR: unable to open $inf_file.\n\n", __LINE__;
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    #
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    printf "%d: Lines read: %d\n", __LINE__, scalar(@{$praw_data});
    #
    return SUCCESS;
}
#
sub accept_token
{
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag
{
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                accept_token($ptokens, $pidx, __LINE__);
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                element_xml($ptokens, 
                            $pidx, 
                            $maxtoken, 
                            $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if (is_end_tag($tag_name, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                printf "%d: MISSING END TAG : <%s,%s>\n", __LINE__, $tag_name, $token;
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if (is_end_tag($first_start_tag, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                printf "%d: UNEXPECTED END TAG : <%s>\n", __LINE__, $token;
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
        }
        else
        {
            printf "%d: UNEXPECTED TOKEN : <%s>\n", __LINE__, $token;
            accept_token($ptokens, $pidx, __LINE__);
            $done = TRUE;
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
        accept_token($ptokens, $pidx, __LINE__);
        element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        printf "%d: NOT XML 1.0 DOC: <%s>\n", __LINE__, $token;
    }
    #
    return($proot);
}
#
sub parse_xml
{
    my ($xml_rec) = @_;
    #
    printf "%d: Parse XML (1): %s\n", __LINE__, $xml_rec;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub element_xml2
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    my $first_start_tag_seen = 0;
    my $first_start_tag_proot = undef;
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                $first_start_tag_seen += 1;
                $first_start_tag_proot = $proot;
                #
                $$proot->{$token} = undef;
                $proot = \$$proot->{$token};
                accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                $$proot->{$token} = undef;
                element_xml2($ptokens, 
                             $pidx, 
                             $maxtoken, 
                             $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            $$proot->{$tag_name} = $tag_value;
            accept_token($ptokens, $pidx, __LINE__);
            #
            $token = $ptokens->[$$pidx];
            if (is_end_tag($tag_name, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                printf "%d: MISSING END TAG : <%s,%s>\n", __LINE__, $tag_name, $token;
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if (is_end_tag($first_start_tag, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                printf "%d: UNEXPECTED END TAG : <%s>\n", __LINE__, $token;
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
        }
        else
        {
            printf "%d: UNEXPECTED TOKEN : <%s>\n", __LINE__, $token;
            accept_token($ptokens, $pidx, __LINE__);
            $done = TRUE;
        }
    }
}
#
sub start_xml2
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        accept_token($ptokens, $pidx, __LINE__);
        element_xml2($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        printf "%d: NOT XML 1.0 DOC: <%s>\n", __LINE__, $token;
    }
    #
    return($proot);
}
#
sub parse_xml2
{
    my ($xml_rec) = @_;
    #
    printf "%d: Parse XML (2): %s\n", __LINE__, $xml_rec;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    #
    my $proot = undef;
    start_xml2(\@tokens, \$idx, scalar(@tokens), \$proot);
    #
    return($proot);
}
#
sub to_xml2
{
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    my $last_element_end_tag = $last_element;
    $last_element_end_tag =~ s?^<?</?;
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "$last_element" if ($i > 0);
            to_xml2($ptree->[$i], $pxml, $last_element);
            $$pxml .= "$last_element_end_tag" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            my $element_end_tag = $element;
            $element_end_tag =~ s?^<?</?;
            #
            $$pxml .= "$element";
            to_xml2($ptree->{$element}, $pxml, $element);
            $$pxml .= "$element_end_tag";
        }
    }
    else
    {
        $$pxml .= "$ptree" if (defined($ptree));
    }
}
#
sub msg_to_xml2
{
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    to_xml2($ptree, \$xml, $last_element);
    #
    return $xml;
}
#
foreach my $inf_file (@ARGV)
{
    my @raw_data = ();
    #
    read_file($inf_file, \@raw_data);
    #
    foreach my $xml_rec (@raw_data)
    {
        my $proot = parse_xml($xml_rec);
        printf "\n%d: DUMPER root msg (1) = %s\n", __LINE__, Dumper($proot);
        #
        my $proot2 = parse_xml2($xml_rec);
        printf "\n%d: DUMPER root Original msg (2) = %s\n", __LINE__, Dumper($proot2);
        #
        my $msg2 = msg_to_xml2($proot2);
        printf "%d: Original = %s\n", __LINE__, $xml_rec;
        printf "%d: Deparsed = %s\n", __LINE__, $msg2;
    }
}
#
exit(0);

__DATA__
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
# parsing LNB-style XML messages
#
package mylnbxml;
#
use myconstants;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{booklist} = undef;
    $self->{xml} = undef;
    $self->{deparse_xml} = undef;
    $self->{logger} = undef;
    $self->{errors} = 0;
    #
    # $self->{xml} = shift if @_;
    # $self->{logger} = shift if @_;
    #
    if (scalar(@_) == 1)
    {
        $self->{logger} = shift;
    }
    elsif (scalar(@_) == 2)
    {
        $self->{xml} = shift;
        $self->{logger} = shift;
    }
    #
    bless $self, $class;
    #
    return($self);
}
#
sub xml
{
    my $self = shift;
    #
    if (@_)
    {
        $self->{xml} = shift;
        $self->{booklist} = undef;
        $self->{deparse_xml} = undef;
        $self->{errors} = 0;
    }
    #
    return($self->{xml});
}
#
sub booklist
{
    my $self = shift;
    #
    return($self->{booklist});
}
#
#
sub errors
{
    my $self = shift;
    #
    return($self->{errors});
}
#
sub accept_token
{
    my $self = shift;
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                $self->accept_token($ptokens, $pidx, __LINE__);
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                $self->element_xml($ptokens, 
                                   $pidx, 
                                   $maxtoken, 
                                   $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            $self->accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if ($self->is_end_tag($tag_name, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $self->accept_token($ptokens, $pidx, __LINE__);
        $self->element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
    }
    #
    return($proot);
}
#
sub parse_xml
{
    my $self = shift;
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    $self->start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub parse
{
    my $self = shift;
    #
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        $self->{booklist} = $self->parse_xml($self->{xml});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
        }
    }
    #
    return($self->{booklist});
}
#
sub accept_token_2
{
    my $self = shift;
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag_2
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml_2
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                $self->accept_token_2($ptokens, $pidx, __LINE__);
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                $self->element_xml_2($ptokens, 
                                     $pidx, 
                                     $maxtoken, 
                                     $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            $self->accept_token_2($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if ($self->is_end_tag_2($tag_name, $token) == TRUE)
            {
                $self->accept_token_2($ptokens, $pidx, __LINE__);
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token_2($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token_2($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token_2($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml_2
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $self->accept_token_2($ptokens, $pidx, __LINE__);
        $self->element_xml_2($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
    }
    #
    return($proot);
}
#
sub parse_xml_2
{
    my $self = shift;
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    $self->start_xml_2(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
sub parse_2
{
    my $self = shift;
    #
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        $self->{booklist} = $self->parse_xml_2($self->{xml});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
        }
    }
    #
    return($self->{booklist});
}
#
sub end_tag
{
    my $self = shift;
    my ($start_tag) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    return($end_tag);
}
#
sub deparse_start_xml
{
    my $self = shift;
    my ($ptree, $pxstr) = @_;
    #
    if (ref($ptree) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$ptree}); ++$i)
        {
            my $name = $ptree->[$i]->{NAME};
            #
            if (scalar(@{$ptree->[$i]->{SIBLINGS}}) > 0)
            {
                $$pxstr .= $name;
                $self->deparse_start_xml($ptree->[$i]->{SIBLINGS}, $pxstr);
                $$pxstr .= $self->end_tag($name);
            }
            elsif (defined($ptree->[$i]->{VALUE}))
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $value . $self->end_tag($name);
            }
            else
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $self->end_tag($name);
            }
        }
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("EXPECTING ARRAY REF: <%s>\n", ref($ptree));
    }
}
#
sub deparse_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml_string = '<?xml version="1.0" encoding="UTF-8"?>';
    $self->deparse_start_xml($ptree, \$xml_string);
    #
    return($xml_string);
}
#
sub deparse
{
    my $self = shift;
    #
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{booklist}))
    {
        $self->{errors} = 0;
        $self->{deparse_xml} = $self->deparse_xml($self->{booklist});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Deparse failed.\n");
            $self->{deparse_xml} = undef;
        }
    }
    #
    return($self->{deparse_xml});
}
#
sub to_xml
{
    my $self = shift;
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "<$last_element>" if ($i > 0);
            $self->to_xml($ptree->[$i], $pxml, $last_element);
            $$pxml .= "</$last_element>" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            $$pxml .= "<$element>";
            $self->to_xml($ptree->{$element}, $pxml, $element);
            $$pxml .= "</$element>";
        }
    }
    else
    {
        $$pxml .= "$ptree";
    }
}
#
sub msg_to_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    $self->to_xml($ptree, \$xml, $last_element);
    #
    $self->{xml} = $xml;
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    $self->{errors} = 0;
    #
    return $xml;
}
#
# exit with success
#
1;
#!/usr/bin/perl -w
#
use strict;
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
use lib $binpath;
#
use myconstants;
use mylogger;
use mylnbxml;
#
my $plog = mylogger->new();
#
my $plnbxml = mylnbxml->new($plog);
#
my $pmsg = 
{
    root => {
        Header => {
            SystemName => 'OTHERSYSTEM',
            SystemVersion => 1.00,
            SessionId => 58628,
            CommandName => 'ProgramDataSend'
        },
        ProgramDataSend => {
            Element => [
                {
                    Date => '2017/03/23,00:00:45',
                    MCNo => 1,
                    Stage => 1,
                    Lane => 1,
                    MjsFileName => 'CO3',
                    MjsGroupName => '1',
                    LotName => 'NPMW-C1',
                    LotNumber => 1,
                    LotName2 => '',
                    LotNumber2 => 0,
                    Rev => 1
                },
                {
                    Date => '2017/03/23,00:00:45',
                    MCNo => 2,
                    Stage => 1,
                    Lane => 1,
                    MjsFileName => 'CO3',
                    MjsGroupName => '1',
                    LotName => 'NPMW-C1',
                    LotNumber => 1,
                    LotName2 => '',
                    LotNumber2 => 0,
                    Rev => 1
                },
            ]
        },
    },
};
#
my $xml = $plnbxml->msg_to_xml($pmsg);
printf "MSG-to-XML ... %s\n", $xml;
#
$plnbxml->parse();
my $xml2 = $plnbxml->deparse();
printf "MSG-to-XML-to-Internal-to-XML ... %s\n", $xml2;
#
if ($xml eq $xml2)
{
    printf "XMls are the same !!!\n";
}
else
{
    printf "XMls are NOT the same !!!\n";
}
#
$xml = $plnbxml->msg_to_xml(
{
    root => {
        Header => {
            SystemName => 'OTHERSYSTEM',
            SystemVersion => 1.00,
            SessionId => 58628,
            CommandName => 'ProgramDataSend'
        },
        ProgramDataSend => {
            Element => [
                {
                    Date => '2017/03/23,00:00:45',
                    MCNo => 1,
                    Stage => 1,
                    Lane => 1,
                    MjsFileName => 'CO3',
                    MjsGroupName => '1',
                    LotName => 'NPMW-C1',
                    LotNumber => 1,
                    LotName2 => '',
                    LotNumber2 => 0,
                    Rev => 1
                },
                {
                    Date => '2017/03/23,00:00:45',
                    MCNo => 2,
                    Stage => 1,
                    Lane => 1,
                    MjsFileName => 'CO3',
                    MjsGroupName => '1',
                    LotName => 'NPMW-C1',
                    LotNumber => 1,
                    LotName2 => '',
                    LotNumber2 => 0,
                    Rev => 1
                },
            ]
        },
    },
});
printf "MSG-to-XML ... %s\n", $xml;
#
$plnbxml->parse();
$xml2 = $plnbxml->deparse();
printf "MSG-to-XML-to-Internal-to-XML ... %s\n", $xml2;
#
if ($xml eq $xml2)
{
    printf "XMls are the same !!!\n";
}
else
{
    printf "XMls are NOT the same !!!\n";
}
#
exit 0;

__DATA__
#!/usr/bin/perl -w
#
################################################################
#
# LNB simulator
#
################################################################
#
use strict;
#
################################################################
#
# read official and local mods
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
# perl mods
#
use Getopt::Std;
use Socket;
use FileHandle;
use POSIX qw(:errno_h);
#
# my mods
#
use lib $binpath;
#
use myconstants;
use mylogger;
use mytimer;
use mytimerpqueue;
use mytaskdata;
use mylnbxml;
#
################################################################
#
# local constants
#
use constant SOH => 1;
use constant STX => 2;
use constant ETX => 3;
#
################################################################
#
# globals
#
my $cmd = $0;
my $default_cfg_file = "mylnb.cfg";
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $pq = mytimerpqueue->new();
die "Unable to create priority queue: $!" unless (defined($pq));
#
my $pservices = mytaskdata->new();
die "Unable to create services data: $!" 
    unless (defined($pservices));
#
my $pfh_services = mytaskdata->new();
die "Unable to create file-handler-to-services data: $!" 
    unless (defined($pfh_services));
#
my $pfh_data = mytaskdata->new();
die "Unable to create task-specific data: $!" 
    unless (defined($pfh_data));
#
my $event_loop_done = FALSE;
#
my %service_params =
(
    name => {
        required => FALSE(),
        handler => FALSE(),
    },
    service => {
        required => TRUE(),
        handler => FALSE(),
    },
    host_name => {
        required => TRUE(),
        handler => FALSE(),
    },
    io_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    service_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    timer_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_io_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_service_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_timer_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    enabled => {
        required => TRUE(),
    },
    port => {
        required => FALSE(),
    },
);
#
# vectors for select()
#
my $rin = '';
my $win = '';
my $ein = '';
#
my $rout = '';
my $wout = '';
my $eout = '';
#
################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h] \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [config-file [config-file2 ...]]

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path

config-file is the configuration file containing lists of
services to create. one or more config files can be given.
if a config file is not given, then the default is to look
for the file generic-server.cfg in the current directory.

EOF
}
#
sub read_file
{
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        $plog->log_err("File %s is NOT readable\n", $file_nm);
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        $plog->log_err("Unable to open %s.\n", $file_nm);
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from windows.
    #
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    $plog->log_vmid("Lines read: %d\n", scalar(@{$praw_data}));
    return SUCCESS;
}
#
################################################################
#
# read and parse config file.
#
sub check_service_data
{
    my ($pservice) = @_;
    #
    foreach my $key (keys %service_params)
    {
        if ((!exists($pservice->{$key})) &&
            ($service_params{$key}{required} == TRUE))
        {
            $plog->log_err("Required field missing: %s\n", $key);
            return FALSE;
        }
    }
    #
    return TRUE;
}
#
sub parse_cfg_file
{
    my ($pdata) = @_;
    #
    my $lnno = 0;
    my $pservice = { };
    my $in_service = FALSE;
    #
    foreach my $record (@{$pdata})
    {
        $plog->log_vmin("Processing record (%d) : %s\n", ++$lnno, $record);
        #
        if (($record =~ m/^\s*#/) || ($record =~ m/^\s*$/))
        {
            # skip comments or white-space-only lines
            next;
        }
        elsif ($record =~ m/^\s*service\s*start\s*$/)
        {
            if ($in_service != FALSE)
            {
                $plog->log_err("Previous service not ended (%d).\n", $lnno);
                return FAIL;
            }
            #
            $pservice = { };
            $in_service = TRUE;
        }
        elsif ($record =~ m/^\s*service\s*end\s*$/)
        {
            if ($in_service != TRUE)
            {
                $plog->log_err("Missing service name (%d).\n", $lnno);
                return FAIL;
            }
            elsif ((exists($pservice->{name})) &&
                   ($pservice->{name} ne ""))
            {
                my $name = $pservice->{name};
                #
                $plog->log_msg("Storing service: %s\n", $name);
                #
                if ($pservices->exists($name) == TRUE)
                {
                    $plog->log_err("Duplicate service name (%d): %s\n", $lnno, $name);
                    return FAIL;
                }
                #
                if (check_service_data($pservice) != TRUE)
                {
                    $plog->log_err("Service sanity check failed (%d): %s\n", $lnno, $name);
                    return FAIL;
                }
                #
                $pservices->set($name, $pservice);
            }
            else
            {
                $plog->log_err("Unknown service name (%d).\n", $lnno);
                return FAIL;
            }
            #
            $pservice = { };
            $in_service = FALSE;
        }
        elsif ($record =~ m/^\s*([^\s]+)\s*=\s*(.*)$/i)
        {
            my $key = ${1};
            my $value = ${2};
            #
            if (exists($service_params{$key}))
            {
                $plog->log_vmin("Setting %s to %s (%d)\n", $key, $value, $lnno);
                $pservice->{$key} = $value;
            }
            else
            {
                $plog->log_err("Record %d with unknown key: %s\n", $lnno, $key, $record);
                return FAIL;
            }
        }
        else
        {
            $plog->log_err("Unknown record %d: %s\n", $lnno, $record);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub read_cfg_file
{
    my ($cfgfile) = @_;
    #
    my @data = ();
    if ((read_file($cfgfile, \@data) == SUCCESS) &&
        (parse_cfg_file(\@data) == SUCCESS))
    {
        $plog->log_vmin("Successfully processed cfg file %s.\n", $cfgfile);
        return SUCCESS;
    }
    else
    {
        $plog->log_err("Processing cfg file %s failed.\n", $cfgfile);
        return FAIL;
    }
}
#
################################################################
#
# generic service handlers
#
sub socket_stream_accept_io_handler
{
    my ($pservice) = @_;
    #
    # do the accept
    #
    my $pfh = $pservice->{fh};
    # my $new_fh = FileHandle->new();
    my $new_fh = undef;
    if (my $client_paddr = accept($new_fh, $$pfh))
    {
        $plog->log_msg("accept() succeeded for service %s\n", $pservice->{name});
        #
        fcntl($new_fh, F_SETFL, O_NONBLOCK);
        #
        my ($client_port, $client_packed_ip) = sockaddr_in($client_paddr);
        my $client_ascii_ip = inet_ntoa($client_packed_ip);
        #
        vec($rin, fileno($new_fh), 1) = 1;
        vec($ein, fileno($new_fh), 1) = 1;
        #
        my $io_handler = undef;
        die "unknown client io handler: $!" 
            unless (exists($pservice->{client_io_handler}));
        $io_handler = $pservice->{client_io_handler};
        #
        my $service_handler = undef;
        die "unknown client service handler: $!" 
            unless (exists($pservice->{client_service_handler}));
        $service_handler = $pservice->{client_service_handler};
        #
        my $timer_handler = $pservice->{client_timer_handler};
        #
        my $pnew_service = 
        {
            client => TRUE(),
            name => "client_of_" . $pservice->{name},
            client_port => $client_port,
            client_host_name => $client_ascii_ip,
            client_paddr => $client_paddr,
            fh => \$new_fh,
            io_handler => $io_handler,
            service_handler => $service_handler,
            timer_handler => $timer_handler,
            total_buffer => "",
        };
        #
        my $fileno = fileno($new_fh);
        $pfh_services->set($fileno, $pnew_service);
        $pfh_data->reallocate($fileno);
        #
        # call ctor if it exists.
        #
        my $ctor = $pservice->{'ctor'};
        if (defined($ctor))
        {
            my $status = &{$ctor}($pnew_service);
        }
        return SUCCESS;
    }
    else
    {
        $plog->log_err("accept() failed for service %s\n", $pservice->{name});
        return FAIL;
    }
}
#
sub generic_stream_io_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering generic_stream_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $buffer = undef;
    my $nr = sysread($$pfh, $buffer, 1024*4);
    #
    if (defined($nr))
    {
        if ($nr > 0)
        {
            #
            # read something ... process it ...
            #
            my $local_buffer = unpack("H*", $buffer);
            $plog->log_msg("nr ... <%d>\n", $nr);
            $plog->log_msg("buffer ... <%s>\n", $buffer);
            $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
            #
            $pfh_data->set($fileno, 'input', $buffer);
            $pfh_data->set($fileno, 'input_length', $nr);
            #
            return &{$pservice->{service_handler}}($pservice);
        }
        else
        {
            #
            # EOF. close socket and clean up.
            #
            vec($rin, $fileno, 1) = 0;
            vec($ein, $fileno, 1) = 0;
            vec($win, $fileno, 1) = 0;
            #
            close($$pfh);
            #
            $plog->log_msg("closing socket (%d) for service %s ...\n", 
                           $fileno,
                           $pservice->{name});
            $pfh_services->deallocate($fileno);
            $pfh_data->deallocate($fileno);
            #
            return SUCCESS;
        }
    }
    elsif ($! != EAGAIN)
    {
        #
        # some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_err("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
        #
        return FAIL;
    }
    else
    {
        # EAGAIN ... try again
        return SUCCESS;
    }
}
#
sub generic_stream_service_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering generic_stream_service_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = $pfh_data->get($fileno, 'input_length');
    my $buffer = $pfh_data->get($fileno, 'input');
    #
    if ( ! defined(send($$pfh, $buffer, $nr)))
    {
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub generic_stream_client_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
            return FAIL;
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
        return FAIL;
    }
    #
    $pxml = undef;
    return SUCCESS;
}
#
################################################################
#
# LNB-specific io handler
#
sub lnb_io_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering lnb_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = 0;
    my $buffer = undef;
    #
    # for testing use a small buffer ...
    # while (defined($nr = sysread($$pfh, $buffer, 8*4)) && ($nr > 0))
    #
    while (defined($nr = sysread($$pfh, $buffer, 1024*4)) && ($nr > 0))
    {
        $plog->log_msg("nr ... <%d>\n", $nr);
        $plog->log_msg("buffer ... <%s>\n", $buffer);
        #
        my $local_buffer = unpack("H*", $buffer);
        $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
        #
        if ($nr > 0)
        {
             my $total_buffer = $pfh_data->get($fileno, 'total_buffer');
             $total_buffer = $total_buffer . $buffer;
             my $tblen = length($total_buffer);
             my $sohi = -1;
             my $stxi = -1;
             my $etxi = -1;
             for (my $tbi = 0; $tbi < $tblen; $tbi += 1)
             {
                 my $ch = substr($total_buffer, $tbi, 1);
                 if ($ch =~ m/^\x01/)
                 {
                     $sohi = $tbi;
                     $stxi = -1;
                     $etxi = -1;
                 }
                 elsif ($ch =~ m/^\x02/)
                 {
                     $stxi = $tbi;
                 }
                 elsif ($ch =~ m/^\x03/)
                 {
                     $etxi = $tbi;
                 }
                 #
                 if (($stxi != -1) && ($etxi != -1))
                 {
                     my $xml_start = $stxi + 1;
                     my $xml_end = $etxi - 1;
                     my $xml_length = $xml_end - $xml_start + 1;
                     my $xml_buffer = substr($total_buffer, 
                                             $xml_start, 
                                             $xml_length);
                     #
                     $pfh_data->set($fileno, 'input', $xml_buffer);
                     $pfh_data->set($fileno, 'input_length', $xml_length);
                     #
                     &{$pservice->{service_handler}}($pservice);
                     #
                     $sohi = -1;
                     $stxi = -1;
                     $etxi = -1;
                 }
             }
             #
             # reset for partially read messages.
             #
             if ($sohi != -1)
             {
                 $plog->log_msg("Partial read ... got back for more.\n");
                 $total_buffer = substr($total_buffer, $sohi);
                 $pfh_data->set($fileno, 'total_buffer', $total_buffer);
             }
        }
    }
    #
    if ((( ! defined($nr)) && ($! != EAGAIN)) ||
        (defined($nr) && ($nr == 0)))
    {
        #
        # EOF or some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
    }
    #
    return SUCCESS;
}
#
sub send_xml_msg
{
    my ($pservice, $xml) = @_;
    #
    my $pfh = $pservice->{fh};
    #
    my $buflen = sprintf("%06d", length($xml));
    #
    # c  ==>> SOH
    # A* ==>> XML length
    # c  ==>> STX
    # A* ==>> XML
    # c  ==>> ETX
    #
    my $buf = pack("cA*cA*c", SOH, $buflen, STX, $xml, ETX);
    #
    # len(SOH) + len(xml_length) + len(STX) + len(xml) + len(ETX)
    #
    my $nw = 1 + 6 + 1 + length($xml) + 1;
    #
    my $local_buf = unpack("H*", $buf);
    $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buf);
    #
    # handle partial writes.
    #
    # die $! if ( ! defined(send($$pfh, $buf, $nw)));
    for (my $ntow=$nw; 
         ($ntow > 0) &&
         defined($nw = send($$pfh, $buf, $ntow));
         $ntow -= $nw) { }
    die $! if ( ! defined($nw) );
}
#
################################################################
#
# lnb service handlers
#
sub test_lnb_client_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
            $pxml = undef;
            return SUCCESS;
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
            $pxml = undef;
            return FAIL;
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
        $pxml = undef;
        return FAIL;
    }
}
#
sub lnbcvthost_client_io_handler
{
    return lnb_io_handler(@_);
}
#
sub lnbcvthost_client_service_handler
{
    return test_lnb_client_service_handler(@_);
}
#
sub lnbcvthost_client_timer_handler
{
    return SUCCESS;
}
#
sub lnbcvthost_io_handler
{
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbcvthost_service_handler
{
    return SUCCESS;
}
#
sub lnbcvthost_timer_handler
{
    return SUCCESS;
}
#
sub lnblmhost_client_io_handler
{
    return lnb_io_handler(@_);
}
#
sub lnblmhost_client_service_handler
{
    return test_lnb_client_service_handler(@_);
}
#
sub lnblmhost_client_timer_handler
{
    return SUCCESS;
}
#
sub lnblmhost_io_handler
{
    return socket_stream_accept_io_handler(@_);
}
#
sub lnblmhost_service_handler
{
    return SUCCESS;
}
#
sub lnblmhost_timer_handler
{
    return SUCCESS;
}
#
sub lnbmihost_client_io_handler
{
    return lnb_io_handler(@_);
}
#
sub lnbmihost_client_service_handler
{
    return test_lnb_client_service_handler(@_);
}
#
sub lnbmihost_client_timer_handler
{
    return SUCCESS;
}
#
sub lnbmihost_io_handler
{
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbmihost_service_handler
{
    return SUCCESS;
}
#
sub lnbmihost_timer_handler
{
    return SUCCESS;
}
#
sub lnbspcvthost_client_io_handler
{
    return lnb_io_handler(@_);
}
#
sub lnbspcvthost_client_service_handler
{
    return test_lnb_client_service_handler(@_);
}
#
sub lnbspcvthost_client_timer_handler
{
    return SUCCESS;
}
#
sub lnbspcvthost_io_handler
{
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbspcvthost_service_handler
{
    return SUCCESS;
}
#
sub lnbspcvthost_timer_handler
{
    return SUCCESS;
}
#
sub lnbspmihost_client_io_handler
{
    return lnb_io_handler(@_);
}
#
sub lnbspmihost_client_service_handler
{
    return test_lnb_client_service_handler(@_);
}
#
sub lnbspmihost_client_timer_handler
{
    return SUCCESS;
}
#
sub lnbspmihost_io_handler
{
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbspmihost_service_handler
{
    return SUCCESS;
}
#
sub lnbspmihost_timer_handler
{
    return SUCCESS;
}
#
sub my_echo_io_handler
{
    return generic_stream_io_handler(@_);
}
#
sub my_echo_service_handler
{
    return generic_stream_service_handler(@_);
}
#
sub null_handler
{
    return SUCCESS;
}
#
sub stdin_timer_handler
{
    my ($ptimer, $pservice) = @_;
    #
    $plog->log_vmin("sanity timer handler ... %s\n", $ptimer->{label});
    #
    start_timer($ptimer->{fileno},
                $ptimer->{delta},
                $ptimer->{label});
}
#
sub stdin_handler
{
    my ($pservice) = @_;
    #
    my $data = <STDIN>;
    chomp($data);
    #
    if (defined($data))
    {
        $plog->log_msg("input ... <%s>\n", $data);
        if ($data =~ m/^q$/i)
        {
            $event_loop_done = TRUE;
        }
        elsif (($data =~ m/^[h?]$/i) ||
               ($data eq ""))
        {
            my $log_fh = $plog->log_fh();
            print $log_fh <<EOF;
Available commnds:
    q - quit
    ? - help
    h - help
    l - list services
    s - print services
    lc - list clients
    cc <fileno> - close client
    t - print timers
    v0 - no verbose
    v1 - min verbose
    v2 - mid verbose
    v3 - max verbose
EOF
        }
        elsif ($data =~ m/^v0$/i)
        {
            $plog->verbose(NOVERBOSE);
        }
        elsif ($data =~ m/^v1$/i)
        {
            $plog->verbose(MINVERBOSE);
        }
        elsif ($data =~ m/^v2$/i)
        {
            $plog->verbose(MIDVERBOSE);
        }
        elsif ($data =~ m/^v3$/i)
        {
            $plog->verbose(MAXVERBOSE);
        }
        elsif ($data =~ m/^s$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                $plog->log_msg("FileNo: %d, Service: %s\n", 
                               $fileno,
                               $pservice->{name});
                if ((defined($pservice->{port})) &&
                    ($pservice->{port} > 0))
                    
                {
                    $plog->log_msg("FileNo: %d, Port: %s\n", 
                               $fileno,
                               $pservice->{port});
                }
                if ((defined($pservice->{file_name})) &&
                    ($pservice->{file_name} ne ""))
                {
                    $plog->log_msg("FileNo: %d, File Name: %s\n", 
                               $fileno,
                               $pservice->{file_name});
                }
                if ((defined($pservice->{client_host_name})) &&
                    ($pservice->{client_host_name} ne ""))
                {
                    $plog->log_msg("FileNo: %d, Client Host Name: %s\n", 
                               $fileno,
                               $pservice->{client_host_name});
                }
                if ((defined($pservice->{client_port})) &&
                    ($pservice->{client_port} > 0))
                {
                    $plog->log_msg("FileNo: %d, Client Port: %d\n", 
                               $fileno,
                               $pservice->{client_port});
                }
            }             
        }
        elsif ($data =~ m/^l$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                $plog->log_msg("FileNo: %d, Service: %s\n", 
                               $fileno,
                               $pservice->{name});
            }             
        }
        elsif ($data =~ m/^lc$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                if ((defined($pservice->{client})) &&
                    ($pservice->{client} == TRUE))
                {
                    $plog->log_msg("Client: FileNo: %d, Service: %s\n", 
                                   $fileno,
                                   $pservice->{name});
                }
            }             
        }
        elsif ($data =~ m/^cc\s*(\d+)\s*$/i)
        {
            my $fileno_to_close = $1;
            if (defined($fileno_to_close) && ($fileno_to_close >= 0))
            {
                my $pfhit = $pfh_services->iterator('n');
                while (defined(my $fileno = $pfhit->()))
                {
                    my $pservice = $pfh_services->get($fileno);
                    if ((defined($pservice->{client})) &&
                        ($pservice->{client} == TRUE) &&
                        ($fileno == $fileno_to_close))
                    {
                        $plog->log_msg("Closing Client: FileNo: %d, Service: %s\n", 
                                       $fileno,
                                       $pservice->{name});
                        vec($rin, $fileno, 1) = 0;
                        vec($ein, $fileno, 1) = 0;
                        vec($win, $fileno, 1) = 0;
                        #
                        my $pfh = $pservice->{fh};
                        close($$pfh);
                        #
                        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                                       $fileno,
                                       $pservice->{name});
                        $pfh_services->deallocate($fileno);
                        $pfh_data->deallocate($fileno);
                    }
                }             
            }
            else
            {
                $plog->log_msg("Invalid client file no.\n");
            }
        }
        elsif ($data =~ m/^t$/i)
        {
            $pq->dump();
        }
    }
}
#
################################################################
#
# create services and service handlers
#
sub add_stdin_to_services
{
    my $fno = fileno(STDIN);
    #
    $pfh_services->set($fno, {
        name => "STDIN",
        io_handler => \&stdin_handler,
        timer_handler => \&stdin_timer_handler,
    });
    #
    $pfh_data->reallocate($fno);
    #
    $plog->log_msg("Adding STDIN service ... %s\n",
                  $pfh_services->get($fno, 'name'));
    #
    vec($rin, fileno(STDIN), 1) = 1;
}
#
sub function_defined
{
    my ($func_name) = @_;
    if (defined(&{$func_name}))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub get_handler
{
    my ($handler) = @_;
    #
    if (function_defined($handler) == TRUE)
    {
        # turn off strict so we can convert name to function.
        no strict 'refs';
        return \&{$handler};
    }
    else
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return undef
    }
}
#
sub create_socket_stream
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating stream socket for %s.\n", $pservice->{name});
    #
    my $fh = undef;
    socket($fh, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    $plog->log_msg("calling gethostbyname($pservice->{host_name})\n");
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $port = undef;
    if (exists($pservice->{service}) && 
        defined($pservice->{service}))
    {
        # get port from services file
        $port = getservbyname($pservice->{service}, 'tcp') or
            die "Can't get port for service $pservice->{service}: $!";
        $plog->log_msg("getservbyname($pservice->{service}, 'tcp') port = $port\n");
        $pservice->{port} = $port;
    }
    else
    {
        $port = $pservice->{port};
        $plog->log_msg("Config file port = $port\n");
    }
    my $paddr = sockaddr_in($port, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind error for $pservice->{name}: $!";
    listen($fh, SOMAXCONN) or die "listen: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for handlers
    #
    foreach my $key (keys %service_params)
    {
        if (exists($service_params{$key}{handler}) &&
            ($service_params{$key}{handler} == TRUE))
        {
            my $handler = $pservice->{$key};
            $pservice->{$key} = get_handler($handler);
            if ( ! defined($pservice->{$key}))
            {
                $plog->log_err("Function %s does NOT EXIST.\n", $key);
                return FAIL;
            }
        }
    }
    #
    return SUCCESS;
}
#
sub create_services
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        $plog->log_msg("Creating server onection for %s ...\n", $service);
        #
        my $pservice = $pservices->get($service);
        if ( ! defined($pservice))
        {
            $plog->log_err("Service %s not found.\n", $service);
            return FAIL;
        }
        #
        if (create_socket_stream($pservice) != SUCCESS)
        {
            $plog->log_err("Failed to create server socket/pipe for %s\n", $service);
            return FAIL;
        }
        #
        my $pfh = $pservice->{'fh'};
        my $fileno = fileno($$pfh);
        $plog->log_msg("Successfully create server socket/pipe for %s (%d)\n", 
                       $service, $fileno);
        $pfh_services->set($fileno, $pservice);
        $pfh_data->reallocate($fileno);
    }
    #
    return SUCCESS;
}
#
################################################################
#
# real-time events loop
#
sub set_io_nonblock
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        fcntl($$pfh, F_SETFL, O_NONBLOCK);
    }
}
#
sub start_timer
{
    my ($fileno, $delta, $label) = @_;
    #
    my $timerid = int(rand(1000000000));
    #
    if ($delta <= 0)
    {
        $plog->log_err("Timer length is zero for %s. Skipping it.\n", $fileno);
        return;
    }
    #
    $plog->log_vmin("starttimer: " .
                    "fileno=${fileno} " .
                    "label=${label} " .
                    "delta=${delta} " .
                    "id=$timerid ");
    #
    my $ptimer = mytimer->new($fileno, $delta, $timerid, $label);
    #
    $plog->log_vmin("fileno = $ptimer->{fileno} " .
                    "delta = $ptimer->{delta} " .
                    "expire = $ptimer->{expire} " .
                    "id = $ptimer->{id} " .
                    "label = $ptimer->{label} ");
    #
    $pq->enqueue($ptimer);
}
#
sub run_event_loop
{
    #
    # mark all file handles as non-blocking
    #
    set_io_nonblock();
    #
    my $psit = $pservices->iterator();
    while (defined(my $service = $psit->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        vec($rin, fileno($$pfh), 1) = 1;
    }
    #
    # enter event loop
    #
    my $sanity_time = 5;
    #
    $plog->log_msg("Start event loop ...\n");
    #
    my $mydelta = 0;
    my $start_time = time();
    my $current_time = $start_time;
    my $previous_time = 0;
    #
    while ($event_loop_done == FALSE)
    {
        #
        # save current time as the last time we did anything.
        #
        $previous_time = $current_time;
        #
        if ($pq->is_empty())
        {
            start_timer(fileno(STDIN),
                        $sanity_time, 
                        "sanity-timer");
        }
        #
        my $ptimer = undef;
        die "Empty timer queue: $!" unless ($pq->front(\$ptimer) == 1);
        #
        $mydelta = $ptimer->{expire} - $current_time;
        $mydelta = 0 if ($mydelta < 0);
        #
        my ($nf, $timeleft) = select($rout=$rin, 
                                     $wout=$win, 
                                     $eout=$ein, 
                                     $mydelta);
        #
        # update current timers
        #
        $current_time = time();
        #
        if ($timeleft <= 0)
        {
            $plog->log_vmid("Time expired ...\n");
            #
            $ptimer = undef;
            while ($pq->dequeue(\$ptimer) != 0)
            {
                if ($ptimer->{expire} > $current_time)
                {
                    $pq->enqueue($ptimer);
                    last;
                }
                #
                my $fileno = $ptimer->{fileno};
                my $pservice = $pfh_services->get($fileno);
                #
                &{$pservice->{timer_handler}}($ptimer, $pservice);
                $ptimer = undef;
            }
        }
        elsif ($nf > 0)
        {
            $plog->log_vmid("NF, TIMELEFT ... (%d,%d)\n", $nf, $timeleft);
            my $pfhit = $pfh_services->iterator();
            while (defined(my $fileno = $pfhit->()))
            {
                my $pfh = $pfh_services->get($fileno, 'fh');
                my $pservice = $pfh_services->get($fileno);
                #
                if (vec($eout, $fileno, 1))
                {
                    #
                    # EOF or some error
                    #
                    vec($rin, $fileno, 1) = 0;
                    vec($ein, $fileno, 1) = 0;
                    vec($win, $fileno, 1) = 0;
                    #
                    close($$pfh);
                    #
                    $plog->log_msg("closing socket (%d) for service %s ...\n", 
                                   $fileno,
                                   $pservice->{name});
                    $pfh_services->deallocate($fileno);
                }
                elsif (vec($rout, $fileno, 1))
                {
                    #
                    # ready for a read
                    #
                    $plog->log_vmid("input available for %s ...\n", $pservice->{name});
                    #
                    # call handler
                    #
                    &{$pservice->{io_handler}}($pservice);
                }
            }             
        }
    }
    #
    $plog->log_msg("Event-loop done ...\n");
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
if (getopts('?hwWv:l:', \%opts) != 1)
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
}
#
# check if config file was given.
#
if (scalar(@ARGV) == 0)
{
    #
    # use default config file.
    #
    $plog->log_msg("Using default config file: %s\n", $default_cfg_file);
    if (read_cfg_file($default_cfg_file) != SUCCESS)
    {
        $plog->log_err_exit("read_cfg_file failed. Done.\n");
    }
}
else
{
    #
    # read in config files and start up services.
    #
    foreach my $cfg_file (@ARGV)
    {
        $plog->log_msg("Reading config file %s ...\n", $cfg_file);
        if (read_cfg_file($cfg_file) != SUCCESS)
        {
            $plog->log_err_exit("read_cfg_file failed. Done.\n");
        }
    }
}
#
# create server sockets or pipes as needed.
#
if (create_services() != SUCCESS)
{
    $plog->log_err_exit("create_server_connections failed. Done.\n");
}
#
# monitor stdin for i/o with user.
#
add_stdin_to_services();
#
# event loop to handle connections, etc.
#
if (run_event_loop() != SUCCESS)
{
    $plog->log_err_exit("run_event_loop failed. Done.\n");
}
#
$plog->log_msg("All is well that ends well.\n");
#
exit 0;


__DATA__

#!/usr/bin/perl -w
#
################################################################
#
# generic server for stream/datagram and socket/unix.
#
################################################################
#
use strict;
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
# perl mods
#
use Getopt::Std;
use Socket;
use FileHandle;
use POSIX qw(:errno_h);
#
# my mods
#
use lib $binpath;
#
use myconstants;
use mylogger;
use mytimer;
use mytimerpqueue;
use mytaskdata;
use mylnbxml;
#
################################################################
#
# local constants
#
use constant SOCKET_STREAM => 'SOCKET_STREAM';
use constant SOCKET_DATAGRAM => 'SOCKET_DATAGRAM';
use constant UNIX_STREAM => 'UNIX_STREAM';
use constant UNIX_DATAGRAM => 'UNIX_DATAGRAM';
use constant TTY_STREAM => 'TTY_STREAM';
#
use constant SOH => 1;
use constant STX => 2;
use constant ETX => 3;
#
################################################################
#
# globals
#
my $cmd = $0;
my $default_cfg_file = "generic-server.cfg";
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $pq = mytimerpqueue->new();
die "Unable to create priority queue: $!" unless (defined($pq));
#
# default service values
#
my %default_service_params =
(
    name => {
        use_default => FALSE(),
        default_value => "",
        translate => undef,
    },
    type => {
        use_default => TRUE(),
        default_value => SOCKET_STREAM(),
        translate => \&to_uc,
    },
    host_name => {
        use_default => TRUE(),
        default_value => "localhost",
        translate => undef,
    },
    file_name => {
        use_default => TRUE(),
        default_value => "",
        translate => undef,
    },
    port => {
        use_default => TRUE(),
        default_value => -1,
        translate => undef,
    },
    service => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    client => {
        use_default => TRUE(),
        default_value => FALSE(),
        translate => undef,
    },
    io_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    service_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    timer_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    ctor => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    client_io_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    client_service_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    client_timer_handler => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
    client_ctor => {
        use_default => TRUE(),
        default_value => undef,
        translate => undef,
    },
);
#
# vectors for select()
#
my $rin = '';
my $win = '';
my $ein = '';
#
my $rout = '';
my $wout = '';
my $eout = '';
#
# map connection type to create connection routine
#
my %create_connection =
(
    SOCKET_STREAM() => \&create_socket_stream,
    SOCKET_DATAGRAM() => \&create_socket_dgram,
    UNIX_STREAM() => \&create_unix_stream,
    UNIX_DATAGRAM() => \&create_unix_dgram,
    TTY_STREAM() => undef
);
#
# private data for each service instance
#
my $pservices = mytaskdata->new();
die "Unable to create services data: $!" 
    unless (defined($pservices));
#
my $pfh_services = mytaskdata->new();
die "Unable to create file-handler-to-services data: $!" 
    unless (defined($pfh_services));
#
my $pfh_data = mytaskdata->new();
die "Unable to create task-specific data: $!" 
    unless (defined($pfh_data));
#
# misc
#
my $event_loop_done = FALSE;
#
################################################################
#
# misc functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [config-file [config-file2 ...]]

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path

config-file is the configuration file containing lists of
services to create. one or more config files can be given.
if a config file is not given, then the default is to look
for the file generic-server.cfg in the current directory.

EOF
}
#
################################################################
#
# read and parse data files.
#
sub read_file
{
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        $plog->log_err("File %s is NOT readable\n", $file_nm);
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        $plog->log_err("Unable to open %s.\n", $file_nm);
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    #
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    $plog->log_vmin("Lines read: %d\n", scalar(@{$praw_data}));
    return SUCCESS;
}
#
sub fill_in_missing_data
{
    my ($pservice) = @_;
    #
    foreach my $key (keys %default_service_params)
    {
        if (( ! exists($pservice->{$key})) &&
            ($default_service_params{$key}{use_default} == TRUE))
        {
            $plog->log_vmin("Defaulting missing %s field.\n", $key);
            $pservice->{$key} = $default_service_params{$key}{default_value};
        }
    }
}
#
sub to_uc
{
    my ($in) = @_;
    return uc($in);
}
#
sub parse_file
{
    my ($pdata) = @_;
    #
    my $lnno = 0;
    my $pservice = { };
    #
    foreach my $record (@{$pdata})
    {
        $plog->log_vmin("Processing record (%d) : %s\n", ++$lnno, $record);
        #
        if (($record =~ m/^\s*#/) || ($record =~ m/^\s*$/))
        {
            # skip comments or white-space-only lines
            next;
        }
        elsif ($record =~ m/^\s*service\s*start\s*$/)
        {
            $pservice = { };
        }
        elsif ($record =~ m/^\s*service\s*end\s*$/)
        {
            if ((exists($pservice->{name})) &&
                ($pservice->{name} ne ""))
            {
                my $name = $pservice->{name};
                #
                $plog->log_msg("Storing service: %s\n", $name);
                #
                die "ERROR: duplicate service $name: $!" 
                    if ($pservices->exists($name) == TRUE);
                #
                fill_in_missing_data($pservice);
                $pservices->set($name, $pservice);
            }
            else
            {
                $plog->log_err("Unknown service name (%d).\n", $lnno);
                return FAIL;
            }
            #
            $pservice = { };
        }
        else
        {
            my $found = FALSE;
            foreach my $key (keys %default_service_params)
            {
                if ($record =~ m/^\s*${key}\s*=\s*(.*)$/i)
                {
                    $plog->log_vmin("Setting %s to %s (%d)\n", $key, ${1}, $lnno);
                    if (defined($default_service_params{$key}{translate}))
                    {
                        # massage the data value
                        $pservice->{$key} = 
                            &{$default_service_params{$key}{translate}}(${1});
                    }
                    else
                    {
                        $pservice->{$key} = ${1};
                    }
                    $found = TRUE;
                    last;
                }
            }
            if ($found == FALSE)
            {
                $plog->log_err_exit("Unknown record %d: %s\n", $lnno, $record);
            }
        }
    }
    #
    return SUCCESS;
}
#
sub read_cfg_file
{
    my ($cfgfile) = @_;
    #
    my @data = ();
    if ((read_file($cfgfile, \@data) == SUCCESS) &&
	(parse_file(\@data) == SUCCESS))
    {
        $plog->log_vmin("Successfully processed cfg file %s.\n", $cfgfile);
        return SUCCESS;
    }
    else
    {
        $plog->log_err("Processing cfg file %s failed.\n", $cfgfile);
        return FAIL;
    }
}
#
################################################################
#
# default timer, io and service handlers
#
sub null_timer_handler
{
    my ($ptimer, $pservice) = @_;
    #
    $plog->log_vmin("null timer handler ... %s\n", $ptimer->{label});
}
#
sub stdin_timer_handler
{
    my ($ptimer, $pservice) = @_;
    #
    $plog->log_vmin("sanity timer handler ... %s\n", $ptimer->{label});
    #
    start_timer($ptimer->{fileno},
                $ptimer->{delta},
                $ptimer->{label});
}
#
sub stdin_handler
{
    my ($pservice) = @_;
    #
    my $data = <STDIN>;
    chomp($data);
    #
    if (defined($data))
    {
        $plog->log_msg("input ... <%s>\n", $data);
        if ($data =~ m/^q$/i)
        {
            $event_loop_done = TRUE;
        }
        elsif (($data =~ m/^[h?]$/i) ||
               ($data eq ""))
        {
            my $log_fh = $plog->log_fh();
            print $log_fh <<EOF;
Available commnds:
    q - quit
    ? - help
    h - help
    l - list services
    s - print services
    lc - list clients
    cc <fileno> - close client
    t - print timers
EOF
        }
        elsif ($data =~ m/^s$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                $plog->log_msg("FileNo: %d, Service: %s\n", 
                               $fileno,
                               $pservice->{name});
                if ((defined($pservice->{port})) &&
                    ($pservice->{port} > 0))
                    
                {
                    $plog->log_msg("FileNo: %d, Port: %s\n", 
                               $fileno,
                               $pservice->{port});
                }
                if ((defined($pservice->{file_name})) &&
                    ($pservice->{file_name} ne ""))
                {
                    $plog->log_msg("FileNo: %d, File Name: %s\n", 
                               $fileno,
                               $pservice->{file_name});
                }
            }             
        }
        elsif ($data =~ m/^l$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                $plog->log_msg("FileNo: %d, Service: %s\n", 
                               $fileno,
                               $pservice->{name});
            }             
        }
        elsif ($data =~ m/^lc$/i)
        {
            my $pfhit = $pfh_services->iterator('n');
            while (defined(my $fileno = $pfhit->()))
            {
                my $pservice = $pfh_services->get($fileno);
                if ((defined($pservice->{client})) &&
                    ($pservice->{client} == TRUE))
                {
                    $plog->log_msg("Client: FileNo: %d, Service: %s\n", 
                                   $fileno,
                                   $pservice->{name});
                }
            }             
        }
        elsif ($data =~ m/^cc\s*(\d+)\s*$/i)
        {
            my $fileno_to_close = $1;
            if (defined($fileno_to_close) && ($fileno_to_close >= 0))
            {
                my $pfhit = $pfh_services->iterator('n');
                while (defined(my $fileno = $pfhit->()))
                {
                    my $pservice = $pfh_services->get($fileno);
                    if ((defined($pservice->{client})) &&
                        ($pservice->{client} == TRUE) &&
                        ($fileno == $fileno_to_close))
                    {
                        $plog->log_msg("Closing Client: FileNo: %d, Service: %s\n", 
                                       $fileno,
                                       $pservice->{name});
                        vec($rin, $fileno, 1) = 0;
                        vec($ein, $fileno, 1) = 0;
                        vec($win, $fileno, 1) = 0;
                        #
                        my $pfh = $pservice->{fh};
                        close($$pfh);
                        #
                        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                                       $fileno,
                                       $pservice->{name});
                        $pfh_services->deallocate($fileno);
                        $pfh_data->deallocate($fileno);
                    }
                }             
            }
            else
            {
                $plog->log_msg("Invalid client file no.\n");
            }
        }
        elsif ($data =~ m/^t$/i)
        {
            $pq->dump();
        }
    }
}
#
sub generic_stream_io_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering generic_stream_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = 0;
    my $buffer = undef;
    while (defined($nr = sysread($$pfh, $buffer, 1024*4)) && ($nr > 0))
    {
        my $local_buffer = unpack("H*", $buffer);
        $plog->log_msg("nr ... <%d>\n", $nr);
        $plog->log_msg("buffer ... <%s>\n", $buffer);
        $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
        #
        $pfh_data->set($fileno, 'input', $buffer);
        $pfh_data->set($fileno, 'input_length', $nr);
        &{$pservice->{service_handler}}($pservice);
    }
    #
    if ((( ! defined($nr)) && ($! != EAGAIN)) ||
        (defined($nr) && ($nr == 0)))
    {
        #
        # EOF or some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
    }
}
#
sub generic_stream_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = $pfh_data->get($fileno, 'input_length');
    my $buffer = $pfh_data->get($fileno, 'input');
    #
    die $! if ( ! defined(send($$pfh, $buffer, $nr)));
}
#
sub generic_datagram_io_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering generic_datagram_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $recvpaddr = undef;
    my $buffer = undef;
    while (defined($recvpaddr = recv($$pfh, $buffer, 1024*4, 0)))
    {
        my $local_buffer = unpack("H*", $buffer);
        $plog->log_msg("buffer ... <%s>\n", $buffer);
        $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
        #
        $pfh_data->set($fileno, 'input', $buffer);
        $pfh_data->set($fileno, 'input_length', length($buffer));
        $pfh_data->set($fileno, 'recvpaddr', $recvpaddr);
        &{$pservice->{service_handler}}($pservice);
    }
    #
    if (( ! defined($recvpaddr)) && ($! != EAGAIN))
    {
        #
        # EOF or some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
    }
}
#
sub generic_datagram_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = $pfh_data->get($fileno, 'input_length');
    my $buffer = $pfh_data->get($fileno, 'input');
    my $recvpaddr = $pfh_data->get($fileno, 'recvpaddr');
    #
    die $! if ( ! defined(send($$pfh, $buffer, 0, $recvpaddr)));
}
#
sub socket_stream_accept_io_handler
{
    my ($pservice) = @_;
    #
    # do the accept
    #
    my $pfh = $pservice->{fh};
    # my $new_fh = FileHandle->new();
    my $new_fh = undef;
    if (my $client_paddr = accept($new_fh, $$pfh))
    {
        $plog->log_msg("accept() succeeded for service %s\n", $pservice->{name});
        #
        fcntl($new_fh, F_SETFL, O_NONBLOCK);
        #
        my ($client_port, $client_packed_ip) = sockaddr_in($client_paddr);
        my $client_ascii_ip = inet_ntoa($client_packed_ip);
        #
        vec($rin, fileno($new_fh), 1) = 1;
        vec($ein, fileno($new_fh), 1) = 1;
        #
        my $io_handler = undef;
        die "unknown client io handler: $!" 
            unless (exists($pservice->{client_io_handler}));
        $io_handler = $pservice->{client_io_handler};
        #
        my $service_handler = undef;
        die "unknown client service handler: $!" 
            unless (exists($pservice->{client_service_handler}));
        $service_handler = $pservice->{client_service_handler};
        #
        my $timer_handler = $pservice->{client_timer_handler};
        #
        my $pnew_service = 
        {
            client => TRUE(),
            name => "client_of_" . $pservice->{name},
            client_port => $client_port,
            client_host_name => $client_ascii_ip,
            client_paddr => $client_paddr,
            fh => \$new_fh,
            io_handler => $io_handler,
            service_handler => $service_handler,
            timer_handler => $timer_handler,
            total_buffer => "",
        };
        #
        my $fileno = fileno($new_fh);
        $pfh_services->set($fileno, $pnew_service);
        $pfh_data->reallocate($fileno);
        #
        # call ctor if it exists.
        #
        my $ctor = $pservice->{'ctor'};
        if (defined($ctor))
        {
            my $status = &{$ctor}($pnew_service);
        }
    }
    else
    {
        $plog->log_err("accept() failed for service %s\n", $pservice->{name});
    }
}
#
sub unix_stream_accept_io_handler
{
    my ($pservice) = @_;
    #
    # do the accept
    #
    my $pfh = $pservice->{fh};
    # my $new_fh = FileHandle->new();
    my $new_fh = undef;
    if (my $client_paddr = accept($new_fh, $$pfh))
    {
        $plog->log_msg("accept() succeeded for service %s\n", $pservice->{name});
        #
        fcntl($new_fh, F_SETFL, O_NONBLOCK);
        #
        my ($client_filename) = sockaddr_un($client_paddr);
        #
        vec($rin, fileno($new_fh), 1) = 1;
        vec($ein, fileno($new_fh), 1) = 1;
        #
        my $io_handler = undef;
        die "unknown client handler: $!" 
            unless (exists($pservice->{client_io_handler}));
        $io_handler = $pservice->{client_io_handler};
        #
        my $service_handler = undef;
        die "unknown client handler: $!" 
            unless (exists($pservice->{client_service_handler}));
        $service_handler = $pservice->{client_service_handler};
        #
        my $timer_handler = $pservice->{client_timer_handler};
        #
        my $pnew_service = 
        {
            client => TRUE(),
            name => "client_of_" . $pservice->{name},
            client_filename => $client_filename,
            client_paddr => $client_paddr,
            fh => \$new_fh,
            io_handler => $io_handler,
            service_handler => $service_handler,
            timer_handler => $timer_handler,
            total_buffer => "",
        };
        #
        my $fileno = fileno($new_fh);
        $pfh_services->set($fileno, $pnew_service);
        $pfh_data->reallocate($fileno);
        #
        # call ctor if it exists.
        #
        my $ctor = $pservice->{'ctor'};
        if (defined($ctor))
        {
            my $status = &{$ctor}($pnew_service);
        }
    }
    else
    {
        $plog->log_err("accept() failed for service %s\n", $pservice->{name});
    }
}
#
sub socket_stream_accept_service_handler
{
    my ($pservice) = @_;
}
#
sub unix_stream_accept_service_handler
{
    my ($pservice) = @_;
}
#
sub socket_stream_io_handler
{
    my ($pservice) = @_;
    generic_stream_io_handler($pservice);
}
#
sub socket_stream_service_handler
{
    my ($pservice) = @_;
    generic_stream_service_handler($pservice);
}
#
sub socket_datagram_io_handler
{
    my ($pservice) = @_;
    generic_datagram_io_handler($pservice);
}
#
sub socket_datagram_service_handler
{
    my ($pservice) = @_;
    generic_datagram_service_handler($pservice);
}
#
sub unix_stream_io_handler
{
    my ($pservice) = @_;
    generic_stream_io_handler($pservice);
}
#
sub unix_stream_service_handler
{
    my ($pservice) = @_;
    generic_stream_service_handler($pservice);
}
#
sub unix_datagram_io_handler
{
    my ($pservice) = @_;
    generic_datagram_io_handler($pservice);
}
#
sub unix_datagram_service_handler
{
    my ($pservice) = @_;
    generic_datagram_service_handler($pservice);
}
#
################################################################
#
# LNB-specific io, timer, and servers
#
sub lnb_io_handler
{
    my ($pservice) = @_;
    #
    $plog->log_msg("entering lnb_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = 0;
    my $buffer = undef;
    
    while (defined($nr = sysread($$pfh, $buffer, 1024*4)) && ($nr > 0))
    {
        $plog->log_msg("nr ... <%d>\n", $nr);
        $plog->log_msg("buffer ... <%s>\n", $buffer);
        #
        my $local_buffer = unpack("H*", $buffer);
        $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
        #
        if ($nr > 0)
        {
             my $total_buffer = $pfh_data->get($fileno, 'total_buffer');
             $total_buffer = $total_buffer . $buffer;
             my $tblen = length($total_buffer);
             my $sohi = -1;
             my $stxi = -1;
             my $etxi = -1;
             for (my $tbi = 0; $tbi < $tblen; $tbi += 1)
             {
                 my $ch = substr($total_buffer, $tbi, 1);
                 if ($ch =~ m/^\x01/)
                 {
                     $sohi = $tbi;
                     $stxi = -1;
                     $etxi = -1;
                 }
                 elsif ($ch =~ m/^\x02/)
                 {
                     $stxi = $tbi;
                 }
                 elsif ($ch =~ m/^\x03/)
                 {
                     $etxi = $tbi;
                 }
                 #
                 if (($stxi != -1) && ($etxi != -1))
                 {
                     my $xml_start = $stxi + 1;
                     my $xml_end = $etxi - 1;
                     my $xml_length = $xml_end - $xml_start + 1;
                     my $xml_buffer = substr($total_buffer, 
                                             $xml_start, 
                                             $xml_length);
                     #
                     $pfh_data->set($fileno, 'input', $xml_buffer);
                     $pfh_data->set($fileno, 'input_length', $xml_length);
                     #
                     &{$pservice->{service_handler}}($pservice);
                     #
                     $sohi = -1;
                     $stxi = -1;
                     $etxi = -1;
                 }
             }
             #
             # reset for partially read messages.
             #
             if ($sohi != -1)
             {
                 $total_buffer = substr($total_buffer, $sohi);
                 $pfh_data->set($fileno, 'total_buffer', $total_buffer);
             }
        }
    }
    #
    if ((( ! defined($nr)) && ($! != EAGAIN)) ||
        (defined($nr) && ($nr == 0)))
    {
        #
        # EOF or some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
    }
}
#
sub send_xml_msg
{
    my ($pservice, $xml) = @_;
    #
    my $pfh = $pservice->{fh};
    #
    my $buflen = sprintf("%06d", length($xml));
    #
    # c  ==>> SOH
    # A* ==>> XML length
    # c  ==>> STX
    # A* ==>> XML
    # c  ==>> ETX
    #
    my $buf = pack("cA*cA*c", SOH, $buflen, STX, $xml, ETX);
    #
    # len(SOH) + len(xml_length) + len(STX) + len(xml) + len(ETX)
    #
    my $nw = 1 + 6 + 1 + length($xml) + 1;
    #
    my $local_buf = unpack("H*", $buf);
    $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buf);
    #
    # handle partial writes.
    #
    # die $! if ( ! defined(send($$pfh, $buf, $nw)));
    for (my $ntow=$nw; 
         ($ntow > 0) &&
         defined($nw = send($$pfh, $buf, $ntow));
         $ntow -= $nw) { }
    die $! if ( ! defined($nw) );
}
#
sub lnbcvthost_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
    }
    #
    $pxml = undef;
}
#
sub lnblmhost_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
    }
    #
    $pxml = undef;
}
#
sub lnbmihost_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
    }
    #
    $pxml = undef;
}
#
sub lnbspcvthost_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
    }
    #
    $pxml = undef;
}
#
sub lnbspmihost_service_handler
{
    my ($pservice) = @_;
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = mylnbxml->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
    }
    #
    $pxml = undef;
}
#
sub lnbcvthost_timer_handler
{
    my ($pservice) = @_;
}
#
sub lnblmhost_timer_handler
{
    my ($pservice) = @_;
}
#
sub lnbmihost_timer_handler
{
    my ($pservice) = @_;
}
#
sub lnbspcvthost_timer_handler
{
    my ($pservice) = @_;
}
#
sub lnbspmihost_timer_handler
{
    my ($pservice) = @_;
}
#
################################################################
#
# create services
#
sub function_defined
{
    my ($func_name) = @_;
    if (defined(&{$func_name}))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub add_stdin_to_services
{
    my $fno = fileno(STDIN);
    #
    $pfh_services->set($fno, {
        name => "STDIN",
        type => TTY_STREAM(),
        io_handler => \&stdin_handler,
        timer_handler => \&stdin_timer_handler,
    });
    #
    $pfh_data->reallocate($fno);
    #
    $plog->log_msg("Adding STDIN service ...\n");
    $plog->log_msg("name ... %s type ... %s\n", 
                  $pfh_services->get($fno, 'name'),
                  $pfh_services->get($fno, 'type'));
    #
    vec($rin, fileno(STDIN), 1) = 1;
}
#
sub get_handler
{
    my ($handler) = @_;
    #
    if (function_defined($handler) == TRUE)
    {
        # turn off strict so we can convert name to function.
        no strict 'refs';
        return \&{$handler};
    }
    else
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return undef
    }
}
#
sub create_socket_stream
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating stream socket for %s.\n", $pservice->{name});
    #
    # my $fh = FileHandle->new;
    my $fh = undef;
    socket($fh, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    $plog->log_msg("calling gethostbyname($pservice->{host_name})\n");
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $port = undef;
    if (exists($pservice->{service}) && 
        defined($pservice->{service}))
    {
        # get port from services file
        $port = getservbyname($pservice->{service}, 'tcp') or
            die "Can't get port for service $pservice->{service}: $!";
        $plog->log_msg("getservbyname($pservice->{service}, 'tcp') port = $port\n");
        $pservice->{port} = $port;
    }
    else
    {
        $port = $pservice->{port};
        $plog->log_msg("config file port = $port\n");
    }
    my $paddr = sockaddr_in($port, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind error for $pservice->{name}: $!";
    listen($fh, SOMAXCONN) or die "listen: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for required handlers
    #
    my $handler = $pservice->{io_handler};
    $pservice->{io_handler} = get_handler($handler);
    if ( ! defined($pservice->{io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{service_handler};
    $pservice->{service_handler} = get_handler($handler);
    if ( ! defined($pservice->{service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{client_io_handler};
    $pservice->{client_io_handler} = get_handler($handler);
    if ( ! defined($pservice->{client_io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{client_service_handler};
    $pservice->{client_service_handler} = get_handler($handler);
    if ( ! defined($pservice->{client_service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    # check for optional handlers
    #
    $handler = $pservice->{timer_handler};
    if (defined($handler))
    {
        $pservice->{timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{ctor};
    if (defined($handler))
    {
        $pservice->{ctor} = get_handler($handler);
        if ( ! defined($pservice->{ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{client_timer_handler};
    if (defined($handler))
    {
        $pservice->{client_timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{client_timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{client_ctor};
    if (defined($handler))
    {
        $pservice->{client_ctor} = get_handler($handler);
        if ( ! defined($pservice->{client_ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    return SUCCESS;
}
#
sub create_socket_dgram
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating dgram socket for %s.\n", $pservice->{name});
    #
    # my $fh = FileHandle->new;
    my $fh = undef;
    socket($fh, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $port = undef;
    if (exists($pservice->{service}) && 
        defined($pservice->{service}))
    {
        # get port from services file
        $port = getservbyname($pservice->{service}, 'udp') or
            die "Can't get port for service $pservice->{service}: $!";
        $plog->log_msg("getservbyname($pservice->{service}, 'udp') port = $port\n");
    }
    else
    {
        $port = $pservice->{port};
        $plog->log_msg("config file port = $port\n");
    }
    my $paddr = sockaddr_in($port, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for required handlers
    #
    my $handler = $pservice->{io_handler};
    $pservice->{io_handler} = get_handler($handler);
    if ( ! defined($pservice->{io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{service_handler};
    $pservice->{service_handler} = get_handler($handler);
    if ( ! defined($pservice->{service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    # check for optional handlers
    #
    $handler = $pservice->{timer_handler};
    if (defined($handler))
    {
        $pservice->{timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{ctor};
    if (defined($handler))
    {
        $pservice->{ctor} = get_handler($handler);
        if ( ! defined($pservice->{ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    return SUCCESS;
}
#
sub create_unix_stream
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating stream unix pipe for %s.\n", $pservice->{name});
    #
    # my $fh = FileHandle->new;
    my $fh = undef;
    socket($fh, PF_UNIX, SOCK_STREAM, 0);
    #
    unlink($pservice->{file_name});
    #
    $plog->log_msg("unix stream file = %s\n", $pservice->{file_name});
    my $paddr = sockaddr_un($pservice->{file_name});
    defined($paddr) or die "sockaddr_un: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    listen($fh, SOMAXCONN) or die "listen: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for required handlers
    #
    my $handler = $pservice->{io_handler};
    $pservice->{io_handler} = get_handler($handler);
    if ( ! defined($pservice->{io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{service_handler};
    $pservice->{service_handler} = get_handler($handler);
    if ( ! defined($pservice->{service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{client_io_handler};
    $pservice->{client_io_handler} = get_handler($handler);
    if ( ! defined($pservice->{client_io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{client_service_handler};
    $pservice->{client_service_handler} = get_handler($handler);
    if ( ! defined($pservice->{client_service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    # check for optional handlers
    #
    $handler = $pservice->{timer_handler};
    if (defined($handler))
    {
        $pservice->{timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{ctor};
    if (defined($handler))
    {
        $pservice->{ctor} = get_handler($handler);
        if ( ! defined($pservice->{ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{client_timer_handler};
    if (defined($handler))
    {
        $pservice->{client_timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{client_timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{client_ctor};
    if (defined($handler))
    {
        $pservice->{client_ctor} = get_handler($handler);
        if ( ! defined($pservice->{client_ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    return SUCCESS;
}
#
sub create_unix_dgram
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating dgram unix pipe for %s.\n", $pservice->{name});
    #
    # my $fh = FileHandle->new;
    my $fh = undef;
    socket($fh, PF_UNIX, SOCK_DGRAM, 0);
    #
    unlink($pservice->{file_name});
    #
    $plog->log_msg("unix datagram file = %s\n", $pservice->{file_name});
    my $paddr = sockaddr_un($pservice->{file_name});
    defined($paddr) or die "sockaddr_un: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for required handlers
    #
    my $handler = $pservice->{io_handler};
    $pservice->{io_handler} = get_handler($handler);
    if ( ! defined($pservice->{io_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    $handler = $pservice->{service_handler};
    $pservice->{service_handler} = get_handler($handler);
    if ( ! defined($pservice->{service_handler}))
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return FALSE;
    }
    #
    # check for optional handlers
    #
    $handler = $pservice->{timer_handler};
    if (defined($handler))
    {
        $pservice->{timer_handler} = get_handler($handler);
        if ( ! defined($pservice->{timer_handler}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    $handler = $pservice->{ctor};
    if (defined($handler))
    {
        $pservice->{ctor} = get_handler($handler);
        if ( ! defined($pservice->{ctor}))
        {
            $plog->log_err("Function %s does NOT EXIST.\n", $handler);
            return FALSE;
        }
    }
    #
    return SUCCESS;
}
#
sub create_server_connections
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        $plog->log_msg("Creating server conection for %s ...\n", $service);
        #
        my $type = $pservices->get($service, 'type');
        die "ERROR: connection type $type is unknown: $!" 
            unless (exists($create_connection{$type}));
        my $status = &{$create_connection{$type}}($pservices->get($service));
        if ($status == SUCCESS)
        {
            my $pfh = $pservices->get($service, 'fh');
            my $fileno = fileno($$pfh);
            $plog->log_msg("Successfully create server socket/pipe for %s (%d)\n", 
                           $service, $fileno);
            $pfh_services->set($fileno, $pservices->get($service));
            $pfh_data->reallocate($fileno);
            #
            # call ctor if it exists.
            #
            my $ctor = $pservices->get($service, 'ctor');
            if (defined($ctor))
            {
                $status = &{$ctor}($pservices->get($service));
            }
        }
        else
        {
            $plog->log_err("Failed to create server socket/pipe for %s\n", $service);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
################################################################
#
# event loop for timers and i/o (via select)
#
sub set_io_nonblock
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        fcntl($$pfh, F_SETFL, O_NONBLOCK);
    }
}
#
sub start_timer
{
    my ($fileno, $delta, $label) = @_;
    #
    my $timerid = int(rand(1000000000));
    #
    if ($delta <= 0)
    {
        $plog->log_err("Timer length is zero for %s. Skipping it.\n", $fileno);
        return;
    }
    #
    $plog->log_vmin("starttimer: " .
                    "fileno=${fileno} " .
                    "label=${label} " .
                    "delta=${delta} " .
                    "id=$timerid ");
    #
    my $ptimer = mytimer->new($fileno, $delta, $timerid, $label);
    #
    $plog->log_vmin("fileno = $ptimer->{fileno} " .
                    "delta = $ptimer->{delta} " .
                    "expire = $ptimer->{expire} " .
                    "id = $ptimer->{id} " .
                    "label = $ptimer->{label} ");
    #
    $pq->enqueue($ptimer);
}
#
sub run_event_loop
{
    #
    # mark all file handles as non-blocking
    #
    set_io_nonblock();
    #
    my $psit = $pservices->iterator();
    while (defined(my $service = $psit->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        vec($rin, fileno($$pfh), 1) = 1;
    }
    #
    # enter event loop
    #
    my $sanity_time = 5;
    #
    $plog->log_msg("Start event loop ...\n");
    #
    my $mydelta = 0;
    my $start_time = time();
    my $current_time = $start_time;
    my $previous_time = 0;
    #
    while ($event_loop_done == FALSE)
    {
        #
        # save current time as the last time we did anything.
        #
        $previous_time = $current_time;
        #
        if ($pq->is_empty())
        {
            start_timer(fileno(STDIN),
                        $sanity_time, 
                        "sanity-timer");
        }
        #
        my $ptimer = undef;
        die "Empty timer queue: $!" unless ($pq->front(\$ptimer) == 1);
        #
        $mydelta = $ptimer->{expire} - $current_time;
        $mydelta = 0 if ($mydelta < 0);
        #
        my ($nf, $timeleft) = select($rout=$rin, 
                                     $wout=$win, 
                                     $eout=$ein, 
                                     $mydelta);
        #
        # update current timers
        #
        $current_time = time();
        #
        if ($timeleft <= 0)
        {
            $plog->log_vmin("Time expired ...\n");
            #
            $ptimer = undef;
            while ($pq->dequeue(\$ptimer) != 0)
            {
                if ($ptimer->{expire} > $current_time)
                {
                    $pq->enqueue($ptimer);
                    last;
                }
                #
                my $fileno = $ptimer->{fileno};
                my $pservice = $pfh_services->get($fileno);
                #
                &{$pservice->{timer_handler}}($ptimer, $pservice);
                $ptimer = undef;
            }
        }
        elsif ($nf > 0)
        {
            $plog->log_msg("NF, TIMELEFT ... (%d,%d)\n", $nf, $timeleft);
            my $pfhit = $pfh_services->iterator();
            while (defined(my $fileno = $pfhit->()))
            {
                my $pfh = $pfh_services->get($fileno, 'fh');
                my $pservice = $pfh_services->get($fileno);
                #
                if (vec($eout, $fileno, 1))
                {
                    #
                    # EOF or some error
                    #
                    vec($rin, $fileno, 1) = 0;
                    vec($ein, $fileno, 1) = 0;
                    vec($win, $fileno, 1) = 0;
                    #
                    close($$pfh);
                    #
                    $plog->log_msg("closing socket (%d) for service %s ...\n", 
                                   $fileno,
                                   $pservice->{name});
                    $pfh_services->deallocate($fileno);
                }
                elsif (vec($rout, $fileno, 1))
                {
                    #
                    # ready for a read
                    #
                    $plog->log_msg("input available for %s ...\n", $pservice->{name});
                    #
                    # call handler
                    #
                    &{$pservice->{io_handler}}($pservice);
                }
            }             
        }
    }
    #
    $plog->log_msg("Event-loop done ...\n");
    return SUCCESS;
}
#
################################################################
#
# start execution
#
$plog->disable_stdout_buffering();
#
my %opts;
if (getopts('?hwWv:l:', \%opts) != 1)
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
}
#
# check if config file was given.
#
if (scalar(@ARGV) == 0)
{
    #
    # use default config file.
    #
    $plog->log_msg("Using default config file: %s\n", $default_cfg_file);
    if (read_cfg_file($default_cfg_file) != SUCCESS)
    {
        $plog->log_err_exit("read_cfg_file failed. Done.\n");
    }
}
else
{
    #
    # read in config files and start up services.
    #
    foreach my $cfg_file (@ARGV)
    {
        $plog->log_msg("Reading config file %s ...\n", $cfg_file);
        if (read_cfg_file($cfg_file) != SUCCESS)
        {
            $plog->log_err_exit("read_cfg_file failed. Done.\n");
        }
    }
}
#
# create server sockets or pipes as needed.
#
if (create_server_connections() != SUCCESS)
{
    $plog->log_err_exit("create_server_connections failed. Done.\n");
}
#
# monitor stdin for i/o with user.
#
add_stdin_to_services();
#
# event loop to handle connections, etc.
#
if (run_event_loop() != SUCCESS)
{
    $plog->log_err_exit("run_event_loop failed. Done.\n");
}
#
$plog->log_msg("All is well that ends well.\n");
#
exit 0;

__DATA__


#!/usr/bin/perl -w
#
use strict;
#
use Data::Dumper;
#
my $log_fh = *STDOUT;
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
use constant FALSE => 0;
use constant TRUE => 1;
#
my $verbose = NOVERBOSE;
#
my $pmsg = 
{
	root => {
		Header => {
			SystemName => 'OTHERSYSTEM',
			SystemVersion => 1.00,
			SessionId => 58628,
			CommandName => 'ProgramDataSend'
		},
		ProgramDataSend => {
			Element => [
				{
					Date => '2017/03/23,00:00:45',
					MCNo => 1,
					Stage => 1,
					Lane => 1,
					MjsFileName => 'CO3',
					MjsGroupName => '1',
					LotName => 'NPMW-C1',
					LotNumber => 1,
					LotName2 => '',
					LotNumber2 => 0,
					Rev => 1
				},
				{
					Date => '2017/03/23,00:00:45',
					MCNo => 2,
					Stage => 1,
					Lane => 1,
					MjsFileName => 'CO3',
					MjsGroupName => '1',
					LotName => 'NPMW-C1',
					LotNumber => 1,
					LotName2 => '',
					LotNumber2 => 0,
					Rev => 1
				},
			]
		},
	},
};
#
sub pretty_print {
    my $var;
    foreach $var (@_) {
        my $level = -1;
        my %already_seen = ();
        if (ref ($var)) {
            print_ref(\%already_seen, \$level, $var);
        } else {
            print_scalar(\%already_seen, \$level, $var);
        }
    }
}

sub print_scalar {
    my $palready_seen = shift;
    my $plevel = shift;
    ++$$plevel;
    my $var = shift;
    print_indented($palready_seen, $plevel, $var);
    --$$plevel;
}

sub print_ref {
    my $palready_seen = shift;
    my $plevel = shift;
    my $r = shift;
    if (exists ($palready_seen->{$r})) {
        print_indented($palready_seen, $plevel, "$r (Seen earlier)");
        return;
    } else {
        $palready_seen->{$r}=1;
    }
    my $ref_type = ref($r);
    if ($ref_type eq "ARRAY") {
        print_array($palready_seen, $plevel, $r);
    } elsif ($ref_type eq "SCALAR") {
        print "Ref -> $r";
        print_scalar($palready_seen, $plevel, $$r);
    } elsif ($ref_type eq "HASH") {
        print_hash($palready_seen, $plevel, $r);
    } elsif ($ref_type eq "REF") {
        ++$$plevel;
        print_indented($palready_seen, $plevel, "Ref -> ($r)");
        print_ref($palready_seen, $plevel, $$r);
        --$$plevel;
    } else {
        print_indented($palready_seen, $plevel, "$ref_type (not supported)");
    }
}

sub print_array {
    my $palready_seen = shift;
    my $plevel = shift;
    my ($r_array) = @_;
    ++$$plevel;
    print_indented($palready_seen, $plevel, "[ # $r_array");
    foreach my $var (@$r_array) {
        if (ref ($var)) {
            print_ref($palready_seen, $plevel, $var);
        } else {
            print_scalar($palready_seen, $plevel, $var);
        }
    }
    print_indented($palready_seen, $plevel, "]");
    --$$plevel;
}

sub print_hash {
    my $palready_seen = shift;
    my $plevel = shift;
    my($r_hash) = @_;
    my($key, $val);
    ++$$plevel; 
    print_indented($palready_seen, $plevel, "{ # $r_hash");
    while (($key, $val) = each %$r_hash) {
        $val = ($val ? $val : '""');
        ++$$plevel;
        if (ref ($val)) {
            print_indented($palready_seen, $plevel, "$key => ");
            print_ref($palready_seen, $plevel, $val);
        } else {
            print_indented($palready_seen, $plevel, "$key => $val");
        }
        --$$plevel;
    }
    print_indented($palready_seen, $plevel, "}");
    --$$plevel;
}

sub print_indented {
    my $palready_seen = shift;
    my $plevel = shift;
    my $spaces = ":  " x $$plevel;
    print "${spaces}$_[0]\n";
}
#
sub to_xml
{
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "<$last_element>" if ($i > 0);
            to_xml($ptree->[$i], $pxml, $last_element);
            $$pxml .= "</$last_element>" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            $$pxml .= "<$element>";
            to_xml($ptree->{$element}, $pxml, $element);
            $$pxml .= "</$element>";
        }
    }
    else
    {
            $$pxml .= "$ptree";
    }
}
#
sub msg_to_xml
{
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    to_xml($ptree, \$xml, $last_element);
    #
    return $xml;
}
#
sub accept_token
{
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                accept_token($ptokens, $pidx, __LINE__);
                #
                my $last_element = scalar(@{$proot})-1;
                $proot = $proot->[$last_element]->{SIBLINGS};
            }
            else
            {
                element_xml($ptokens, 
                            $pidx, 
                            $maxtoken, 
                            $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if (is_end_tag($tag_name, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                printf "%d; MISSING END TAG : <%s,%s>\n", 
                        __LINE__, $tag_name, $token;
                accept_token($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if (is_end_tag($first_start_tag, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                printf "%d: UNEXPECTED END TAG : <%s>\n", __LINE__, $token;
                accept_token($ptokens, $pidx, __LINE__);
            }
        }
        else
        {
            printf "%d: UNEXPECTED TOKEN : <%s>\n", __LINE__, $token;
            accept_token($ptokens, $pidx, __LINE__);
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
        accept_token($ptokens, $pidx, __LINE__);
        element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        printf "ERROR: NOT XML 1.0 DOC: <%s>\n", $token;
    }
    #
    return($proot);
}
#
sub xml_to_msg
{
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    printf $log_fh "\n%d: DEBUG - TOKENS: \n\t%s\n", 
               __LINE__, 
               join("\n\t", @tokens) if ($verbose >= MINVERBOSE);
    #
    start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
printf "\n%d: DUMPER Original msg = %s\n", __LINE__, Dumper($pmsg);
printf "\n%d: PP Original msg =\n", __LINE__; pretty_print($pmsg);
#
my $xml = msg_to_xml($pmsg);
printf "\n%d: XML msg = %s\n", __LINE__, $xml;
#
my $pmsg2 = xml_to_msg($xml);
printf "\n%d: DUMPER XML-converted msg = %s\n", __LINE__, Dumper($pmsg2);
printf "\n%d: XML-converted PP deparsed msg =\n", __LINE__; pretty_print($pmsg2);
#
exit 0;

__DATA__

#!/usr/bin/perl -w
#
use strict;
#
use Data::Dumper;
#
my $log_fh = *STDOUT;
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
my $verbose = NOVERBOSE;
#
my $pmsg = 
{
	root => {
		Header => {
			SystemName => 'OTHERSYSTEM',
			SystemVersion => 1.00,
			SessionId => 58628,
			CommandName => 'ProgramDataSend'
		},
		ProgramDataSend => {
			Element => [
				{
					Date => '2017/03/23,00:00:45',
					MCNo => 1,
					Stage => 1,
					Lane => 1,
					MjsFileName => 'CO3',
					MjsGroupName => '1',
					LotName => 'NPMW-C1',
					LotNumber => 1,
					LotName2 => '',
					LotNumber2 => 0,
					Rev => 1
				},
				{
					Date => '2017/03/23,00:00:45',
					MCNo => 2,
					Stage => 1,
					Lane => 1,
					MjsFileName => 'CO3',
					MjsGroupName => '1',
					LotName => 'NPMW-C1',
					LotNumber => 1,
					LotName2 => '',
					LotNumber2 => 0,
					Rev => 1
				},
			]
		},
	},
};
#
# my $pmsg2 = 
# {
#     root => [
#         {
#             Header => [
#                 { SystemName => 'OTHERSYSTEM' },
#                 { SystemVersion => 1.00 },
#                 { SessionId => 58628 },
#                 { CommandName => 'ProgramDataSend' }
#             ]
#         },
#         {
#             ProgramDataSend => [
#                 Element => [
#                     [
#                         { Data => '2017/03/23,00:00:45' },
#                         { MCNo => 1 },
#                         { Stage => 1 },
#                         { Lane => 1 },
#                         { MjsFileName => 'CO3' },
#                         { MjsGroupName => '1' },
#                         { LotName => 'NPMW-C1' },
#                         { LotNumber => 1 },
#                         { LotName2 => '' },
#                         { LotNumber2 => 0 },
#                         { Rev => 1 },
#                     ],
#                     [
#                         { Data => '2017/03/23,00:00:45' },
#                         { MCNo => 2 },
#                         { Stage => 1 },
#                         { Lane => 1 },
#                         { MjsFileName => 'CO3' },
#                         { MjsGroupName => '1' },
#                         { LotName => 'NPMW-C1' },
#                         { LotNumber => 1 },
#                         { LotName2 => '' },
#                         { LotNumber2 => 0 },
#                         { Rev => 1 },
#                     ],
#                 ],
#             ]
#         },
#     ],
# };
#
sub pretty_print {
    my $var;
    foreach $var (@_) {
        my $level = -1;
        my %already_seen = ();
        if (ref ($var)) {
            print_ref(\%already_seen, \$level, $var);
        } else {
            print_scalar(\%already_seen, \$level, $var);
        }
    }
}

sub print_scalar {
    my $palready_seen = shift;
    my $plevel = shift;
    ++$$plevel;
    my $var = shift;
    print_indented($palready_seen, $plevel, $var);
    --$$plevel;
}

sub print_ref {
    my $palready_seen = shift;
    my $plevel = shift;
    my $r = shift;
    if (exists ($palready_seen->{$r})) {
        print_indented($palready_seen, $plevel, "$r (Seen earlier)");
        return;
    } else {
        $palready_seen->{$r}=1;
    }
    my $ref_type = ref($r);
    if ($ref_type eq "ARRAY") {
        print_array($palready_seen, $plevel, $r);
    } elsif ($ref_type eq "SCALAR") {
        print "Ref -> $r";
        print_scalar($palready_seen, $plevel, $$r);
    } elsif ($ref_type eq "HASH") {
        print_hash($palready_seen, $plevel, $r);
    } elsif ($ref_type eq "REF") {
        ++$$plevel;
        print_indented($palready_seen, $plevel, "Ref -> ($r)");
        print_ref($palready_seen, $plevel, $$r);
        --$$plevel;
    } else {
        print_indented($palready_seen, $plevel, "$ref_type (not supported)");
    }
}

sub print_array {
    my $palready_seen = shift;
    my $plevel = shift;
    my ($r_array) = @_;
    ++$$plevel;
    print_indented($palready_seen, $plevel, "[ # $r_array");
    foreach my $var (@$r_array) {
        if (ref ($var)) {
            print_ref($palready_seen, $plevel, $var);
        } else {
            print_scalar($palready_seen, $plevel, $var);
        }
    }
    print_indented($palready_seen, $plevel, "]");
    --$$plevel;
}

sub print_hash {
    my $palready_seen = shift;
    my $plevel = shift;
    my($r_hash) = @_;
    my($key, $val);
    ++$$plevel; 
    print_indented($palready_seen, $plevel, "{ # $r_hash");
    while (($key, $val) = each %$r_hash) {
        $val = ($val ? $val : '""');
        ++$$plevel;
        if (ref ($val)) {
            print_indented($palready_seen, $plevel, "$key => ");
            print_ref($palready_seen, $plevel, $val);
        } else {
            print_indented($palready_seen, $plevel, "$key => $val");
        }
        --$$plevel;
    }
    print_indented($palready_seen, $plevel, "}");
    --$$plevel;
}

sub print_indented {
    my $palready_seen = shift;
    my $plevel = shift;
    my $spaces = ":  " x $$plevel;
    print "${spaces}$_[0]\n";
}
#
sub to_xml
{
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    if ($ref_type eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$ptree}); ++$i)
        {
            $$pxml .= " <$last_element> ";
            to_xml($ptree->[$i], $pxml, $last_element);
            $$pxml .= " </$last_element> ";
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            $$pxml .= " <$element> "
                unless (ref($ptree->{$element}) eq "ARRAY");
            to_xml($ptree->{$element}, $pxml, $element);
            $$pxml .= " </$element> "
                unless (ref($ptree->{$element}) eq "ARRAY");
        }
    }
    else
    {
            $$pxml .= " $ptree ";
    }
}
#
sub to_xml2
{
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "<$last_element>" if ($i > 0);
            to_xml2($ptree->[$i], $pxml, $last_element);
            $$pxml .= "</$last_element>" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            $$pxml .= "<$element>";
            to_xml2($ptree->{$element}, $pxml, $element);
            $$pxml .= "</$element>";
        }
    }
    else
    {
            $$pxml .= "$ptree";
    }
}
#
sub convert_to_xml
{
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    to_xml($ptree, \$xml, $last_element);
    #
    return $xml;
}
#
sub convert_to_xml2
{
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    to_xml2($ptree, \$xml, $last_element);
    #
    return $xml;
}
#
printf "\n%d: DUMPER msg = %s\n", __LINE__, Dumper($pmsg);
# printf "\n%d: DUMPER msg2 = %s\n", __LINE__, Dumper($pmsg2);
#
printf "\n%d: PP msg =\n", __LINE__;
pretty_print($pmsg);
# printf "\n%d: PP msg2 =\n", __LINE__;
# pretty_print($pmsg2);
#
printf "\n%d: XML msg = %s\n", __LINE__, convert_to_xml($pmsg);
printf "\n%d: XML2 msg = %s\n", __LINE__, convert_to_xml2($pmsg);
# printf "\n%d: XML msg2 = %s\n", __LINE__, convert_to_xml($pmsg2);
#
exit 0;


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
# comparison types
#
use constant NOT_A_DATE => -2;
use constant BEFORE_WINDOW => -1;
use constant IN_WINDOW => 0;
use constant AFTER_WINDOW => +1;
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
my $print_raw_record = FALSE;
my $trace_msg_type = XML_MSGS;
my $use_private_parser = FALSE;
my $do_deparse_xml = FALSE;
my $start_date = "";
my $end_date = "";
my $last_date = "";
my $exit_upon_enddate = FALSE;
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
my %xml_tally = ( );
my %pm_tally = ( );
my %total_xml_tally = ( TOTAL_MSGS => 0 );
my %total_pm_tally = ( TOTAL_MSGS => 0 );
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
        [-t | -T] [-R] [-r] \\ 
        [-P xml|pm|all] [-p] [-d] \\
        [-S yyyymmddhhmmss] [-E yyyymmddhhmmss] [-x] \\
        [-X yyyymmddhhmmss] \\
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
    -r - print raw record as read from file.
    -P xml|pm|all - type of message to trace (XML=default).
    -p - use private parser, if available (only XML for now).
    -d - deparse, that is, generate XML from XML parse tree 
         generated by private parser (-p option).
    -S yyyymmddhhmmss - start date/time for parsing
    -E yyyymmddhhmmss - end date/time for parsing
    -x - exit when end date/time is exceeded.
    -X yyyymmddhhmmss - exact date/time for parsing

EOF
}
#
sub ftrace
{
    my @data = @_;
    #
    return if ($verbose < MAXVERBOSE);
    #
    if (scalar(@data) == 1)
    {
        printf $log_fh "\n%d: DEBUG TRACE\n", $data[0];
    }
    elsif (scalar(@data) == 2)
    {
        printf $log_fh "\n%d: DEBUG TRACE: %s\n", 
               $data[0], $data[1];
    }
}
#
sub tally_ho
{
    my ($ptally, $ptotals, $name) = @_;
    #
    if (exists($ptally->{$name}))
    {
        $ptally->{$name} += 1;
    }
    else
    {
        $ptally->{$name} = 1;
    }
    if (exists($ptotals->{$name}))
    {
        $ptotals->{$name} += 1;
    }
    else
    {
        $ptotals->{$name} = 1;
    }
    $ptotals->{TOTAL_MSGS} += 1;
}
#
sub pm_tally_ho
{
    my ($name) = @_;
    #
    tally_ho(\%pm_tally, \%total_pm_tally, $name);
}
#
sub xml_tally_ho
{
    my ($name) = @_;
    #
    tally_ho(\%xml_tally, \%total_xml_tally, $name);
}
#
sub init_tally
{
    %pm_tally = ( );
    %xml_tally = ( );
}
#
sub print_file_tally
{
    printf $log_fh "\n%d: XML MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $xml_tally{$_}\n" for sort keys %xml_tally;
    #
    printf $log_fh "\n%d: PM MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $pm_tally{$_}\n" for sort keys %pm_tally;
}
#
sub print_total_tally
{
    printf $log_fh "\n%d: TOTAL XML MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $total_xml_tally{$_}\n" for sort keys %total_xml_tally;
    #
    printf $log_fh "\n%d: TOTAL PM MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $total_pm_tally{$_}\n" for sort keys %total_pm_tally;
}
#
######################################################################
#
# read in PanaCIM log file and filter out XML messages to and from LNB.
#
sub print_pm
{
    my ($post_raw_nl, 
        $tstamp,
        $label,
        $msg_src,
        $msg_dest,
        $msg_class,
        $msg_type,
        $rec) = @_;
    ftrace(__LINE__);
    #
    pm_tally_ho($msg_class . '::' .  $msg_type);
    #
    if ($full_trace == TRUE)
    {
        $rec =~ m/^.*(MessageSource\s*=\s[^\s]+\s*,\s*MessageDestination\s*=\s*[^\s]+.*)$/;
        my $pm_rec = $1;
        #
        printf $log_fh "%d: %s %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n\t%s\n", 
               __LINE__, 
               $tstamp,
               $label,
               $msg_src,
               $msg_dest,
               $msg_class,
               $msg_type,
               join("\n\t", split(",", $pm_rec));
    }
    else
    {
        printf $log_fh "%d: %s %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n", 
               __LINE__, 
               $tstamp,
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
    my ($post_raw_nl, $tstamp, $rec) = @_;
    ftrace(__LINE__);
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
        printf $log_fh "\n%d: %s %s - %s\n", 
               __LINE__, $tstamp, $label, $rec if ($print_raw == TRUE);
        #
        print_pm($post_raw_nl, 
                 $tstamp,
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
sub start_get_value
{
    my ($ptree, $search_name, $pvalue, $pdone) = @_;
    ftrace(__LINE__);
    #
    if (ref($ptree) eq "ARRAY")
    {
        for (my $i=0; ($$pdone == FALSE) && ($i<scalar(@{$ptree})); ++$i)
        {
            my $name = $ptree->[$i]->{NAME};
            if ($search_name eq $name)
            {
                if (defined($ptree->[$i]->{VALUE}))
                {
                    $$pvalue = $ptree->[$i]->{VALUE};
                }
                else
                {
                    $$pvalue = "";
                }
                $$pdone = TRUE;
            }
            elsif (scalar(@{$ptree->[$i]->{SIBLINGS}}) > 0)
            {
                start_get_value($ptree->[$i]->{SIBLINGS},
                                $search_name, 
                                $pvalue, 
                                $pdone);
            }
        }
    }
    else
    {
        printf $log_fh "\n%d: ERROR - EXPECTING ARRAY REF: <%s>\n", 
               __LINE__, 
               ref($ptree);
        $$pdone = TRUE;
    }
}
#
sub get_value
{
    my ($ptree, $search_name) = @_;
    ftrace(__LINE__);
    #
    my $value = "UNKNOWN";
    my $done = FALSE;
    #
    start_get_value($ptree, $search_name, \$value, \$done);
    #
    return($value);
}
#
sub print_xml
{
    my($post_raw_nl, $label, $tstamp, $pbooklist) = @_;
    ftrace(__LINE__);
    #
    if ($full_trace == TRUE)
    {
        my $cmdnm = '';
        if ($use_private_parser == TRUE)
        {
            $cmdnm = get_value($pbooklist, "<CommandName>");
            xml_tally_ho($cmdnm);
        }
        else
        {
            $cmdnm = $pbooklist->{'Header'}->{'CommandName'};
            xml_tally_ho($pbooklist->{'Header'}->{'CommandName'});
        }
        printf $log_fh "%d: %s %s - %s - %s\n", 
               __LINE__, 
               $tstamp,
               $label,
               $cmdnm,
               Dumper($pbooklist);
    }
    elsif ($use_private_parser == TRUE)
    {
        my $cmdnm = get_value($pbooklist, "<CommandName>");
        xml_tally_ho($cmdnm);
        printf $log_fh "%s%d: %s %s - %s\n", 
               $post_raw_nl,
               __LINE__, 
               $tstamp,
               $label,
               $cmdnm;
    }
    else
    {
        xml_tally_ho($pbooklist->{'Header'}->{'CommandName'});
        printf $log_fh "%s%d: %s %s - %s\n", 
               $post_raw_nl,
               __LINE__, 
               $tstamp,
               $label,
               $pbooklist->{'Header'}->{'CommandName'};
    }
}
#
sub accept_token
{
    my ($ptokens, $pidx, $lnno) = @_;
    ftrace(__LINE__);
    #
    printf $log_fh "\n%d: DEBUG - ACCEPTING TOKEN AT %d: %s\n", 
               __LINE__, 
               $lnno,
               $ptokens->[$$pidx] if ($verbose >= MIDVERBOSE);
    $$pidx += 1;
}
#
sub is_end_tag
{
    my ($start_tag, $token) = @_;
    ftrace(__LINE__);
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    ftrace(__LINE__);
    #
    printf $log_fh "\n%d: DEBUG - ENTRY: (%s,%s,%s,%s)\n", 
           __LINE__, 
           $ptokens, 
           $pidx, 
           $maxtoken, 
           $proot if ($verbose >= MIDVERBOSE);
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                 $first_start_tag = $token;
                 #
                 push @{$proot}, {
                     NAME       => $token,
                     VALUE      => undef,
                     ATTRIBUTES => [],
                     SIBLINGS   => []
                 };
                 accept_token($ptokens, $pidx, __LINE__);
                 #
                 my $last_element = scalar(@{$proot})-1;
                 $proot = $proot->[$last_element]->{SIBLINGS};
            }
            else
            {
                my $last_element = scalar(@{$proot})-1;
                element_xml($ptokens, 
                            $pidx, 
                            $maxtoken, 
                            $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if (is_end_tag($tag_name, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                printf $log_fh "\n%d: ERROR - MISSING END TAG : <%s,%s>\n", 
                       __LINE__, $tag_name, $token;
                accept_token($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if (is_end_tag($first_start_tag, $token) == TRUE)
            {
                accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                printf $log_fh "\n%d: ERROR - UNEXPECTED END TAG : <%s>\n", 
                       __LINE__, $token;
            }
        }
        else
        {
            printf $log_fh "\n%d: ERROR - UNEXPECTED TOKEN : <%s>\n", 
                   __LINE__, $token;
            accept_token($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml
{
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    ftrace(__LINE__);
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        accept_token($ptokens, $pidx, __LINE__);
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
    ftrace(__LINE__);
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    printf $log_fh "\n%d: DEBUG - TOKENS: \n\t%s\n", 
               __LINE__, 
               join("\n\t", @tokens) if ($verbose >= MINVERBOSE);
    #
    start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub end_tag
{
    my ($start_tag) = @_;
    ftrace(__LINE__);
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    return($end_tag);
}
#
sub deparse_start_xml
{
    my ($ptree, $pxstr) = @_;
    ftrace(__LINE__);
    #
    if (ref($ptree) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$ptree}); ++$i)
        {
            my $name = $ptree->[$i]->{NAME};
            #
            if (scalar(@{$ptree->[$i]->{SIBLINGS}}) > 0)
            {
                printf $log_fh "\n%d: %s\n", 
                       __LINE__, 
                       $name if ($verbose >= MINVERBOSE);
                $$pxstr .= $name;
                deparse_start_xml($ptree->[$i]->{SIBLINGS}, $pxstr);
                printf $log_fh "\n%d: %s\n", 
                       __LINE__, 
                       end_tag($name) if ($verbose >= MINVERBOSE);
                $$pxstr .= end_tag($name);
            }
            elsif (defined($ptree->[$i]->{VALUE}))
            {
                my $value = $ptree->[$i]->{VALUE};
                printf $log_fh "\n%d: %s%s%s\n", 
                       __LINE__, 
                       $name, 
                       $value, 
                       end_tag($name) if ($verbose >= MINVERBOSE);
                $$pxstr .= $name . $value . end_tag($name);
            }
            else
            {
                my $value = $ptree->[$i]->{VALUE};
                printf $log_fh "\n%d: %s%s\n", 
                       __LINE__, 
                       $name, 
                       end_tag($name) if ($verbose >= MINVERBOSE);
                $$pxstr .= $name . end_tag($name);
            }
        }
    }
    else
    {
        printf $log_fh "\n%d: ERROR - EXPECTING ARRAY REF: <%s>\n", 
               __LINE__, 
               ref($ptree);
    }
}
#
sub deparse_xml
{
    my ($ptree, $tstamp) = @_;
    ftrace(__LINE__);
    #
    printf $log_fh "\n%d: DEPARSE START:\n", __LINE__;
    #
    my $xml_string = '<?xml version="1.0" encoding="UTF-8"?>';
    deparse_start_xml($ptree, \$xml_string);
    #
    printf $log_fh "\n%d: %s DEPARSE XML STRING: %s\n", 
           __LINE__, $tstamp, $xml_string;
}
#
sub process_xml
{
    my ($post_raw_nl, $tstamp, $rec) = @_;
    ftrace(__LINE__, $rec);
    #
    my $done = FALSE;
    my $booklist = undef;
    #
    if ($rec =~ m/\tDATA OUT:\s*(.*)$/)
    {
        my $do_rec = $1;
        printf $log_fh "\n%d: %s PanaCIM ==>> LNB - %s\n", 
               __LINE__, $tstamp, $do_rec if ($print_raw == TRUE);
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
                  $tstamp,
                  $booklist);
        $done = TRUE;
    }
    elsif ($rec =~ m/\tDATA IN:\s*(.*)$/)
    {
        my $di_rec = $1;
        printf $log_fh "\n%d: %s PanaCIM <<== LNB - %s\n", 
               __LINE__, $tstamp, $di_rec if ($print_raw == TRUE);
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
                  $tstamp,
                  $booklist);
        $done = TRUE;
    }
    #
    deparse_xml($booklist, $tstamp) if (($do_deparse_xml == TRUE) &&
                                        ($use_private_parser == TRUE) &&
                                        ($done == TRUE));
    #
    $booklist = undef;
    #
    return($done);
}
#
sub process_other
{
    my ($post_raw_nl, $tstamp, $rec) = @_;
    ftrace(__LINE__);
    #
    my $done = FALSE;
    #
    if ($rec =~ m/(STARTING INFO LOGGING)/)
    {
        my $start_rec = $1;
        printf $log_fh "%d: %s PROCESS STARTUP - %s\n", 
               __LINE__, $tstamp, $start_rec;
    }
    #
    return($done);
}
#
sub process_rec
{
    my($post_raw_nl, $rec, $tstamp) = @_;
    ftrace(__LINE__, $rec);
    #
    if (($trace_msg_type == XML_MSGS) ||
        ($trace_msg_type == ALL_MSGS))
    {
        ftrace(__LINE__);
        return if (process_xml($post_raw_nl, $tstamp, $rec) == TRUE);
    }
    if (($trace_msg_type == PM_MSGS) ||
        ($trace_msg_type == ALL_MSGS))
    {
        ftrace(__LINE__);
        return if (process_pm($post_raw_nl, $tstamp, $rec) == TRUE);
    }
    ftrace(__LINE__);
    process_other($post_raw_nl, $tstamp, $rec);
}
#
# use constant BEFORE_WINDOW => -1;
# use constant IN_WINDOW => 0;
# use constant AFTER_WINDOW => +1;
#
sub date_filter
{
    my ($rec, $ptstamp) = @_;
    ftrace(__LINE__);
    #
    if ($rec !~ m/\t\d\d\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d.\d\d\d\t/)
    {
        # does not contain a date. skip it.
        return NOT_A_DATE;
    }
    #
    my @data = split("\t", $rec, 3);
    #
    $$ptstamp = $data[1];
    $$ptstamp =~ s?[ /:]??g;
    $$ptstamp = substr $$ptstamp, 0, 14;
    #
    $last_date = $$ptstamp;
    #
    if ($verbose < MIDVERBOSE)
    {
        return BEFORE_WINDOW if (($start_date ne "") &&
                                 ($start_date gt $$ptstamp));
        return AFTER_WINDOW if (($end_date ne "") &&
                                 ($end_date lt $$ptstamp));
        return IN_WINDOW;
    }
    elsif (($start_date ne "") &&
           ($start_date gt $$ptstamp))
    {
        printf $log_fh "\n%d: DEBUG - START DATE TEST - RETURN FALSE (%s,%s)\n", 
               __LINE__, 
               $start_date,
               $$ptstamp;
        return BEFORE_WINDOW;
    }
    elsif (($end_date ne "") &&
           ($end_date lt $$ptstamp))
    {
        printf $log_fh "\n%d: DEBUG - END DATE TEST - RETURN FALSE (%s,%s)\n", 
               __LINE__, 
               $end_date,
               $$ptstamp;
        return AFTER_WINDOW;
    }
    else
    {
        printf $log_fh "\n%d: DEBUG - DATE TEST - RETURN TRUE (%s)\n", 
               __LINE__, 
               $$ptstamp;
        return IN_WINDOW;
    }
}
#
sub is_xml_start
{
    my ($rec) = @_;
    #
    if ($rec =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/i)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub process_xml_block
{
    my ($post_raw_nl, $infh, $rec, $tstamp) = @_;
    ftrace(__LINE__);
    #
    my @recs = ();
    #
    push @recs, $rec;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    my $first_end_tag = "";
    #
    while (($done == FALSE) && ($rec = <$infh>))
    {
        $rec =~ s/\r*\n$//;
        #
        if (($first_start_tag eq "") &&
            ($rec =~ m/^<([^\/>\s]+)/))
        {
            $first_start_tag = "<" . ${1} . ">";
            $first_end_tag = end_tag($first_start_tag);
        }
        elsif ($rec =~ m/$first_end_tag/)
        {
            $done = TRUE;
        }
        #
        push @recs, $rec;
    }
    #
    printf $log_fh "\n%d: XML block: \n\t%s\n", 
           __LINE__, join("\n\t", @recs) if ($verbose >= MINVERBOSE);
}
#
sub process_file
{
    my ($log_file) = @_;
    ftrace(__LINE__);
    #
    printf $log_fh "\n%d: START PROCESSING PanaCIM LOG FILE: %s\n\n", 
                   __LINE__, $log_file;
    #
    init_tally();
    open(my $infh, "<", $log_file) || die $!;
    #
    my $post_raw_nl = '';
    $post_raw_nl = "\n" if ($print_raw == TRUE);
    #
    while (my $rec = <$infh>)
    {
        $rec =~ s/\r*\n$//;
        #
        printf $log_fh "%d: Raw File Record: %s\n", 
                   __LINE__, $rec if ($print_raw_record == TRUE);
        #
        my $tstamp = "";
        my $result = date_filter($rec, \$tstamp);
        if ($result == IN_WINDOW)
        {
            process_rec($post_raw_nl, $rec, $tstamp);
        }
        elsif (($exit_upon_enddate == TRUE) &&
               ($result == AFTER_WINDOW))
        {
            printf $log_fh "\n%d: Exiting processing loop at: %s\n", 
                   __LINE__, $tstamp;
            last;
        }
        elsif ($result == NOT_A_DATE)
        {
            if (is_xml_start($rec) == TRUE)
            {
                # we have the start of a multiline xml block.
                process_xml_block($post_raw_nl, 
                                  $infh, 
                                  $rec,
                                  $last_date);
            }
        }
    }
    #
    close($infh);
    #
    print_file_tally();
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
#         [-P xml|pm|all] [-p] [-d] \\
#
my %opts;
if (getopts('?hwWv:l:tTRrP:pdS:E:X:x', \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (keys %opts)
{
    printf "\n%d: Option: $opt, $opts{$opt}\n", __LINE__;
    #
    if (($opt eq 'h') or ($opt eq '?'))
    {
        usage($cmd);
        exit 0;
    }
    elsif ($opt eq 'x')
    {
        $exit_upon_enddate = TRUE;
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
    elsif ($opt eq 'r')
    {
        $print_raw_record = TRUE;
    }
    elsif ($opt eq 'R')
    {
        $print_raw = TRUE;
    }
    elsif ($opt eq 'p')
    {
        $use_private_parser = TRUE;
    }
    elsif ($opt eq 'd')
    {
        $do_deparse_xml = TRUE;
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
    elsif ($opt eq 'X')
    {
        if ($opts{$opt} =~ m/^(19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[01])(0[0-9]|1[0-9]|2[0-3])[0-5][0-9][0-5][0-9]$/)
        {
            $start_date = $opts{$opt};
            $end_date = $opts{$opt};
        }
        else
        {
            printf $log_fh "\n%d: Invalid exact date: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
        printf $log_fh "\n%d: exact date: $opts{$opt}\n", __LINE__;
    }
    elsif ($opt eq 'S')
    {
        if ($opts{$opt} =~ m/^(19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[01])(0[0-9]|1[0-9]|2[0-3])[0-5][0-9][0-5][0-9]$/)
        {
            $start_date = $opts{$opt};
        }
        else
        {
            printf $log_fh "\n%d: Invalid start date: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
        printf $log_fh "\n%d: start date: $opts{$opt}\n", __LINE__;
    }
    elsif ($opt eq 'E')
    {
        if ($opts{$opt} =~ m/^(19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[01])(0[0-9]|1[0-9]|2[0-3])[0-5][0-9][0-5][0-9]$/)
        {
            $end_date = $opts{$opt};
        }
        else
        {
            printf $log_fh "\n%d: Invalid end date: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
        printf $log_fh "\n%d: end date: $opts{$opt}\n", __LINE__;
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
if (($start_date ne "") &&
    ($end_date ne "") &&
    ($start_date gt $end_date))
{
    printf $log_fh "%d: ERROR - start date after end date.\n(%s > %s)\n", 
           __LINE__, 
           $start_date,
           $end_date;
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
        printf $log_fh "%d: ERROR - No log files given.\n", __LINE__;
        usage($cmd);
        exit 2;
    }
    #
    foreach my $panacim_log_file (@ARGV)
    {
        process_file($panacim_log_file);
    }
    print_total_tally();
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
    print_total_tally();
}
#
exit 0;

# parsing LNB-style XML messages
#
package mylnbxml;
#
use myconstants;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{booklist} = undef;
    $self->{xml} = undef;
    $self->{deparse_xml} = undef;
    $self->{logger} = undef;
    $self->{errors} = 0;
    #
    $self->{xml} = shift if @_;
    $self->{logger} = shift if @_;
    #
    bless $self, $class;
    #
    return($self);
}
#
sub xml
{
    my $self = shift;
    #
    if (@_)
    {
        $self->{xml} = shift;
        $self->{booklist} = undef;
        $self->{deparse_xml} = undef;
        $self->{errors} = 0;
    }
    #
    return($self->{xml});
}
#
sub booklist
{
    my $self = shift;
    #
    return($self->{booklist});
}
#
#
sub errors
{
    my $self = shift;
    #
    return($self->{errors});
}
#
sub accept_token
{
    my $self = shift;
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                $self->accept_token($ptokens, $pidx, __LINE__);
                #
                my $last_element = scalar(@{$proot})-1;
                $proot = $proot->[$last_element]->{SIBLINGS};
            }
            else
            {
                $self->element_xml($ptokens, 
                                   $pidx, 
                                   $maxtoken, 
                                   $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            $self->accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if ($self->is_end_tag($tag_name, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                # printf "\n%d: ERROR - MISSING END TAG : <%s,%s>\n", 
                #        __LINE__, $tag_name, $token;
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                # printf "\n%d: ERROR - UNEXPECTED END TAG : <%s>\n", 
                #        __LINE__, $token;
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
            }
        }
        else
        {
            # printf "\n%d: ERROR - UNEXPECTED TOKEN : <%s>\n", __LINE__, $token;
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $self->accept_token($ptokens, $pidx, __LINE__);
        $self->element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        # printf "\n%d: ERROR - NOT XML 1.0 DOC: <%s>\n", __LINE__, $token;
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
    }
    #
    return($proot);
}
#
sub parse_xml
{
    my $self = shift;
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    $self->start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub parse
{
    my $self = shift;
    #
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        $self->{booklist} = $self->parse_xml($self->{xml});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
        }
    }
    #
    return($self->{booklist});
}
#
sub end_tag
{
    my $self = shift;
    my ($start_tag) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    return($end_tag);
}
#
sub deparse_start_xml
{
    my $self = shift;
    my ($ptree, $pxstr) = @_;
    #
    if (ref($ptree) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$ptree}); ++$i)
        {
            my $name = $ptree->[$i]->{NAME};
            #
            if (scalar(@{$ptree->[$i]->{SIBLINGS}}) > 0)
            {
                $$pxstr .= $name;
                $self->deparse_start_xml($ptree->[$i]->{SIBLINGS}, $pxstr);
                $$pxstr .= $self->end_tag($name);
            }
            elsif (defined($ptree->[$i]->{VALUE}))
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $value . $self->end_tag($name);
            }
            else
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $self->end_tag($name);
            }
        }
    }
    else
    {
        # printf $log_fh "\n%d: ERROR - EXPECTING ARRAY REF: <%s>\n", 
        #        __LINE__, ref($ptree);
        $self->{errors} += 1;
        $self->{logger}->log_err("EXPECTING ARRAY REF: <%s>\n", ref($ptree));
    }
}
#
sub deparse_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml_string = '<?xml version="1.0" encoding="UTF-8"?>';
    $self->deparse_start_xml($ptree, \$xml_string);
    #
    return($xml_string);
}
#
sub deparse
{
    my $self = shift;
    #
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{booklist}))
    {
        $self->{errors} = 0;
        $self->{deparse_xml} = $self->deparse_xml($self->{booklist});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Deparse failed.\n");
            $self->{deparse_xml} = undef;
        }
    }
    #
    return($self->{deparse_xml});
}
#
# exit with success
#
1;
#!/usr/bin/perl
#
use strict;
use XML::Simple;
#
my $depth = 0;
my $verbose = 0;
#
sub read_file {
    my ($infile, $pdata) = @_;
    #
    # is file readable?
    #
    if ( ! -r $infile )
    {
        printf "ERROR: file $infile is NOT readable\n";
        exit -1;
    }
    #
    # read in file 
    #
    unless (open(INFD, $infile))
    {
        printf "ERROR: unable to open $infile.\n";
        exit -1;
    }
    my @buf = <INFD>;
    close(INFD);
    #
    # return data.
    #
    unshift @{$pdata}, @buf;
    #
    return;
}
#
sub traverse {
    my ($p, $pdl) = @_;
    #
    $depth += 1;
    my $indent = (' ' x ($depth*2));
    #
    if (ref($p) eq 'SCALAR')
    {
        print "${indent}SCALAR REF: $p\n";
    }
    elsif (ref($p) eq 'ARRAY')
    {
        print "${indent}ARRAY REF: $p\n" if ($verbose);
        foreach my $element (@{$p})
        {
            traverse($element, $pdl);
        }
    }
    elsif (ref($p) eq 'HASH')
    {
        print "${indent}HASH REF: $p\n" if ($verbose);
        foreach my $key (keys(%{$p}))
        {
            traverse($p->{$key}, $pdl);
        }
    }
    elsif (ref($p) eq 'CODE')
    {
        print "${indent}CODE REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'REF')
    {
        print "${indent}REF REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'GLOB')
    {
        print "${indent}GLOB REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'LVALUE')
    {
        print "${indent}LVALUE REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'FORMAT')
    {
        print "${indent}FORMAT REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'IO')
    {
        print "${indent}IO REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'VSTRING')
    {
        print "${indent}VSTRING REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'Regexp')
    {
        print "${indent}Regexp REF: $p\n" if ($verbose);
    }
    else
    {
        print "${indent}SCALAR: $p\n" if ($verbose);
        $$pdl += length($p);
    }
    #
    $depth -= 1;
}
#
if ($#ARGV>=0)
{
    if ($ARGV[0] eq '-v')
    {
        $verbose = 1;
        shift @ARGV;
    }
}
#
foreach my $xml_file (@ARGV)
{
    printf "\nProcessing XML file: %s\n", $xml_file;
    #
    my @raw_xml = ();
    read_file($xml_file, \@raw_xml);
    #
    my $xml = join '', @raw_xml;
    my $xml_length = length($xml);
    #
    my $ref = XMLin($xml);
    #
    my $data_length = 0;
    traverse($ref,\$data_length);
    #
    printf "XML Tags and Data length: %d\n", $xml_length;
    printf "Data length: %d\n", $data_length;
    printf "Percent Data/(Data+XML) = %6.2f%%\n", 
            100.0*($data_length/$xml_length);
}
#
exit 0;
