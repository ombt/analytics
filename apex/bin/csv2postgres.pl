#!/usr/bin/perl -w
######################################################################
#
# process a maihime file, create a temp CSV file, and 
# import into PostgreSQL.
#
######################################################################
#
use strict;
use warnings;
#
my $binpath = undef;
#
BEGIN {
    use File::Basename;
    #
    $binpath = dirname($0);
    $binpath = "." if ($binpath eq "");
}
#
use Carp;
use Getopt::Std;
use File::Find;
use File::Path qw(mkpath);
use File::Path 'rmtree';
use Data::Dumper;
use Cwd 'abs_path';
use DBI;
#
# my mods
#
use lib "$binpath";
use lib "$binpath/myutils";
#
use myconstants;
use mylogger;
use myutils;
#
######################################################################
#
# globals
#
my $cmd = $0;
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $putils = myutils->new($plog);
die "Unable to create utils: $!" unless (defined($putils));
#
# cmd line options
#
my $logfile = '';
my $delimiter = ",";
my $debug_flag = FALSE;
#
my $host_name = "localhost";
my $database_name = undef; # the site name
my $schema_name = undef; # the type of file
my $user_name = "cim";
my $password = undef;
my $port = 5432;
#
my $temp_path = "PSQL.CSV.$$";
#
my $dbh = undef;
#
my %special_field_types = (
    "_filename_id" => "numeric(30,0)",
    "_filename_timestamp" => "bigint",
);
#
my %columns_in_tables = ();
#
######################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] [-T] \\ 
        [-t temp directory path] \\
        [-d row delimiter] \\
        [-u user name] [-p passwd] \\
        [-P port ] \\
        -D db_name -S schema_name [-X] \\
        [CSV-file ...] or reads STDIN

where:

    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v level - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace
    -t path - temp directory path, defaults to '${temp_path}'
    -d delimiter - row delimiter (default = <$delimiter>)
    -u user name - PostgresQL user name
    -p passwd - PostgresQL user password
    -P port - PostgreSQL port (default = 5432)
    -D db_name - name of PostgreSQL database (site name)
    -S schema_name - name of PostgreSQL schema (file type)

EOF
}
#
######################################################################
#
# database access functions
#
sub create_db
{
    my ($host, $port, $db, $user, $pwd) = @_;
    #
    $dbh = undef;
    my $dsn = "dbi:Pg:dbname='';host=$host;port=$port";
    if ( ! defined($dbh = DBI->connect($dsn, 
                                       $user, 
                                       $pwd, 
                                       { PrintError => 0,
                                         RaiseError => 0 })))
    {
        $plog->log_err("(host:%s,port:%s,db:%s,user:%s,pwd:%s) DB connect failed: %s\n", 
                       $host, 
                       $port,
                       (defined($db) ? $db : "undef"),
                       (defined($user) ? $user : "undef"),
                       (defined($pwd) ? $pwd : "undef"),
                       $DBI::errstr);
        return FAIL;
    }
    #
    my $found = FALSE;
    #
    my $sth = $dbh->prepare("select datname from pg_database");
    if ( ! defined($sth))
    {
        $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
        $dbh->disconnect;
        $dbh = undef;
        return FAIL;
    }
    #
    $sth->execute();
    #
    while (my @data = $sth->fetchrow_array())
    {
        if ($data[0] eq $db)
        {
            $found = 1;
	    last;
        }
    }
    #
    $sth = undef;
    #
    if ($found)
    {
        $plog->log_msg(": ==>> DB %s: EXISTS.\n", $db);
    }
    else
    {
        $plog->log_msg("==>> DB %s: NOT EXISTS. Creating.\n", $db);
        #
        my $sql = "create database $db";
        if (defined($user_name))
        {
            $sql .= " owner $user_name";
        }
        #
        $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            $plog->log_err("DB prepare failed: %s\n", , $DBI::errstr);
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
        if (defined($sth->execute()))
        {
            $plog->log_msg("Database %s created.\n", $db);
        }
        else
        {
            $plog->log_err("==>> DB %s: STILL DOES NOT EXISTS.\n%s\n", 
                           $db, $DBI::errstr);
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
    }
    #
    $dbh->disconnect;
    $dbh = undef;
    #
    return SUCCESS;
}
#
sub create_schema
{
    my ($host, $port, $db, $schema, $user, $pwd) = @_;
    #
    $dbh = undef;
    my $dsn = "dbi:Pg:dbname=$db;host=$host;port=$port";
    if ( ! defined($dbh = DBI->connect($dsn, 
                                       $user, 
                                       $pwd, 
                                       { PrintError => 0,
                                         RaiseError => 0 })))
    {
        $plog->log_err("DB connect failed: %s\n", $DBI::errstr);
        return FAIL;
    }
    #
    my $found = FALSE;
    #
    my $sth = $dbh->prepare("select catalog_name, schema_name , schema_owner from information_schema.schemata");
    if ( ! defined($sth))
    {
        $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
        $dbh->disconnect;
        $dbh = undef;
        return FAIL;
    }
    #
    $sth->execute();
    #
    while (my @data = $sth->fetchrow_array())
    {
        if (($data[0] eq $db) and ($data[1] eq $schema))
        {
            $found = 1;
	    last;
        }
    }
    #
    $sth = undef;
    #
    if ($found)
    {
        $plog->log_msg("DB %s, Schema %s: EXISTS.\n", $db, $schema);
    }
    else
    {
        $plog->log_msg(": ==>> DB %s, Schema %s: NOT EXISTS. Creating.\n", 
                       $db, $schema);
        #
        my $sql = "create schema $schema";
        #
        $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
        if (defined($sth->execute()))
        {
            $plog->log_msg("Database schema created.\n");
        }
        else
        {
            $plog->log_err("==>> DB %s, Schema %s: STILL DOES NOT EXISTS.\n%s\n", $db, $schema, $DBI::errstr);
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
    }
    #
    $dbh->disconnect;
    $dbh = undef;
    #
    return SUCCESS;
}
#
sub table_exists
{
    my ($schema, $table) = @_;
    #
    my $sth = $dbh->prepare("select count(*) from pg_tables where tablename = '$table' and schemaname = '$schema'");
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    my @data = $sth->fetchrow_array();
    if ($data[0] == 0)
    {
        $plog->log_vmid("Schema.Table does NOT EXIST: %s.%s\n", $schema, $table);
        return FALSE;
    }
    else
    {
        $plog->log_vmid("Schema.Table does EXIST: %s.%s\n", $schema, $table);
        return TRUE;
    }
}
#
sub add_columns_to_table
{
    my ($schema, $table, $pcols) = @_;
    #
    # columns in file section
    #
    my @cols_from_file = @{$pcols};
    tr/A-Z/a-z/ for @cols_from_file;
    $plog->log_vmid("cols-from-file %s\n", join(";", @{$pcols}));
    #
    # check if we already know the current columns in the table.
    #
    my $schema_table = "$schema.$table";
    if (exists($columns_in_tables{$schema_table}))
    {
        my $same = TRUE;
        foreach my $col (@cols_from_file)
        {
            if ( ! exists($columns_in_tables{$schema_table}{$col}))
            {
                $same = FALSE;
                last;
            }
        }
        #
        if ($same == TRUE)
        {
            # nothing to do, just return
            $plog->log_vmid("file cols == table cols.\n");
            return SUCCESS;
        }
        #
        delete $columns_in_tables{$schema_table};
    }
    #
    $plog->log_vmid("File cols != table cols.\n");
    #
    # unique columns in file section
    #
    my %seen = ();
    my @unique_cols_from_file = grep { ! $seen{$_}++ } @cols_from_file;
    $plog->log_vmid("unique-cols-from-file %s\n", 
                     join(";", @unique_cols_from_file));
    #
    # get columns from schema/table pair.
    # 
    my $sth = $dbh->prepare("select table_schema, table_name, column_name, data_type from information_schema.columns where table_name = '$table' and table_schema = '$schema'");
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    my @cols_from_table = ();
    while (my @data = $sth->fetchrow_array())
    {
        push @cols_from_table, $data[2];
    }
    $plog->log_vmid("cols-from-table %s\n", join(";", @cols_from_table));
    #
    # get unique columns from schema/table pair.
    #
    %seen = ();
    my @unique_cols_from_table = grep { ! $seen{$_}++ } @cols_from_table;
    $plog->log_vmid("unique-cols-from-table %s\n", 
                     join(";", @unique_cols_from_table));
    #
    # difference between file and table schema
    #
    my %counts = ();
    #
    foreach my $col (@unique_cols_from_file)
    {
        $counts{$col} = 1;
    }
    foreach my $col (@unique_cols_from_table)
    {
        if (exists($counts{$col}))
        {
            $counts{$col} += 2;
        }
        else
        {
            $counts{$col} = 2;
        }
    }
    #
    my @union = keys %counts;
    #
    my @intersection = ();
    my @file_minus_table = ();
    my @table_minus_file = ();
    my @symmetric_diff = ();
    #
    foreach my $col (keys %counts)
    {
        if ($counts{$col} == 1)
        {
            push @file_minus_table, $col;
            push @symmetric_diff, $col;
        }
        elsif ($counts{$col} == 2)
        {
            push @table_minus_file, $col;
            push @symmetric_diff, $col;
        }
        else
        {
            push @intersection, $col;
        }
    }
    #
    $plog->log_vmid("union of cols; %s\n", join(";", @union));
    $plog->log_vmid("intersection of cols; %s\n", join(";", @intersection));
    $plog->log_vmid("symmetric-diff of cols; %s\n", join(";", @symmetric_diff));
    $plog->log_vmid("file-table of cols; %s\n", join(";", @file_minus_table));
    $plog->log_vmid("table-file of cols; %s\n", join(";", @table_minus_file));
    #
    if (scalar(@file_minus_table) > 0)
    {
        $plog->log_vmid("Adding to table new column(s) in file, but not already in table: %s\n", join(";", @file_minus_table));
        #
        my $sql = "alter table $schema.$table ";
        #
        foreach my $col (@file_minus_table)
        {
            if (exists($special_field_types{$col}))
            {
                $sql .= "add column \"$col\" $special_field_types{$col}, ";
            }
            else
            {
                $sql .= "add column \"$col\" text, ";
            }
        }
        #
        $sql =~ s/, *$//;
        #
        my $sth = $dbh->prepare($sql);
        die "Prepare failed: $DBI::errstr\n" 
            unless (defined($sth));
        #
        die "Unable to execute: " . $sth->errstr 
            unless (defined($sth->execute()));
    }
    #
    @{$columns_in_tables{$schema_table}}{@union} = 1;
    #
    return SUCCESS;
}
#
sub create_table
{
    my ($schema, $table, $pcols) = @_;
    #
    my $sql = "create table $schema.$table ( ";
    #
    foreach my $col (@{$pcols})
    {
        # $sql .= "\"$col\" text, ";
        if (exists($special_field_types{$col}))
        {
            $sql .= "$col $special_field_types{$col}, ";
        }
        else
        {
            $sql .= "$col text, ";
        }
    }
    #
    $sql =~ s/, *$//;
    $sql .= " )";
    $sql =~ tr/A-Z/a-z/;
    #
    $plog->log_msg("==>> SQL CREATE DB command: %s\n", $sql);
    #
    my $sth = $dbh->prepare($sql);
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    $plog->log_msg("schema.table created: %s.%s\n", $schema, $table);
    return SUCCESS;
}
#
sub create_table_index
{
    my ($schema, $table, $index_name, $pcols) = @_;
    #
    my $sql = "create index $index_name on $schema.$table ( ";
    #
    foreach my $col (@{$pcols})
    {
        # $sql .= "\"$col\", ";
        $sql .= "$col, ";
    }
    #
    $sql =~ s/, *$//;
    $sql .= " )";
    $sql =~ tr/A-Z/a-z/;
    #
    $plog->log_msg("==>> SQL CREATE INDEX DB command: %s\n", $sql);
    #
    my $sth = $dbh->prepare($sql);
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    $plog->log_msg("schema.table created: %s.%s\n", $schema, $table);
    return SUCCESS;
}
#
sub make_table_and_index
{
    my ($schema_name, 
        $table_name,
        $ptable_cols,
        $table_index_name,
        $ptable_index_cols) = @_;
    #
    if (table_exists($schema_name, $table_name) != TRUE)
    {
        if ((create_table($schema_name, 
                          $table_name, 
                          $ptable_cols) != TRUE) ||
            (create_table_index($schema_name, 
                                $table_name, 
                                $table_index_name, 
                                $ptable_index_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema_name, $table_name);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub check_table
{
    my ($pcols, $schema, $table) = @_;
    #
    if (table_exists($schema, $table) == TRUE)
    {
        return add_columns_to_table($schema, $table, $pcols);
    }
    else
    {
        return create_table($schema, $table, $pcols);
    }
}
#
sub check_table_and_index
{
    my ($pcols, $schema, $table) = @_;
    #
    if (table_exists($schema, $table) == TRUE)
    {
        return add_columns_to_table($schema, $table, $pcols);
    }
    else
    {
        return make_table_and_index($schema, 
                                    $table, 
                                    $pcols,
                                    "idx_" . $table,
                                    [ "_filename_id" ] );
    }
}
#
sub open_db
{
    my ($pdbh, $host, $port, $db, $user, $pwd) = @_;
    #
    my $dsn = "dbi:Pg:dbname=$db;host=$host;port=$port";
    if ( ! defined($$pdbh = DBI->connect($dsn, 
                                         $user, 
                                         $pwd, 
                                         { PrintError => 0,
                                           RaiseError => 0 })))
    {
        $plog->log_err("DB connect failed: %s\n", $DBI::errstr);
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub close_db
{
    my ($pdbh) = @_;
    #
    $pdbh->disconnect();
    #
    return SUCCESS;
}
#
######################################################################
#
sub export_to_postgres
{
    my ($prod_file, $schema, $praw_data) = @_;
    #
    $plog->log_msg("Exporting data file to Postgres: %s\n", $prod_file);
    #
    my $file_name = basename($prod_file);
    if ($file_name !~ m/\.csv$/i)
    {
        $plog->log_err("Not a CSV file: %s\n", $prod_file);
        return FAIL;
    }
    #
    my $table = $file_name;
    $table =~ tr/A-Z/a-z/;
    $table =~ s/\....$//;
    $table =~ s/\.sql$//; # just in case ...
    $table =~ s/[\[\]]//g;
    $table =~ s/<([0-9]+)>/_$1/g;
    $table =~ s/\./_/g;
    #
    my $header = shift @{$praw_data};
    $header =~ tr/A-Z/a-z/;
    #
    my @cols = split /${delimiter}/, $header;
    s/^(.*)$/_$1/ for @{cols};
    #
    $plog->log_msg("Table: %s, Header: %s\n", $table, $header);
    #
    if ((table_exists($schema, $table) != TRUE) &&
        (create_table($schema, $table, \@cols) != TRUE))
    {
        $plog->log_err("Failed to create table: %s\n", $table);
        return FAIL;
    }
    else
    {
        $plog->log_msg("Created table: %s\n", $table);
    }
    #
    my $full_prod_file = abs_path($prod_file);
    #
    my $sql = "copy ${schema}.${table} ( " . join(",", @cols) . " ) from '${full_prod_file}' with ( format csv, delimiter '${delimiter}', header ) ";
    #
    $plog->log_msg("COPY CMD: %s\n", $sql);
    #
    my $sth = $dbh->prepare($sql);
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    return SUCCESS;
}
#
sub process_file
{
    my ($prod_file, $schema) = @_;
    #
    $plog->log_msg("Processing product File, Schema: %s,%s\n", 
                   $prod_file, $schema);
    #
    my @raw_data = ();
    #
    my $status = FAIL;
    if ($putils->read_file($prod_file, \@raw_data) != SUCCESS)
    {
        $plog->log_err("Reading product file: %s\n", $prod_file);
    }
    elsif (export_to_postgres($prod_file, $schema, \@raw_data) != SUCCESS)
    {
        $plog->log_err("Exporting product file to Postgresql: %s\n", $prod_file);
    }
    else
    {
        $plog->log_msg("Success processing product file: %s\n", 
                        $prod_file);
        $status = SUCCESS;
    }
    #
    return $status;
}
#
######################################################################
#
# start of main
#
$plog->trace(FALSE);
$plog->disable_stdout_buffering();
#
# build allowed options using usage message
#
my $alwd_opts = "";
$alwd_opts .= '?h'; # -? or -h - print this usage.
$alwd_opts .= 'w';  # -w - enable warning (level=min=1)
$alwd_opts .= 'W';  # -W - enable warning and trace (level=mid=2)
$alwd_opts .= 'v:'; # -v level - verbose level: 0=off,1=min,2=mid,3=max
$alwd_opts .= 'l:'; # -l logfile - log file path
$alwd_opts .= 'T';  # -T - turn on trace
$alwd_opts .= 't:'; # -t path - temp directory path, defaults to '${temp_path}'
$alwd_opts .= 'd:'; # -d delimiter - row delimiter (new line by default)
$alwd_opts .= 'u:'; # -u user name - PostgresQL user name
$alwd_opts .= 'p:'; # -p passwd - PostgresQL user password
$alwd_opts .= 'P:'; # -P port - PostgreSQL port (default = 5432)
$alwd_opts .= 'D:'; # -D db_name - name of PostgreSQL database (site name)
$alwd_opts .= 'S:'; # -S schema_name - name of PostgreSQL schema (file type)
#
my %opts;
if (getopts($alwd_opts, \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (%opts)
{
    if (($opt eq 'h') or ($opt eq '?'))
    {
        usage($cmd);
        exit 0;
    }
    elsif ($opt eq 'T')
    {
        $plog->trace(TRUE);
    }
    elsif ($opt eq 'w')
    {
        $plog->verbose(MINVERBOSE);
    }
    elsif ($opt eq 'W')
    {
        $plog->verbose(MIDVERBOSE);
    }
    elsif ($opt eq 'v')
    {
        if (!defined($plog->verbose($opts{$opt})))
        {
            $plog->log_err("Invalid verbose level: $opts{$opt}\n");
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        $plog->logfile($opts{$opt});
        $plog->log_msg("Log File: %s\n", $opts{$opt});
    }
    elsif ($opt eq 't')
    {
        $temp_path = $opts{$opt} . '/';
        $plog->log_msg("Temp directory path: %s\n", $temp_path);
    }
    elsif ($opt eq 'd')
    {
        $delimiter = $opts{$opt};
        $plog->delimiter($delimiter);
    }
    elsif ($opt eq 'u')
    {
        $user_name = $opts{$opt};
    }
    elsif ($opt eq 'p')
    {
        $password = $opts{$opt};
    }
    elsif ($opt eq 'P')
    {
        $port = $opts{$opt};
    }
    elsif ($opt eq 'D')
    {
        $database_name = $opts{$opt};
    }
    elsif ($opt eq 'S')
    {
        $schema_name = $opts{$opt};
    }
}
#
if (( ! defined($database_name)) ||
    ( ! defined($schema_name)) ||
    ( $schema_name eq "") ||
    ( $database_name eq ""))
{
    $plog->log_err("Database or Schema names are undefined.\n");
    usage($cmd);
    exit 2;
}
#
$plog->log_msg("Open DB for (host,port,db,user) = (%s,%s,%s,%s)\n", 
               $host_name, 
               $port, 
               $database_name, 
               (defined($user_name) ? $user_name : "undef"));
#
# clean up upon exit
#
END {
    if (defined($dbh))
    {
        $plog->log_msg("END block. Closing DB.\n");
        close_db($dbh);
        $dbh = undef;
    }
    else
    {
        $plog->log_msg("END block. DB already closed.\n");
    }
}
#
# check if db exists.
#
if (create_db($host_name, $port, 
              $database_name, 
              $user_name, $password) != SUCCESS)
{
    $plog->log_err_exit("Create DB failed for (host,port,db,user,pass) = (%s,%s,%s,%s,%s)", 
                        $host_name, $port, 
                        $database_name, 
                        (defined($user_name) ? $user_name : "undef"),
                        (defined($password) ? $password : "undef"));
}
#
# check if schema exists.
#
if (create_schema($host_name, $port, 
                  $database_name, $schema_name, 
                  $user_name, $password) != SUCCESS)
{
    $plog->log_err_exit("Create DB schema failed for (host,port,db,schema,user,pass) = (%s,%s,%s,%s,%s,%s)",
                        $host_name, $port, 
                        $database_name, $schema_name, 
                        (defined($user_name) ? $user_name : "undef"),
                        (defined($password) ? $password : "undef"));
}
#
if (open_db(\$dbh, $host_name, $port, 
             $database_name, 
             $user_name, $password) != SUCCESS)
{
    $plog->log_err("Open DB failed for (host,port,db,user,pass) = (%s,%s,%s,%s,%s)", 
                   $host_name, $port, 
                   $database_name, 
                   (defined($user_name) ? $user_name : "undef"),
                   (defined($password) ? $password : "undef"));
    usage($cmd);
    exit 2;
}
#
if ( -t STDIN )
{
    #
    # getting a list of files from command line.
    #
    if (scalar(@ARGV) == 0)
    {
        $plog->log_err("No product files given.\n");
        usage($cmd);
        exit 2;
    }
    #
    foreach my $prod_file (@ARGV)
    {
        my $status = process_file($prod_file, $schema_name);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $prod_file);
        }
    }
}
else
{
    $plog->log_msg("Reading STDIN for list of files ...\n");
    #
    while( defined(my $prod_file = <STDIN>) )
    {
        chomp($prod_file);
        my $status = process_file($prod_file, $schema_name);
        if ($status != SUCCESS)
        {
            $plog->log_err_exit("Failed to process %s.\n", $prod_file);
        }
    }
}
#
close_db($dbh);
$dbh = undef;
# 
exit 0;
