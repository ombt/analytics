#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
if (scalar(@ARGV) == 0)
{
    printf "usage: $0 db [schema.]table fld1[:fld2...] index_name host [port [user [passwd]]]\n", ;
    exit 0;
}
#
my $db_name = undef;
my $schema_table = undef;
my $index_fields = undef;
my $index_name = undef;
my $host_name = undef;
my $port = 5432;
my $user_name = undef;
my $password = undef;
#
die "missing db, schema, table, flds, index name or host: $!" unless (scalar(@ARGV) >= 5);
#
$db_name = shift @ARGV;
$schema_table = shift @ARGV;
$index_fields = shift @ARGV;
$index_name = shift @ARGV;
$host_name = shift @ARGV;
#
$port = shift @ARGV if (scalar(@ARGV) > 0);
$user_name = shift @ARGV if (scalar(@ARGV) > 0);
$password = shift @ARGV if (scalar(@ARGV) > 0);
#
my @fields = split /:/, $index_fields;
#
my $dsn = "dbi:Pg:dbname=$db_name;host=$host_name;port=$port";
#
my $dbh = DBI->connect($dsn, 
                       $user_name, 
                       $password, 
                       { PrintError => 0, 
                         RaiseError => 0 } );
die "Unable to connect: $DBI::errstr\n" unless (defined($dbh));
#
my $sql = "create index $index_name on $schema_table ( ";
    #
foreach my $col (@{fields})
{
    $sql .= "$col, ";
}
#
$sql =~ s/, *$//;
$sql .= " )";
$sql =~ tr/A-Z/a-z/;
#
printf "==>> SQL CREATE INDEX DB command: %s\n", $sql;
#
my $sth = $dbh->prepare($sql);
die "Prepare failed: $DBI::errstr\n" 
    unless (defined($sth));
#
die "Unable to execute: " . $sth->errstr 
    unless (defined($sth->execute()));
#
printf "Index %s created for schema.table: %s\n", 
       $index_name, $schema_table;
#
$dbh->disconnect;
#
exit 0;
