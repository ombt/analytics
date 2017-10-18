#!/usr/bin/perl -w
#
#########################################################################
#
use strict;
#
use FileHandle;
use File::Basename;
use Getopt::Std;
# use Cwd;
use POSIX;
#
#########################################################################
#
# denormalized data
#
# r.route_id 
# r.route_name 
# rl.pos 
# rl.zone_id 
# z.zone_name 
# z.trace_level 
# z.module_id 
# zl.pos 
# zl.equipment_id 
# sh.equipment_id 
# sh.panel_equipment_id 
# sh.trx_product_id 
# sh.master_strace_id 
# sh.panel_strace_id 
# sh.timestamp 
# p.panel_id 
# p.equipment_id 
# p.nc_version 
# p.start_time 
# p.end_time 
# p.panel_equipment_id 
# p.panel_source 
# p.panel_trace 
# p.stage_no 
# p.lane_no 
# p.job_id 
# p.setup_id 
# p.trx_product_id 
# td.serial_no 
# td.barcode 
# td.prod_model_no 
# td.panel_id 
# td.pattern_id 
# td.setup_id 
# td.top_bottom 
# td.timestamp 
# td.import_flag
#
# p.panel_id 
# td.panel_id 
#
# p.panel_equipment_id 
# sh.panel_equipment_id 
#
#########################################################################
#
# tables and fields
# 
# panel_strace_header panel_equipment_id
# panel_strace_header equipment_id
# panel_strace_header master_strace_id
# panel_strace_header panel_strace_id
# panel_strace_header timestamp
# panel_strace_header trx_product_id
# 
# panel_strace_details panel_strace_id
# panel_strace_details reel_id
# panel_strace_details z_num
# panel_strace_details pu_num
# panel_strace_details part_no
# panel_strace_details custom_area1
# panel_strace_details custom_area2
# panel_strace_details custom_area3
# panel_strace_details custom_area4
# panel_strace_details feeder_bc
# 
# panels panel_id
# panels equipment_id
# panels nc_version
# panels start_time
# panels end_time
# panels panel_equipment_id
# panels panel_source
# panels panel_trace
# panels stage_no
# panels lane_no
# panels job_id
# panels setup_id
# panels trx_product_id
# 
# tracking_data serial_no
# tracking_data prod_model_no
# tracking_data panel_id
# tracking_data pattern_id
# tracking_data barcode
# tracking_data setup_id
# tracking_data top_bottom
# tracking_data timestamp
# tracking_data import_flag
#
# product_run_history product_run_history_id
# product_run_history equipment_id
# product_run_history lane_no
# product_run_history setup_id
# product_run_history start_time
# product_run_history end_time
#
#########################################################################
#
# global variables and local functions
#
my $cmd = $0;
my $verbose = 0;
my $phase = 0;
my $logfile = '';
my $log_fh = *STDOUT;
my $audit = 0;
#
sub usage
{
	my ($arg0) = @_;
	print <<EOF;

usage: $arg0 [-?] [-h] \\ 
		[-L logfile] \\ 
		[-V level] \\ 
		[-P level] \\ 
		[-A] 	
		trace_data_file \\ 
		product_run_history_data_file \\ 
		max_panel_id_data_file \\ 
		generated_sql_file

where:
	-? - print usage.
	-h - print usage.
	-L logfile - name of log file; stdout by default.
	-V level - verbose level: 0=off,1=on
	-P phase - fix phase: 0=off,>0=max-phase to execute
	-A - turn on internal audit. off by default. very noisy.

EOF
}
#
sub read_raw_file
{
	my ($msg, $pfile, $pdata) = @_;
	#
	open(RTDIN, $pfile) or die $!;
	@{$pdata} = <RTDIN>;
	close(RTDIN);
	#
	printf $log_fh "\nNumber Of %s Records Read: %d\n", $msg, scalar(@{$pdata});
}
#
sub store_product_run_history
{
	my ($praw, $pprh) = @_;
	#
	chomp(@{$praw});
	#
	my @cols = split(/\t/, shift @{$praw});
	my @prh = ();
	while (scalar(@{$praw}) > 0)
	{
		my @data = split(/\t/, shift @{$praw});
		my %hash = ();
		@hash{@cols} = @data;
		unshift @prh, \%hash;
	}
	printf $log_fh "\nNumber Of Product Run History Records: %d\n", scalar(@prh);
	#
	my $curr_equip_id = -1;
	my $curr_lane_no = -1;
	#
	foreach my $phash (@prh)
	{
		my $hist_id = $phash->{'prh.product_run_history_id'};
		my $equip_id = $phash->{'prh.equipment_id'};
		my $lane_no = $phash->{'prh.lane_no'};
		my $setup_id = $phash->{'prh.setup_id'};
		my $start_time = $phash->{'prh.start_time'};
		my $end_time = $phash->{'prh.end_time'};
		#
		unshift @{$pprh->{$equip_id}{$lane_no}},
		{
			'prh.product_run_history_id' => $hist_id,
			'prh.equipment_id' => $equip_id,
			'prh.setup_id' => $setup_id,
			'prh.start_time' => $start_time,
			'prh.end_time' => $end_time
		};
	}
	#
	# verify the entries are ascending.
	#
	return unless ($audit == 1);
	#
	foreach my $eqid (sort keys %{$pprh})
	{
		foreach my $lane (sort keys %{$pprh->{$eqid}})
		{
			my $pdata = $pprh->{$eqid}{$lane};
			my $max = $#$pdata;
			my $cnt = scalar(@{$pdata});
			printf $log_fh "\nPRH Data - Equip ID: %d, Lane: %d, Max: %d, Cnt: %d\n", $eqid, $lane, $max, $cnt;
			#
			my $prev_st = 0;
			for (my $i=0; $i<$cnt; $i++)
			{
				my $st = $pprh->{$eqid}{$lane}->[$i]->{'prh.start_time'};
				printf $log_fh "\t%04d: %d %d %d", $i, $eqid, $lane, $st;
				if ($prev_st < $st)
				{
					printf $log_fh " LT OK\n";
				}
				elsif ($prev_st > $st)
				{
					printf $log_fh " GT NOT OK\n";
				}
				else
				{
					printf $log_fh " EQ OK\n";
				}
			}
		}
	}
}
sub store_max_panel_ids
{
	my ($praw, $pdata) = @_;
	#
	chomp(@{$praw});
	#
	my @sh_cols = split(/\t/, shift @{$praw});
	my @sh_data = split(/\t/, shift @{$praw});
	my %sh_hash = ();
	@sh_hash{@sh_cols} = @sh_data;
	@{$pdata}{keys %sh_hash } = values %sh_hash;
	#
	my @p_cols = split(/\t/, shift @{$praw});
	my @p_data = split(/\t/, shift @{$praw});
	my %p_hash = ();
	@p_hash{@p_cols} = @p_data;
	@{$pdata}{keys %p_hash } = values %p_hash;
	#
	my @td_cols = split(/\t/, shift @{$praw});
	my @td_data = split(/\t/, shift @{$praw});
	my %td_hash = ();
	@td_hash{@td_cols} = @td_data;
	@{$pdata}{keys %td_hash } = values %td_hash;
	#
	printf $log_fh "\nMax Panel IDs:\n";
	#
	foreach my $key (sort keys %{$pdata})
	{
		printf $log_fh "%s ==>> %d\n", $key, $pdata->{$key};
	}
}
#
sub get_prh_setup_id
{
	my ($equip_id, $lane_no, $timestamp, $pprh) = @_;
	#
	my $setup_id = -1;
	my $match_ts = -1;
	#
	if (exists($pprh->{$equip_id}{$lane_no}))
	{
		printf $log_fh "Equip ID: %d, Lane NO: %d, Time: %d, Size: %d FOUND!\n", $equip_id, $lane_no, $timestamp, scalar(@{$pprh->{$equip_id}{$lane_no}}) if ($verbose > 0);
		#
		my $min = 0;
		my $max = scalar(@{$pprh->{$equip_id}{$lane_no}}) - 1;
		my $mid = floor(($max + $min)/2);
		my $prev_mid = $mid;
		my $last_cmp = 'eq';
		#
		my $pdata = $pprh->{$equip_id}{$lane_no};
		#
		while ($min <= $max)
		{
			my $min_ts = $pdata->[$min]->{'prh.start_time'};
			my $max_ts = $pdata->[$max]->{'prh.start_time'};
			my $mid_ts = $pdata->[$mid]->{'prh.start_time'};
			printf $log_fh "MIN: %d, MID: %d, MAX: %d, TS: %d, MINTS: %d, MIDTS: %d, MAXTS: %d", $min, $mid, $max, $timestamp, $min_ts, $mid_ts, $max_ts if (($audit == 1) && ($verbose > 0));
			if ($timestamp < $mid_ts)
			{
				$last_cmp = 'lt';
				$prev_mid = $mid;
				$max = $mid - 1;
				$mid = floor(($max + $min)/2);
				printf $log_fh " LT\n" if (($audit == 1) && ($verbose > 0));
			}
			elsif ($timestamp > $mid_ts)
			{
				$last_cmp = 'gt';
				$prev_mid = $mid;
				$min = $mid + 1;
				$mid = floor(($max + $min)/2);
				printf $log_fh " GT\n" if (($audit == 1) && ($verbose > 0));
			}
			else
			{
				$last_cmp = 'eq';
				$prev_mid = $mid;
				printf $log_fh " EQ\n" if (($audit == 1) && ($verbose > 0));
				last;
			}
		}
		#
		my $rpt_mid = -1;
		if ($last_cmp eq 'lt')
		{
			my $ts = $pdata->[$prev_mid]->{'prh.start_time'};
			if ($timestamp < $ts)
			{
				$rpt_mid = $prev_mid-1;
			}
			else
			{
				$rpt_mid = $prev_mid;
			}
		}
		elsif ($last_cmp eq 'gt')
		{
			$rpt_mid = $prev_mid;
		}
		else
		{
			$rpt_mid = $prev_mid;
		}
		$setup_id = $pdata->[$rpt_mid]->{'prh.setup_id'};
		$match_ts = $pdata->[$rpt_mid]->{'prh.start_time'};
		#
		my $cmp_status = 'UNKNOWN';
		if ($match_ts < $timestamp)
		{
			$cmp_status = 'LT OK';
		}
		elsif ($match_ts > $timestamp)
		{
			$cmp_status = 'GT NOT OK';
		}
		else
		{
			$cmp_status = 'EQ OK';
		}
		#
		printf $log_fh "Equip ID: %d, Lane NO: %d, Search Time: %d, Match Time: %d, LastCmp: %s, LessOrEq: %s, RptMid: %d\n", $equip_id, $lane_no, $timestamp, $match_ts, $last_cmp, $cmp_status, $rpt_mid if ($verbose > 0);
	}
	else
	{
		printf $log_fh "Equip ID: %d, Lane NO: %d, Time: %d, NOT FOUND!\n", $equip_id, $lane_no, $timestamp if ($verbose > 0);
	}
	#
	return $setup_id;
}
#
sub phase1_fix1
{
	my ($fldnm, $rec_no, $ptd, $fn, $preal, $ppnl, $prf, $phash) = @_;
	#
	if ($$ptd eq 'NULL')
	{
		$phash->{"wrong.${fldnm}"} = $$ptd;
		$$prf += 1;
		printf $log_fh "\n" if (($$ppnl != 0) && ($verbose > 0));
		$$ppnl = 0;
		printf $log_fh "ERROR - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$ptd = $fn;
		printf $log_fh "==>> FIX - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$preal = $$ptd;
	}
	elsif (length($$ptd) < length($fn))
	{
		$phash->{"wrong.${fldnm}"} = $$ptd;
		$$prf += 1;
		printf $log_fh "\n" if (($$ppnl != 0) && ($verbose > 0));
		$$ppnl = 0;
		printf $log_fh "ERROR - REC: %d, '${fldnm}' LENGTH IS %d\n", $rec_no, length($$ptd) if ($verbose > 0);
		$$ptd = $fn;
		printf $log_fh "==>> FIX - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$preal = $$ptd;
	}
	elsif ($$ptd ne $fn)
	{
		$phash->{"wrong.${fldnm}"} = $$ptd;
		$$prf += 1;
		printf $log_fh "\n" if (($$ppnl != 0) && ($verbose > 0));
		$$ppnl = 0;
		printf $log_fh "ERROR - REC: %d, '${fldnm}' VALUE IS %s\n", $rec_no, $$ptd if ($verbose > 0);
		$$ptd = $fn;
		printf $log_fh "==>> FIX - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$preal = $$ptd;
	}
}
#
sub phase1_fix2
{
	my ($fldnm, $rec_no, $ptd, $fn, $preal, $ppnl, $prf, $phash) = @_;
	#
	if ($$ptd eq 'NULL')
	{
		$phash->{"wrong.${fldnm}"} = $$ptd;
		$$prf += 1;
		printf $log_fh "\n" if (($$ppnl != 0) && ($verbose > 0));
		$$ppnl = 0;
		printf $log_fh "ERROR - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$ptd = $fn;
		printf $log_fh "==>> FIX - REC: %d, '${fldnm}' EQ '%d'\n", $rec_no, $$ptd if ($verbose > 0);
		$$preal = $$ptd;
	}
	elsif ($$ptd != $fn)
	{
		$phash->{"wrong.${fldnm}"} = $$ptd;
		$$prf += 1;
		printf $log_fh "\n" if (($$ppnl != 0) && ($verbose > 0));
		$$ppnl = 0;
		printf $log_fh "ERROR - REC: %d, OLD '${fldnm}' IS %d\n", $rec_no, $$ptd if ($verbose > 0);
		$$ptd = $fn;
		printf $log_fh "==>> FIX - REC: %d, '${fldnm}' EQ '%s'\n", $rec_no, $$ptd if ($verbose > 0);
		$$preal = $$ptd;
	}
}
#
sub phase1
{
	my ($praw, $pcols, $pdata, $pprh, $p_td_pids, $p_p_pids) = @_;
	#
	chomp(@{$praw});
	#
	@{$pcols} = split(/\t/, shift @{$praw});
	#
	while (scalar(@{$praw}) > 0)
	{
		my @data = split(/\t/, shift @{$praw});
		my %hash = ();
		@hash{@{$pcols}} = @data;
		unshift @{$pdata}, \%hash;
	}
	printf $log_fh "\nNumber Of Phase 1 Trace Data Records: %d\n", scalar(@{$pdata});
	#
	# fix serial and barcode if required.
	#
	return unless ($phase >= 1);
	#
	my $total_rec_fixed = 0;
	my $total_fld_fixed = 0;
	my $rec_no = 1; # skipped column header
	#
	my $keep = -1;
	my @keep_list = ();
	#
	foreach my $phash (@{$pdata})
	{
		$keep += 1;
		#
		# get data to verify 
		#
		$rec_no += 1;
		#
		# track current panels ids. we delete them later.
		#
		my $td_panel_id = $phash->{'td.panel_id'};
		$p_td_pids->{$td_panel_id} += 1;
		#
		my $p_panel_id = $phash->{'p.panel_id'};
		$p_p_pids->{$p_panel_id} += 1;
		#
		# get some of the current data for verification.
		#
		my $td_serial_no = $phash->{'td.serial_no'};
		my $td_barcode = $phash->{'td.barcode'};
		my $td_prod_model_no = $phash->{'td.prod_model_no'};
		my $td_top_bottom = $phash->{'td.top_bottom'};
		my $td_import_flag = $phash->{'td.import_flag'};
		my $td_setup_id = $phash->{'td.setup_id'};
		my $td_timestamp = $phash->{'td.timestamp'};
		#
		my $p_setup_id = $phash->{'p.setup_id'};
		my $p_job = $phash->{'p.job'}; # ALL JOBIDS ARE NULL. OK.
		#
		my $sh_equipment_id = $phash->{'sh.equipment_id'};
		my $sh_timestamp = $phash->{'sh.timestamp'};
		my $sh_trx_product_id = $phash->{'sh.trx_product_id'};
		#
		my @parts = split('\+-\+', $sh_trx_product_id);
		if (scalar(@parts) < 9)
		{
			printf $log_fh "\n\nERROR - REC: %d, SH.TRX PRODUCT ID HAS < 9 PARTS\nSKIPPING ... %s\n", $rec_no, $sh_trx_product_id;
			next;
		}
		my $lane_no = $parts[3];
		#
		unshift @keep_list, $keep;
		#
		my $fix_barcode = $parts[5];
		my $fix_serial_no = substr($fix_barcode, 5, 11);
		my $fix_prod_model_no = $parts[7];
		my $fix_top_bottom = 'T';
		my $fix_import_flag = 0;
		my $fix_setup_id = get_prh_setup_id($sh_equipment_id,
						    $lane_no,
						    $sh_timestamp,
						    $pprh);
		my $fix_timestamp = $sh_timestamp;
		#
		# patch some data required later but we have here.
		#
		$phash->{'TRX_SH_FILE_NAME'} = $sh_trx_product_id;
		$phash->{'TRX_DATE'} = $parts[0];
		$phash->{'TRX_MACHINE_NO'} = $parts[1];
		$phash->{'TRX_STAGE'} = $parts[2];
		$phash->{'TRX_LANE'} = $parts[3];
		$phash->{'TRX_PCB_SERIAL'} = $parts[4];
		$phash->{'TRX_PCB_ID'} = $parts[5];
		$phash->{'TRX_OUTPUT'} = $parts[6];
		$phash->{'TRX_PCB_ID_LOT_NO'} = $parts[7];
		$phash->{'TRX_REST'} = $parts[8];
		#
		# check if we have anything to fix and fix it.
		#
		my $print_nl = 1;
		my $rec_fixed = 0;
		#
		phase1_fix1('td.serial_no', 
			    $rec_no,
			   \$td_serial_no,
			    $fix_serial_no,
			   \$phash->{'td.serial_no'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix1('td.barcode', 
			    $rec_no,
			   \$td_barcode,
			    $fix_barcode,
			   \$phash->{'td.barcode'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix1('td.prod_model_no', 
			    $rec_no,
			   \$td_prod_model_no,
			    $fix_prod_model_no,
			   \$phash->{'td.prod_model_no'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix1('td.top_bottom', 
			    $rec_no,
			   \$td_top_bottom,
			    $fix_top_bottom,
			   \$phash->{'td.top_bottom'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix1('td.import_flag', 
			    $rec_no,
			   \$td_import_flag,
			    $fix_import_flag,
			   \$phash->{'td.import_flag'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix2('p.setup_id', 
			    $rec_no,
			   \$p_setup_id,
			    $fix_setup_id,
			   \$phash->{'p.setup_id'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix2('td.setup_id', 
			    $rec_no,
			   \$td_setup_id,
			    $fix_setup_id,
			   \$phash->{'td.setup_id'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		phase1_fix2('td.timestamp', 
			    $rec_no,
			   \$td_timestamp,
			    $fix_timestamp,
			   \$phash->{'td.timestamp'},
			   \$print_nl,
			   \$rec_fixed,
			    $phash);
		#
		if ($rec_fixed > 0)
		{
			$total_rec_fixed += 1;
			$total_fld_fixed += $rec_fixed;
		}
	}
	#
	# slice off the bad records
	#
	@{$pdata} = @{$pdata}[@keep_list];
	#
	# remove NULL entry.
	#
	delete $p_td_pids->{'NULL'} if (exists($p_td_pids->{'NULL'}));
	delete $p_p_pids->{'NULL'} if (exists($p_p_pids->{'NULL'}));
	#
	printf $log_fh "\n%d RECORDS FIXED OUT OF %d RECORDS.\n", $total_rec_fixed, ($rec_no - 1);
	printf $log_fh "\n%d FIELDS FIXED.\n", $total_fld_fixed;
}
#
sub dump_phase1
{
	return unless ($verbose > 2);
	#
	my ($pcols, $pdata) = @_;
	#
	my $i = 0;
	my @all_null_fields = ();
	foreach my $phash (@{$pdata})
	{
		$i += 1;
		#
		my @null_fields = grep(/NULL/, map { "$_ X $phash->{$_}" } keys %{$phash});
		if (scalar(@null_fields) > 0)
		{
			unshift @all_null_fields, @null_fields;
		}
		#
		my $str = join(", ", map { "$_ X $phash->{$_}" } keys %{$phash});
		printf $log_fh "%07d: %s\n", $i, $str;
	}
	#
	# strip out fields which are OK to be NULL.
	#
	@all_null_fields = grep( ! /p.job_id/, @all_null_fields);
	#
	printf $log_fh "\nNumber of Remaining NULL fields: %d\n", scalar(@all_null_fields);
	#
	printf $log_fh "\nNULL Fields Left:\n\n";
	#
	my %null_field_count = ();
	foreach (@all_null_fields)
	{
		$null_field_count{$_}++;
	}
	foreach (sort keys %null_field_count)
	{
		printf $log_fh "%s = %d\n", $_, $null_field_count{$_};
	}
}
#
sub get_route_data
{
	my ($pi, $cnt, $pdata, $prtd) = @_;
	#
	printf $log_fh "\nEntry get_route_data: i: %d, max: %d\n", $$pi, $cnt;
	#
	if ($$pi>=$cnt)
	{
		printf $log_fh "\nImmediate Return get_route_data: i: %d, max: %d\n", $$pi, $cnt;
		return;
	}
	#
	my $phash = $pdata->[$$pi];
	my $curr_route_id = $phash->{'r.route_id'};
	#
	printf $log_fh "Current Route ID: %d\n", $curr_route_id;
	#
	for ( ; $$pi<$cnt; $$pi++)
	{
		$phash = $pdata->[$$pi];
		#
		my $r_route_id = $phash->{'r.route_id'};
		last unless ($curr_route_id == $r_route_id);
		#
		unshift @{$prtd}, $phash;
	}
	#
	printf $log_fh "Return get_route_data: i: %d, max: %d, found: %d\n", $$pi, $cnt, scalar(@{$prtd});
}
#
sub get_route_barcodes
{
	my ($prtd, $prbc, $ptsbc) = @_;
	#
	printf $log_fh "\nEntry get_route_barcodes: count: %d\n", scalar(@{$prtd});
	#
	foreach my $phash (@{$prtd})
	{
		my $td_barcode = $phash->{'td.barcode'};
		$prbc->{$td_barcode}->{count} += 1;
		unshift @{$prbc->{$td_barcode}->{data}}, $phash;
	}
	printf $log_fh "\nEntry get_route_barcodes: barcode count: %d\n", scalar(keys %{$prbc});
	#
	foreach my $barcode (keys %{$prbc})
	{
		my $phash = $prbc->{$barcode};
		my $min_date = "99999999999999999";
		my $file_name = '';
		my $machine_no = 0;
		#
		foreach my $phash2 (@{$phash->{data}})
		{
			if ($phash2->{'TRX_DATE'} lt $min_date)
			{
				$min_date = $phash2->{'TRX_DATE'};
				$file_name = $phash2->{'TRX_SH_FILE_NAME'};
				$machine_no  = $phash2->{'TRX_MACHINE_NO'};
			}
		}
		unshift @{$ptsbc},
		{
			'min_date' => $min_date,
			'barcode' => $barcode,
			'file_name' => $file_name,
			'machine_no' => $machine_no
		};
	}
	#
	@{$ptsbc} = sort { $a->{'min_date'} cmp $b->{'min_date'} } @{$ptsbc};
}
#
sub dump_route_barcodes
{
	return unless ($verbose > 2);
	#
	my ($rte_id, $prbc, $ptsbc) = @_;
	#
	printf $log_fh "\nEntry dump_route_barcodes: count: %d\n", scalar(keys %{$prbc});
	#
	printf $log_fh "\nRoute ID: %s\n", $rte_id;
	#
	foreach my $barcode (sort keys %{$prbc})
	{
		my $phash = $prbc->{$barcode};
		printf $log_fh "\tBarcode: %s, Count: %d, Data Count: %d\n", $barcode, $phash->{count}, scalar(@{$phash->{data}});
		foreach my $phash2 (@{$phash->{data}})
		{
			printf $log_fh "\t\tSH FILE NAME : %s", $phash2->{'TRX_SH_FILE_NAME'};
			if (exists($phash2->{'wrong.td.barcode'}))
			{
				printf $log_fh ", WRONG BARCODE: %s", $phash2->{'wrong.td.barcode'};
			}
			printf $log_fh "\n";
		}
	}
	#
	printf $log_fh "\nTime-Sorted Bar Codes:\n";
	foreach my $phash (@{$ptsbc})
	{
		printf $log_fh "Date: %s, Barcode: %s, File Name: %s, Machine: %d\n",
			$phash->{'min_date'},
			$phash->{'barcode'},
			$phash->{'file_name'},
			$phash->{'machine_no'};
	}
}
#
sub check_for_nulls
{
	my ($phash) = @_;
	#
	foreach my $key (keys %{$phash})
	{
		if ($phash->{$key} eq 'NULL')
		{
			printf $log_fh "\t\t\t\tNULL FIELD: %s\n", $key;
		}
	}
}
#
sub check_for_equality
{
	my ($phash, $fn1, $fn2) = @_;
	#
	my $val1 = $phash->{$fn1};
	my $val2 = $phash->{$fn2};
	#
	return if (($val1 eq 'NULL') and ($val2 eq 'NULL'));
	#
	if ($val1 ne $val2)
	{
		printf $log_fh "\t\t\t\t%s(%s) != %s(%s)\n", 
			$fn1, $val1, $fn2, $val2;
	}
}
#
sub write_sql_fix
{
	my ($sql_fh, 
	    $phash2, 
	    $p_td_pids, 
	    $p_p_pids, 
	    $old_td_panel_id,
	    $old_p_panel_id,
 	    $write_td,
	    $td_panel_id) = @_;
	#
	# panel_strace_header panel_equipment_id
	# panel_strace_header equipment_id
	# panel_strace_header master_strace_id
	# panel_strace_header panel_strace_id
	# panel_strace_header timestamp
	# panel_strace_header trx_product_id
	#
	printf $sql_fh "set identity_insert panel_strace_header on\n";
	printf $sql_fh "go\n";
	#
	printf $sql_fh "delete from panel_strace_header where \n";
	printf $sql_fh "    panel_equipment_id = %d\ngo\n",
		 $phash2->{'sh.panel_equipment_id'};
	# 
	printf $sql_fh "insert into panel_strace_header (\n";
	printf $sql_fh " panel_equipment_id, ";
	printf $sql_fh " equipment_id, ";
	printf $sql_fh " master_strace_id, ";
	printf $sql_fh " panel_strace_id, ";
	printf $sql_fh " timestamp, ";
	printf $sql_fh " trx_product_id\n";
	printf $sql_fh ") values (\n";
	printf $sql_fh " %s, ", $phash2->{'sh.panel_equipment_id'};
	printf $sql_fh " %s, ", $phash2->{'sh.equipment_id'};
	printf $sql_fh " %s, ", $phash2->{'sh.master_strace_id'};
	printf $sql_fh " %s, ", $phash2->{'sh.panel_strace_id'};
	printf $sql_fh " %s, ", $phash2->{'sh.timestamp'};
	printf $sql_fh " '%s'\n", $phash2->{'sh.trx_product_id'};
	printf $sql_fh ")\ngo\n";
	#
	printf $sql_fh "set identity_insert panel_strace_header off\n";
	printf $sql_fh "go\n";
	#
	# panels panel_id
	# panels equipment_id
	# panels nc_version
	# panels start_time
	# panels end_time
	# panels panel_equipment_id
	# panels panel_source
	# panels panel_trace
	# panels stage_no
	# panels lane_no
	# panels job_id
	# panels setup_id
	# panels trx_product_id
	#
	printf $sql_fh "set identity_insert panels on\n";
	printf $sql_fh "go\n";
	#
	if (exists($p_p_pids->{$old_p_panel_id}))
	{
		delete $p_p_pids->{$old_p_panel_id};
		printf $sql_fh "delete from panels where \n";
		printf $sql_fh "    panel_id = %d\ngo\n", $old_p_panel_id;
	}
	#
	printf $sql_fh "insert into panels (\n";
	printf $sql_fh " panel_id, ";
	printf $sql_fh " equipment_id, ";
	printf $sql_fh " nc_version, ";
	printf $sql_fh " start_time, ";
	printf $sql_fh " end_time, ";
	printf $sql_fh " panel_equipment_id, ";
	printf $sql_fh " panel_source, ";
	printf $sql_fh " panel_trace, ";
	printf $sql_fh " stage_no, ";
	printf $sql_fh " lane_no, ";
	printf $sql_fh " job_id, ";
	printf $sql_fh " setup_id, ";
	printf $sql_fh " trx_product_id\n";
	printf $sql_fh ") values (\n";
	printf $sql_fh " %s, ", $phash2->{'p.panel_id'};
	printf $sql_fh " %s, ", $phash2->{'p.equipment_id'};
	printf $sql_fh " %s, ", $phash2->{'p.nc_version'};
	printf $sql_fh " %s, ", $phash2->{'p.start_time'};
	printf $sql_fh " %s, ", $phash2->{'p.end_time'};
	printf $sql_fh " %s, ", $phash2->{'p.panel_equipment_id'};
	printf $sql_fh " %s, ", $phash2->{'p.panel_source'};
	printf $sql_fh " %s, ", $phash2->{'p.panel_trace'};
	printf $sql_fh " %s, ", $phash2->{'p.stage_no'};
	printf $sql_fh " %s, ", $phash2->{'p.lane_no'};
	printf $sql_fh " %s, ", $phash2->{'p.job_id'};
	printf $sql_fh " %s, ", $phash2->{'p.setup_id'};
	printf $sql_fh " '%s'\n", $phash2->{'p.trx_product_id'};
	printf $sql_fh ")\ngo\n";
	#
	printf $sql_fh "set identity_insert panels off\n";
	printf $sql_fh "go\n";
	#
	# tracking_data serial_no
	# tracking_data prod_model_no
	# tracking_data panel_id
	# tracking_data pattern_id
	# tracking_data barcode
	# tracking_data setup_id
	# tracking_data top_bottom
	# tracking_data timestamp
	# tracking_data import_flag
	#
	# if tracking data is already inserted, then do not reinsert. 
	# however, delete any old reference to tracking data if required.
	#
	if (exists($p_td_pids->{$old_td_panel_id}))
	{
		delete $p_td_pids->{$old_td_panel_id};
		printf $sql_fh "delete from tracking_data where \n";
		printf $sql_fh "    panel_id = %d\ngo\n", $old_td_panel_id;
	}
	#
	return unless ($write_td == 1);
	#
	my $use_existing = 1;
	#
	printf $sql_fh "set identity_insert Panel_Seq on\n";
	printf $sql_fh "go\n";
	printf $sql_fh "insert into Panel_Seq (PANEL_ID,TITLE) VALUES (%s, 'Dummy')\ngo\n", $td_panel_id;
	printf $sql_fh "set identity_insert Panel_Seq off\n";
	printf $sql_fh "go\n";
	#
	if ($phash2->{'td.pattern_id'} eq 'NULL')
	{
		$use_existing = 0;
		printf $sql_fh 'declare @pattern_id numeric(18,0)';
		printf $sql_fh "\n";
		printf $sql_fh "INSERT INTO Pattern_Seq (TITLE) VALUES ('Dummy')\n";
		printf $sql_fh 'set @pattern_id = dbo.udf_Get_Identity()';
		printf $sql_fh "\n";
	}
	#
	printf $sql_fh "insert into tracking_data (\n";
	printf $sql_fh " serial_no, ";
	printf $sql_fh " prod_model_no, ";
	printf $sql_fh " panel_id, ";
	printf $sql_fh " pattern_id, ";
	printf $sql_fh " barcode, ";
	printf $sql_fh " setup_id, ";
	printf $sql_fh " top_bottom, ";
	printf $sql_fh " timestamp, ";
	printf $sql_fh " import_flag\n";
	printf $sql_fh ") values (\n";
	printf $sql_fh " '%s', ", $phash2->{'td.serial_no'};
	printf $sql_fh " '%s', ", $phash2->{'td.prod_model_no'};
	printf $sql_fh " %s, ", $phash2->{'td.panel_id'};
	if ($use_existing == 1)
	{
		printf $sql_fh " %s, ", $phash2->{'td.pattern_id'};
	}
	else
	{
		printf $sql_fh ' @pattern_id, ';
	}
	printf $sql_fh " '%s', ", $phash2->{'td.barcode'};
	printf $sql_fh " %s, ", $phash2->{'td.setup_id'};
	printf $sql_fh " '%s', ", $phash2->{'td.top_bottom'};
	printf $sql_fh " %s, ", $phash2->{'td.timestamp'};
	printf $sql_fh " %s", $phash2->{'td.import_flag'};
	printf $sql_fh ")\ngo\n";
}
#
sub fix_panel_ids
{
	my ($pall_pids, $pmax_pids, $phash, $p_td_pids, $p_p_pids, $sql_fh) = @_;
	#
	$pmax_pids->{'max.td.panel_id'} += 1;
	my $td_panel_id = $pmax_pids->{'max.td.panel_id'};
	#
	my $write_td = 1;
	#
	foreach my $phash2 (@{$phash->{data}})
	{
		#
		# p.panel_id 
		# td.panel_id 
		#
		my $ppid = $phash2->{'p.panel_id'};
		my $tdpid = $phash2->{'td.panel_id'};
		#
		$pall_pids->{$ppid} += 1;
		$pall_pids->{$tdpid} += 1;
		#
		my $ppeqid = $phash2->{'p.panel_equipment_id'};
		my $shpeqid = $phash2->{'sh.panel_equipment_id'};
		#
		$pall_pids->{$ppeqid} += 1;
		$pall_pids->{$shpeqid} += 1;
		#
		my $old_td_panel_id = $phash2->{'td.panel_id'};
		my $old_p_panel_id = $phash2->{'p.panel_id'};
		#
		$phash2->{'td.panel_id'} = $td_panel_id;
		$phash2->{'p.panel_id'} = $td_panel_id;
		#
#		$pmax_pids->{'max.p.panel_equipment_id'} += 1;
#		my $p_panel_equipment_id = 
#			$pmax_pids->{'max.p.panel_equipment_id'};
		#
		# p.panel_equipment_id 
		# sh.panel_equipment_id 
		#
#		$phash2->{'p.panel_equipment_id'} = $p_panel_equipment_id;
#		$phash2->{'sh.panel_equipment_id'} = $p_panel_equipment_id;
		$phash2->{'p.panel_equipment_id'} = 
			$phash2->{'sh.panel_equipment_id'};
		#
		write_sql_fix($sql_fh,
			      $phash2, 
			      $p_td_pids, 
			      $p_p_pids, 
			      $old_td_panel_id,
			      $old_p_panel_id,
			      $write_td,
			      $td_panel_id);
		$write_td = 0;
	}
}
#
sub check_route_data
{
	my ($rte_id, $prbc, $pmax_pids, $ptsbc, $p_td_pids, $p_p_pids, $sql_fh) = @_;
	#
	printf $log_fh "\nTime-Sorted Data for Route ID: %s\n", $rte_id;
	#
	my %all_panel_ids = ();
	#
	foreach my $pbchash (@{$ptsbc})
	{
		my $md = $pbchash->{'min_date'};
		my $bc = $pbchash->{'barcode'};
		my $fn = $pbchash->{'file_name'};
		my $mn = $pbchash->{'machine_no'};
		#
		my $phash = $prbc->{$bc};
		#
		printf $log_fh "\n\tBarcode: %s, Count: %d, Data Count: %d\n", $bc, $phash->{count}, scalar(@{$phash->{data}});
		#
		foreach my $phash2 (@{$phash->{data}})
		{
			printf $log_fh "\t\tSH FILE NAME : %s", $phash2->{'TRX_SH_FILE_NAME'};
			if (exists($phash2->{'wrong.td.barcode'}))
			{
				printf $log_fh ", WRONG BARCODE: %s", $phash2->{'wrong.td.barcode'};
			}
			printf $log_fh "\n";
			my $str = join(", ", map { "$_ X $phash2->{$_}" } keys %{$phash2});
			printf $log_fh "\t\tTUPLE: %s\n", $str;
			#
			# preliminary sanity checks
			#
			check_for_nulls($phash2);
			check_for_equality($phash2, 
					  'p.panel_id', 
					  'td.panel_id');
			check_for_equality($phash2, 
					  'p.panel_equipment_id',
					  'sh.panel_equipment_id');
		}
		#
		# start checking for real and fix the data per panel.
		#
		fix_panel_ids(\%all_panel_ids, 
			      $pmax_pids, 
			      $phash, 
			      $p_td_pids,
			      $p_p_pids,
			      $sql_fh);
	}
}
#
sub phase2
{
	my ($pcols, $pdata, $fname, $pmax_pids, $p_td_pids, $p_p_pids) = @_;
	#
	local *FH;
	open(FH, '>', $fname) or die $!;
	my $sql_fh = *FH;
	#
	# disable identity insert. can only have one one at a time.
	#
	printf $sql_fh "set identity_insert panel_strace_header off\n";
	printf $sql_fh "go\n";
	printf $sql_fh "set identity_insert panels off\n";
	printf $sql_fh "go\n";
	#
	my $cnt = scalar(@{$pdata});
	#
	my $current_route_id = -1;
	#
	for (my $i=0; $i<$cnt; )
	{
		#
		# get all the data associated with this route
		#
		my $phash = $pdata->[$i];
		my $r_route_id = $phash->{'r.route_id'};
		#
		my @route_trace_data = ();
		get_route_data(\$i, $cnt, $pdata, \@route_trace_data);
		#
		my %route_barcodes = ();
		my @time_sorted_barcodes = ();
		get_route_barcodes(\@route_trace_data, 
				   \%route_barcodes,
				   \@time_sorted_barcodes);
		#
		dump_route_barcodes($r_route_id, 
				   \%route_barcodes,
				   \@time_sorted_barcodes);
		#
		check_route_data($r_route_id, 
			        \%route_barcodes,
				 $pmax_pids,
			        \@time_sorted_barcodes,
				 $p_td_pids,
				 $p_p_pids,
				 $sql_fh);
	}
	#
	#
	# disable identity insert
	#
	printf $sql_fh "set identity_insert panel_strace_header off\n";
	printf $sql_fh "go\n";
	printf $sql_fh "set identity_insert panels off\n";
	printf $sql_fh "go\n";
	#
	close $sql_fh;
}
#
#########################################################################
#
# start of script
#
my %opts;
if (getopts('?AhV:P:L:', \%opts) != 1)
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
	elsif ($opt eq "V")
	{
		$verbose = $opts{$opt};
	}
	elsif ($opt eq "A")
	{
		$audit = 1;
	}
	elsif ($opt eq "P")
	{
		$phase = $opts{$opt};
		if ($phase =~ m/all/i)
		{
			$phase = 100000; # some big number
		}
	}
	elsif ($opt eq "L")
	{
		local *FH;
		$logfile = $opts{$opt};
		open(FH, '>', $logfile) or die $!;
		$log_fh = *FH;
		printf("\nLog File: %s\n", $logfile);
	}
}
#
if (scalar(@ARGV) != 4)
{
	printf("\nIncorrect number of arguments!\n");
	usage($cmd);
	exit 2;
}
#
my $trace_data_file = $ARGV[0];
my $product_run_history_file = $ARGV[1];
my $max_panel_id_file = $ARGV[2];
my $gen_sql_file = $ARGV[3];
#
printf $log_fh "\nTrace Data File         : %s\n", $trace_data_file;
printf $log_fh "Product Run History File: %s\n", $product_run_history_file;
printf $log_fh "Max Panel ID File       : %s\n", $max_panel_id_file;
printf $log_fh "Generated SQL File      : %s\n", $gen_sql_file;
#
# read in product run history file
#
my @raw_product_run_history = ();
read_raw_file("Product Run History", 
	      $product_run_history_file, 
	      \@raw_product_run_history);
#
my %product_run_history = ();
store_product_run_history(\@raw_product_run_history, 
			  \%product_run_history);
#
# read in trace data file.
#
my @raw_trace_data = ();
read_raw_file("Trace Data File", 
	      $trace_data_file, 
	      \@raw_trace_data);
#
# read in max panel ids file.
#
my @raw_max_panel_ids = ();
read_raw_file("Max Panel ID Data File", 
	      $max_panel_id_file, 
	      \@raw_max_panel_ids);
#
my %max_panel_ids = ();
store_max_panel_ids(\@raw_max_panel_ids, \%max_panel_ids);
#
# phase 1 in fixing data
#
my @column_names = ();
my @trace_data = ();
my %old_td_panels_ids = ();
my %old_p_panels_ids = ();
phase1(\@raw_trace_data, 
       \@column_names, 
       \@trace_data, 
       \%product_run_history,
       \%old_td_panels_ids,
       \%old_p_panels_ids);
dump_phase1(\@column_names, \@trace_data);
#
# phase 2 in fixing data
#
phase2(\@column_names, 
       \@trace_data, 
       $gen_sql_file, 
       \%max_panel_ids,
       \%old_td_panels_ids,
       \%old_p_panels_ids);
#
printf $log_fh "\nAll Done\n";
#
exit 0;
