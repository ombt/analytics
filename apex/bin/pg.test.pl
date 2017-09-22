#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
my $dsn = "dbi:Pg:dbname=cim;host=localhost";
#
my $dbh = DBI->connect($dsn, "cim");
#
my $sth = $dbh->prepare("select * from test");
$sth->execute();
while (my @data = $sth->fetchrow_array())
{
    printf "==>> %s\n", join(" ", @data);
}
#
$dbh->disconnect;
#
exit 0;
