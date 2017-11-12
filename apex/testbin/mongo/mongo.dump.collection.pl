#!/usr/bin/perl -w
#
use strict;
#
use MongoDB;
#
use Try::Tiny;
use Safe::Isa;
use Data::Dumper;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 db table limit host [port [user [passwd]]]\n", ;
    exit 0;
}
#
#
my $db_name = undef;
my $table_name = undef;
my $limit = undef;
my $host_name = undef;
my $port = undef;
my $user_name = undef;
my $password = undef;
#
die "missing db, table, limit or host: $!" unless (scalar(@ARGV) >= 4);
#
$db_name = shift @ARGV;
$table_name = shift @ARGV;
$limit = shift @ARGV;
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
my $cursor = undef;
#
if ($limit > 0)
{
    $cursor = $db_data->find()->limit($limit);
}
else
{
    $cursor = $db_data->find();
}
#
while (my $row = $cursor->next)
{
    printf Dumper($row);
}
#
$client->disconnect;
#
exit 0;
