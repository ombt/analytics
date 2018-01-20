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
    printf "usage: $0 db table host [port [user [passwd]]]\n", ;
    exit 0;
}
#
my $db_name = undef;
my $table_name = undef;
my $host_name = undef;
my $port = undef;
my $user_name = undef;
my $password = undef;
#
die "missing table, host, db or field names: $!" unless (scalar(@ARGV) >= 3);
#
$db_name = shift @ARGV;
$table_name = shift @ARGV;
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
my $db = $client->get_database($db_name);
#
my $db_data = $db->get_collection($table_name);
#
$db_data->drop;
#
$client->disconnect;
#
exit 0;

