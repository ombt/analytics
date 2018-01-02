#!/usr/bin/perl -w
#
use strict;
use warnings;
#
my $binpath = undef;
#
BEGIN {
    use File::Basename;
    #
    $binpath = dirname($0);
    $binpath = "." if ($binpath eq "");
}
#
use lib "$binpath";
use lib "$binpath/myutils";
#
use myconstants;
use mylogger;
use myutils;
#
my $use_join = FALSE;
#
if ((scalar(@ARGV) < 1) ||
    (($ARGV[0] eq "-j") && (scalar(@ARGV) == 1)))
{
    printf "usage: $0 [-j] string1 [string2 [...]]\n";
    exit 2;
}
elsif ($ARGV[0] eq "-j")
{
    $use_join = TRUE;
    shift @ARGV;
}
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $putils = myutils->new($plog);
die "Unable to create utils: $!" unless (defined($putils));
#
if ($use_join == TRUE)
{
    my $crc32 = $putils->my_crc_32(join("", @ARGV));
    #
    printf "\nMY CRC32 (string) = %s\n", $crc32;
    printf "MY CRC32 (long) = %ld\n", $crc32;
    printf "MY CRC32 (HEX) = %X\n", $crc32;
}
else
{
    foreach my $arg (@ARGV)
    {
        my $crc32 = $putils->crc32($arg);
        #
        printf "\nMY CRC32 (string) = %s\n", $crc32;
        printf "MY CRC32 (long) = %ld\n", $crc32;
        printf "MY CRC32 (HEX) = %X\n", $crc32;
    }
}
#
exit 0;
