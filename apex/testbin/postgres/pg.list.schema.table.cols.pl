#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 db schema table host [user [passwd]]\n", ;
    exit 0;
}
#
my $db_name = undef;
my $schema_name = undef;
my $table_name = undef;
my $host_name = undef;
my $port = 5432;
my $user_name = undef;
my $password = undef;
#
die "missing table, host, or db names: $!" unless (scalar(@ARGV) >= 4);
#
$db_name = shift @ARGV;
$schema_name = shift @ARGV;
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
# my $sth = $dbh->prepare("select * from $table_name");
# my $sth = $dbh->prepare("select count(*) from pg_tables where tablename = '$table_name' and schemaname = 'public'");
my $sth = $dbh->prepare("select table_schema, table_name, column_name, data_type from information_schema.columns where table_name = '$table_name' and table_schema = '$schema_name'");
$sth->execute();
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join("|", @data);
}
#
$dbh->disconnect;
#
exit 0;
