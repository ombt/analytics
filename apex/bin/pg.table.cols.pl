#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 table [host [db [user [passwd]]]]\n", ;
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
#
my $dsn = "dbi:Pg:dbname=$db_name;host=$host_name";
#
my $dbh = DBI->connect($dsn, $user_name, $password);
#
# my $sth = $dbh->prepare("select * from $table_name");
# my $sth = $dbh->prepare("select count(*) from pg_tables where tablename = '$table_name' and schemaname = 'public'");
my $sth = $dbh->prepare("select table_schema, table_name, column_name, data_type from information_schema.columns where table_name = '$table_name' and table_schema = 'public'");
$sth->execute();
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join("|", @data);
}
#
$dbh->disconnect;
#
exit 0;
