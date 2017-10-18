#!/usr/bin/perl -w
#########################################################################
#
# basic script to access a CIMC database and execute a command.
#
#########################################################################
#
use strict;
#
# packages
#
use Getopt::Std;
use DBI;
use File::Basename;
#
# globals
#
my $cmd = $0;
my $base_cmd = basename($cmd);
#
my $db_user   = "cim";
my $db_passwd = "cim";
my $db_server = "";
my $db_port = -1;
my $db_name = "";
#
my $use_column_names = "no";
my $field_separator = ";";
#
my %operations = (
    'cimc-sql.pl' => {
        operation => sub { },
        usage => "
usage: ${base_cmd} 
        [-?|-h] 
where:
        -? - print usage
        -h - print usage"
    },
    'lsdb.pl' => {
        operation => \&lsdb,
        usage => "
usage: ${base_cmd} 
        [-?|-h] 
	[-U user_name] [-P user_passwd]
	[-s server_name] [-p server_port]
where:
        -? - print usage
        -h - print usage"
    },
    'lsdbtbls.pl' => {
        operation => \&lsdbtbls,
        usage => "
usage: ${base_cmd} 
        [-?|-h] 
	[-U user_name] [-P user_passwd]
	[-s server_name] [-p server_port]
        [-d db_name] 
where:
        -? - print usage
        -h - print usage"
    },
    'select.pl' => {
        operation => \&select,
        usage => "
usage: ${base_cmd} 
        [-?|-h] 
	[-U user_name] [-P user_passwd]
	[-s server_name] [-p server_port] 
        [-d db_name] 
        [-c] [-f field_separator]
        table [field1 [field2 ...]]
where:
        -? - print usage
        -h - print usage
        -c - print column names
        -f field_separator - delimiter for fields in a row.
                             default is a semi-colon, ';'."
    },
);
#
#########################################################################
#
sub usage 
{
    my ($arg0) = @_;
    #
    $arg0 = basename($arg0);
    #
    if (exists($operations{$arg0}))
    {
        printf "%s\n\n", $operations{$arg0}{usage};
    }
    else
    {
        printf "%s\n\n", $operations{'cimc-sql.pl'}{usage};
        $arg0 = 'cimc-sql.pl';
    }
    #
    printf "All available operations are:\n\n";
    foreach my $operation (keys %operations)
    {
        printf "\t%s\n", $operation;
    }
}
#
#########################################################################
#
sub open_db_connection
{
    my ($db_server, $db_port, $db_name, $db_user, $db_passwd, $pdbh) = @_;
    #
    my $dsn = "DBI:Sybase:host=$db_server;port=$db_port";
    $dsn .= ";database=$db_name" if ($db_name ne "");
printf "DSN=<%s>\n", $dsn;
    #
    $$pdbh = DBI->connect($dsn, $db_user, $db_passwd, {PrintError => 0});
    # 
    unless ($$pdbh) {
        die "ERROR: Failed to connect to server ($db_server).\nERROR MESSAGE: $DBI::errstr";
    }
}
#
sub close_db_connection
{
    my ($dbh) = @_;
    $dbh->disconnect;
}
#
#########################################################################
#
sub lsdb
{
    my ($pargs) = @_;
    #
    my $dbh;
    open_db_connection($db_server, $db_port, "", $db_user, $db_passwd, \$dbh);
    #
    my $sql = "SELECT name FROM sys.sysdatabases";
    #
    my $sth;
    unless ($sth = $dbh->prepare($sql))
    {
        $dbh->disconnect;
        die "ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    unless ($sth->execute)
    {
        $dbh->disconnect;
        die "ERROR: Failed to execute query.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    while (my ($name) = $sth->fetchrow)
    {
        printf "Name: %s\n", $name;
    }
    #
    $sth->finish;
    #
    close_db_connection($dbh);
}
#########################################################################
#
sub lsdbtbls
{
    my ($pargs) = @_;
    #
    my $dbh;
    open_db_connection($db_server, $db_port, $db_name, $db_user, $db_passwd, \$dbh);
    #
    my $sql = "SELECT name, object_id, type_desc FROM sys.objects WHERE type_desc = 'USER_TABLE'";
    #
    my $sth;
    unless ($sth = $dbh->prepare($sql))
    {
        $dbh->disconnect;
        die "ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    unless ($sth->execute)
    {
        $dbh->disconnect;
        die "ERROR: Failed to execute query.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    printf "TABLE NAME:\n";
    while (my ($name) = $sth->fetchrow)
    {
        printf "%s\n", $name;
    }
    #
    $sth->finish;
    #
    close_db_connection($dbh);
}
#
#########################################################################
#
sub select
{
    my ($pargs) = @_;
    #
    die "ERROR: NO database name given." if ($db_name eq "");
    die "ERROR: NO table given." if (scalar(@{$pargs}) <= 0);
    #
    my $dbh;
    open_db_connection($db_server, $db_port, $db_name, $db_user, $db_passwd, \$dbh);
    #
    my $table = shift @{$pargs};
    #
    my $fields = '*';
    if (scalar(@{$pargs}) > 0)
    {
        $fields = shift @{$pargs};
        foreach my $field (@{$pargs})
        {
            $fields .= ", $field";
        }
    }
    #
    my $sql = "SELECT ${fields} FROM ${table}";
    #
    my $sth;
    unless ($sth = $dbh->prepare($sql))
    {
        $dbh->disconnect;
        die "ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    unless ($sth->execute)
    {
        $dbh->disconnect;
        die "ERROR: Failed to execute query.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    if ($use_column_names eq "yes")
    {
        my $first = 1;
        my @column_names = ();
        while (my $precord = $sth->fetchrow_hashref)
        {
            if ($first)
            {
                my @column_names = sort keys %{$precord};
                printf "%s\n", join("$field_separator", @column_names);
                $first = 0;
            }
            #
            my @record = map { $precord->{$_} } sort keys %{$precord};
            #
            @record = grep {
                $_ = "NULL" if ( ! defined($_));
                $_;
            } @record;
            #
            printf "%s\n", join("$field_separator", @record);
        }
    }
    else
    {
        while (my @record = $sth->fetchrow)
        {
            @record = grep {
                $_ = "NULL" if ( ! defined($_));
                $_;
            } @record;
            printf "%s\n", join("$field_separator", @record);
        }
    }
    #
    $sth->finish;
    #
    close_db_connection($dbh);
}
#
#########################################################################
#
# get command line options
#
my %opts = ();
if (getopts('?hcU:P:s:p:d:f:', \%opts) != 1)
{
    usage($base_cmd);
    exit(1);
}
#
$db_server = $ENV{DB_SERVER} if (exists($ENV{DB_SERVER}));
$db_port = $ENV{DB_PORT_NO} if (exists($ENV{DB_PORT_NO}));
$db_name = $ENV{DB_NAME} if (exists($ENV{DB_NAME}));
#
foreach my $opt (%opts)
{
    if (($opt eq "?") or ($opt eq "h"))
    {
        usage($base_cmd);
        exit(0);
    }
    elsif ($opt eq "U")
    {
        $db_user = $opts{$opt};
    }
    elsif ($opt eq "P")
    {
        $db_passwd = $opts{$opt};
    }
    elsif ($opt eq "s")
    {
        $db_server = $opts{$opt};
    }
    elsif ($opt eq "p")
    {
        $db_port = $opts{$opt};
    }
    elsif ($opt eq "d")
    {
        $db_name = $opts{$opt};
    }
    elsif ($opt eq "c")
    {
        $use_column_names = "yes";
    }
    elsif ($opt eq "f")
    {
        $field_separator = $opts{$opt};
    }
}
#
printf "DB USER  : %s\n", $db_user;
printf "DB SERVER: %s\n", $db_server;
printf "DB PORT  : %s\n", $db_port;
#
# check which command was issued.
#
die "ERROR: ${base_cmd} NOT supported." unless (exists($operations{$base_cmd}{operation}));
#
# run requested operation
#
&{$operations{$base_cmd}{operation}}(\@ARGV);
#
# all done
#
exit 0;
