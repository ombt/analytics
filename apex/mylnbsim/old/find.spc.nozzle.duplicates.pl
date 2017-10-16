#!/usr/bin/perl -w
#
# scan a machine directory searching for duplicate NHAdd,NCAdd locations
# in the U01 file Noxxle section. look for locations with differemt
# NozzleName.
#
use strict;
use Cwd;
#
my $cmd = $0;
#
my $processed_dir = "quarantine_logs/spc_log/processed";
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
sub duplicate_nozzles
{
	my ($pnozzles) = @_;
	#
	my %seen = ();
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
		my ($nhadd, $ncadd, $nozzle_name) = @tokens[1,2,6];
# printf "nhadd,ncadd,nozzle_name = %s,%s,%s\n", $nhadd, $ncadd, $nozzle_name;
		#
		my $key = "$nhadd" . "$ncadd";
# printf "key = %s\n", $key;
		#
		if (exists($seen{$key}))
		{
			printf "DUPLICATE: (nhadd,ncadd) = %s, OLD NOZZLE NAME = %s, NEW NOZZLE NAME = %s\n", $key, $seen{$key}, $nozzle_name;
			$seen{$key} .= "," . $nozzle_name;
		}
		else
		{
			$seen{$key} = $nozzle_name;
		}
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
		my @u01s = glob "*.u01";
		foreach my $u01 (@u01s)
		{
			printf "U01: %s\n", $u01;
			#
			# read in entire file. slurp.
			#
			open(INFILE, $u01) or dir $!;
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
