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
        [-t | -T] [-R] \\ 
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
sub print_tally
{
    printf $log_fh "\n%d: XML MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $xml_tally{$_}\n" for sort keys %xml_tally;
    #
    printf $log_fh "\n%d: PM MSG TALLY:\n", __LINE__;
    printf $log_fh "$_ = $pm_tally{$_}\n" for sort keys %pm_tally;
    #
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
    pm_tally_ho($msg_class . $msg_type);
    #
    if ($full_trace == TRUE)
    {
        $rec =~ m/^.*(MessageSource\s*=\s[^\s]+\s*,\s*MessageDestination\s*=\s*[^\s]+.*)$/;
        my $pm_rec = $1;
        #
        printf $log_fh "\n%d: %s %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n\t%s\n", 
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
        printf $log_fh "\n%d: %s %s - (src,dst,cls,type) = (%s,%s,%s,%s)\n", 
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
        if ($use_private_parser == TRUE)
        {
            my $cmdnm = get_value($pbooklist, "<CommandName>");
            xml_tally_ho($cmdnm);
        }
        else
        {
            xml_tally_ho($pbooklist->{'Header'}->{'CommandName'});
        }
        printf $log_fh "\n%d: %s %s - %s\n", 
               __LINE__, 
               $tstamp,
               $label,
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
        printf $log_fh "\n%d: %s PROCESS STARTUP - %s\n", 
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
            push @recs, $rec;
        }
        elsif ($rec =~ m/$first_end_tag/)
        {
            push @recs, $rec;
            $done = TRUE;
        }
        else
        {
            push @recs, $rec;
        }
    }
    #
    printf $log_fh "\n%d: XML block: \n\t%s\n", 
                   __LINE__, join("\n\t", @recs);
}
#
sub process_file
{
    my ($log_file) = @_;
    ftrace(__LINE__);
    #
    printf $log_fh "\n%d: Processing PanaCIM Log File: %s\n", 
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
    print_tally();
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
if (getopts('?hwWv:l:tTRP:pdS:E:X:x', \%opts) != 1)
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
