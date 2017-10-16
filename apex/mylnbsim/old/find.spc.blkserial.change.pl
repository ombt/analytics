#!/usr/bin/perl -w
#
# scan a machine directory searching for duplicate NHAdd,NCAdd locations
# in the U01 file Nozzle section. look for locations with differemt
# NozzleName across files, not just with in a file.
#
use strict;
use Cwd;
#
my $cmd = $0;
#
my $processed_dir = "quarantine_logs/spc_log/processed";
#
my $stage = -1;
my $lane  = -1;
my $mach  = -1;
#
########################################################################
#
# usage function.
# 
sub usage
{
	print <<EOF;

usage: $cmd machine_directory ...

EOF
}
#
########################################################################
#
# tokenize a row from the [MountPickupNozzle] section. the tokens are
# space separated, but spaces can occur in quoted strings. so, this
# function handles quoted-strings and identifies the spaces, ie, 
# delimiters, outside a quoted string. any spaces in a quoted string
# are just added to the current token.  the tokens are inserted
# into an array as they are identified.
#
sub tokenize
{
	my ($ptokens, $string_with_quotes) = @_;
	#
	my @new_chars = ();
	#
	my @chars = split('', $string_with_quotes);
	while (@chars)
	{
		my $char = shift @chars;
		#
		if ($char eq '"')
		{
			#
			# start of a quoted string. read characters
			# until we reach the terminating double quote or
			# the end of the buffer. each character
			# is appended to the current token.
			#
			while ((scalar(@chars) > 0) &&
                               (($char = shift @chars) ne '"'))
			{
				push @new_chars, $char;
			}
		}
		elsif ($char eq " ")
		{
			#
			# delimiter space since it is NOT in a
			# quoted string. push token.
			#
			push @{$ptokens}, join('', @new_chars);
			@new_chars = ();
		}
		else
		{
			#
			# add character to current token.
			#
			push @new_chars, $char;
		}
	}
	#
	# push last token
	#
	push @{$ptokens}, join('', @new_chars);
}
#
########################################################################
#
# scan [MountPickupNozzle] section for locations (NHAdd,NCAdd) with
# multiple rows, ie, different NozzleName.
#
my %seen = ();
#
sub duplicate_nozzles
{
	my ($pnozzles) = @_;
	#
	while (@{$pnozzles})
	{
		my $nozzle = shift @{$pnozzles};
# printf "nozzle data = %s\n", $nozzle;
		#
		next if ($nozzle =~ /MountPickupNozzle/);
		next if ($nozzle =~ /Head.*NozzleName.*Pickup/);
		last if ($nozzle =~ /^\s*$/);
		#
		my @tokens = ();
		tokenize(\@tokens,  shift @{$pnozzles});
		next if (scalar(@tokens) < 14);
		#
		my ($nhadd, $ncadd, $blkserial) = @tokens[1,2,4];
# printf "nhadd,ncadd,blkserial = %s,%s,%s\n", $nhadd, $ncadd, $blkserial;
		#
		my $key = "${nhadd}:" . "$ncadd";
# printf "key = %s\n", $key;
		#
		if (exists($seen{$mach}{$stage}{$lane}{$key}))
		{
			if ($seen{$mach}{$stage}{$lane}{$key} ne $blkserial)
			{
				printf "DUPLICATE: (mach,stage,lane,nhadd,ncadd) = %s,%s,%s,%s, OLD BLK SERIAL = %s, NEW BLK SERIAL = %s\n", $mach, $stage, $lane, $key, $seen{$key}, $blkserial;
				$seen{$mach}{$stage}{$lane}{$key} = $blkserial;
			}
		}
		else
		{
			$seen{$mach}{$stage}{$lane}{$key} = $blkserial;
		}
	}
}
#
########################################################################
#
# get stage and lane numbers from file name, and set globals.
#
sub set_stage_lane_mach
{
	my ($u01) = @_;
	#
	my @tokens = split('-', $u01);
	#
	if (scalar(@tokens) >= 4)
	{
		$mach = $tokens[1];
		$stage = $tokens[2];
		$lane = $tokens[3];
	}
	else
	{
		$mach = -1;
		$stage = -1;
		$lane = -1;
	}
}
#
################################ MAIN ####################################
#
my $root = getcwd();
#
if (scalar(@ARGV) <= 0)
{
	usage();
	exit(2);
}
#
foreach my $dir (@ARGV)
{
	my $machine_dir = $dir . "/" . $processed_dir;
	#
	chdir $machine_dir;
	printf "Directory: %s\n", getcwd();
	#
	my $procdir = getcwd();
	#
	my @datedirs = glob "2013*";
	#
	foreach my $datedir (@datedirs)
	{
		chdir $datedir;
		printf "Directory: %s\n", getcwd();
		#
		my @u01s = sort glob "*.u01";
		#
		foreach my $u01 (@u01s)
		{
			printf "U01: %s\n", $u01;
			#
			set_stage_lane_mach($u01);
			#
			# check if we have a reset for this stage/lane.
			#
			if ($u01 =~ /.*-13-.*/)
			{
				#
				# reset files contain no data
				printf "RESETTING (mach,stage,lane) = %s %s %s\n", $mach, $stage, $lane;
				$seen{$mach}{$stage}{$lane} = ();
				next;
			}
			#
			# read in entire file. slurp.
			#
			open(INFILE, $u01) or die $!;
			my @inbuf = <INFILE>;
			close(INFILE);
			#
			# remove newlines.
			#
			chomp(@inbuf);
			#
			# get the MountPickupNozzle section data.
			#
			my @nozzles = grep(/MountPickupNozzle/../^\s*$/, @inbuf);
			printf "Read in: %d, Section: %d\n",
                               scalar(@inbuf), scalar(@nozzles);
			#
			# scan for duplcate entries per location.
			#
			duplicate_nozzles(\@nozzles);
		}
		#
		chdir $procdir;
	}
	#
	chdir $root;
}
#
exit 0
