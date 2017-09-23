#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 host [user [passwd]]\n", ;
    exit 0;
}
#
my $host_name = undef;
my $user_name = undef;
my $password = undef;
#
die "missing host: $!" unless (scalar(@ARGV) >= 1);
#
$host_name = shift @ARGV;
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
#
my $dsn = "dbi:Pg:dbname='';host=$host_name";
#
my $dbh = DBI->connect($dsn, $user_name, $password, { PrintError => 0, RaiseError => 0 } );
, $password);
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
# my $sth = $dbh->prepare("select * from $table_name");
# my $sth = $dbh->prepare("select count(*) from pg_tables where tablename = '$table_name' and schemaname = 'public'");
my $sth = $dbh->prepare("select datname from pg_database");
$sth->execute();
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join("|", @data);
}
#
$dbh->disconnect;
#
exit 0;
