#!/usr/bin/perl -w
######################################################################
#
# process an AOI XML file, create a temp CSV file, and 
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
use DateTime;
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
my %special_field_types =
(
    "_filename_id"        => "numeric(30,0)",
    "_filename_timestamp" => "bigint",
    "_p"                  => "integer",
    "_cmp"                => "integer",
    "_defect"             => "integer"
);
#
my $fid_table_name = "filename_to_fid";
my @fid_table_cols =
(
    "_filename", 
    "_filename_type",
    "_filename_timestamp",
    "_filename_route",
    "_filename_id"
);
my $fid_table_index1_name = "idx_filename_to_fid_1";
my @fid_table_index1_cols =
(
    "_filename_id"
);
#
my $fid_table_index2_name = "idx_filename_to_fid_2";
my @fid_table_index2_cols =
(
    "_filename_timestamp"
);
#
my $fid_table_index3_name = "idx_filename_to_fid_3";
my @fid_table_index3_cols =
(
    "_filename_id",
    "_filename_timestamp"
);
#
my $fid_table_index4_name = "idx_filename_to_fid_4";
my @fid_table_index4_cols =
(
    "_filename_timestamp",
    "_filename_id"
);
#
my $aoi_table_name = "aoi_filename_data";
my @aoi_table_cols =
(
    "_filename_id",
    "_aoi_pcbid",
    "_date_time"
);
my $aoi_table_index_name = "idx_aoi_filename_data";
my @aoi_table_index_cols = 
(
    "_filename_id"
);
#
my $aoi_insp_table_name = "insp";
my @aoi_insp_table_cols =
(
    "_filename_id", 
    "_p",
    "_cid",
    "_timestamp",
    "_crc",
    "_c2d",
    "_recipename",
    "_mid"
);
my @insert_aoi_insp_table_cols =
(
    "_cid",
    "_timestamp",
    "_crc",
    "_c2d",
    "_recipename",
    "_mid"
);
my %default_insert_aoi_insp_table_values =
(
    "_cid" => '',
    "_timestamp" => '',
    "_crc" => '',
    "_c2d" => '',
    "_recipename" => '',
    "_mid" => ''
);
my $aoi_insp_table_index_name = "idx_insp_fid";
my @aoi_insp_table_index_cols =
(
    "_filename_id"
);
#
my $aoi_p_table_name = "p";
my @aoi_p_table_cols =
(
    "_filename_id", 
    "_p",
    "_cmp",
    "_sc",
    "_pid",
    "_fc"
);
my @insert_aoi_p_table_cols =
(
    "_sc",
    "_pid",
    "_fc"
);
my %default_insert_aoi_p_table_values = 
(
    "_sc" => '',
    "_pid" => '',
    "_fc" => ''
);
my $aoi_p_table_index_name = "idx_p_fid";
my @aoi_p_table_index_cols =
(
    "_filename_id"
);
my $aoi_p_table_index2_name = "idx_p_fid_p";
my @aoi_p_table_index2_cols =
(
    "_filename_id",
    "_p"
);
#
my $aoi_cmp_table_name = "cmp";
my @aoi_cmp_table_cols =
(
    "_filename_id", 
    "_cmp",
    "_defect",
    "_cc",
    "_ref",
    "_type"
);
my @insert_aoi_cmp_table_cols =
(
    "_cc",
    "_ref",
    "_type"
);
my %default_insert_aoi_cmp_table_values = 
(
    "_cc" => '',
    "_ref" => '',
    "_type" => ''
);
my $aoi_cmp_table_index_name = "idx_cmp_fid";
my @aoi_cmp_table_index_cols =
(
    "_filename_id"
);
my $aoi_cmp_table_index2_name = "idx_cmp_fid_cmp";
my @aoi_cmp_table_index2_cols =
(
    "_filename_id",
    "_cmp"
);
#
my $aoi_defect_table_name = "defect";
my @aoi_defect_table_cols =
(
    "_filename_id",
    "_defect",
    "_insp_type",
    "_lead_id"
);
my @insert_aoi_defect_table_cols =
(
    "_insp_type",
    "_lead_id"
);
my %default_insert_aoi_defect_table_values =
(
    "_insp_type" => '',
    "_lead_id" => ''
);
my $aoi_defect_table_index_name = "idx_defect_fid";
my @aoi_defect_table_index_cols =
(
    "_filename_id"
);
my $aoi_defect_table_index2_name = "idx_defect_fid_cmp";
my @aoi_defect_table_index2_cols =
(
    "_filename_id",
    "_defect"
);
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
        [AOI-XML-file ...] or reads STDIN

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
sub process_defect
{
    my ($aoi_file, 
        $praw_data, 
        $paoi_db, 
        $maxi, 
        $pi, 
        $pcmpi, 
        $pdefecti) = @_;
    #
    my $status = FAIL;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/defect>$/i)
        {
            $$pi += 1;
            $$pdefecti += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<lead_id>(.*)<\/lead_id>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_cmp}->[$$pcmpi]->{_defect}->[$$pdefecti]->{_lead_id} = $1;
        }
        elsif ($line =~ m/^<insp_type>(.*)<\/insp_type>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_cmp}->[$$pcmpi]->{_defect}->[$$pdefecti]->{_insp_type} = $1;
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_cmp
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi, $pcmpi) = @_;
    #
    my $status = FAIL;
    #
    my $defecti = 0;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/cmp>$/i)
        {
            $$pi += 1;
            $$pcmpi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<type>(.*)<\/type>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_cmp}->[$$pcmpi]->{_type} = $1;
        }
        elsif ($line =~ m/^<ref>(.*)<\/ref>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_cmp}->[$$pcmpi]->{_ref} = $1;
        }
        elsif ($line =~ m/^<cc>(.*)<\/cc>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_cmp}->[$$pcmpi]->{_cc} = $1;
        }
        elsif ($line =~ m/^<defect>$/i)
        {
            $$pi += 1;
            #
            $status = process_defect($aoi_file, 
                                     $praw_data, 
                                     $paoi_db, 
                                     $maxi, 
                                     $pi,
                                     $pcmpi,
                                    \$defecti);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing DEFECT for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_p
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi) = @_;
    #
    my $status = FAIL;
    #
    my $cmpi = 0;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/p>$/i)
        {
            $$pi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<fc>(.*)<\/fc>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_fc} = $1;
        }
        elsif ($line =~ m/^<pid>(.*)<\/pid>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_pid} = $1;
        }
        elsif ($line =~ m/^<sc>(.*)<\/sc>$/i)
        {
            $$pi += 1;
            $paoi_db->{_p}->{_sc} = $1;
        }
        elsif ($line =~ m/^<cmp>$/i)
        {
            $$pi += 1;
            #
            $status = process_cmp($aoi_file, 
                                  $praw_data, 
                                  $paoi_db, 
                                  $maxi, 
                                  $pi, 
                                 \$cmpi);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing CMP for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_insp
{
    my ($aoi_file, $praw_data, $paoi_db, $maxi, $pi) = @_;
    #
    my $status = FAIL;
    #
    for ( ; $$pi<$maxi; )
    {
        my $line = $praw_data->[$$pi];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($$pi+1), $line);
        #
        if ($line =~ m/^<\/insp>$/i)
        {
            $$pi += 1;
            $status = SUCCESS;
            last;
        }
        elsif ($line =~ m/^<P>$/i)
        {
            $$pi += 1;
            #
            $status = process_p($aoi_file, 
                                $praw_data, 
                                $paoi_db, 
                                $maxi, 
                                $pi);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing P for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        elsif ($line =~ m/^<recipename>(.*)<\/recipename>$/i)
        {
            $$pi += 1;
            $paoi_db->{_recipename} = $1;
        }
        elsif ($line =~ m/^<timestamp>(.*)<\/timestamp>$/i)
        {
            $$pi += 1;
            $paoi_db->{_timestamp} = $1;
        }
        elsif ($line =~ m/^<mid>(.*)<\/mid>$/i)
        {
            $$pi += 1;
            $paoi_db->{_mid} = $1;
        }
        elsif ($line =~ m/^<cid>(.*)<\/cid>$/i)
        {
            $$pi += 1;
            $paoi_db->{_cid} = $1;
        }
        elsif ($line =~ m/^<c2d>(.*)<\/c2d>$/i)
        {
            $$pi += 1;
            $paoi_db->{_c2d} = $1;
        }
        elsif ($line =~ m/^<pid>(.*)<\/pid>$/i)
        {
            $$pi += 1;
            $paoi_db->{_pid} = $1;
        }
        elsif ($line =~ m/^<crc>(.*)<\/crc>$/i)
        {
            $$pi += 1;
            $paoi_db->{_crc} = $1;
        }
        else
        {
            $$pi += 1;
        }
    }
    #
    return $status;
}
#
sub process_data
{
    my ($aoi_file, $praw_data, $paoi_db) = @_;
    #
    my $status = FAIL;
    my $maxi = scalar(@{$praw_data});
    #
    for (my $i=0; $i<$maxi; )
    {
        my $line = $praw_data->[$i];
        #
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        #
        $plog->log_vmid("Line(%d): %s\n", ($i+1), $line);
        #
        if ($line =~ m/^<INSP>$/i)
        {
            $i += 1;
            #
            $status = process_insp($aoi_file, 
                                   $praw_data, 
                                   $paoi_db, 
                                   $maxi, 
                                  \$i);
            if ($status != SUCCESS)
            {
                $plog->log_err("Processing INSP for %s failed.\n", 
                               $aoi_file);
                last;
            }
        }
        else
        {
            $i += 1;
        }
    }
    #
    return $status;
}
#
######################################################################
#
sub insert_filename_to_id
{
    my ($schema, $fname, $fname_type, $fname_tstamp, $route_name, $fname_id) = @_;
    #
    $plog->log_vmid("Inserting %s ==>> %s,%s into %s filename-to-id table\n",
                    $fname, $fname_type, $fname_id, $schema);
    #
    my $sql = "insert into ${schema}.${fid_table_name} ( " .  join(",", @fid_table_cols) . " ) values ( '$fname', '$fname_type', $fname_tstamp, '$route_name', $fname_id )";
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
    if ($ext =~ m/^xml$/i) 
    {
        my $sql = "insert into ${schema}.${aoi_table_name} ( " . 
                   join(",", @aoi_table_cols) . 
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
        #
        return SUCCESS;
    }
    else
    {
        $plog->log_err("Unknown file extension: %s\n", $ext);
        return FAIL;
    }
}
#
sub parse_with_ext
{
    my ($fname, $time_zone, $ext, $ptstamp, $pparts) = @_;
    #
    $plog->log_vmid("File Name (ext=%s): %s\n", $ext, $fname);
    #
    @{$pparts} = undef;
    #
    if ($ext =~ m/^xml$/i) 
    {
        my @tokens = split /_/, $fname;
        if (scalar(@tokens) < 2)
        {
            $plog->log_err("Incorrect number of file tokens for file: %s\n", $fname);
            return FAIL;
        }
        #
        my $date_time = pop @tokens;
        my $pcbid = join("_", @tokens);
        #
        $date_time =~ m/^(....)(..)(..)(..)(..)(..).*$/;
        #
        my $dt = DateTime->new(
            year => $1,
            month => $2,
            day => $3,
            hour => $4,
            minute => $5,
            second => $6,
            nanosecond => 0,
            time_zone => $time_zone);
        #
        ${$ptstamp} = $dt->epoch();
        #
        $plog->log_vmid("PCBID: %s\ndate time: %s\n", $pcbid, $date_time);
        #
        my $idx = -1;
        #
        $pparts->[++$idx] = $pcbid;
        $pparts->[++$idx] = $date_time;
    }
    else
    {
        $plog->log_err("Unknown ext %s for %s\n", $ext, $fname);
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub parse_filename
{
    my $fpath = shift;
    my $pext = shift;
    my $ptstamp = shift;
    my $pparts = shift;
    #
    my $time_zone = "America/Chicago";
    $time_zone = shift @_ if (@_);
    #
    $plog->log_vmid("Parsing File Path: %s\n", $fpath);
    #
    my $fname = basename($fpath);
    #
    if ($fname =~ m/\.([^\.]+)$/)
    {
        ${$pext} = ${1};
        #
        $fname =~ s/\.${$pext}$//;
        #
        return parse_with_ext($fname, $time_zone, ${$pext}, $ptstamp, $pparts);
    }
    else
    {
        $plog->log_err("No extension for file: %s\n", $fname);
        return FAIL;
    }
}
#
sub export_to_postgres
{
    my ($prod_file, $schema, $route_name, $pprod_db) = @_;
    #
    $plog->log_msg("Exporting data file to Postgres: %s\n", $prod_file);
    #
    # parse file name and get data.
    #
    my $tstamp = 0;
    my $ext = "";
    my @parts = undef;
    my $filename = basename($prod_file);
    if (parse_filename($filename, \$ext, \$tstamp, \@parts) != SUCCESS)
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
    # save any data associated with the file name.
    #
    if (insert_ext_data($schema, $ext, $filename_id, \@parts) != SUCCESS)
    {
        $plog->log_err("Failed to insert filename extension <%s> data: %s ==>> %s\n", 
                       $ext, $filename, $filename_id);
        return FAIL;
    }
    #
    # debug dump ...
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    $plog->log_vmid("Schema, Product Name: %s, %s\n", $schema, $prod_name);
    $plog->log_vmid("Dumper: %s\n", Dumper($pprod_db));
    #
    ## my @aoi_insp_table_cols = ( "_filename_id", 
    ##                             "_p",
    ##                             "_cid",
    ##                             "_timestamp",
    ##                             "_crc",
    ##                             "_c2d",
    ##                             "_recipename",
    ##                             "_mid" );
    ## my @insert_aoi_insp_table_cols = ( "_cid",
    ##                                    "_timestamp",
    ##                                    "_crc",
    ##                                    "_c2d",
    ##                                    "_recipename",
    ##                                    "_mid" );
    ## my @aoi_p_table_cols = ( "_filename_id", 
    ##                          "_p",
    ##                          "_cmp",
    ##                          "_sc",
    ##                          "_fc" );
    ## my @insert_aoi_p_table_cols = ( "_sc",
    ##                                 "_fc" );
    ## my @aoi_cmp_table_cols = ( "_filename_id", 
    ##                            "_cmp",
    ##                            "_defect",
    ##                            "_cc",
    ##                            "_ref",
    ##                            "_type" );
    ## my @insert_aoi_cmp_table_cols = ( "_cc",
    ##                                   "_ref",
    ##                                   "_type" );
    ## my $aoi_defect_table_name = "defect";
    ## my @aoi_defect_table_cols = ( "_filename_id", 
    ##                               "_defect",
    ##                               "_insp_type",
    ##                               "_lead_id" );
    ## my @insert_aoi_defect_table_cols = ( "_insp_type",
    ##                                      "_lead_id" );
    #
    # start inserting the data
    #
    my $p = 1;
    my $sql = "insert into ${schema}.${aoi_insp_table_name} ( " . 
               join(",", @aoi_insp_table_cols) . 
              " ) values ( $filename_id,$p,'" . 
               join("','", @{$pprod_db}{@{insert_aoi_insp_table_cols}}) . 
              "' )";
    $plog->log_msg("SQL Insert: %s\n", $sql);
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
    # check if there is any component data. usually the NG or failure
    # cases have a list of components which failed inspection.
    #
    if ((exists(($pprod_db->{_p}->{_cmp}))) &&
        (ref($pprod_db->{_p}->{_cmp}) eq "ARRAY"))
    {
        #
        # we have a failed inspection. init any missing
        # fields so we have some sane values.
        #
        foreach my $col (@{insert_aoi_p_table_cols})
        {
            if ( ! exists($pprod_db->{_p}->{$col}))
            {
                $pprod_db->{_p}->{$col} = 
                    $default_insert_aoi_p_table_values{$col};
            }
        }
        #
        # insert records and pointer to first component data.
        #
        my $cmp = 1;
        $sql = "insert into ${schema}.${aoi_p_table_name} ( " . 
               join(",", @aoi_p_table_cols) . 
               " ) values ( $filename_id,$p,$cmp,'" . 
               join("','", @{$pprod_db->{_p}}{@{insert_aoi_p_table_cols}}) . 
               "' )";
        $plog->log_msg("SQL Insert: %s\n", $sql);
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
        # now handle list of failed components.
        #
        my $pcmps = $pprod_db->{_p}->{_cmp};
        my $maxicmp = scalar(@{$pcmps});
        for (my $icmp = 0; 
                $icmp<$maxicmp; 
                $icmp++, $cmp++)
        {
            $plog->log_msg("%02d: Component Dumper: %s\n", 
                           $icmp, Dumper($pcmps->[$icmp]));
            if ((exists(($pcmps->[$icmp]->{_defect}))) &&
                (ref($pcmps->[$icmp]->{_defect}) eq "ARRAY"))
            {
                my $defect = 1;
                #
                $sql = "insert into ${schema}.${aoi_cmp_table_name} ( " . 
                       join(",", @aoi_cmp_table_cols) . 
                       " ) values ( $filename_id,$cmp,$defect,'" . 
                       join("','", @{$pcmps->[$icmp]}{@{insert_aoi_cmp_table_cols}}) . 
                       "' )";
                $plog->log_msg("SQL Insert: %s\n", $sql);
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
                my $pdefects = $pcmps->[$icmp]->{_defect};
                my $maxidefects = scalar(@{$pdefects});
                for (my $idefect = 0; 
                        $idefect<$maxidefects; 
                        $idefect++, $defect++)
                {
                    $plog->log_msg("%02d: Defect Dumper: %s\n", 
                                   $idefect, Dumper($pdefects->[$idefect]));
                    $sql = "insert into ${schema}.${aoi_defect_table_name} ( " . 
                           join(",", @aoi_defect_table_cols) . 
                           " ) values ( $filename_id,$defect,'" . 
                           join("','", @{$pdefects->[$idefect]}{@{insert_aoi_defect_table_cols}}) . 
                           "' )";
                    $plog->log_msg("SQL Insert: %s\n", $sql);
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
            }
            else
            {
                $sql = "insert into ${schema}.${aoi_cmp_table_name} ( " . 
                       join(",", @aoi_cmp_table_cols) . 
                       " ) values ( $filename_id,$cmp,-1,'" . 
                       join("','", @{$pcmps->[$icmp]}{@{insert_aoi_cmp_table_cols}}) . 
                       "' )";
                $plog->log_msg("SQL Insert: %s\n", $sql);
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
        }
    }
    else
    {
        #
        # we have an OK inspection. init any missing
        # fields so we have some sane values.
        #
        foreach my $col (@{insert_aoi_p_table_cols})
        {
            if ( ! exists($pprod_db->{_p}->{$col}))
            {
                $pprod_db->{_p}->{$col} = 
                    $default_insert_aoi_p_table_values{$col};
            }
        }
        #
        # insert data and we have NO components list.
        #
        $sql = "insert into ${schema}.${aoi_p_table_name} ( " . 
               join(",", @aoi_p_table_cols) . 
               " ) values ( $filename_id,$p,-1,'" . 
               join("','", @{$pprod_db->{_p}}{@{insert_aoi_p_table_cols}}) . 
               "' )";
        $plog->log_msg("SQL Insert: %s\n", $sql);
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
    elsif (process_data($prod_file, \@raw_data, \%prod_db) != SUCCESS)
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
    if (table_exists($schema_name, $fid_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $fid_table_name, 
                         \@fid_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $fid_table_name, 
                                $fid_table_index1_name,
                               \@fid_table_index1_cols) != TRUE) ||
            (create_table_index($schema, 
                                $fid_table_name, 
                                $fid_table_index2_name,
                               \@fid_table_index2_cols) != TRUE) ||
            (create_table_index($schema, 
                                $fid_table_name, 
                                $fid_table_index3_name,
                               \@fid_table_index3_cols) != TRUE) ||
            (create_table_index($schema, 
                                $fid_table_name, 
                                $fid_table_index4_name,
                               \@fid_table_index4_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $fid_table_name);
            return FAIL;
        }
    }
    #
    if (table_exists($schema_name, $aoi_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $aoi_table_name, 
                         \@aoi_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_table_name, 
                                $aoi_table_index_name,
                               \@aoi_table_index_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $aoi_table_name);
            return FAIL;
        }
    }
    #
    if (table_exists($schema_name, $aoi_insp_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $aoi_insp_table_name, 
                         \@aoi_insp_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_insp_table_name, 
                                $aoi_insp_table_index_name,
                               \@aoi_insp_table_index_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $aoi_insp_table_name);
            return FAIL;
        }
    }
    #
    if (table_exists($schema_name, $aoi_p_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $aoi_p_table_name, 
                         \@aoi_p_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_p_table_name, 
                                $aoi_p_table_index_name,
                               \@aoi_p_table_index_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_p_table_name, 
                                $aoi_p_table_index2_name,
                               \@aoi_p_table_index2_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $aoi_p_table_name);
            return FAIL;
        }
    }
    #
    if (table_exists($schema_name, $aoi_cmp_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $aoi_cmp_table_name, 
                         \@aoi_cmp_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_cmp_table_name, 
                                $aoi_cmp_table_index_name,
                               \@aoi_cmp_table_index_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_cmp_table_name, 
                                $aoi_cmp_table_index2_name,
                               \@aoi_cmp_table_index2_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $aoi_cmp_table_name);
            return FAIL;
        }
    }
    #
    if (table_exists($schema_name, $aoi_defect_table_name) != TRUE)
    {
        if ((create_table($schema, 
                          $aoi_defect_table_name, 
                         \@aoi_defect_table_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_defect_table_name, 
                                $aoi_defect_table_index_name,
                               \@aoi_defect_table_index_cols) != TRUE) ||
            (create_table_index($schema, 
                                $aoi_defect_table_name, 
                                $aoi_defect_table_index2_name,
                               \@aoi_defect_table_index2_cols) != TRUE))
        {
            $plog->log_err("Unable to create table or index for %s.%s\n", 
                           $schema, $aoi_defect_table_name);
            return FAIL;
        }
    }
    #
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
        my $status = process_file($prod_file, $schema_name, $route_name);
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

