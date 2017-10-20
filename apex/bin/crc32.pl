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
use lib "$binpath/utils";
#
use mylogger;
use myutils;
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $putils = myutils->new($plog);
die "Unable to create utils: $!" unless (defined($putils));
#
my $crc32 = $putils->crc32(join("", @ARGV));
printf "CRC32 (string) = %s\n", $crc32;
printf "CRC32 (long) = %ld\n", $crc32;
printf "CRC32 (HEX) = %X\n", $crc32;
#
exit 0;
