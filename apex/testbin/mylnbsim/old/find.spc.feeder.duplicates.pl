#!/usr/bin/perl -w
#
# scan a machine directory searching for duplicate FADD,FSADD locations
# in the U01 file Feeder section. duplicates may occur when an exhaust or
# splice occurs and there are two rows for the same locationm, FADD and
# FSADD, with different REELIDS.
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
# tokenize a row from the [MountPickupFeeder] section. the tokens are
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
# scan [MountPickupFeeder] section for locations (FADD,FSADD) with
# multiple rows, ie, different REELIDS.
#
sub duplicate_feeders
{
	my ($pfeeders) = @_;
	#
	my %seen = ();
	#
	while (@{$pfeeders})
	{
		my $feeder = shift @{$pfeeders};
		#
		next if ($feeder =~ /MountPickupFeeder/);
		next if ($feeder =~ /BLKCode/);
		last if ($feeder =~ /^\s*$/);
		#
		my @tokens = ();
		tokenize(\@tokens,  shift @{$pfeeders});
		next if (scalar(@tokens) < 15);
		#
		my ($fadd, $fsadd, $reelid) = @tokens[4,5,6];
# printf "fsadd,fadd,reelid = %s,%s,%s\n", $fadd, $fsadd, $reelid;
		#
		my $key = "$fadd" . "$fsadd";
# printf "key = %s\n", $key;
		#
		if (exists($seen{$key}))
		{
			printf "DUPLICATE: (fadd,fsadd) = %s, OLD REELID = %s, NEW REELID = %s\n", $key, $seen{$key}, $reelid;
			$seen{$key} .= "," . $reelid;
		}
		else
		{
			$seen{$key} = $reelid;
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
			# get the MountPickFeeder section data.
			#
			my @feeders = grep(/MountPickupFeeder/../^\s*$/, @inbuf);
			printf "Read in: %d, Section: %d\n",
                               scalar(@inbuf), scalar(@feeders);
			#
			# scan for duplcate entries per location.
			#
			duplicate_feeders(\@feeders);
		}
		#
		chdir $procdir;
	}
	#
	chdir $root;
}
#
exit 0
