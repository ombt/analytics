#!/usr/bin/perl -w
use strict;
use DBI;
#
my $user   = "cim";
my $passwd = "cim";
my $server = "$ENV{DB_SERVER}";
my $port = "$ENV{DB_PORT_NO}";
# 
my $dbh = DBI->connect("DBI:Sybase:host=$server;port=$port", $user, $passwd, {PrintError => 0});
my $sth;
# 
unless ($dbh) {
    die "ERROR: Failed to connect to server ($server).\nERROR MESSAGE: $DBI::errstr";
} else {
    print "\n";
    print "Successful Connection.";
    print "\n\n";
}
# 
print "Current Connection Properties\n";
print "---------------------------------------------------------------------------------------\n";
my $sqlStatement = "select \@\@servername, \@\@version, db_name(), system_user, host_name()";
unless ($sth = $dbh->prepare($sqlStatement)) {
    $dbh->disconnect;
    die "ERROR: Failed to prepare SQL statement.\nSQL: $sqlStatement\nERROR MESSAGE: $DBI::errstr";
}
unless ($sth->execute) {
    $dbh->disconnect;
    die "ERROR: Failed to execute query.\nSQL: $sqlStatement\nERROR MESSAGE: $DBI::errstr";
}
while (my ($serverName, $sqlServerVersion, $currentDatabase,
          $currentUser, $clientMachine) = $sth->fetchrow)
{
    my @dummy = ();
    ($sqlServerVersion, @dummy) = split(/\n/, $sqlServerVersion);

    print "    SQL Server Instance : $serverName\n";
    print "    SQL Server Version  : $sqlServerVersion\n";
    print "    Current Database    : $currentDatabase\n";
    print "    Current User        : $currentUser\n";
    print "    Client Machine      : $clientMachine\n";
}
print "\n";
$sth->finish;
# 
# 
print "Available Databases\n";
print "-----------------------------------------------------------------\n";
$sqlStatement = "select
                        isnull(db_name(dbid), 'MSSQL SYSTEM RESOURCE') as Name
                      , str(convert(dec(15),sum(size))* 8192/ 1048576,10,2)+ N' MB' as Size
                    from sys.sysaltfiles
                    group by dbid
                    order by 2 desc";
unless ($sth = $dbh->prepare($sqlStatement)) {
    $dbh->disconnect;
    die "ERROR: Failed to prepare SQL statement.\nSQL: $sqlStatement\nERROR MESSAGE: $DBI::errstr";
}
unless ($sth->execute) {
    $dbh->disconnect;
    die "ERROR: Failed to execute query.\nSQL: $sqlStatement\nERROR MESSAGE: $DBI::errstr";
}
while (my ($databaseName, $databaseSize) = $sth->fetchrow) {
    printf("    %-40s %20s\n", $databaseName, $databaseSize);  
}
print "\n";
$sth->finish;
# 
print "Disconnecting from SQL Server.\n\n";
$dbh->disconnect;
exit(0);
