#!/usr/bin/perl -w
#
################################################################
#
# parse an AOI XML file line-by-line
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
        [-llogfile] [-T ] \\ 
        AOI-file [AOI-file ...]

where:
    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace

EOF
}
#
sub process_defect
{
    my ($aoi_file, 
        $praw_data, 
        $paoi_db, 
        $maxi, 
        $pi, 
        $pcmpi, 
        $pdefecti) = @_;
    #
    my $status = FAIL;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/defect>$/i)
        {
            $$pi += 1;
            $$pdefecti += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<lead_id>(.*)<\/lead_id>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{cmp}->[$$pcmpi]->{defect}->[$$pdefecti]->{lead_id} = $1;
        }
        elsif ($line =~ m/^<insp_type>(.*)<\/insp_type>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{cmp}->[$$pcmpi]->{defect}->[$$pdefecti]->{insp_type} = $1;
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_cmp
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi, $pcmpi) = @_;
    #
    my $status = FAIL;
    #
    my $defecti = 0;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/cmp>$/i)
        {
            $$pi += 1;
            $$pcmpi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<type>(.*)<\/type>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{cmp}->[$$pcmpi]->{type} = $1;
        }
        elsif ($line =~ m/^<ref>(.*)<\/ref>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{cmp}->[$$pcmpi]->{ref} = $1;
        }
        elsif ($line =~ m/^<cc>(.*)<\/cc>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{cmp}->[$$pcmpi]->{cc} = $1;
        }
        elsif ($line =~ m/^<defect>$/i)
        {
            $$pi += 1;
            #
            $status = process_defect($aoi_file, 
                                     $praw_data, 
                                     $paoi_db, 
                                     $maxi, 
                                     $pi,
                                     $pcmpi,
                                    \$defecti);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing DEFECT for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_p
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi) = @_;
    #
    my $status = FAIL;
    #
    my $cmpi = 0;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/p>$/i)
        {
            $$pi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<fc>(.*)<\/fc>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{fc} = $1;
        }
        elsif ($line =~ m/^<pid>(.*)<\/pid>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{pid} = $1;
        }
        elsif ($line =~ m/^<sc>(.*)<\/sc>$/i)
        {
            $$pi += 1;
            $paoi_db->{p}->{sc} = $1;
        }
        elsif ($line =~ m/^<cmp>$/i)
        {
            $$pi += 1;
            #
            $status = process_cmp($aoi_file, 
                                  $praw_data, 
                                  $paoi_db, 
                                  $maxi, 
                                  $pi, 
                                 \$cmpi);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing CMP for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_insp
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi) = @_;
    #
    my $status = FAIL;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/insp>$/i)
        {
            $$pi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<P>$/i)
        {
            $$pi += 1;
            #
            $status = process_p($aoi_file, 
                                $praw_data, 
                                $paoi_db, 
                                $maxi, 
                                $pi);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing P for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        elsif ($line =~ m/^<recipename>(.*)<\/recipename>$/i)
        {
            $$pi += 1;
            $paoi_db->{recipename} = $1;
        }
        elsif ($line =~ m/^<timestamp>(.*)<\/timestamp>$/i)
        {
            $$pi += 1;
            $paoi_db->{timestamp} = $1;
        }
        elsif ($line =~ m/^<mid>(.*)<\/mid>$/i)
        {
            $$pi += 1;
            $paoi_db->{mid} = $1;
        }
        elsif ($line =~ m/^<cid>(.*)<\/cid>$/i)
        {
            $$pi += 1;
            $paoi_db->{cid} = $1;
        }
        elsif ($line =~ m/^<c2d>(.*)<\/c2d>$/i)
        {
            $$pi += 1;
            $paoi_db->{c2d} = $1;
        }
        elsif ($line =~ m/^<crc>(.*)<\/crc>$/i)
        {
            $$pi += 1;
            $paoi_db->{crc} = $1;
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_data
{
    my ($aoi_file, $praw_data, $paoi_db) = @_;
    #
    my $status = FAIL;
    my $maxi = scalar(@{$praw_data});
    #
    for (my $i=0; $i<$maxi; )
    {
        my $line = $praw_data->[$i];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($i+1), $line);
        #
        if ($line =~ m/^<INSP>$/i)
        {
            $i += 1;
            #
            $status = process_insp($aoi_file, 
                                   $praw_data, 
                                   $paoi_db, 
                                   $maxi, 
                                  \$i);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing INSP for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $i += 1;
        }
    }
    #
    return $status;
}
#
sub export_to_stdout
{
    my ($aoi_file, $paoi_db) = @_;
    #
    $plog->log_vmin("Dumper: %s\n", Dumper($paoi_db));
    #
    return SUCCESS;
}
#
sub process_file
{
    my ($aoi_file) = @_;
    #
    $plog->log_msg("Processing AOI File: %s\n", $aoi_file);
    #
    my @raw_data = ();
    my %aoi_db = ();
    #
    my $status = FAIL;
    if ($putils->read_file($aoi_file, \@raw_data) != SUCCESS)
    {
        $plog->log_err("Reading AOI file: %s\n", $aoi_file);
    }
    elsif (process_data($aoi_file, \@raw_data, \%aoi_db) != SUCCESS)
    {
        $plog->log_err("Processing AOI file: %s\n", $aoi_file);
    }
    elsif (export_to_stdout($aoi_file, \%aoi_db) != SUCCESS)
    {
        $plog->log_err("Exporting AOI file to STDOUT: %s\n", $aoi_file);
    }
    else
    {
        $plog->log_msg("Success processing AOI file: %s\n", $aoi_file);
        $status = SUCCESS;
    }
    #
    return $status;
}
#
################################################################
#
# start of main
#
$plog->disable_stdout_buffering();
#
my %opts;
if (getopts('?hwWv:l:T', \%opts) != 1)
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
    elsif ($opt eq 'T')
    {
        $plog->trace(TRUE);
    }
    elsif ($opt eq 'l')
    {
        $plog->logfile($opts{$opt});
        $plog->log_msg("Log File: %s\n", $opts{$opt});
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
        $plog->log_err("No AOI files given.\n");
        usage($cmd);
        exit 2;
    }
    #
    foreach my $aoi_file (@ARGV)
    {
        my $status = process_file($aoi_file);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $aoi_file);
        }
    }
}
else
{
    $plog->log_msg("Reading STDIN for list of files ...\n");
    #
    while( defined(my $aoi_file = <STDIN>) )
    {
        chomp($aoi_file);
        my $status = process_file($aoi_file);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $aoi_file);
        }
    }
}
#
exit 0;
