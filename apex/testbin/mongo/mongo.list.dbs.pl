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
    printf "usage: $0 host [user [passwd]]\n", ;
    exit 0;
}
#
my $host_name = undef;
my $port = undef;
my $user_name = undef;
my $password = undef;
#
die "missing host: $!" unless (scalar(@ARGV) >= 1);
#
my $mongo_uri = undef;
#
$host_name = shift @ARGV;
$port = shift @ARGV if (scalar(@ARGV) > 0);
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
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
my @dbs = $client->database_names;
printf "MongoDBs:\n%s\n", join("\n", @dbs);
#
$client->disconnect;
#
exit 0;
