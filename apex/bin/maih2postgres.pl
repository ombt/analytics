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
use mymaihparser;
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
my $pmaih = mymaihparser->new($plog);
die "Unable to create maih parser: $!" unless (defined($pmaih));
#
# cmd line options
#
my $logfile = '';
my $delimiter = "\t";
my $export_to_postgresql = TRUE;
my $debug_flag = FALSE;
#
my $host_name = "localhost";
my $database_name = undef; # the site name
my $schema_name = undef; # the type of file
my $user_name = "cim";
my $password = undef;
my $port = 5432;
my $route_name = "none";
#
my $temp_path = "PSQL.CSV.$$";
#
my $dbh = undef;
#
# track existing tables to determine when to flush
# data to the database. usually it will once for each
# section type (table) and for all the data.
#
my %tables =
(
    dummy => {
        name => undef,
        columns => [],
        csv_file => undef
    }
);
#
# track the columns in tables.
#
my %columns_in_tables = ();
#
# filename table data
#
my $fid_table_name = "filename_to_fid";
my @fid_table_cols = ( "_filename", 
                       "_filename_type",
                       "_filename_timestamp",
                       "_filename_route",
                       "_filename_id" );
my $fid_table_index_name = "idx_filename_to_fid";
my @fid_table_index_cols = ( "_filename_id" );
#
my $u0x_table_name = "u0x_filename_data";
my @u0x_table_cols = ( "_filename_id", 
                       "_date",
                       "_machine_order",
                       "_stage_no",
                       "_lane_no",
                       "_pcb_serial",
                       "_pcb_id",
                       "_output_no",
                       "_pcb_id_lot_no",
                       "_pcb_id_serial_no" );
my $u0x_table_index_name = "idx_u0x_filename_data";
my @u0x_table_index_cols = ( "_filename_id" );
#
my $crb_table_name = "crb_filename_data";
my @crb_table_cols = ( "_filename_id", 
                       "_history_id",
                       "_time_stamp",
                       "_crb_file_name",
                       "_product_name" );
my $crb_table_index_name = "idx_crb_filename_data";
my @crb_table_index_cols = ( "_filename_id" );
#
my $rst_table_name = "rst_filename_data";
my @rst_table_cols = ( "_filename_id", 
                       "_machine",
                       "_lane",
                       "_date_time",
                       "_serial_number",
                       "_inspection_result",
                       "_board_removed" );
my $rst_table_index_name = "idx_rst_filename_data";
my @rst_table_index_cols = ( "_filename_id" );
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
        [-R route ] \\
        -D db_name -S schema_name [-X]
        [maihime-file ...] or reads STDIN

where:

    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v level - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -T - turn on trace
    -t path - temp directory path, defaults to '${temp_path}'
    -d delimiter - delimiter (tab by default)
    -u user name - PostgresQL user name
    -p passwd - PostgresQL user password
    -P port - PostgreSQL port (default = 5432)
    -R route - route name (default=none)
    -D db_name - name of PostgreSQL database (site name)
    -S schema_name - name of PostgreSQL schema (file type)
    -X - DO NOT EXPORT to PostgreSQL and KEEP CSV file.

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
            $sql .= "add column \"$col\" text, ";
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
        $sql .= "$col text, ";
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
sub export_section_to_postgres
{
    my ($fname_id, $pprod_db, $schema, $section) = @_;
    #
    my $table = $section;
    $table =~ tr/A-Z/a-z/;
    $table =~ s/[\[\]]//g;
    $table =~ s/<([0-9]+)>/_$1/g;
    #
    $plog->log_vmid("Export section %s to schema.table %s.%s\n", 
                   $section, $schema, $table);
    #
    # check if table exists
    #
    my $pcols_wo_fid = $pprod_db->{COLUMN_NAMES}->{$section};
    my $pcols_w_fid = $pprod_db->{COLUMN_NAMES_WITH_FID}->{$section};
    if (check_table_and_index($pcols_w_fid, $schema, $table) != SUCCESS)
    {
        $plog->log_err("Check table and index failed: section %s, schema.table %s.%s\n", $section, $schema, $table);
        return FAIL;
    }
    #
    if ($debug_flag == TRUE)
    {
        $plog->log_msg("==>> section: %s\n", $section);
        #
        $plog->log_msg("schema.table: %s.%s\n", $schema, $table);
        #
        my $local_delimiter = "";
        foreach my $col (@{$pcols_w_fid})
        {
            $plog->log_msg("%s%s", $local_delimiter, $col);
            $local_delimiter = $delimiter;
        }
        $plog->log_msg("\n");
        #
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $local_delimiter = "${fname_id}${delimiter}";
            foreach my $col (@{$pcols_wo_fid})
            {
                $plog->log_msg("%s%s", $local_delimiter, $prow->{$col});
                $local_delimiter = $delimiter;
            }
            $plog->log_msg("\n");
        }
    }
    else
    {
        my $csv_file = "/tmp/csv.$$";
        open(my $outfh, ">" , $csv_file) || die "file is $csv_file: $!";
        #
        my $local_delimiter = "";
        foreach my $col (@{$pcols_w_fid})
        {
            printf $outfh "%s%s", $local_delimiter, $col;
            $local_delimiter = $delimiter;
        }
        printf $outfh "\n";
        #
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $local_delimiter = "${fname_id}${delimiter}";
            foreach my $col (@{$pcols_wo_fid})
            {
                printf $outfh "%s%s", $local_delimiter, $prow->{$col};
                $local_delimiter = $delimiter;
            }
            printf $outfh "\n";
        }
        #
        close($outfh);
        #
        my @cols_from_file = @{$pcols_w_fid};
        tr/A-Z/a-z/ for @cols_from_file;
        #
        # my $sql = "copy ${schema}.${table} ( \"" . join("\",\"", @cols_from_file) . "\" ) from '${csv_file}' with ( format csv, delimiter '${delimiter}', header ) ";
         my $sql = "copy ${schema}.${table} ( " . join(",", @cols_from_file) . " ) from '${csv_file}' with ( format csv, delimiter '${delimiter}', header ) ";
        $plog->log_vmid("COPY CMD: %s\n", $sql);
        #
        my $sth = $dbh->prepare($sql);
        die "Prepare failed: $DBI::errstr\n" 
            unless (defined($sth));
        #
        die "Unable to execute: " . $sth->errstr 
            unless (defined($sth->execute()));
    }
    #
    return SUCCESS;
}
#
sub insert_filename_to_id
{
    my ($schema, $fname, $fname_type, $fname_tstamp, $route_name, $fname_id) = @_;
    #
    $plog->log_vmid("Inserting %s ==>> %s,%s into %s filename-to-id table\n",
                    $fname, $fname_type, $fname_id, $schema);
    #
    my $sql = "insert into ${schema}.${fid_table_name} ( " .  join(",", @fid_table_cols) . " ) values ( '$fname', '$fname_type', '$fname_tstamp', '$route_name', '$fname_id' )";
    #
    my $sth = $dbh->prepare($sql);
    if ( ! defined($sth))
    {
        $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
        return FAIL;
    }
    if ( ! defined($sth->execute()))
    {
        $plog->log_err("DB Execute failed: %s\n", $DBI::errstr);
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub insert_ext_data
{
    my ($schema, $ext, $fid, $pparts) = @_;
    #
    $plog->log_vmid("Inserting %s, %s, %s, %s into filename data tables\n",
                    $schema, $ext, $fid, join(",", @{$pparts}));
    #
    if (($ext =~ m/^u01$/i) ||
        ($ext =~ m/^u03$/i) ||
        ($ext =~ m/^mpr$/i))
    {
        my $idx = -1;
        #
        my $sql = "insert into ${schema}.${u0x_table_name} ( " . 
                   join(",", @u0x_table_cols) . 
                  " ) values ( '$fid','" . 
                   join("','", @{$pparts}) . 
                  "' )";
        #
        my $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
            return FAIL;
        }
        if ( ! defined($sth->execute()))
        {
            $plog->log_err("DB Execute failed: %s\n", $DBI::errstr);
            return FAIL;
        }
    }
    elsif ($ext =~ m/^crb$/i) 
    {
        my $idx = -1;
        #
        my $sql = "insert into ${schema}.${crb_table_name} ( " . 
                   join(",", @crb_table_cols) . 
                  " ) values ( '$fid','" . 
                   join("','", @{$pparts}) . 
                  "' )";
        #
        my $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
            return FAIL;
        }
        if ( ! defined($sth->execute()))
        {
            $plog->log_err("DB Execute failed: %s\n", $DBI::errstr);
            return FAIL;
        }
    }
    elsif ($ext =~ m/^rst$/i) 
    {
        my $idx = -1;
        #
        my $sql = "insert into ${schema}.${rst_table_name} ( " . 
                   join(",", @rst_table_cols) . 
                  " ) values ( '$fid','" . 
                   join("','", @{$pparts}) . 
                  "' )";
        #
        my $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            $plog->log_err("DB prepare failed: %s\n", $DBI::errstr);
            return FAIL;
        }
        if ( ! defined($sth->execute()))
        {
            $plog->log_err("DB Execute failed: %s\n", $DBI::errstr);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub export_to_postgres
{
    my ($prod_file, $schema, $route_name, $pprod_db) = @_;
    #
    $plog->log_msg("Exporting data file to Postgres: %s\n", $prod_file);
    #
    my $filename = basename($prod_file);
    #
    # parse file name and get data.
    #
    my $tstamp = 0;
    my $ext = "";
    my @parts = undef;
    if ($pmaih->parse_filename($filename, \$ext, \$tstamp, \@parts) != SUCCESS)
    {
        $plog->log_err("Failed to parse filename: %s\n", 
                       $filename);
        return FAIL;
    }
    #
    # add filename to filename-to-id table.
    #
    my $filename_id = $putils->crc_64($filename);
    if (insert_filename_to_id($schema, $filename, $ext, $tstamp, $route_name, $filename_id) != SUCCESS)
    {
        $plog->log_err("Failed to insert filename-to-id tuple: %s ==>> %s\n", 
                       $filename, $filename_id);
        return FAIL;
    }
    #
    if (insert_ext_data($schema, $ext, $filename_id, \@parts) != SUCCESS)
    {
        $plog->log_err("Failed to insert filename extension <%s> data: %s ==>> %s\n", 
                       $ext, $filename, $filename_id);
        return FAIL;
    }
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    $plog->log_vmid("Schema, Product Name: %s, %s\n", $schema, $prod_name);
    #
    my $status = FAIL;
    #
    my $max_isec = scalar(@{$pprod_db->{ORDER}});
    for (my $isec = 0; $isec<$max_isec; ++$isec)
    {
        my $section = $pprod_db->{ORDER}->[$isec];
        #
        $plog->log_vmid("writing section: %s\n", $section);
        #
        if ($pprod_db->{TYPE}->{$section} == SECTION_NAME_VALUE)
        {
            $plog->log_vmid("Name-Value Section: %s\n", $section);
            $status = export_section_to_postgres($filename_id,
                                                 $pprod_db,
                                                 $schema,
                                                 $section);
        }
        elsif ($pprod_db->{TYPE}->{$section} == SECTION_LIST)
        {
            $plog->log_vmid("List Section: %s\n", $section);
            $status = export_section_to_postgres($filename_id,
                                                 $pprod_db,
                                                 $schema,
                                                 $section);
        }
        else
        {
            $plog->log_err("Unknown type Section: %s\n", $section);
        }
    }
    #
    return $status;
}
#
sub process_file
{
    my ($prod_file, $schema, $route_name) = @_;
    #
    $plog->log_msg("Processing product File, Schema: %s,%s\n", 
                   $prod_file, $schema);
    #
    my @raw_data = ();
    my %prod_db = ();
    #
    my $status = FAIL;
    if ($putils->read_file($prod_file, \@raw_data) != SUCCESS)
    {
        $plog->log_err("Reading product file: %s\n", $prod_file);
    }
    elsif ($pmaih->process_data($prod_file, \@raw_data, \%prod_db) != SUCCESS)
    {
        $plog->log_err("Processing product file: %s\n", $prod_file);
    }
    elsif (export_to_postgres($prod_file, $schema, $route_name, \%prod_db) != SUCCESS)
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
sub make_tables
{
    my ($schema) = @_;
    #
    if (make_table_and_index($schema, 
                             $fid_table_name, 
                            \@fid_table_cols,
                             $fid_table_index_name, 
                            \@fid_table_index_cols) != TRUE)
    {
        $plog->log_err("Unable to create table or index for %s.%s\n", 
                       $schema, $fid_table_name);
        return FAIL;
    }
    if (make_table_and_index($schema, 
                             $u0x_table_name, 
                            \@u0x_table_cols,
                             $u0x_table_index_name, 
                            \@u0x_table_index_cols) != TRUE)
    {
        $plog->log_err("Unable to create table or index for %s.%s\n", 
                       $schema, $u0x_table_name);
        return FAIL;
    }
    if (make_table_and_index($schema, 
                             $crb_table_name, 
                            \@crb_table_cols,
                             $crb_table_index_name, 
                            \@crb_table_index_cols) != TRUE)
    {
        $plog->log_err("Unable to create table or index for %s.%s\n", 
                       $schema, $crb_table_name);
        return FAIL;
    }
    if (make_table_and_index($schema, 
                             $rst_table_name, 
                            \@rst_table_cols,
                             $rst_table_index_name, 
                            \@rst_table_index_cols) != TRUE)
    {
        $plog->log_err("Unable to create table or index for %s.%s\n", 
                       $schema, $rst_table_name);
        return FAIL;
    }
    return SUCCESS;
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
$alwd_opts .= 'R:'; # -R route - route name (default=none)
$alwd_opts .= 'D:'; # -D db_name - name of PostgreSQL database (site name)
$alwd_opts .= 'S:'; # -S schema_name - name of PostgreSQL schema (file type)
$alwd_opts .= 'X';  # -X - DO NOT EXPORT to PostgreSQL and KEEP CSV file.
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
    elsif ($opt eq 'X')
    {
        $export_to_postgresql = FALSE;
    }
    elsif ($opt eq 'R')
    {
        $route_name = $opts{$opt};
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
# check if required tables exist.
#
if (make_tables($schema_name) != TRUE)
{
    $plog->log_err("Unable to create tables for (host,port,db,user,pass) = (%s,%s,%s,%s,%s)", 
                   $host_name, $port, 
                   $database_name, 
                   (defined($user_name) ? $user_name : "undef"),
                   (defined($password) ? $password : "undef"));
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
        my $status = process_file($prod_file, $schema_name, $route_name);
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

__DATA__

