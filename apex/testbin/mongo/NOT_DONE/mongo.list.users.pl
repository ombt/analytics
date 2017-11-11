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
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
my $sth = $dbh->prepare(
"SELECT 
     u.usename AS \"User Name\", 
     u.usesysid AS \"User ID\",  
     CASE 
         WHEN u.usesuper AND u.usecreatedb 
         THEN 
             CAST('superuser, create database' AS pg_catalog.text)
         WHEN u.usesuper 
         THEN 
             CAST('superuser' AS pg_catalog.text)
         WHEN u.usecreatedb 
         THEN 
             CAST('create database' AS pg_catalog.text)
         ELSE 
            CAST('' AS pg_catalog.text)
     END AS \"Attributes\" 
 FROM 
     pg_catalog.pg_user u
 ORDER BY
     u.usename");
die "Prepare failed: $DBI::errstr\n" unless (defined($sth));
#
$sth->execute();
#
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join("|", @data);
}
#
$dbh->disconnect;
#
exit 0;
