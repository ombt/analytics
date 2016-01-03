#!/usr/bin/perl -w
#########################################################################
#
# audit LNB data files: u01, u03, mpr.
#
#########################################################################
#
use strict;
#
use Getopt::Std;
use File::Find;
#
# output type constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant PROD_COMPLETE => 3;
use constant PROD_COMPLETE_LATER => 4;
use constant DETECT_CHANGE => 5;
use constant MANUAL_CLEAR => 11;
use constant TIMER_NOT_RUNNING => 12;
use constant AUTO_CLEAR => 13;
#
use constant RESET => 'reset';
use constant BASELINE => 'baseline';
use constant DELTA => 'delta';
#
use constant INDEX => '[Index]';
use constant INFORMATION => '[Information]';
use constant TIME => '[Time]';
use constant CYCLETIME => '[CycleTime]';
use constant COUNT => '[Count]';
use constant DISPENSER => '[Dispenser]';
use constant MOUNTPICKUPFEEDER => '[MountPickupFeeder]';
use constant MOUNTPICKUPNOZZLE => '[MountPickupNozzle]';
use constant INSPECTIONDATA => '[InspectionData]';
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
use constant TIMEDATASP => '[TimeDataSP]';
use constant COUNTDATASP => '[CountDataSP]';
use constant COUNTDATASP2 => '[CountDataSP2]';
use constant TRACEDATASP => '[TraceDataSP]';
use constant TRACEDATASP_2 => '[TraceDataSP_2]';
use constant ISPINFODATA => '[ISPInfoData]';
use constant MASKISPINFODATA => '[MaskISPInfoData]';
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
# globals
#
my $cmd = $0;
my $dummy = 0;
my $verbose = 0;
my $file_type = ""; # default is all files: u01, u03, mpr
my $use_neg_delta = FALSE; 
#
my %verbose_levels =
(
    off => 0,
    min => 1,
    mid => 2,
    max => 3
);
#
# summary tables.
#
my %totals = ();
my %report_precision = ();
#
sub usage
{
    my ($arg0) = @_;
    print <<EOF;

usage: $arg0 [-?] [-h] \\ 
        [-v |-V level] \\ 
        [-d value] \\ 
        [-t u10|u03|mpr] \\ 
        [-n] \\
        directory ...

where:
    -? or -h - print usage.
    -v - verbose (level=min=1)
    -V - verbose level: 0=off,1=min,2=mid,3=max
    -d value - dummy
    -t file-type = type of file to process: u01, u03, mpr.
                   default is all files.
    -n - use negative deltas (default is NOT to use)

EOF
}
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
}
#
my %all_list = ();
my $one_type = '';
#
sub want_one_type
{
    if ($_ =~ m/^.*\.${one_type}$/)
    {
        printf "FOUND %s FILE: %s\n", $one_type, $File::Find::name 
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
        printf "FOUND u01 FILE: %s\n", $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        $dt = 'u01';
    }
    elsif ($_ =~ m/^.*\.u03$/)
    {
        printf "FOUND u03 FILE: %s\n", $File::Find::name 
            if ($verbose >= MAXVERBOSE);
        $dt = 'u03';
    }
    elsif ($_ =~ m/^.*\.mpr$/)
    {
        printf "FOUND mpr FILE: %s\n", $File::Find::name 
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
sub load
{
    my ($pdata) = @_;
    #
    my $path = $pdata->{full_path};
    #
    if ( ! -r $path )
    {
        printf "\nERROR: file $path is NOT readable\n\n";
        return 0;
    }
    #
    unless (open(INFD, $path))
    {
        printf "\nERROR: unable to open $path.\n\n";
        return 0;
    }
    @{$pdata->{data}} = <INFD>;
    close(INFD);
    #
    # remove newlines
    #
    chomp(@{$pdata->{data}});
    printf "Lines read: %d\n", scalar(@{$pdata->{data}})
        if ($verbose >= MAXVERBOSE);
    #
    return 1;
}
#
sub load_name_value
{
    my ($pdata, $section) = @_;
    #
    printf "\nLoading Name-Value Section: %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    my $re_section = '\\' . $section;
    @{$pdata->{raw}->{$section}} = 
        grep /^${re_section}\s*$/ .. /^\s*$/, @{$pdata->{data}};
    #
    # printf "<%s>\n", join("\n", @{$pdata->{raw}->{$section}});
    #
    if (scalar(@{$pdata->{raw}->{$section}}) <= 2)
    {
        $pdata->{$section} = {};
        printf "No data found.\n"
            if ($verbose >= MAXVERBOSE);
        return 1;
    }
    #
    shift @{$pdata->{raw}->{$section}};
    pop @{$pdata->{raw}->{$section}};
    #
    printf "Section Lines: %d\n", scalar(@{$pdata->{raw}->{$section}})
        if ($verbose >= MAXVERBOSE);
    #
    %{$pdata->{$section}->{data}} = 
        map { split /\s*=\s*/, $_, 2 } @{$pdata->{raw}->{$section}};
    printf "Number of Keys: %d\n", scalar(keys %{$pdata->{$section}->{data}})
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
            $token .= $c;
            if ($c eq '"')
            {
                $in_string = 0;
            }
        }
        elsif ($c eq '"')
        {
            $token = $c;
            $in_string = 1;
        }
        elsif ($c eq ' ')
        {
            # printf "Token ... <%s>\n", $token;
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
        # printf "Token ... <%s>\n", $token;
        push (@tokens, $token);
        $token = '';
    }
    #
    # printf "Tokens: \n%s\n", join("\n",@tokens);
    #
    return @tokens;
}
#
sub load_list
{
    my ($pdata, $section) = @_;
    #
    printf "\nLoading List Section: %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    my $re_section = '\\' . $section;
    @{$pdata->{raw}->{$section}} = 
        grep /^${re_section}\s*$/ .. /^\s*$/, @{$pdata->{data}};
    #
    # printf "<%s>\n", join("\n", @{$pdata->{raw}->{$section}});
    #
    if (scalar(@{$pdata->{raw}->{$section}}) <= 3)
    {
        $pdata->{$section} = {};
        printf "No data found.\n"
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
    printf "Section Lines: %d\n", scalar(@{$pdata->{raw}->{$section}})
        if ($verbose >= MAXVERBOSE);
    # printf "Column Names: %d\n", $number_columns;
    foreach my $record (@{$pdata->{raw}->{$section}})
    {
        # printf "\nRECORD: %s\n", $record;
        #
        # printf "\nRECORD (original): %s\n", $record;
        # $record =~ s/"\s+"\s/"" /g;
        # $record =~ s/"\s+"\s*$/""/g;
        # printf "\nRECORD (final): %s\n", $record;
        # my @tokens = split / /, $record;
        #
        my @tokens = split_quoted_string($record);
        my $number_tokens = scalar(@tokens);
        printf "Number of tokens in record: %d\n", $number_tokens
            if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pdata->{$section}->{column_names}}} = @tokens;
            my $data_size = scalar(keys %data);
            # printf "Current Data Size: %d\n", $data_size;
            unshift @{$pdata->{$section}->{data}}, \%data;
            printf "Current Number of Records: %d\n", scalar(@{$pdata->{$section}->{data}})
                if ($verbose >= MAXVERBOSE);
        }
        else
        {
            printf "SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $number_tokens, $number_columns;
        }
    }
    #
    return 1;
}
#
sub calculate_u01_name_value_delta
{
    my ($pcache, $pu01, $section) = @_;
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
        my $delta = 0;
        #
        if (exists($pcache->{$section}->{$machine}{$lane}{$stage}{data}{$key}))
        {
            $delta = 
                $pu01->{$section}->{data}->{$key} -
                $pcache->{$section}->{$machine}{$lane}{$stage}{data}{$key};
        }
        else
        {
            $delta = $pu01->{$section}->{data}->{$key};
            printf "ERROR: [%s] %s key %s NOT found in cache. Taking counts (%d) as is.\n",
                $filename, $section, $key, $delta;
        }
        #
        if ($delta >= 0)
        {
            $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
        }
        elsif ($use_neg_delta == TRUE)
        {
            printf "WARNING: [%s] using NEGATIVE delta for %s key %s: %d\n",
                $filename, $section, $key, $delta;
            $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
        }
        else
        {
            $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = 0;
            printf "WARNING: [%s] setting NEGATIVE delta (%d) for %s key %s to ZERO\n",
                $filename, $delta, $section, $key;
        }
        #
        printf "%s: %s = %d\n", $section, $key, $delta
            if ($verbose >= MAXVERBOSE);
    }
}
#
sub copy_u01_name_value_delta
{
    my ($pcache, $pu01, $section) = @_;
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
        my $delta = $pu01->{$section}->{data}->{$key};
        $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key} = $delta;
        printf "%s: %s = %d\n", $section, $key, $delta
            if ($verbose >= MAXVERBOSE);
    }
}
#
sub copy_u01_name_value_cache
{
    my ($pcache, $pu01, $section) = @_;
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
        $pcache->{$section}->{$machine}{$lane}{$stage}{data}{$key} =
            $pu01->{$section}->{data}->{$key};
    }
}
#
sub tabulate_u01_name_value_delta
{
    my ($pcache, $pu01, $section) = @_;
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
        if (exists($totals{$section}{by_machine}{$machine}{$key}))
        {
            $totals{$section}{by_machine}{$machine}{$key} += 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine}{$machine}{$key} = 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        if (exists($totals{$section}{by_machine_lane}{$machine}{$lane}{$key}))
        {
            $totals{$section}{by_machine_lane}{$machine}{$lane}{$key} += 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine_lane}{$machine}{$lane}{$key} = 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        if (exists($totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key}))
        {
            $totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} += 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
        else
        {
            $totals{$section}{by_machine_lane_stage}{$machine}{$lane}{$stage}{$key} = 
                $pcache->{$section}->{$machine}{$lane}{$stage}{delta}{$key};
        }
    }
}
#
sub set_report_precision
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
sub audit_u01_name_value
{
    my ($pcache, $pu01, $section) = @_;
    #
    set_report_precision($pu01, $section);
    #
    my $machine = $pu01->{mach_no};
    my $lane = $pu01->{lane};
    my $stage = $pu01->{stage};
    my $output_no = $pu01->{output_no};
    #
    printf "\nSECTION  : %s\n", $section
        if ($verbose >= MAXVERBOSE);
    #
    if ($verbose >= MAXVERBOSE)
    {
        printf "MACHINE  : %s\n", $machine;
        printf "LANE     : %d\n", $lane;
        printf "STAGE    : %d\n", $stage;
        printf "OUTPUT NO: %s\n", $output_no;
        printf "FILE RECS : %d\n", scalar(@{$pu01->{data}});
        printf "%s RECS: %d\n", $section, scalar(keys %{$pu01->{$section}->{data}});
    }
    #
    if ( ! exists($pcache->{$section}->{$machine}{$lane}{$stage}{state}))
    {
        printf "ENTRY STATE: UNKNOWN\n"
            if ($verbose >= MAXVERBOSE);
        #
        if (($output_no == MANUAL_CLEAR) ||
            ($output_no == AUTO_CLEAR))
        {
            $pcache->{$section}->{$machine}{$lane}{$stage}{state} = RESET;
            $pcache->{$section}->{$machine}{$lane}{$stage}{data} = undef;
        }
        else
        {
            $pcache->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
            $pcache->{$section}->{$machine}{$lane}{$stage}{data} = undef;
            #
            copy_u01_name_value_cache($pcache, $pu01, $section);
        }
        printf "EXIT STATE: %s\n", 
            $pcache->{$section}->{$machine}{$lane}{$stage}{state}
            if ($verbose >= MAXVERBOSE);
        #
        return;
    }
    #
    my $state = $pcache->{$section}->{$machine}{$lane}{$stage}{state};
    printf "ENTRY STATE: %s\n", 
        $pcache->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    if ($state eq DELTA)
    {
        calculate_u01_name_value_delta($pcache, $pu01, $section);
        tabulate_u01_name_value_delta($pcache, $pu01, $section);
        copy_u01_name_value_cache($pcache, $pu01, $section);
        #
        $pcache->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    elsif ($state eq RESET)
    {
        copy_u01_name_value_delta($pcache, $pu01, $section);
        tabulate_u01_name_value_delta($pcache, $pu01, $section);
        copy_u01_name_value_cache($pcache, $pu01, $section);
        #
        $pcache->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    elsif ($state eq BASELINE)
    {
        $pcache->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
        $pcache->{$section}->{$machine}{$lane}{$stage}{data} = undef;
        #
        copy_u01_name_value_cache($pcache, $pu01, $section);
        #
        $pcache->{$section}->{$machine}{$lane}{$stage}{state} = DELTA;
    }
    else
    {
        die "ERROR: unknown $section state: $state. Stopped";
    }
    printf "EXIT STATE: %s\n", 
        $pcache->{$section}->{$machine}{$lane}{$stage}{state}
        if ($verbose >= MAXVERBOSE);
    #
    return;
}
#
sub audit_u01_feeders
{
    my ($pcache, $pu01) = @_;
    #
    return;
}
#
sub audit_u01_nozzles
{
    my ($pcache, $pu01) = @_;
    #
    return;
}
#
sub audit_u01_file
{
    my ($pcache, $pu01) = @_;
    #
    audit_u01_name_value($pcache, $pu01, COUNT);
    audit_u01_name_value($pcache, $pu01, TIME);
    audit_u01_feeders($pcache, $pu01);
    audit_u01_nozzles($pcache, $pu01);
    #
    return;
}
#
sub audit_u01_files
{
    my ($pu01s, $pcache) = @_;
    #
    printf "\nAudit U01 files:\n";
    #
    foreach my $pu01 (@{$pu01s})
    {
        printf "\nAudit U01: %s\n", $pu01->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pu01) != 0);
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
        #
        audit_u01_file($pcache, $pu01);
    }
    #
    return;
}
#
sub print_u01_report
{
    my ($pcache) = @_;
    #
    my $section = COUNT;
    my $section_precision = $report_precision{$section}{precision};
    #
    printf "\nData For %s:\n", $section;
    #
    foreach my $machine (sort keys %{$totals{$section}{by_machine}})
    {
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf "%${section_precision}s: %d\n", 
                $key, 
                $totals{$section}{by_machine}{$machine}{$key};
        }
    }
    #
    $section = TIME;
    $section_precision = $report_precision{$section}{precision};
    #
    printf "\nData For %s:\n", $section;
    #
    foreach my $machine (sort keys %{$totals{$section}{by_machine}})
    {
        foreach my $key (sort keys %{$totals{$section}{by_machine}{$machine}})
        {
            printf "%${section_precision}s: %d\n", 
                $key, 
                $totals{$section}{by_machine}{$machine}{$key};
        }
    }
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
        printf "No U01 files to process. Returning.\n\n";
        return;
    }
    #
    my %cache = ();
    audit_u01_files($pu01s, \%cache);
    print_u01_report(\%cache);
    #
    return;
}
#
sub audit_u03_files
{
    my ($pu03s, $pcache) = @_;
    #
    printf "\nAudit U03 files:\n";
    #
    foreach my $pu03 (@{$pu03s})
    {
        printf "\nAudit u03: %s\n", $pu03->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pu03) != 0);
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
    return;
}
#
sub process_u03_files
{
    my ($pu03s) = @_;
    #
    if (scalar(@{$pu03s}) <= 0)
    {
        printf "No U03 files to process. Returning.\n\n";
        return;
    }
    #
    my %cache = ();
    audit_u03_files($pu03s, \%cache);
    #
    return;
}
#
sub audit_mpr_files
{
    my ($pmprs, $pcache) = @_;
    #
    printf "\nAudit MPR files:\n";
    #
    foreach my $pmpr (@{$pmprs})
    {
        printf "\nAudit mpr: %s\n", $pmpr->{file_name}
            if ($verbose >= MIDVERBOSE);
        #
        next unless (load($pmpr) != 0);
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
    return;
}
#
sub process_mpr_files
{
    my ($pmprs) = @_;
    #
    if (scalar(@{$pmprs}) <= 0)
    {
        printf "No MPR files to process. Returning.\n\n";
        return;
    }
    #
    my %cache = ();
    audit_mpr_files($pmprs, \%cache);
    #
    return;
}
#
#########################################################################
#
# start of script
#
my %opts;
if (getopts('?nhvV:d:t:', \%opts) != 1)
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
    elsif ($opt eq "v")
    {
        $verbose = 1;
    }
    elsif ($opt eq "n")
    {
        $use_neg_delta = 1; 
        printf "Will USE negative delta values.\n";
    }
    elsif ($opt eq "t")
    {
        $file_type = $opts{$opt};
        $file_type =~ tr/[A-Z]/[a-z]/;
        if ($file_type !~ m/^(u01|u03|mpr)$/i)
        {
            printf "\nInvalid file type: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq "d")
    {
        $dummy = $opts{$opt};
    }
    elsif ($opt eq "V")
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
            printf "\nInvalid verbose level: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
}
#
if (scalar(@ARGV) == 0)
{
    printf "No directories given.\n";
    usage($cmd);
    exit 2;
}
#
printf "\nScan directories for U01, U03 and MPR files: \n\n";
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
printf "Number of U01 files: %d\n", scalar(@u01_files);
printf "Number of U03 files: %d\n", scalar(@u03_files);
printf "Number of MPR files: %d\n\n", scalar(@mpr_files);
#
process_u01_files(\@u01_files);
process_u03_files(\@u03_files);
process_mpr_files(\@mpr_files);
#
printf "\nAll Done\n";
#
exit 0;
