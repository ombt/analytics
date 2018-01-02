#!/usr/bin/perl -w
#
# create a db if it does not exist.
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 db host [user [passwd]]\n", ;
    exit 0;
}
#
my $host_name = undef;
my $db_name = undef;
my $user_name = undef;
my $password = undef;
#
die "missing host or db : $!" unless (scalar(@ARGV) >= 2);
#
$db_name = shift @ARGV;
$host_name = shift @ARGV;
#
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
#
my $dsn = "dbi:Pg:dbname='';host=$host_name";
#
my $dbh = DBI->connect($dsn, $user_name, $password, { PrintError => 0, RaiseError => 0 } );
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
my $found = 0;
#
my $sth = $dbh->prepare("select datname from pg_database");
$sth->execute();
while (my @data = $sth->fetchrow_array())
{
    if ($data[0] eq $db_name)
    {
        $found = 1;
	last;
    }
}
$sth = undef;
#
if ($found)
{
    printf "==>> DB %s: EXISTS.\n", $db_name;
}
else
{
    printf "==>> DB %s: NOT EXISTS. Creating.\n", $db_name;
    #
    my $sql = "create database $db_name";
    if (defined($user_name))
    {
        $sql .= " owner $user_name";
    }
    #
    $sth = $dbh->prepare($sql);
    if (defined($sth->execute()))
    {
        printf "Database created ... Checking again.\n";
        $found = 0;
        $sth = $dbh->prepare("select datname from pg_database");
        $sth->execute();
        while (my @data = $sth->fetchrow_array())
        {
            if ($data[0] eq $db_name)
            {
                $found = 1;
	        last;
            }
        }
        $sth = undef;
        #
        if ($found)
        {
            printf "==>> DB %s: EXISTS.\n", $db_name;
        }
        else
        {
            printf "==>> DB %s: NOT EXISTS. CREATE DATABASE FAILED.\n", $db_name;
        }
    }
    else
    {
        printf "==>> DB %s: STILL DOES NOT EXISTS.\n", $db_name;
    }
}
#
$dbh->disconnect;
$dbh = undef;
#
exit 0;
