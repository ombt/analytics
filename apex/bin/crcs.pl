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
# use CPAN to download Digest::CRC if it is not available.
#
# use Digest::CRC qw(crc64 crc32 crc16 crcccitt crc crc8);
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
    my $crc = undef;
    my $args = join("", @ARGV);
    #
    $crc = $putils->my_crc_32($args);
    printf "\nMy CRC32 (string) = %s\n", $crc;
    #
    $crc = $putils->crc_16($args);
    printf "CRC16 (string) = %s\n", $crc;
    #
    $crc = $putils->crc_32($args);
    printf "CRC32 (string) = %s\n", $crc;
    #
    $crc = $putils->crc_64($args);
    printf "CRC64 (string) = %s\n", $crc;
    #
    $crc = $putils->crc_ccitt($args);
    printf "CRCCCITT (string) = %s\n", $crc;
}
else
{
    foreach my $arg (@ARGV)
    {
        my $crc = undef;
        #
        $crc = $putils->my_crc_32($arg);
        printf "\nMy CRC32 (string) = %s\n", $crc;
        #
        $crc = $putils->crc_16($arg);
        printf "CRC16 (string) = %s\n", $crc;
        #
        $crc = $putils->crc_32($arg);
        printf "CRC32 (string) = %s\n", $crc;
        #
        $crc = $putils->crc_64($arg);
        printf "CRC64 (string) = %s\n", $crc;
        #
        $crc = $putils->crc_ccitt($arg);
        printf "CRCCCITT (string) = %s\n", $crc;
    }
}
#
exit 0;
