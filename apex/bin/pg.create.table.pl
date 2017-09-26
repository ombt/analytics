#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 table host db [user [passwd]]\n", ;
    exit 0;
}
#
my $table_name = undef;
my $host_name = undef;
my $db_name = undef;
my $user_name = undef;
my $password = undef;
#
die "missing table, host, or db names: $!" unless (scalar(@ARGV) >= 3);
#
$table_name = shift @ARGV;
$host_name = shift @ARGV;
$db_name = shift @ARGV;
#
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
my $dsn = "dbi:Pg:dbname=$db_name;host=$host_name";
#
my $dbh = DBI->connect($dsn, $user_name, $password, { PrintError => 0, RaiseError => 0 } );
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
my $sth = $dbh->prepare("select tablename from pg_tables where tablename = '$table_name' and schemaname = 'public'");
$sth->execute();
#
while (my @data = $sth->fetchrow_array())
{
    if ($data[0] eq $table_name)
    {
        $found = 1;
	last;
    }
}
$sth = undef;
#
if ($found)
{
    printf "==>> Table %s: EXISTS.\n", $table_name;
}
else
{
    printf "==>> Table %s: NOT EXISTS. Creating.\n", $table_name;
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
#
exit 0;
