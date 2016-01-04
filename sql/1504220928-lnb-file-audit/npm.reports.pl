#!/usr/bin/perl -w
######################################################################
#
# process LNB data files, u01, u03, mpr and create reports.
#
######################################################################
#
use strict;
#
use Getopt::Std;
use File::Find;
#
######################################################################
#
# constants
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
# output types
#
use constant PROD_COMPLETE => 3;
use constant PROD_COMPLETE_LATER => 4;
use constant DETECT_CHANGE => 5;
use constant MANUAL_CLEAR => 11;
use constant TIMER_NOT_RUNNING => 12;
use constant AUTO_CLEAR => 13;
#
# processing states
#
use constant RESET => 'reset';
use constant BASELINE => 'baseline';
use constant DELTA => 'delta';
#
# common sections for all files types: u01, u03, mpr
#
use constant INDEX => '[Index]';
use constant INFORMATION => '[Information]';
#
# sections specific to u01
#
use constant TIME => '[Time]';
use constant CYCLETIME => '[CycleTime]';
use constant COUNT => '[Count]';
use constant DISPENSER => '[Dispenser]';
use constant MOUNTPICKUPFEEDER => '[MountPickupFeeder]';
use constant MOUNTPICKUPNOZZLE => '[MountPickupNozzle]';
use constant INSPECTIONDATA => '[InspectionData]';
#
# sections specific to u03
#
use constant BRECG => '[BRecg]';
use constant BRECGCALC => '[BRecgCalc]';
use constant ELAPSETIMERECOG => '[ElapseTimeRecog]';
use constant SBOARD => '[SBoard]';
use constant HEIGHTCORRECT => '[HeightCorrect]';
use constant MOUNTQUALITYTRACE => '[MountQualityTrace]';
use constant MOUNTLATESTREEL => '[MountLatestReel]';
use constant MOUNTEXCHANGEREEL => '[MountExchangeReel]';
#
# sections specfic to mpr
#
use constant TIMEDATASP => '[TimeDataSP]';
use constant COUNTDATASP => '[CountDataSP]';
use constant COUNTDATASP2 => '[CountDataSP2]';
use constant TRACEDATASP => '[TraceDataSP]';
use constant TRACEDATASP_2 => '[TraceDataSP_2]';
use constant ISPINFODATA => '[ISPInfoData]';
use constant MASKISPINFODATA => '[MaskISPInfoData]';
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
# processing options
#
use constant PROC_OPT_NONE  => 0;
use constant PROC_OPT_IGN12 => 1;
#
######################################################################
#
# globals
#
my $cmd = $0;
my $logfile = '';
my $log_fh = *STDOUT;
#
# cmd line options
#
my $verbose = 0;
my $file_type = ""; # default is all files: u01, u03, mpr
my $use_neg_delta = FALSE; 
my $audit_only = FALSE; 
my $red_flag_trigger = 0; # off by default
my $export_csv = FALSE;
my $export_dir = '/tmp/';
my $proc_option = PROC_OPT_NONE;
#
my %red_flags =();
#
my %verbose_levels =
(
    off => 0,
    min => 1,
    mid => 2,
    max => 3
);
#
# report formats
#
my @nozzle_print_cols =
(
    { name => 'Machine', format => '%-8s ' },
    { name => 'Lane', format => '%-8s ' },
    { name => 'Stage', format => '%-8s ' },
    { name => 'NHAdd', format => '%-8s ' },
    { name => 'NCAdd', format => '%-8s ' },
    { name => 'Blkserial', format => '%-30s ' },
    { name => 'Pickup', format => '%-8s ' },
    { name => 'PMiss', format => '%-8s ' },
    { name => 'RMiss', format => '%-8s ' },
    { name => 'DMiss', format => '%-8s ' },
    { name => 'MMiss', format => '%-8s ' },
    { name => 'HMiss', format => '%-8s ' },
    { name => 'TRSMiss', format => '%-8s ' },
    { name => 'Mount', format => '%-8s ' }
);
#
my @nozzle_print_cols2 =
(
    { name => 'Machine', format => '%-8s ' },
    { name => 'Lane', format => '%-8s ' },
    { name => 'Stage', format => '%-8s ' },
    { name => 'NHAdd', format => '%-8s ' },
    { name => 'NCAdd', format => '%-8s ' },
    { name => 'Pickup', format => '%-8s ' },
    { name => 'PMiss', format => '%-8s ' },
    { name => 'RMiss', format => '%-8s ' },
    { name => 'DMiss', format => '%-8s ' },
    { name => 'MMiss', format => '%-8s ' },
    { name => 'HMiss', format => '%-8s ' },
    { name => 'TRSMiss', format => '%-8s ' },
    { name => 'Mount', format => '%-8s ' }
);
#
my @nozzle_export_cols =
(
    { name => 'Machine', format => '%s' },
    { name => 'Lane', format => ',%s ' },
    { name => 'Stage', format => ',%s' },
    { name => 'NHAdd', format => ',%s' },
    { name => 'NCAdd', format => ',%s' },
    { name => 'Blkserial', format => ',%s' },
    { name => 'Pickup', format => ',%s' },
    { name => 'PMiss', format => ',%s' },
    { name => 'RMiss', format => ',%s' },
    { name => 'DMiss', format => ',%s' },
    { name => 'MMiss', format => ',%s' },
    { name => 'HMiss', format => ',%s' },
    { name => 'TRSMiss', format => ',%s' },
    { name => 'Mount', format => ',%s' }
);
#
my @nozzle_export_cols2 =
(
    { name => 'Machine', format => '%s' },
    { name => 'Lane', format => ',%s' },
    { name => 'Stage', format => ',%s' },
    { name => 'NHAdd', format => ',%s' },
    { name => 'NCAdd', format => ',%s' },
    { name => 'Pickup', format => ',%s' },
    { name => 'PMiss', format => ',%s' },
    { name => 'RMiss', format => ',%s' },
    { name => 'DMiss', format => ',%s' },
    { name => 'MMiss', format => ',%s' },
    { name => 'HMiss', format => ',%s' },
    { name => 'TRSMiss', format => ',%s' },
    { name => 'Mount', format => ',%s' }
);
#
my @nozzle_count_cols =
(
    'Pickup',
    'PMiss',
    'RMiss',
    'DMiss',
    'MMiss',
    'HMiss',
    'TRSMiss',
    'Mount'
);
#
my @feeder_print_cols =
(
    { name => 'Machine', format => '%-8s ' },
    { name => 'Lane', format => '%-8s ' },
    { name => 'Stage', format => '%-8s ' },
    { name => 'FAdd', format => '%-8s ' },
    { name => 'FSAdd', format => '%-8s ' },
    # { name => 'Blkserial', format => '%-30s ' },
    { name => 'ReelID', format => '%-30s ' },
    { name => 'Pickup', format => '%-8s ' },
    { name => 'PMiss', format => '%-8s ' },
    { name => 'RMiss', format => '%-8s ' },
    { name => 'DMiss', format => '%-8s ' },
    { name => 'MMiss', format => '%-8s ' },
    { name => 'HMiss', format => '%-8s ' },
    { name => 'TRSMiss', format => '%-8s ' },
    { name => 'Mount', format => '%-8s ' }
);
#
my @feeder_print_cols2 =
(
    { name => 'Machine', format => '%-8s ' },
    { name => 'Lane', format => '%-8s ' },
    { name => 'Stage', format => '%-8s ' },
    { name => 'FAdd', format => '%-8s ' },
    { name => 'FSAdd', format => '%-8s ' },
    { name => 'Pickup', format => '%-8s ' },
    { name => 'PMiss', format => '%-8s ' },
    { name => 'RMiss', format => '%-8s ' },
    { name => 'DMiss', format => '%-8s ' },
    { name => 'MMiss', format => '%-8s ' },
    { name => 'HMiss', format => '%-8s ' },
    { name => 'TRSMiss', format => '%-8s ' },
    { name => 'Mount', format => '%-8s ' }
);
#
my @feeder_export_cols =
(
    { name => 'Machine', format => '%s' },
    { name => 'Lane', format => ',%s' },
    { name => 'Stage', format => ',%s' },
    { name => 'FAdd', format => ',%s' },
    { name => 'FSAdd', format => ',%s' },
    # { name => 'Blkserial', format => ',%s' },
    { name => 'ReelID', format => ',%s' },
    { name => 'Pickup', format => ',%s' },
    { name => 'PMiss', format => ',%s' },
    { name => 'RMiss', format => ',%s' },
    { name => 'DMiss', format => ',%s' },
    { name => 'MMiss', format => ',%s' },
    { name => 'HMiss', format => ',%s' },
    { name => 'TRSMiss', format => ',%s' },
    { name => 'Mount', format => ',%s' }
);
#
my @feeder_export_cols2 =
(
    { name => 'Machine', format => '%s' },
    { name => 'Lane', format => ',%s' },
    { name => 'Stage', format => ',%s' },
    { name => 'FAdd', format => ',%s' },
    { name => 'FSAdd', format => ',%s' },
    { name => 'Pickup', format => ',%s' },
    { name => 'PMiss', format => ',%s' },
    { name => 'RMiss', format => ',%s' },
    { name => 'DMiss', format => ',%s' },
    { name => 'MMiss', format => ',%s' },
    { name => 'HMiss', format => ',%s' },
    { name => 'TRSMiss', format => ',%s' },
    { name => 'Mount', format => ',%s' }
);
#
my @feeder_count_cols =
(
    'Pickup',
    'PMiss',
    'RMiss',
    'DMiss',
    'MMiss',
    'HMiss',
    'TRSMiss',
    'Mount'
);
#
my @mount_quality_trace_cols =
(
    'B',
    'IDNUM',
    'TURN',
    'MS',
    'TS',
    'FAdd',
    'FSAdd',
    'FBLKCode',
    'FBLKSerial',
    'NHAdd',
    'NCAdd',
    'NBLKCode',
    'NBLKSerial',
    'ReelID',
    'F',
    'RCGX',
    'RCGY',
    'RCGA',
    'TCX',
    'TCY',
    'MPosiRecX',
    'MPosiRecY',
    'MPosiRecA',
    'MPosiRecZ',
    'THMAX',
    'THAVE',
    'MNTCX',
    'MNTCY',
    'MNTCA',
    'TLX',
    'TLY',
    'InspectArea',
    'DIDNUM',
    'DS',
    'DispenseID',
    'PARTS',
    'WarpZ'
);
#
my @mount_latest_reel_cols =
(
    'BLKCode',
    'BLKSerial',
    'Ftype',
    'FAdd',
    'FSAdd',
    'Use',
    'PEStatus',
    'PCStatus',
    'Remain',
    'Init',
    'PartsName',
    'Custom1',
    'Custom2',
    'Custom3',
    'Custom4',
    'ReelID',
    'PartsEmp'
);
#
my @mount_exchange_reel_cols =
(
    'BLKCode',
    'BLKSerial',
    'Ftype',
    'FAdd',
    'FSAdd',
    'Use',
    'PEStatus',
    'PCStatus',
    'Remain',
    'Init',
    'PartsName',
    'Custom1',
    'Custom2',
    'Custom3',
    'Custom4',
    'ReelID',
    'PartsEmp'
);
#
# fields to ignore for output=12 files if enabled.
#
my %ignored_output12_fields =
(
    'TPICKUP' => 1,
    'TPMISS' => 1,
    'TRMISS' => 1,
    'TDMISS' => 1,
    'TMMISS' => 1,
    'THMISS' => 1,
    'CPERR' => 1,
    'CRERR' => 1,
    'CDERR' => 1,
    'CMERR' => 1,
    'CTERR' => 1
);
#
# summary tables.
#
my %totals = ();
my %report_precision = ();
#
######################################################################
#
# miscellaneous routines
#
sub usage
{
    my ($arg0) = @_;
    print <<EOF;

usage: $arg0 [-?] [-h] \\ 
        [-w | -W |-v level] \\ 
        [-d value] \\ 
        [-t u10|u03|mpr] \\ 
        [-r value] \\ 
        [-L logfile_path] \\ 
        [-O option] \\ 
        [-n] \\
        [-a] \\
        [-x] [-d path] \\
        directory ...

where:
    -? or -h - print usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -t file-type = type of file to process: u01, u03, mpr.
                   default is all files.
    -r value - red flag if counts decrease by more than this amount.
    -L path - log file path
    -O option - enable a procesing option:
                ign12 - ignore resetable output=12 fields.
    -n - use negative deltas (default is NOT to use)
    -a - only audit data, do not generate any report.
    -x - export reports as CSV files.
    -d path - export directory, defaults to '/tmp'.

EOF
}
#
sub get_product_info
{
    my ($pdata, $pmjsid, $plotname, $plotnumber) = @_;
    #
    my $section = INDEX;
    $$pmjsid = $pdata->{$section}->{data}->{MJSID};
    $$pmjsid = $1 if ($$pmjsid =~ m/"([^"]*)"/);
    #
    $section = INFORMATION;
    $$plotname = $pdata->{$section}->{data}->{LotName};
    $$plotname = $1 if ($$plotname =~ m/"([^"]*)"/);
    $$plotnumber = $pdata->{$section}->{data}->{LotNumber};
}
#
sub set_product_info_u01
{
    my ($pdb, $pu01) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $mjsid = 'UNKNOWN';
    my $lotname = 'UNKNOWN';
    my $lotnumber = 0;
    #
    if (($output_no == PROD_COMPLETE) ||
        ($output_no == PROD_COMPLETE_LATER))
    {
        get_product_info($pu01, \$mjsid, \$lotname, \$lotnumber);
        $pdb->{product}{u01}{$machine}{$lane}{$stage} = "${mjsid}_${lotname}_${lotnumber}";
    }
    elsif ( ! exists($pdb->{product}{u01}{$machine}{$lane}{$stage}))
    {
        $pdb->{product}{u01}{$machine}{$lane}{$stage} = "${mjsid}_${lotname}_${lotnumber}";
    }
    #
    printf $log_fh "Product U01: %s\n", $pdb->{product}{u01}{$machine}{$lane}{$stage} if ($verbose >= MIDVERBOSE);
}
#
sub set_product_info_u03
{
    my ($pdb, $pu03) = @_;
    #
    my $filename = $pu03->{file_name};
    #
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    #
    my $mjsid = 'UNKNOWN';
    my $lotname = 'UNKNOWN';
    my $lotnumber = 0;
    #
    if (($output_no == PROD_COMPLETE) ||
        ($output_no == PROD_COMPLETE_LATER))
    {
        get_product_info($pu03, \$mjsid, \$lotname, \$lotnumber);
        $pdb->{product}{u03}{$machine}{$lane}{$stage} = "${mjsid}_${lotname}_${lotnumber}";
    }
    elsif ( ! exists($pdb->{product}{u03}{$machine}{$lane}{$stage}))
    {
        $pdb->{product}{u03}{$machine}{$lane}{$stage} = "${mjsid}_${lotname}_${lotnumber}";
    }
    #
    printf $log_fh "Product U03: %s\n", $pdb->{product}{u03}{$machine}{$lane}{$stage} if ($verbose >= MIDVERBOSE);
}
#
sub set_red_flag
{
    my ($machine, $lane, $stage, $filename, $delta) = @_;
    #
    return unless ($red_flag_trigger > 0);
    #
    $delta = -$delta unless ($delta >= 0);
    #
    if ($delta >= $red_flag_trigger)
    {
        $red_flags{$machine}{$lane}{$stage} = $filename;
    }
}
#
sub check_red_flag
{
    my ($pu01) = @_;
    #
    return unless ($red_flag_trigger > 0);
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    #
    if (exists($red_flags{$machine}{$lane}{$stage}))
    {
        my $previous_filename = $red_flags{$machine}{$lane}{$stage};
        #
        printf $log_fh "\nRED FLAG FILES FOR MACHINE: %s, Lane: %s, Stage: %s:\n",
            $machine, $lane, $stage;
        printf $log_fh "==>> Previous File: %s\n", $previous_filename;
        printf $log_fh "==>> Current File : %s\n", $filename;
        #
        delete $red_flags{$machine}{$lane}{$stage};
    }
}
#
######################################################################
#
# report routines
#
sub init_report_precision
{
    my $section = TIME;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = COUNT;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = MOUNTPICKUPFEEDER;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = MOUNTPICKUPNOZZLE;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = MOUNTQUALITYTRACE;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = MOUNTLATESTREEL;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
    #
    $section = MOUNTEXCHANGEREEL;
    $report_precision{$section}{set} = FALSE;
    $report_precision{$section}{precision} = 0;
}
#
sub set_report_name_value_precision
{
    my ($pu01, $section) = @_;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (keys %{$pu01->{$section}->{data}})
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
sub set_report_nozzle_precision
{
    my ($pu01) = @_;
    #
    my $section = MOUNTPICKUPNOZZLE;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (@nozzle_count_cols)
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
sub set_report_feeder_precision
{
    my ($pu01) = @_;
    #
    my $section = MOUNTPICKUPFEEDER;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (@feeder_count_cols)
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
sub set_report_quality_trace_precision
{
    my ($pu03) = @_;
    #
    my $section = MOUNTQUALITYTRACE;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (@mount_quality_trace_cols)
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
sub set_report_latest_reel_precision
{
    my ($pu03) = @_;
    #
    my $section = MOUNTLATESTREEL;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (@mount_latest_reel_cols)
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
sub set_report_exchange_reel_precision
{
    my ($pu03) = @_;
    #
    my $section = MOUNTEXCHANGEREEL;
    #
    return unless ($report_precision{$section}{set} == FALSE);
    #
    $report_precision{$section}{precision} = 0;
    #
    foreach my $key (@mount_exchange_reel_cols)
    {
        my $keylen = length($key);
        if ($keylen > $report_precision{$section}{precision})
        {
            $report_precision{$section}{precision} = $keylen;
        }
    }
    #
    if ($report_precision{$section}{precision} <= 0)
    {
        $report_precision{$section}{precision} = 20;
    }
    #
    $report_precision{$section}{set} = TRUE;
}
#
######################################################################
#
# read in data file and load all sections
#
sub load
{
    my ($pdata) = @_;
    #
    my $path = $pdata->{full_path};
    #
    if ( ! -r $path )
    {
        printf $log_fh "\nERROR: file $path is NOT readable\n\n";
        return 0;
    }
    #
    unless (open(INFD, $path))
    {
        printf $log_fh "\nERROR: unable to open $path.\n\n";
        return 0;
    }
    @{$pdata->{data}} = <INFD>;
    close(INFD);
    #
    # remove newlines
    #
    chomp(@{$pdata->{data}});
    printf $log_fh "Lines read: %d\n", scalar(@{$pdata->{data}})
        if ($verbose >= MAXVERBOSE);
    #
    return 1;
}
#
sub load_name_value
{
    my ($pdata, $section) = @_;
    #
    printf $log_fh "\nLoading Name-Value Section: %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    my $re_section = '\\' . $section;
    @{$pdata->{raw}->{$section}} = 
        grep /^${re_section}\s*$/ .. /^\s*$/, @{$pdata->{data}};
    #
    # printf $log_fh "<%s>\n", join("\n", @{$pdata->{raw}->{$section}});
    #
    if (scalar(@{$pdata->{raw}->{$section}}) <= 2)
    {
        $pdata->{$section} = {};
        printf $log_fh "No data found.\n"
            if ($verbose >= MAXVERBOSE);
        return 1;
    }
    #
    shift @{$pdata->{raw}->{$section}};
    pop @{$pdata->{raw}->{$section}};
    #
    printf $log_fh "Section Lines: %d\n", scalar(@{$pdata->{raw}->{$section}})
        if ($verbose >= MAXVERBOSE);
    #
    %{$pdata->{$section}->{data}} = 
        map { split /\s*=\s*/, $_, 2 } @{$pdata->{raw}->{$section}};
    printf $log_fh "Number of Keys: %d\n", scalar(keys %{$pdata->{$section}->{data}})
        if ($verbose >= MAXVERBOSE);
    #
    return 1;
}
#
sub split_quoted_string
{
    my $rec = shift;
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
        elsif ($c eq ' ')
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
    #
    # printf $log_fh "Tokens: \n%s\n", join("\n",@tokens);
    #
    return @tokens;
}
#
sub load_list
{
    my ($pdata, $section) = @_;
    #
    printf $log_fh "\nLoading List Section: %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    my $re_section = '\\' . $section;
    @{$pdata->{raw}->{$section}} = 
        grep /^${re_section}\s*$/ .. /^\s*$/, @{$pdata->{data}};
    #
    # printf $log_fh "<%s>\n", join("\n", @{$pdata->{raw}->{$section}});
    #
    if (scalar(@{$pdata->{raw}->{$section}}) <= 3)
    {
        $pdata->{$section} = {};
        printf $log_fh "No data found.\n"
            if ($verbose >= MAXVERBOSE);
        return 1;
    }
    shift @{$pdata->{raw}->{$section}};
    pop @{$pdata->{raw}->{$section}};
    $pdata->{$section}->{header} = shift @{$pdata->{raw}->{$section}};
    @{$pdata->{$section}->{column_names}} = 
        split / /, $pdata->{$section}->{header};
    my $number_columns = scalar(@{$pdata->{$section}->{column_names}});
    #
    @{$pdata->{$section}->{data}} = ();
    #
    printf $log_fh "Section Lines: %d\n", scalar(@{$pdata->{raw}->{$section}})
        if ($verbose >= MAXVERBOSE);
    # printf $log_fh "Column Names: %d\n", $number_columns;
    foreach my $record (@{$pdata->{raw}->{$section}})
    {
        # printf $log_fh "\nRECORD: %s\n", $record;
        #
        # printf $log_fh "\nRECORD (original): %s\n", $record;
        # $record =~ s/"\s+"\s/"" /g;
        # $record =~ s/"\s+"\s*$/""/g;
        # printf $log_fh "\nRECORD (final): %s\n", $record;
        # my @tokens = split / /, $record;
        #
        my @tokens = split_quoted_string($record);
        my $number_tokens = scalar(@tokens);
        printf $log_fh "Number of tokens in record: %d\n", $number_tokens
            if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pdata->{$section}->{column_names}}} = @tokens;
            my $data_size = scalar(keys %data);
            # printf $log_fh "Current Data Size: %d\n", $data_size;
            unshift @{$pdata->{$section}->{data}}, \%data;
            printf $log_fh "Current Number of Records: %d\n", scalar(@{$pdata->{$section}->{data}})
                if ($verbose >= MAXVERBOSE);
        }
        else
        {
            printf $log_fh "SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $number_tokens, $number_columns;
        }
    }
    #
    return 1;
}
#
######################################################################
#
# audit U01 files
#
######################################################################
#
# routines for Count and Time sections
# 
sub calculate_u01_name_value_delta
{
    my ($pdb, $pu01, $section) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    if ((($proc_option | PROC_OPT_IGN12) != 0) &&
        ($output_no == TIMER_NOT_RUNNING) &&
        ($section eq COUNT))
    {
        foreach my $key (keys %{$pu01->{$section}->{data}})
        {
            my $delta = 0;
            #
            my $KEY = $key;
            $KEY =~ tr/[a-z]/[A-Z]/;
            #
            if (exists($ignored_output12_fields{$KEY}))
            {
                 $delta = 0;
            }
            elsif (exists($pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$key}))
            {
                $delta = 
                    $pu01->{$section}->{data}->{$key} -
                    $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$key};
            }
            else
            {
                $delta = $pu01->{$section}->{data}->{$key};
                printf $log_fh "ERROR: [%s] %s key %s NOT found in cache. Taking counts (%d) as is.\n",
                    $filename, $section, $key, $delta;
            }
            #
            if ($delta >= 0)
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
            }
            elsif ($use_neg_delta == TRUE)
            {
                printf $log_fh "%d WARNING: [%s] using NEGATIVE delta for %s key %s: %d\n", __LINE__, $filename, $section, $key, $delta if ($verbose >= MINVERBOSE);
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
            }
            else
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = 0;
                printf $log_fh "%d WARNING: [%s] setting NEGATIVE delta (%d) for %s key %s to ZERO\n", __LINE__, $filename, $delta, $section, $key if ($verbose >= MINVERBOSE);
                set_red_flag($machine, $lane, $stage, $filename, $delta);
            }
            #
            printf $log_fh "%s: %s = %d\n", $section, $key, $delta
                if ($verbose >= MAXVERBOSE);
        }
    }
    else
    {
        foreach my $key (keys %{$pu01->{$section}->{data}})
        {
            my $delta = 0;
            #
            if (exists($pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$key}))
            {
                $delta = 
                    $pu01->{$section}->{data}->{$key} -
                    $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$key};
            }
            else
            {
                $delta = $pu01->{$section}->{data}->{$key};
                printf $log_fh "ERROR: [%s] %s key %s NOT found in cache. Taking counts (%d) as is.\n",
                    $filename, $section, $key, $delta;
            }
            #
            if ($delta >= 0)
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
            }
            elsif ($use_neg_delta == TRUE)
            {
                printf $log_fh "%d WARNING: [%s] using NEGATIVE delta for %s key %s: %d\n", __LINE__, $filename, $section, $key, $delta if ($verbose >= MINVERBOSE);
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
            }
            else
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = 0;
                printf $log_fh "%d WARNING: [%s] setting NEGATIVE delta (%d) for %s key %s to ZERO\n", __LINE__, $filename, $delta, $section, $key if ($verbose >= MINVERBOSE);
                set_red_flag($machine, $lane, $stage, $filename, $delta);
            }
            #
            printf $log_fh "%s: %s = %d\n", $section, $key, $delta
                if ($verbose >= MAXVERBOSE);
        }
    }
}
#
sub copy_u01_name_value_delta
{
    my ($pdb, $pu01, $section) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta};
    #
    foreach my $key (keys %{$pu01->{$section}->{data}})
    {
        my $delta = $pu01->{$section}->{data}->{$key};
        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
        printf "%s: %s = %d\n", $section, $key, $delta
            if ($verbose >= MAXVERBOSE);
    }
}
#
sub copy_u01_name_value_cache
{
    my ($pdb, $pu01, $section) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    foreach my $key (keys %{$pu01->{$section}->{data}})
    {
        $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$key} =
            $pu01->{$section}->{data}->{$key};
    }
}
#
sub tabulate_u01_name_value_delta
{
    my ($pdb, $pu01, $section) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $product = $pdb->{product}{u01}{$machine}{$lane}{$stage};
    #
    foreach my $key (keys %{$pu01->{$section}->{data}})
    {
        #
        # product dependent totals
        #
        if (exists($totals{by_product}{$product}{$section}{totals}{$key}))
        {
            $totals{by_product}{$product}{$section}{totals}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{by_product}{$product}{$section}{totals}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{by_product}{$product}{$section}{by_machine}{$machine}{$key}))
        {
            $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}{$key}))
        {
            $totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key}))
        {
            $totals{by_product}{$product}{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{by_product}{$product}{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        # product independent totals
        #
        if (exists($totals{$section}{totals}{$key}))
        {
            $totals{$section}{totals}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{totals}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{$section}{by_machine}{$machine}{$key}))
        {
            $totals{$section}{by_machine}{$machine}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine}{$machine}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{$section}{by_machine_lane}{$machine}{$lane}{$key}))
        {
            $totals{$section}{by_machine_lane}{$machine}{$lane}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine_lane}{$machine}{$lane}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        #
        if (exists($totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key}))
        {
            $totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} += 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} = 
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
    }
}
#
sub audit_u01_name_value
{
    my ($pdb, $pu01, $section) = @_;
    #
    set_report_name_value_precision($pu01, $section);
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    #
    my $mjsid = '';
    my $lotname = '';
    my $lotnumber = 0;
    #
    get_product_info($pu01, \$mjsid, \$lotname, \$lotnumber);
# printf $log_fh "%d: %s filename: %s, mjsid: %s, lotname: %s, lotnumber: %s\n", __LINE__, $section, $filename, $mjsid, $lotname, $lotnumber;
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu01->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(keys %{$pu01->{$section}->{data}});
    }
    #
    if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{state}))
    {
        printf $log_fh "ENTRY STATE: UNKNOWN\n"
            if ($verbose >= MAXVERBOSE);
        #
        if (($output_no == MANUAL_CLEAR) ||
            ($output_no == AUTO_CLEAR))
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = RESET;
            delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
        }
        else
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
            delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
            #
            copy_u01_name_value_cache($pdb, $pu01, $section);
        }
        printf $log_fh "EXIT STATE: %s\n", 
            $pdb->{$section}->{$machine}{$lane}{$stage}{state}
            if ($verbose >= MAXVERBOSE);
        #
        return;
    }
    #
    my $state = $pdb->{$section}->{$machine}{$lane}{$stage}{state};
    printf $log_fh "ENTRY STATE: %s\n", 
        $pdb->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    if (($output_no == MANUAL_CLEAR) ||
        ($output_no == AUTO_CLEAR))
    {
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = RESET;
        delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
    }
    elsif ($state eq DELTA)
    {
        calculate_u01_name_value_delta($pdb, $pu01, $section);
        tabulate_u01_name_value_delta($pdb, $pu01, $section);
        copy_u01_name_value_cache($pdb, $pu01, $section);
        #
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    elsif ($state eq RESET)
    {
        copy_u01_name_value_delta($pdb, $pu01, $section);
        tabulate_u01_name_value_delta($pdb, $pu01, $section);
        copy_u01_name_value_cache($pdb, $pu01, $section);
        #
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    elsif ($state eq BASELINE)
    {
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
        #
        copy_u01_name_value_cache($pdb, $pu01, $section);
        #
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    else
    {
        die "ERROR: unknown $section state: $state. Stopped";
    }
    printf $log_fh "EXIT STATE: %s\n", 
        $pdb->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    return;
}
#
######################################################################
#
# routines for feeder section
# 
sub calculate_u01_feeder_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $section = MOUNTPICKUPFEEDER;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $fadd = $prow->{FAdd};
        my $fsadd = $prow->{FSAdd};
        my $reelid = $prow->{ReelID};
        #
        my $is_tray = substr($fadd, -4, 2);
        if ($is_tray > 0)
        {
            $is_tray = TRUE;
            printf $log_fh "%d: [%s] %s IS tray part (%s) fadd: %s, fsadd: %s\n", __LINE__, $filename, $section, $is_tray, $fadd, $fsadd
                if ($verbose >= MAXVERBOSE);
        }
        else
        {
            $is_tray = FALSE;
            printf $log_fh "%d: [%s] %s IS NOT tray part (%s) fadd: %s, fsadd: %s\n", __LINE__, $filename, $section, $is_tray, $fadd, $fsadd
                if ($verbose >= MAXVERBOSE);
        }
        #
        if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{data}))
        {
            printf $log_fh "%d WARNING: [%s] %s FAdd %s, FSAdd %s NOT found in cache. Taking all counts as is.\n", __LINE__, $filename, $section, $fadd, $fsadd if ($verbose >= MINVERBOSE);
            foreach my $col (@{$pcols})
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = $prow->{$col};
            }
        }
        else
        {
            my $cache_reelid = $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{data}{ReelID};
            my $cache_filename = $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{filename};
            if (($reelid eq $cache_reelid) || ($is_tray == TRUE))
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{ReelID} = $reelid;
                #
                foreach my $col (@feeder_count_cols)
                {
                    my $u01_value = $prow->{$col};
                    my $cache_value = $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{data}{$col};
                    #
                    my $delta = $u01_value - $cache_value;
                    #
                    if ($delta >= 0)
                    {
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = $delta;
                    }
                    elsif ($use_neg_delta == TRUE)
                    {
                         printf $log_fh "%d WARNING: [%s] [%s] %s FAdd %s, FSAdd %s using NEGATIVE delta for key %s: %d\n", __LINE__, $filename, $cache_filename, $section, $fadd, $fsadd, $col, $delta if ($verbose >= MINVERBOSE);
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = $delta;
                    }
                    else
                    {
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = 0;
                         printf $log_fh "%d WARNING: [%s] [%s] %s FAdd %s, FSAdd %s setting NEGATIVE delta (%d) for key %s to ZERO; current value %d, cache value %d\n", __LINE__, $filename, $cache_filename, $section, $fadd, $fsadd, $delta, $col, $u01_value, $cache_value if ($verbose >= MINVERBOSE);
                        set_red_flag($machine, $lane, $stage, $filename, $delta);
                    }
                }
            }
            else
            {
                printf $log_fh "%d WARNING: [%s] %s FAdd %s, FSAdd %s REELID CHANGED: CACHED %s, CURRENT U01 %s\n", __LINE__, $filename, $section, $fadd, $fsadd, $cache_reelid, $reelid if ($verbose >= MINVERBOSE);
                #
                delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data};
                #
                foreach my $col (@{$pcols})
                {
                    $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = $prow->{$col};
                }
            }
        }
    }
}
#
sub copy_u01_feeder_cache
{
    my ($pdb, $pu01, $state) = @_;
    #
    my $section = MOUNTPICKUPFEEDER;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $fadd = $prow->{FAdd};
        my $fsadd = $prow->{FSAdd};
        #
        foreach my $col (@{$pcols})
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{data}{$col} = $prow->{$col};
        }
        #
        $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{state} = $state;
        $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$fadd}{$fsadd}{filename} = $filename;
    }
}
#
sub copy_u01_feeder_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $section = MOUNTPICKUPFEEDER;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $fadd = $prow->{FAdd};
        my $fsadd = $prow->{FSAdd};
        #
        foreach my $col (@{$pcols})
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col} = $prow->{$col};
        }
    }
}
#
sub tabulate_u01_feeder_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    my $section = MOUNTPICKUPFEEDER;
    #
    my $product = $pdb->{product}{u01}{$machine}{$lane}{$stage};
    #
    foreach my $fadd (sort { $a <=> $b } keys %{$pdb->{$section}{$machine}{$lane}{$stage}{delta}})
    {
        foreach my $fsadd (sort { $a <=> $b } keys %{$pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}})
        {
            my $reelid = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{ReelID};
            #
            # product-independent totals
            #
            if (exists($totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            #
            if (exists($totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            #
            if (exists($totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            #
            # product-dependent totals
            #
            if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            #
            if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            #
            if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}))
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@feeder_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$fadd}{$fsadd}{data}{$col};
                }
            }
        }
    }
}
#
sub audit_u01_feeders
{
    my ($pdb, $pu01) = @_;
    #
    set_report_feeder_precision($pu01);
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    my $section = MOUNTPICKUPFEEDER;
    my $filename = $pu01->{file_name};
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu01->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(@{$pu01->{$section}->{data}}) if (defined(@{$pu01->{$section}->{data}}));
    }
    #
    # check if the file has a feeder data section.
    #
    if ($output_no == TIMER_NOT_RUNNING)
    {
        printf $log_fh "No Feeder data in Output=%d U01 files. Skipping.\n", $output_no
            if ($verbose >= MAXVERBOSE);
        return;
    }
    elsif (($output_no == PROD_COMPLETE) ||
           ($output_no == PROD_COMPLETE_LATER))
    {
        if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{state}))
        {
            printf $log_fh "ENTRY STATE: UNKNOWN\n", 
                if ($verbose >= MAXVERBOSE);
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
            delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
            #
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq RESET)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            copy_u01_feeder_delta($pdb, $pu01);
            tabulate_u01_feeder_delta($pdb, $pu01);
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
            #
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq DELTA)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            calculate_u01_feeder_delta($pdb, $pu01);
            tabulate_u01_feeder_delta($pdb, $pu01);
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
            #
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        }
        else
        {
            my $state = $pdb->{$section}->{$machine}{$lane}{$stage}{state};
            die "ERROR: unknown $section state: $state. Stopped";
        }
    }
    elsif ($output_no == DETECT_CHANGE)
    {
        if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{state}))
        {
            printf $log_fh "ENTRY STATE: UNKNOWN\n", 
                if ($verbose >= MAXVERBOSE);
            #
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq RESET)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            copy_u01_feeder_delta($pdb, $pu01);
            tabulate_u01_feeder_delta($pdb, $pu01);
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq DELTA)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            calculate_u01_feeder_delta($pdb, $pu01);
            tabulate_u01_feeder_delta($pdb, $pu01);
            copy_u01_feeder_cache($pdb, $pu01, DELTA);
            #
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        }
        else
        {
            my $state = $pdb->{$section}->{$machine}{$lane}{$stage}{state};
            die "ERROR: unknown $section state: $state. Stopped";
        }
    }
    elsif (($output_no == MANUAL_CLEAR) ||
           ($output_no == AUTO_CLEAR))
    {
        printf $log_fh "ENTRY STATE: %s\n", 
            $pdb->{$section}->{$machine}{$lane}{$stage}{state}
            if ($verbose >= MAXVERBOSE);
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = RESET;
        delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
    }
    else
    {
        die "ERROR: unknown $section output type: $output_no. Stopped";
    }
    #
    printf $log_fh "EXIT STATE: %s\n", 
        $pdb->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    return;
}
#
######################################################################
#
# routines for nozzle section
#
sub calculate_u01_nozzle_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $section = MOUNTPICKUPNOZZLE;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $nhadd = $prow->{NHAdd};
        my $ncadd = $prow->{NCAdd};
        my $blkserial = $prow->{BLKSerial};
        #
        if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$nhadd}{$ncadd}{data}))
        {
            printf $log_fh "%d WARNING: [%s] %s NHAdd %s, NCAdd %s NOT found in cache. Taking all counts as is.\n", __LINE__, $filename, $section, $nhadd, $ncadd if ($verbose >= MINVERBOSE);
            foreach my $col (@{$pcols})
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = $prow->{$col};
            }
        }
        else
        {
            my $cache_blkserial = $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$nhadd}{$ncadd}{data}{BLKSerial};
            if ($blkserial eq $cache_blkserial)
            {
                $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{BLKSerial} = $blkserial;
                #
                foreach my $col (@nozzle_count_cols)
                {
                    my $u01_value = $prow->{$col};
                    my $cache_value = $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$nhadd}{$ncadd}{data}{$col};
                    #
                    my $delta = $u01_value - $cache_value;
                    #
                    if ($delta >= 0)
                    {
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = $delta;
                    }
                    elsif ($use_neg_delta == TRUE)
                    {
                         printf $log_fh "%d WARNING: [%s] %s NHAdd %s, NCAdd %s using NEGATIVE delta for key %s: %d\n", __LINE__, $filename, $section, $nhadd, $ncadd, $col, $delta if ($verbose >= MINVERBOSE);
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = $delta;
                    }
                    else
                    {
                        $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = 0;
                         printf $log_fh "%d WARNING: [%s] %s NHAdd %s, NCAdd %s setting NEGATIVE delta (%d) for key %s to ZERO\n", __LINE__, $filename, $section, $nhadd, $ncadd, $delta, $col if ($verbose >= MINVERBOSE);
                        set_red_flag($machine, $lane, $stage, $filename, $delta);
                    }
                }
            }
            else
            {
                printf $log_fh "%d WARNING: [%s] %s NHAdd %s, NCAdd %s BLKSERIAL CHANGED: CACHED %s, CURRENT U01 %s\n", __LINE__, $filename, $section, $nhadd, $ncadd, $cache_blkserial, $blkserial if ($verbose >= MINVERBOSE);
                #
                delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data};
                #
                foreach my $col (@{$pcols})
                {
                    $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = $prow->{$col};
                }
            }
        }
    }
}
#
sub copy_u01_nozzle_cache
{
    my ($pdb, $pu01, $state) = @_;
    #
    my $section = MOUNTPICKUPNOZZLE;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $nhadd = $prow->{NHAdd};
        my $ncadd = $prow->{NCAdd};
        #
        foreach my $col (@{$pcols})
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$nhadd}{$ncadd}{data}{$col} = $prow->{$col};
        }
        #
        $pdb->{$section}->{$machine}{$lane}{$stage}{cache}{$nhadd}{$ncadd}{state} = $state;
    }
}
#
sub copy_u01_nozzle_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $section = MOUNTPICKUPNOZZLE;
    #
    my $filename = $pu01->{file_name};
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    my $pcols = $pu01->{$section}->{column_names};
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{delta};
    #
    foreach my $prow (@{$pu01->{$section}->{data}})
    {
        my $nhadd = $prow->{NHAdd};
        my $ncadd = $prow->{NCAdd};
        #
        foreach my $col (@{$pcols})
        {
            $pdb->{$section}->{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col} = $prow->{$col};
        }
    }
}
#
sub tabulate_u01_nozzle_delta
{
    my ($pdb, $pu01) = @_;
    #
    my $filename = $pu01->{file_name};
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    my $section = MOUNTPICKUPNOZZLE;
    #
    my $product = $pdb->{product}{u01}{$machine}{$lane}{$stage};
    #
    foreach my $nhadd (sort { $a <=> $b } keys %{$pdb->{$section}{$machine}{$lane}{$stage}{delta}})
    {
        foreach my $ncadd (sort { $a <=> $b } keys %{$pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}})
        {
            my $blkserial = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{BLKSerial};
            #
            # product-independent totals
            #
            if (exists($totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}))
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            #
            if (exists($totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}))
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            #
            # product-dependent totals
            #
            if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}))
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            #
            if (exists($totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}))
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col} += $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
            else
            {
                foreach my $col (@nozzle_count_cols)
                {
                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col} = $pdb->{$section}{$machine}{$lane}{$stage}{delta}{$nhadd}{$ncadd}{data}{$col};
                }
            }
        }
    }
}
#
sub audit_u01_nozzles
{
    my ($pdb, $pu01) = @_;
    #
    set_report_nozzle_precision($pu01);
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    my $section = MOUNTPICKUPNOZZLE;
    my $filename = $pu01->{file_name};
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu01->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(@{$pu01->{$section}->{data}}) if (defined(@{$pu01->{$section}->{data}}));
    }
    #
    # check if the file has a nozzle data section.
    #
    if (($output_no == DETECT_CHANGE) ||
        ($output_no == TIMER_NOT_RUNNING))
    {
        printf $log_fh "No Nozzle data in Output=%d U01 files. Skipping.\n", $output_no
            if ($verbose >= MAXVERBOSE);
        return;
    }
    elsif (($output_no == PROD_COMPLETE) ||
           ($output_no == PROD_COMPLETE_LATER))
    {
        if ( ! exists($pdb->{$section}->{$machine}{$lane}{$stage}{state}))
        {
            printf $log_fh "ENTRY STATE: UNKNOWN\n", 
                if ($verbose >= MAXVERBOSE);
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
            delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
            #
            copy_u01_nozzle_cache($pdb, $pu01, DELTA);
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq RESET)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            copy_u01_nozzle_delta($pdb, $pu01);
            tabulate_u01_nozzle_delta($pdb, $pu01);
            copy_u01_nozzle_cache($pdb, $pu01, DELTA);
            #
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        }
        elsif ($pdb->{$section}->{$machine}{$lane}{$stage}{state} eq DELTA)
        {
            printf $log_fh "ENTRY STATE: %s\n", 
                $pdb->{$section}->{$machine}{$lane}{$stage}{state}
                if ($verbose >= MAXVERBOSE);
            calculate_u01_nozzle_delta($pdb, $pu01);
            tabulate_u01_nozzle_delta($pdb, $pu01);
            copy_u01_nozzle_cache($pdb, $pu01, DELTA);
            #
            $pdb->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        }
        else
        {
            my $state = $pdb->{$section}->{$machine}{$lane}{$stage}{state};
            die "ERROR: unknown $section state: $state. Stopped";
        }
    }
    elsif (($output_no == MANUAL_CLEAR) ||
           ($output_no == AUTO_CLEAR))
    {
        printf $log_fh "ENTRY STATE: %s\n", 
            $pdb->{$section}->{$machine}{$lane}{$stage}{state}
            if ($verbose >= MAXVERBOSE);
        $pdb->{$section}->{$machine}{$lane}{$stage}{state} = RESET;
        delete $pdb->{$section}->{$machine}{$lane}{$stage}{cache};
    }
    else
    {
        die "ERROR: unknown $section output type: $output_no. Stopped";
    }
    #
    printf $log_fh "EXIT STATE: %s\n", 
        $pdb->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    return;
}
#
######################################################################
#
# high-level u01 file audit functions
#
sub audit_u01_file
{
    my ($pdb, $pu01) = @_;
    #
    check_red_flag($pu01);
    set_product_info_u01($pdb, $pu01);
    #
    audit_u01_name_value($pdb, $pu01, COUNT);
    audit_u01_name_value($pdb, $pu01, TIME);
    audit_u01_feeders($pdb, $pu01);
    audit_u01_nozzles($pdb, $pu01);
    #
    return;
}
#
sub load_u01_sections
{
    my ($pu01) = @_;
    #
    load_name_value($pu01, INDEX);
    load_name_value($pu01, INFORMATION);
    #
    load_name_value($pu01, TIME);
    load_name_value($pu01, CYCLETIME);
    load_name_value($pu01, COUNT);
    load_list($pu01, DISPENSER);
    load_list($pu01, MOUNTPICKUPFEEDER);
    load_list($pu01, MOUNTPICKUPNOZZLE);
    load_name_value($pu01, INSPECTIONDATA);
}
#
sub audit_u01_files
{
    my ($pu01s, $pdb) = @_;
    #
    printf $log_fh "\nAudit U01 files:\n";
    #
    foreach my $pu01 (@{$pu01s})
    {
        printf $log_fh "\nAudit U01: %s\n", $pu01->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pu01) != 0);
        #
        load_u01_sections($pu01);
        #
        audit_u01_file($pdb, $pu01);
    }
    #
    return;
}
#
######################################################################
#
# print u01 file report functions
#
sub print_u01_count_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = COUNT;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine:\n", $section;
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine}})
    {
        printf $log_fh "Machine: %s\n", $machine;
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf $log_fh "\t%-${section_precision}s: %d\n", 
                $key, 
                $totals{$section}{by_machine}{$machine}{$key};
        }
    }
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine and Lane:\n", $section;
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}{$machine}})
        {
            printf $log_fh "Machine: %s, Lane: %s\n", $machine, $lane;
            foreach my $key (sort keys %{$totals{$section}{by_machine_lane}{$machine}{$lane}})
            {
                printf $log_fh "\t%-${section_precision}s: %d\n", 
                    $key, 
                    $totals{$section}{by_machine}{$machine}{$key};
            }
        }
    }
    #
    ###############################################################
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        $section = COUNT;
        $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For Product %s %s by Machine:\n", $product, $section;
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine}})
        {
            printf $log_fh "Machine: %s\n", $machine;
            foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine}{$machine}})
            {
                printf $log_fh "\t%-${section_precision}s: %d\n", 
                    $key, 
                    $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
            }
        }
    }
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        $section = COUNT;
        $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For Product %s %s by Machine and Lane:\n", $product, $section;
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}})
            {
                printf $log_fh "Machine: %s, Lane: %s\n", $machine, $lane;
                foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}})
                {
                    printf $log_fh "\t%-${section_precision}s: %d\n", 
                        $key, 
                        $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
                }
            }
        }
    }
}
#
sub print_u01_time_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = TIME;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine:\n", $section;
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine}})
    {
        printf $log_fh "Machine: %s\n", $machine;
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf $log_fh "\t%-${section_precision}s: %d\n", 
                $key, 
                $totals{$section}{by_machine}{$machine}{$key};
        }
    }
    #
    $section = TIME;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine and Lane:\n", $section;
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}{$machine}})
        {
            printf $log_fh "Machine: %s, Lane: %s\n", $machine, $lane;
            foreach my $key (sort keys %{$totals{$section}{by_machine_lane}{$machine}{$lane}})
            {
                printf $log_fh "\t%-${section_precision}s: %d\n", 
                    $key, 
                    $totals{$section}{by_machine}{$machine}{$key};
            }
        }
    }
    #
    ###############################################################
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        $section = TIME;
        $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For Product %s %s by Machine:\n", $product, $section;
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine}})
        {
            printf $log_fh "Machine: %s\n", $machine;
            foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine}{$machine}})
            {
                printf $log_fh "\t%-${section_precision}s: %d\n", 
                    $key, 
                    $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
            }
        }
    }
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        $section = TIME;
        $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For Product %s %s by Machine and Lane:\n", $product, $section;
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}})
            {
                printf $log_fh "Machine: %s, Lane: %s\n", $machine, $lane;
                foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}})
                {
                    printf $log_fh "\t%-${section_precision}s: %d\n", 
                        $key, 
                        $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
                }
            }
        }
    }
}
#
sub print_u01_nozzle_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = MOUNTPICKUPNOZZLE;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine, Lane, Stage, NHAdd, NCAdd, Blkserial:\n", $section;
    #
    foreach my $pcol (@nozzle_print_cols)
    {
        printf $log_fh  $pcol->{format}, $pcol->{name};
    }
    printf $log_fh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}})
            {
                foreach my $nhadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}})
                {
                    foreach my $ncadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}})
                    {
                        foreach my $blkserial (sort keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}})
                        {
                            printf $log_fh "%-8s %-8s %-8s %-8s %-8s %-30s ",
                                $machine, $lane, $stage, $nhadd, $ncadd, $blkserial;
                            foreach my $col (@nozzle_count_cols)
                            {
                                printf $log_fh "%-8d ", 
                                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col};
                            }
                            printf $log_fh "\n";
                        }
                    }
                }
            }
        }
    }
    #
    printf $log_fh "\nData For %s by Machine, Lane, Stage, NHAdd, NCAdd:\n", $section;
    #
    foreach my $pcol (@nozzle_print_cols2)
    {
        printf $log_fh  $pcol->{format}, $pcol->{name};
    }
    printf $log_fh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}})
            {
                foreach my $nhadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}})
                {
                    foreach my $ncadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}})
                    {
                        printf $log_fh "%-8s %-8s %-8s %-8s %-8s ",
                            $machine, $lane, $stage, $nhadd, $ncadd;
                        foreach my $col (@nozzle_count_cols)
                        {
                            printf $log_fh "%-8d ", 
                                $totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col};
                        }
                        printf $log_fh "\n";
                    }
                }
            }
        }
    }
    #
    ###############################################################
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        my $section = MOUNTPICKUPNOZZLE;
        my $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For %s %s by Machine, Lane, Stage, NHAdd, NCAdd, Blkserial:\n", $product, $section;
        #
        foreach my $pcol (@nozzle_print_cols)
        {
            printf $log_fh  $pcol->{format}, $pcol->{name};
        }
        printf $log_fh "\n";
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}})
                {
                    foreach my $nhadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}})
                    {
                        foreach my $ncadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}})
                        {
                            foreach my $blkserial (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}})
                            {
                                printf $log_fh "%-8s %-8s %-8s %-8s %-8s %-30s ",
                                    $machine, $lane, $stage, $nhadd, $ncadd, $blkserial;
                                foreach my $col (@nozzle_count_cols)
                                {
                                    printf $log_fh "%-8d ", 
                                        $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col};
                                }
                                printf $log_fh "\n";
                            }
                        }
                    }
                }
            }
        }
        #
        printf $log_fh "\nData For %s %s by Machine, Lane, Stage, NHAdd, NCAdd:\n", $product, $section;
        #
        foreach my $pcol (@nozzle_print_cols2)
        {
            printf $log_fh  $pcol->{format}, $pcol->{name};
        }
        printf $log_fh "\n";
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}})
                {
                    foreach my $nhadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}})
                    {
                        foreach my $ncadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}})
                        {
                            printf $log_fh "%-8s %-8s %-8s %-8s %-8s ",
                                $machine, $lane, $stage, $nhadd, $ncadd;
                            foreach my $col (@nozzle_count_cols)
                            {
                                printf $log_fh "%-8d ", 
                                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col};
                            }
                            printf $log_fh "\n";
                        }
                    }
                }
            }
        }
    }
}
#
sub print_u01_feeder_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = MOUNTPICKUPFEEDER;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nData For %s by Machine, Lane, Stage, FAdd, FSAdd, ReelID:\n", $section;
    #
    foreach my $pcol (@feeder_print_cols)
    {
        printf $log_fh  $pcol->{format}, $pcol->{name};
    }
    printf $log_fh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}})
            {
                foreach my $fadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}})
                {
                    foreach my $fsadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}})
                    {
                        foreach my $reelid (sort keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}})
                        {
                            printf $log_fh "%-8s %-8s %-8s %-8s %-8s %-30s ",
                                $machine, $lane, $stage, $fadd, $fsadd, $reelid;
                            foreach my $col (@feeder_count_cols)
                            {
                                printf $log_fh "%-8d ", 
                                    $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col};
                            }
                            printf $log_fh "\n";
                        }
                    }
                }
            }
        }
    }
    #
    printf $log_fh "\nData For %s by Machine, Lane, Stage, FAdd, FSAdd:\n", $section;
    #
    foreach my $pcol (@feeder_print_cols2)
    {
        printf $log_fh  $pcol->{format}, $pcol->{name};
    }
    printf $log_fh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}})
            {
                foreach my $fadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}})
                {
                    foreach my $fsadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}})
                    {
                        printf $log_fh "%-8s %-8s %-8s %-8s %-8s ",
                            $machine, $lane, $stage, $fadd, $fsadd;
                        foreach my $col (@feeder_count_cols)
                        {
                            printf $log_fh "%-8d ", 
                                $totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col};
                        }
                        printf $log_fh "\n";
                    }
                }
            }
        }
    }
    #
    ###############################################################
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        my $section = MOUNTPICKUPFEEDER;
        my $section_precision = $report_precision{$section}{precision};
        #
        printf $log_fh "\nData For %s %s by Machine, Lane, Stage, FAdd, FSAdd, ReelID:\n", $product, $section;
        #
        foreach my $pcol (@feeder_print_cols)
        {
            printf $log_fh  $pcol->{format}, $pcol->{name};
        }
        printf $log_fh "\n";
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}})
                {
                    foreach my $fadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}})
                    {
                        foreach my $fsadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}})
                        {
                            foreach my $reelid (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}})
                            {
                                printf $log_fh "%-8s %-8s %-8s %-8s %-8s %-30s ",
                                    $machine, $lane, $stage, $fadd, $fsadd, $reelid;
                                foreach my $col (@feeder_count_cols)
                                {
                                    printf $log_fh "%-8d ", 
                                        $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col};
                                }
                                printf $log_fh "\n";
                            }
                        }
                    }
                }
            }
        }
        #
        printf $log_fh "\nData For %s %s by Machine, Lane, Stage, FAdd, FSAdd:\n", $product, $section;
        #
        foreach my $pcol (@feeder_print_cols2)
        {
            printf $log_fh  $pcol->{format}, $pcol->{name};
        }
        printf $log_fh "\n";
        #
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}})
                {
                    foreach my $fadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}})
                    {
                        foreach my $fsadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}})
                        {
                            printf $log_fh "%-8s %-8s %-8s %-8s %-8s ",
                                $machine, $lane, $stage, $fadd, $fsadd;
                            foreach my $col (@feeder_count_cols)
                            {
                                printf $log_fh "%-8d ", 
                                    $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col};
                            }
                            printf $log_fh "\n";
                        }
                    }
                }
            }
        }
    }
}
#
sub print_u01_report
{
    my ($pdb) = @_;
    #
    print_u01_count_report($pdb);
    print_u01_time_report($pdb);
    print_u01_nozzle_report($pdb);
    print_u01_feeder_report($pdb);
}
#
######################################################################
#
# export u01 file report functions
#
sub export_u01_count_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = COUNT;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Total Data For %s:\n", $section;
    #
    my $first_time = TRUE;
    #
    open(my $outfh, ">" , "${export_dir}/COUNT_TOTALS.csv") || die $!;
    #
    foreach my $key (sort keys %{$totals{$section}{totals}})
    {
        if ($first_time == TRUE)
        {
            printf $outfh "%s", $key;
            $first_time = FALSE;
        }
        else
        {
            printf $outfh ",%s", $key;
        }
    }
    printf $outfh "\n";
    #
    $first_time = TRUE;
    foreach my $key (sort keys %{$totals{$section}{totals}})
    {
        if ($first_time == TRUE)
        {
            printf $outfh "%d", $totals{$section}{totals}{$key};
            $first_time = FALSE;
        }
        else
        {
            printf $outfh ",%d", $totals{$section}{totals}{$key};
        }
    }
    printf $outfh "\n";
    close($outfh);
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine:\n", $section;
    #
    $first_time = TRUE;
    #
    open($outfh, ">" , "${export_dir}/COUNT_BY_MACHINE.csv") || die $!;
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine}})
    {
        if ($first_time == TRUE)
        {
            printf $outfh "machine";
            foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
            {
                printf $outfh ",%s", $key;
            }
            printf $outfh "\n";
            $first_time = FALSE;
        }
        #
        printf $outfh "%s", $machine;
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf $outfh ",%d", $totals{$section}{by_machine}{$machine}{$key};
        }
        printf $outfh "\n";
    }
    close($outfh);
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine and Lane:\n", $section;
    #
    $first_time = TRUE;
    open($outfh, ">" , "${export_dir}/COUNT_BY_MACHINE_LANE.csv") || die $!;
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}{$machine}})
        {
            if ($first_time == TRUE)
            {
                printf $outfh "machine,lane";
                foreach my $key (sort keys %{$totals{$section}{by_machine_lane}{$machine}{$lane}})
                {
                    printf $outfh ",%s", $key;
                }
                printf $outfh "\n";
                $first_time = FALSE;
            }
            #
            printf $outfh "%s,%s,", $machine, $lane;
            foreach my $key (sort keys %{$totals{$section}{by_machine_lane}{$machine}{$lane}})
            {
                printf $outfh ",%d", $totals{$section}{by_machine}{$machine}{$key};
            }
            printf $outfh "\n";
        }
    }
    close($outfh);
    #
    ###############################################################
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Total Data For %s by Product:\n", $section;
    #
    $first_time = TRUE;
    open($outfh, ">" , "${export_dir}/COUNT_TOTALS_BY_PRODUCT.csv") || die $!;
    foreach my $product (sort keys %{$totals{by_product}})
    {
        if ($first_time == TRUE)
        {
            printf $outfh "product";
            foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{totals}})
            {
                printf $outfh ",%s", $key;
            }
            printf $outfh "\n";
            $first_time = FALSE;
        }
        #
        printf $outfh "%s", $product;
        foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{totals}})
        {
            printf $outfh ",%d", $totals{by_product}{$product}{$section}{totals}{$key};
        }
        printf $outfh "\n";
    }
    close($outfh);
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Product and Machine:\n", $section;
    #
    $first_time = TRUE;
    open($outfh, ">" , "${export_dir}/COUNT_BY_PRODUCT_MACHINE.csv") || die $!;
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine}})
        {
            if ($first_time == TRUE)
            {
                printf $outfh "product,machine";
                foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine}{$machine}})
                {
                    printf $outfh ",%s", $key;
                }
                printf $outfh "\n";
                $first_time = FALSE;
            }
            #
            printf $outfh "%s,%s", $product, $machine;
            foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine}{$machine}})
            {
                printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
            }
            printf $outfh "\n";
        }
    }
    close($outfh);
    #
    $section = COUNT;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Product, Machine and Lane:\n", $section;
    #
    $first_time = TRUE;
    open($outfh, ">" , "${export_dir}/COUNT_BY_PRODUCT_MACHINE_LANE.csv") || die $!;
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}})
            {
                if ($first_time == TRUE)
                {
                    printf $outfh "product,machine,lane";
                    foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}})
                    {
                        printf $outfh ",%s", $key;
                    }
                    printf $outfh "\n";
                    $first_time = FALSE;
                }
                #
                printf $outfh "%s,%s,%s", $product, $machine, $lane;
                foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}})
                {
                    printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
                }
                printf $outfh "\n";
            }
        }
    }
    close($outfh);
}
#
sub export_u01_time_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = TIME;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine:\n", $section;
    #
    open(my $outfh, ">" , "${export_dir}/TIME_BY_MACHINE.csv") || die $!;
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine}})
    {
        printf $outfh "%s", $machine;
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf $outfh ",%d", $totals{$section}{by_machine}{$machine}{$key};
        }
        printf $outfh "\n", 
    }
    close($outfh);
    #
    $section = TIME;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine and Lane:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/TIME_BY_MACHINE_LANE.csv") || die $!;
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane}{$machine}})
        {
            printf $outfh "%s,%s", $machine, $lane;
            foreach my $key (sort keys %{$totals{$section}{by_machine_lane}{$machine}{$lane}})
            {
                printf $outfh ",%d", $totals{$section}{by_machine}{$machine}{$key};
            }
            printf $outfh "\n";
        }
    }
    close($outfh);
    #
    ###############################################################
    #
    $section = TIME;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Product and Machine:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/TIME_BY_PRODUCT_MACHINE.csv") || die $!;
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine}})
        {
            printf $outfh "%s,%s", $product, $machine;
            foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine}{$machine}})
            {
                printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
            }
            printf $outfh "\n";
        }
    }
    close($outfh);
    #
    printf $log_fh "\nExport Data For %s by Product, Machine and Lane:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/TIME_BY_PRODUCT_MACHINE_LANE.csv") || die $!;
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}})
            {
                printf $outfh "%s,s,%s", $product, $machine, $lane;
                foreach my $key (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane}{$machine}{$lane}})
                {
                    printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine}{$machine}{$key};
                }
                printf $outfh "\n";
            }
        }
    }
    close($outfh);
}
#
sub export_u01_nozzle_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = MOUNTPICKUPNOZZLE;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine, Lane, Stage, NHAdd, NCAdd, Blkserial:\n", $section;
    #
    open(my $outfh, ">" , "${export_dir}/NOZZLE_BY_MACHINE_LANE_STAGE_NHADD_NCADD_BLKSERIAL.csv") || die $!;
    foreach my $pcol (@nozzle_export_cols)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}})
            {
                foreach my $nhadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}})
                {
                    foreach my $ncadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}})
                    {
                        foreach my $blkserial (sort keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}})
                        {
                            printf $outfh "%s,%s,%s,%s,%s,%s",
                                $machine, $lane, $stage, $nhadd, $ncadd, $blkserial;
                            foreach my $col (@nozzle_count_cols)
                            {
                                printf $outfh ",%d", 
                                    $totals{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col};
                            }
                            printf $outfh "\n";
                        }
                    }
                }
            }
        }
    }
    close($outfh);
    #
    printf $log_fh "\nExport Data For %s by Machine, Lane, Stage, NHAdd, NCAdd:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/NOZZLE_BY_MACHINE_LANE_STAGE_NHADD_NCADD.csv") || die $!;
    printf $outfh "Product,";
    foreach my $pcol (@nozzle_export_cols2)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}})
            {
                foreach my $nhadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}})
                {
                    foreach my $ncadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}})
                    {
                        printf $outfh "%s,%s,%s,%s,%s", $machine, $lane, $stage, $nhadd, $ncadd;
                        foreach my $col (@nozzle_count_cols)
                        {
                            printf $outfh ",%d", $totals{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col};
                        }
                        printf $outfh "\n";
                    }
                }
            }
        }
    }
    close($outfh);
    #
    ###############################################################
    #
    $section = MOUNTPICKUPNOZZLE;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Product, Machine, Lane, Stage, NHAdd, NCAdd, Blkserial:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/NOZZLE_BY_MACHINE_LANE_STAGE_NHADD_NCADD_BLKSERIAL.csv") || die $!;
    printf $outfh "Product,";
    foreach my $pcol (@nozzle_export_cols)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}})
                {
                    foreach my $nhadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}})
                    {
                        foreach my $ncadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}})
                        {
                            foreach my $blkserial (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}})
                            {
                                printf $outfh "%s,%s,%s,%s,%s,%s,%s", $product, $machine, $lane, $stage, $nhadd, $ncadd, $blkserial;
                                foreach my $col (@nozzle_count_cols)
                                {
                                    printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd_blkserial}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$blkserial}{$col};
                                }
                                printf $outfh "\n";
                            }
                        }
                    }
                }
            }
        }
    }
    close($outfh);
    #
    printf $log_fh "\nExport Data For %s by Product, Machine, Lane, Stage, NHAdd, NCAdd:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/NOZZLE_BY_PRODUCT_MACHINE_LANE_STAGE_NHADD_NCADD.csv") || die $!;
    printf $outfh "Product,";
    foreach my $pcol (@nozzle_export_cols2)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}})
                {
                    foreach my $nhadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}})
                    {
                        foreach my $ncadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}})
                        {
                            printf $outfh "%s,%s,%s,%s,%s,%s",
                                $product, $machine, $lane, $stage, $nhadd, $ncadd;
                            foreach my $col (@nozzle_count_cols)
                            {
                                printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine_lane_stage_nhadd_ncadd}{$machine}{$lane}{$stage}{$nhadd}{$ncadd}{$col};
                            }
                            printf $outfh "\n";
                        }
                    }
                }
            }
        }
    }
    close($outfh);
}
#
sub export_u01_feeder_report
{
    my ($pdb) = @_;
    #
    ###############################################################
    #
    my $section = MOUNTPICKUPFEEDER;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Machine, Lane, Stage, FAdd, FSAdd, ReelID:\n", $section;
    #
    open(my $outfh, ">" , "${export_dir}/FEEDER_BY_MACHINE_LANE_STAGE_FADD_FSADD_REELID.csv") || die $!;
    foreach my $pcol (@feeder_export_cols)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}})
            {
                foreach my $fadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}})
                {
                    foreach my $fsadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}})
                    {
                        foreach my $reelid (sort keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}})
                        {
                            printf $outfh "%s,%s,%s,%s,%s,%s", $machine, $lane, $stage, $fadd, $fsadd, $reelid;
                            foreach my $col (@feeder_count_cols)
                            {
                                printf $outfh ",%d", $totals{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col};
                            }
                            printf $outfh "\n";
                        }
                    }
                }
            }
        }
    }
    close($outfh);
    #
    printf $log_fh "\nExport Data For %s by Machine, Lane, Stage, FAdd, FSAdd:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/FEEDER_BY_MACHINE_LANE_STAGE_FADD_FSADD.csv") || die $!;
    foreach my $pcol (@feeder_export_cols2)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $machine (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}})
    {
        foreach my $lane (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}})
        {
            foreach my $stage (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}})
            {
                foreach my $fadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}})
                {
                    foreach my $fsadd (sort { $a <=> $b } keys %{$totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}})
                    {
                        printf $outfh "%s,%s,%s,%s,%s", $machine, $lane, $stage, $fadd, $fsadd;
                        foreach my $col (@feeder_count_cols)
                        {
                            printf $outfh ",%d", $totals{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col};
                        }
                        printf $outfh "\n";
                    }
                }
            }
        }
    }
    close($outfh);
    #
    ###############################################################
    #
    $section = MOUNTPICKUPFEEDER;
    $section_precision = $report_precision{$section}{precision};
    #
    printf $log_fh "\nExport Data For %s by Product, Machine, Lane, Stage, FAdd, FSAdd, ReelID:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/FEEDER_BY_PRODUCT_MACHINE_LANE_STAGE_FADD_FSADD_REELID.csv") || die $!;
    printf $outfh "Product,";
    foreach my $pcol (@feeder_export_cols)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}})
                {
                    foreach my $fadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}})
                    {
                        foreach my $fsadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}})
                        {
                            foreach my $reelid (sort keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}})
                            {
                                printf $outfh "%s,%s,%s,%s,%s,%s,%s", $product, $machine, $lane, $stage, $fadd, $fsadd, $reelid;
                                foreach my $col (@feeder_count_cols)
                                {
                                    printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd_reelid}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$reelid}{$col};
                                }
                                printf $outfh "\n";
                            }
                        }
                    }
                }
            }
        }
    }
    close($outfh);
    #
    printf $log_fh "\nExport Data For %s by Product, Machine, Lane, Stage, FAdd, FSAdd:\n", $section;
    #
    open($outfh, ">" , "${export_dir}/FEEDER_BY_PRODUCT_MACHINE_LANE_STAGE_FADD_FSADD.csv") || die $!;
    printf $outfh "Product,";
    foreach my $pcol (@feeder_export_cols2)
    {
        printf $outfh $pcol->{format}, $pcol->{name};
    }
    printf $outfh "\n";
    #
    foreach my $product (sort keys %{$totals{by_product}})
    {
        foreach my $machine (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}})
        {
            foreach my $lane (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}})
            {
                foreach my $stage (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}})
                {
                    foreach my $fadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}})
                    {
                        foreach my $fsadd (sort { $a <=> $b } keys %{$totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}})
                        {
                            printf $outfh "%s,%s,%s,%s,%s,%s", $product, $machine, $lane, $stage, $fadd, $fsadd;
                            foreach my $col (@feeder_count_cols)
                            {
                                printf $outfh ",%d", $totals{by_product}{$product}{$section}{by_machine_lane_stage_fadd_fsadd}{$machine}{$lane}{$stage}{$fadd}{$fsadd}{$col};
                            }
                            printf $outfh "\n";
                        }
                    }
                }
            }
        }
    }
    close($outfh);
}
#
sub export_u01_report
{
    my ($pdb) = @_;
    #
    export_u01_count_report($pdb);
    export_u01_time_report($pdb);
    export_u01_nozzle_report($pdb);
    export_u01_feeder_report($pdb);
}
#
sub process_u01_files
{
    my ($pu01s) = @_;
    #
    # any files to process?
    #
    if (scalar(@{$pu01s}) <= 0)
    {
        printf $log_fh "No U01 files to process. Returning.\n\n";
        return;
    }
    #
    my %db = ();
    audit_u01_files($pu01s, \%db);
    #
    unless ($audit_only == TRUE)
    {
        if ($export_csv == TRUE)
        {
            export_u01_report(\%db);
        }
        else
        {
            print_u01_report(\%db);
        }
    }
    #
    return;
}
#
######################################################################
#
# audit U03 files
#
sub load_u03_sections
{
    my ($pu03) = @_;
    #
    load_name_value($pu03, INDEX);
    load_name_value($pu03, INFORMATION);
    #
    load_list($pu03, BRECG);
    load_list($pu03, BRECGCALC);
    load_list($pu03, ELAPSETIMERECOG);
    load_list($pu03, SBOARD);
    load_list($pu03, HEIGHTCORRECT);
    load_list($pu03, MOUNTQUALITYTRACE);
    load_list($pu03, MOUNTLATESTREEL);
    load_list($pu03, MOUNTEXCHANGEREEL);
}
#
# don't need this. leave it for now in case that changes.
#
sub copy_u03_data
{
    my ($pdb, $pu03, $section) = @_;
    #
    my $filename = $pu03->{file_name};
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    #
    my $pcols = $pu03->{$section}->{column_names};
    $pdb->{$section}->{$machine}{$lane}{$stage}{column_names} = $pcols;
    #
    delete $pdb->{$section}->{$machine}{$lane}{$stage}{data};
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$pdb->{$section}->{$machine}{$lane}{$stage}{data}}, $prow;
    }
}
#
sub tabulate_u03_quality_trace
{
    my ($pdb, $pu03) = @_;
    #
    my $filename = $pu03->{file_name};
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    #
    my $section = MOUNTQUALITYTRACE;
    my $product = $pdb->{product}{u03}{$machine}{$lane}{$stage};
    #
    my $pcols = $pu03->{$section}->{column_names};
    $totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
    #
    $totals{$section}{by_product_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{by_product}{$product}{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
}
#
sub tabulate_u03_latest_reel
{
    my ($pdb, $pu03) = @_;
    #
    my $filename = $pu03->{file_name};
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    #
    my $section = MOUNTLATESTREEL;
    my $product = $pdb->{product}{u03}{$machine}{$lane}{$stage};
    #
    my $pcols = $pu03->{$section}->{column_names};
    $totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
    #
    $totals{$section}{by_product_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{by_product}{$product}{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
}
#
sub tabulate_u03_exchange_reel
{
    my ($pdb, $pu03) = @_;
    #
    my $filename = $pu03->{file_name};
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    #
    my $section = MOUNTEXCHANGEREEL;
    my $product = $pdb->{product}{u03}{$machine}{$lane}{$stage};
    #
    my $pcols = $pu03->{$section}->{column_names};
    $totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
    #
    $totals{$section}{by_product_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{column_names} = $pcols;
    #
    foreach my $prow (@{$pu03->{$section}->{data}})
    {
        unshift @{$totals{by_product}{$product}{$section}{by_machine_lane_stage_filename}{$machine}{$lane}{$stage}{$filename}{data}}, $prow;
    }
}
#
sub audit_u03_mount_quality_trace
{
    my ($pdb, $pu03) = @_;
    #
    set_report_quality_trace_precision($pu03);
    #
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    my $section = MOUNTQUALITYTRACE;
    my $filename = $pu03->{file_name};
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu03->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(@{$pu03->{$section}->{data}}) if (defined(@{$pu03->{$section}->{data}}));
    }
    #
    # check if the file has a quality trace section.
    #
    return unless (($output_no == PROD_COMPLETE) ||
                   ($output_no == PROD_COMPLETE_LATER));
    #
    tabulate_u03_quality_trace($pdb, $pu03);
    #
    return;
}
#
sub audit_u03_mount_latest_reel
{
    my ($pdb, $pu03) = @_;
    #
    set_report_latest_reel_precision($pu03);
    #
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    my $section = MOUNTLATESTREEL;
    my $filename = $pu03->{file_name};
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu03->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(@{$pu03->{$section}->{data}}) if (defined(@{$pu03->{$section}->{data}}));
    }
    #
    # check if the file has a latest_reel section.
    #
    return unless (($output_no == PROD_COMPLETE) ||
                   ($output_no == PROD_COMPLETE_LATER));
    #
    tabulate_u03_latest_reel($pdb, $pu03);
    #
    return;
}
#
sub audit_u03_mount_exchange_reel
{
    my ($pdb, $pu03) = @_;
    #
    set_report_exchange_reel_precision($pu03);
    #
    my $machine = $pu03->{mach_no};
    my $lane = $pu03->{lane};
    my $stage = $pu03->{stage};
    my $output_no = $pu03->{output_no};
    my $section = MOUNTEXCHANGEREEL;
    my $filename = $pu03->{file_name};
    #
    printf $log_fh "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf $log_fh "MACHINE  : %s\n", $machine;
        printf $log_fh "LANE     : %d\n", $lane;
        printf $log_fh "STAGE    : %d\n", $stage;
        printf $log_fh "OUTPUT NO: %s\n", $output_no;
        printf $log_fh "FILE RECS : %d\n", scalar(@{$pu03->{data}});
        printf $log_fh "%s RECS: %d\n", $section, scalar(@{$pu03->{$section}->{data}}) if (defined(@{$pu03->{$section}->{data}}));
    }
    #
    # check if the file has a latest reel section.
    #
    return unless (($output_no == PROD_COMPLETE) ||
                   ($output_no == PROD_COMPLETE_LATER));
    #
    tabulate_u03_exchange_reel($pdb, $pu03);
    #
    return;
}
#
sub audit_u03_file
{
    my ($pdb, $pu03) = @_;
    #
    set_product_info_u03($pdb, $pu03);
    #
    audit_u03_mount_quality_trace($pdb, $pu03);
    audit_u03_mount_latest_reel($pdb, $pu03);
    audit_u03_mount_exchange_reel($pdb, $pu03);
    #
    return;
}
#
sub audit_u03_files
{
    my ($pu03s, $pdb) = @_;
    #
    printf $log_fh "\nAudit U03 files:\n";
    #
    foreach my $pu03 (@{$pu03s})
    {
        printf $log_fh "\nAudit u03: %s\n", $pu03->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pu03) != 0);
        #
        load_u03_sections($pu03, INDEX);
        #
        audit_u03_file($pdb, $pu03);
    }
    #
    return;
}
#
sub export_u01_mount_quality_trace_report
{
    my ($pdb) = @_;
}
#
sub export_u01_mount_latest_reel_report
{
    my ($pdb) = @_;
}
#
sub export_u01_mount_exchange_reel_report
{
    my ($pdb) = @_;
}
#
sub export_u03_report
{
    my ($pdb) = @_;
    #
    export_u01_mount_quality_trace_report($pdb);
    export_u01_mount_latest_reel_report($pdb);
    export_u01_mount_exchange_reel_report($pdb);
}
#
sub print_u03_report
{
    my ($pdb) = @_;
    #
}
#
sub process_u03_files
{
    my ($pu03s) = @_;
    #
    if (scalar(@{$pu03s}) <= 0)
    {
        printf $log_fh "\nNo U03 files to process. Returning.\n\n";
        return;
    }
    #
    my %db = ();
    audit_u03_files($pu03s, \%db);
    #
    unless ($audit_only == TRUE)
    {
        if ($export_csv == TRUE)
        {
            export_u03_report(\%db);
        }
        else
        {
            print_u03_report(\%db);
        }
    }
    #
    return;
}
#
######################################################################
#
# audit MPR files
#
sub load_mpr_sections
{
    my ($pmpr) = @_;
    #
    load_name_value($pmpr, INDEX);
    load_name_value($pmpr, INFORMATION);
    #
    load_list($pmpr, TIMEDATASP);
    load_list($pmpr, COUNTDATASP);
    load_list($pmpr, COUNTDATASP2);
    load_list($pmpr, TRACEDATASP);
    load_list($pmpr, TRACEDATASP_2);
    load_list($pmpr, ISPINFODATA);
    load_list($pmpr, MASKISPINFODATA);
}
#
sub audit_mpr_files
{
    my ($pmprs, $pdb) = @_;
    #
    printf $log_fh "\nAudit MPR files:\n";
    #
    foreach my $pmpr (@{$pmprs})
    {
        printf $log_fh "\nAudit mpr: %s\n", $pmpr->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pmpr) != 0);
        #
        load_mpr_sections($pmpr);
    }
    #
    return;
}
#
sub process_mpr_files
{
    my ($pmprs) = @_;
    #
    if (scalar(@{$pmprs}) <= 0)
    {
        printf $log_fh "\nNo MPR files to process. Returning.\n\n";
        return;
    }
    #
    my %db = ();
    audit_mpr_files($pmprs, \%db);
    #
    return;
}
#
######################################################################
#
# scan directories for U01, U03 and MPR files.
#
my %all_list = ();
my $one_type = '';
#
sub want_one_type
{
    if ($_ =~ m/^.*\.${one_type}$/)
    {
        printf $log_fh "FOUND %s FILE: %s\n", $one_type, $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        #
        my $file_name = $_;
        #
        my $date = '';
        my $mach_no = '';
        my $stage = '';
        my $lane = '';
        my $pcb_serial = '';
        my $pcb_id = '';
        my $output_no = '';
        my $pcb_id_lot_no = '';
        #
        my @parts = split('\+-\+', $file_name);
        if (scalar(@parts) >= 9)
        {
            $date          = $parts[0];
            $mach_no       = $parts[1];
            $stage         = $parts[2];
            $lane          = $parts[3];
            $pcb_serial    = $parts[4];
            $pcb_id        = $parts[5];
            $output_no     = $parts[6];
            $pcb_id_lot_no = $parts[7];
        }
        else
        {
            @parts = split('-', $file_name);
            if (scalar(@parts) >= 9)
            {
                $date          = $parts[0];
                $mach_no       = $parts[1];
                $stage         = $parts[2];
                $lane          = $parts[3];
                $pcb_serial    = $parts[4];
                $pcb_id        = $parts[5];
                $output_no     = $parts[6];
                $pcb_id_lot_no = $parts[7];
            }
        }
        #
        unshift @{$all_list{$one_type}},
        {
            'file_name'     => $file_name,
            'full_path'     => $File::Find::name,
            'directory'     => $File::Find::dir,
            'date'          => $date,
            'mach_no'       => $mach_no,
            'stage'         => $stage,
            'lane'          => $lane,
            'pcb_serial'    => $pcb_serial,
            'pcb_id'        => $pcb_id,
            'output_no'     => $output_no,
            'pcb_id_lot_no' => $pcb_id_lot_no
        };
    }
}
#
sub want_all_types
{
    my $dt = '';
    #
    if ($_ =~ m/^.*\.u01$/)
    {
        printf $log_fh "FOUND u01 FILE: %s\n", $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        $dt = 'u01';
    }
    elsif ($_ =~ m/^.*\.u03$/)
    {
        printf $log_fh "FOUND u03 FILE: %s\n", $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        $dt = 'u03';
    }
    elsif ($_ =~ m/^.*\.mpr$/)
    {
        printf $log_fh "FOUND mpr FILE: %s\n", $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        $dt = 'mpr';
    }
    #
    if ($dt ne '')
    {
        my $file_name = $_;
        #
        my $date = '';
        my $mach_no = '';
        my $stage = '';
        my $lane = '';
        my $pcb_serial = '';
        my $pcb_id = '';
        my $output_no = '';
        my $pcb_id_lot_no = '';
        #
        my @parts = split('\+-\+', $file_name);
        if (scalar(@parts) >= 9)
        {
            $date          = $parts[0];
            $mach_no       = $parts[1];
            $stage         = $parts[2];
            $lane          = $parts[3];
            $pcb_serial    = $parts[4];
            $pcb_id        = $parts[5];
            $output_no     = $parts[6];
            $pcb_id_lot_no = $parts[7];
        }
        else
        {
            @parts = split('-', $file_name);
            if (scalar(@parts) >= 9)
            {
                $date          = $parts[0];
                $mach_no       = $parts[1];
                $stage         = $parts[2];
                $lane          = $parts[3];
                $pcb_serial    = $parts[4];
                $pcb_id        = $parts[5];
                $output_no     = $parts[6];
                $pcb_id_lot_no = $parts[7];
            }
        }
        #
        unshift @{$all_list{$dt}},
        {
            'file_name'     => $file_name,
            'full_path'     => $File::Find::name,
            'directory'     => $File::Find::dir,
            'date'          => $date,
            'mach_no'       => $mach_no,
            'stage'         => $stage,
            'lane'          => $lane,
            'pcb_serial'    => $pcb_serial,
            'pcb_id'        => $pcb_id,
            'output_no'     => $output_no,
            'pcb_id_lot_no' => $pcb_id_lot_no
        };
    }
}
#
sub get_all_files
{
    my ($ftype, $pargv, $pu01, $pu03, $pmpr) = @_;
    #
    # optimize for file type
    #
    if ($ftype eq 'u01')
    {
        $one_type = $ftype;
        $all_list{$one_type} = $pu01;
        #
        find(\&want_one_type, @{$pargv});
        #
        @{$pu01} = sort { $a->{file_name} cmp $b->{file_name} } @{$pu01};
    }
    elsif ($ftype eq 'u03')
    {
        $one_type = $ftype;
        $all_list{$one_type} = $pu03;
        #
        find(\&want_one_type, @{$pargv});
        #
        @{$pu03} = sort { $a->{file_name} cmp $b->{file_name} } @{$pu03};
    }
    elsif ($ftype eq 'mpr')
    {
        $one_type = $ftype;
        $all_list{$one_type} = $pmpr;
        #
        find(\&want_one_type, @{$pargv});
        #
        @{$pmpr} = sort { $a->{file_name} cmp $b->{file_name} } @{$pmpr};
    }
    else
    {
        $all_list{u01} = $pu01;
        $all_list{u03} = $pu03;
        $all_list{mpr} = $pmpr;
        #
        find(\&want_all_types, @{$pargv});
        #
        @{$pu01} = sort { $a->{file_name} cmp $b->{file_name} } @{$pu01};
        @{$pu03} = sort { $a->{file_name} cmp $b->{file_name} } @{$pu03};
        @{$pmpr} = sort { $a->{file_name} cmp $b->{file_name} } @{$pmpr};
    }
}
#
#########################################################################
#
# start of script
#
my %opts;
if (getopts('?L:O:anxhwWv:d:t:r:', \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (%opts)
{
    if ($opt eq "h")
    {
        usage($cmd);
        exit 0;
    }
    elsif ($opt eq "w")
    {
        $verbose = MINVERBOSE;
    }
    elsif ($opt eq "W")
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq "a")
    {
        $audit_only = TRUE; 
    }
    elsif ($opt eq "x")
    {
        $export_csv = TRUE; 
    }
    elsif ($opt eq "n")
    {
        $use_neg_delta = 1; 
        printf $log_fh "Will USE negative delta values.\n";
    }
    elsif ($opt eq "t")
    {
        $file_type = $opts{$opt};
        $file_type =~ tr/[A-Z]/[a-z]/;
        if ($file_type !~ m/^(u01|u03|mpr)$/i)
        {
            printf $log_fh "\nInvalid file type: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq "O")
    {
        my $option = $opts{$opt};
        $option =~ tr/[a-z]/[A-Z]/;
        if ($option eq "IGN12")
        {
            $proc_option |= PROC_OPT_IGN12;
        }
        else
        {
            printf $log_fh "\nInvalid option type: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq "L")
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        printf $log_fh "\nLog File: %s\n", $logfile;
    }
    elsif ($opt eq "r")
    {
        $red_flag_trigger = $opts{$opt};
        if (($red_flag_trigger !~ m/^[0-9][0-9]*$/) ||
            ($red_flag_trigger < 0))
        {
            printf $log_fh "\nInvalid Red Flag value; must be integer > 0.\n";
            usage($cmd);
            exit 2;
        }
        printf $log_fh "\nRed Flag trigger value: %d\n", $red_flag_trigger;
    }
    elsif ($opt eq "d")
    {
        $export_dir = $opts{$opt};
        printf $log_fh "\nExport directory: %s\n", $export_dir;
    }
    elsif ($opt eq "v")
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $verbose = $opts{$opt};
        }
        elsif (exist($verbose_levels{$opts{$opt}}))
        {
            $verbose = $verbose_levels{$opts{$opt}};
        }
        else
        {
            printf $log_fh "\nInvalid verbose level: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
}
#
if (scalar(@ARGV) == 0)
{
    printf $log_fh "No directories given.\n";
    usage($cmd);
    exit 2;
}
#
printf $log_fh "\nScan directories for U01, U03 and MPR files: \n\n";
#
my @u01_files = ();
my @u03_files = ();
my @mpr_files = ();
#
init_report_precision();
#
get_all_files($file_type,
             \@ARGV,
             \@u01_files,
             \@u03_files,
             \@mpr_files);
printf $log_fh "Number of U01 files: %d\n", scalar(@u01_files);
printf $log_fh "Number of U03 files: %d\n", scalar(@u03_files);
printf $log_fh "Number of MPR files: %d\n\n", scalar(@mpr_files);
#
process_u01_files(\@u01_files);
process_u03_files(\@u03_files);
process_mpr_files(\@mpr_files);
#
printf $log_fh "\nAll Done\n";
#
exit 0;
