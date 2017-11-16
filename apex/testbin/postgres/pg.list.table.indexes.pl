#!/usr/bin/perl -w
#
use strict;
#
use DBI;
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
#
my $port = 5432;
my $user_name = undef;
my $password = undef;
#
die "missing table, host, or db names: $!" unless (scalar(@ARGV) >= 3);
#
$db_name = shift @ARGV;
$table_name = shift @ARGV;
$host_name = shift @ARGV;
#
$port = shift @ARGV if (scalar(@ARGV) > 0);
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
#
my $dsn = "dbi:Pg:dbname=$db_name;host=$host_name;port=$port";
#
my $dbh = DBI->connect($dsn, $user_name, $password, { PrintError => 0, RaiseError => 0 } );
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
# my $sql = "select schemaname as 'schema_name', tablename as 'table_name', indexname as 'index_name' from pg_catalog.pg_indexes where tablename = '$table_name'";
my $sql = "select schemaname, tablename, indexname from pg_catalog.pg_indexes where tablename = '$table_name'";
#
my $sth = $dbh->prepare($sql);
die "Prepare failed: $DBI::errstr\n" 
    unless (defined($sth));
#
die "Unable to execute: " . $sth->errstr 
    unless (defined($sth->execute()));
#
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join("|", @data);
}
#
$dbh->disconnect;
#
exit 0;
