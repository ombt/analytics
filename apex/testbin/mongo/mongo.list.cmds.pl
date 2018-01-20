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
    printf "usage: $0 host [port [user [passwd]]]\n", ;
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
my $db_name = shift @db_names;
my $db = $client->get_database($db_name);
my $commands = $db->run_command([listCommands => 1]);
#
# printf "MongoDB Cmds: %s\n", Dumper($commands);
printf "MongoDB Cmds: \n%s\n", join("\n", sort keys %{$commands->{commands}});
#
$client->disconnect;
#
exit 0;
