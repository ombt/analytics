#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 table fld1[:fld2...] host db [user [passwd]]\n", ;
    exit 0;
}
#
my $table_name = undef;
my $csv_fields = undef;
my $host_name = undef;
my $db_name = undef;
my $user_name = undef;
my $password = undef;
#
die "missing table, host, or db names: $!" unless (scalar(@ARGV) >= 4);
#
$table_name = shift @ARGV;
$csv_fields = shift @ARGV;
$host_name = shift @ARGV;
$db_name = shift @ARGV;
#
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
my @fields = split /:/, $csv_fields;
#
my $dsn = "dbi:Pg:dbname=$db_name;host=$host_name";
#
my $dbh = DBI->connect($dsn, $user_name, $password, { PrintError => 0, RaiseError => 0 } );
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
my $sth = $dbh->prepare("select tablename from pg_tables where tablename = '$table_name' and schemaname = 'public'");
$sth->execute();
#
my $found = 0;
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
die "Table $table_name does NOT EXIST." unless ($found);
#
my $sql = "alter table $table_name ";
#
while (scalar(@fields) > 0)
{
    my $field = shift @fields;
    #
    $sql .= "add column $field text, ";
}
#
$sql =~ s/, *$//;
#
printf "==>> SQL Alter command: %s\n", $sql;
#
$sth = $dbh->prepare($sql);
if (defined($sth->execute()))
{
    printf "==>> Table altered ... \n";
}
else
{
    printf "==>> TABLE alter failed.\n";
}
#
$dbh->disconnect;
#
exit 0;
