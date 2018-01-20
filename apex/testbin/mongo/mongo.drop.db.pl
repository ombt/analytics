#!/usr/bin/perl -w
#
use strict;
#
use MongoDB;
#
use Try::Tiny;
use Safe::Isa;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 db host [port [user [passwd]]]\n", ;
    exit 0;
}
#
my $db_to_drop = undef;
my $host_name = undef;
my $port = undef;
my $user_name = undef;
my $password = undef;
#
die "missing host or db: $!" unless (scalar(@ARGV) >= 2);
#
$db_to_drop = shift @ARGV;
$host_name = shift @ARGV;
#
$port = shift @ARGV if (scalar(@ARGV) > 0);
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
my $mongo_uri = undef;
#
if (defined($port))
{
    if (defined($user_name))
    {
        if (defined($password))
        {
            $mongo_uri = "mongodb://${user_name}:${password}@${host_name}:${port}";
        }
        else
        {
            $mongo_uri = "mongodb://${user_name}@${host_name}:${port}";
        }
    }
    else
    {
        $mongo_uri = "mongodb://${host_name}:${port}";
    }
}
else
{
    $mongo_uri = "mongodb://${host_name}";
}
#
my $client = undef;
#
$client = MongoDB->connect($mongo_uri);
$client->connect;
#
my @db_names = $client->database_names;
foreach my $db_name (@db_names)
{
    if ($db_name eq $db_to_drop)
    {
        my $db = $client->get_database($db_to_drop);
        $db->drop;
        last;
    }
}
#
$client->disconnect;
#
exit 0;
