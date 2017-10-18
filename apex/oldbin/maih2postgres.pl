#!/usr/bin/perl -w
######################################################################
#
# process a maihime file, create a temp CSV file, and 
# import into PostgreSQL.
#
######################################################################
#
use strict;
#
use Carp;
use Getopt::Std;
use File::Find;
use File::Path qw(mkpath);
use File::Basename;
use File::Path 'rmtree';
use Data::Dumper;
use DBI;
#
######################################################################
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
# section types
#
use constant SECTION_UNKNOWN => 0;
use constant SECTION_NAME_VALUE => 1;
use constant SECTION_LIST => 2;
#
######################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
#
# cmd line options
#
my $logfile = '';
my $verbose = NOVERBOSE;
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
#
my $temp_path = "PSQL.CSV.$$";
#
my %verbose_levels =
(
    off => NOVERBOSE(),
    min => MINVERBOSE(),
    mid => MIDVERBOSE(),
    max => MAXVERBOSE()
);
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
######################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [-t temp directory path] \\
        [-d row delimiter] \\
        [-u user name] [-p passwd] \\
        [-P port ] \\
        -D db_name -S schema_name [-X]
        [maihime-file ...] or reads STDIN

where:

    -? or -h - print this usage.
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v level - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path
    -t path - temp directory path, defaults to '${temp_path}'
    -d delimiter - row delimiter (new line by default)
    -u user name - PostgresQL user name
    -p passwd - PostgresQL user password
    -P port - PostgreSQL port (default = 5432)
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
        printf $log_fh "%d: (host:%s,port:%s,db:%s,user:%s,pwd:%s) ERROR: DB connect failed: %s\n", 
                       __LINE__,
                       $host, 
                       $port,
                       (defined($db) ? $db : "undef"),
                       (defined($user) ? $user : "undef"),
                       (defined($pwd) ? $pwd : "undef"),
                       $DBI::errstr;
        return FAIL;
    }
    #
    my $found = FALSE;
    #
    my $sth = $dbh->prepare("select datname from pg_database");
    if ( ! defined($sth))
    {
        printf $log_fh "%d: ERROR: DB prepare failed: %s\n", 
                       __LINE__, $DBI::errstr;
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
        printf $log_fh "%d: ==>> DB %s: EXISTS.\n", __LINE__, $db;
    }
    else
    {
        printf $log_fh "%d: ==>> DB %s: NOT EXISTS. Creating.\n", 
                       __LINE__, $db;
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
            printf $log_fh "%d: ERROR: DB prepare failed: %s\n", 
                           __LINE__, $DBI::errstr;
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
        if (defined($sth->execute()))
        {
            printf $log_fh "%d: Database created.\n", __LINE__;
        }
        else
        {
            printf $log_fh "%d: ERROR: ==>> DB %s: STILL DOES NOT EXISTS.\n%s\n", __LINE__, $db, $DBI::errstr;
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
        printf $log_fh "%d: ERROR: DB connect failed: %s\n", 
                       __LINE__, $DBI::errstr;
        return FAIL;
    }
    #
    my $found = FALSE;
    #
    my $sth = $dbh->prepare("select catalog_name, schema_name , schema_owner from information_schema.schemata");
    if ( ! defined($sth))
    {
        printf $log_fh "%d: ERROR: DB prepare failed: %s\n", 
                       __LINE__, $DBI::errstr;
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
        printf $log_fh "%d: ==>> DB %s, Schema %s: EXISTS.\n", 
               __LINE__, $db, $schema;
    }
    else
    {
        printf $log_fh "%d: ==>> DB %s, Schema %s: NOT EXISTS. Creating.\n", 
                       __LINE__, $db, $schema;
        #
        my $sql = "create schema $schema";
        #
        $sth = $dbh->prepare($sql);
        if ( ! defined($sth))
        {
            printf $log_fh "%d: ERROR: DB prepare failed: %s\n", 
                           __LINE__, $DBI::errstr;
            $dbh->disconnect;
            $dbh = undef;
            return FAIL;
        }
        if (defined($sth->execute()))
        {
            printf $log_fh "\t%d: Database schema created.\n", __LINE__;
        }
        else
        {
            printf $log_fh "%d: ERROR: ==>> DB %s, Schema %s: STILL DOES NOT EXISTS.\n%s\n", __LINE__, $db, $schema, $DBI::errstr;
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
        printf $log_fh "%d: Schema.Table does NOT EXIST: %s.%s\n", 
                       __LINE__, $schema, $table;
        return FALSE;
    }
    else
    {
        printf $log_fh "%d: Schema.Table does EXIST: %s.%s\n", 
                       __LINE__, $schema, $table;
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
    printf $log_fh "\n\t%d: cols-from-file %s\n", 
           __LINE__, join(";", @{$pcols})
        if ($verbose >= MINVERBOSE);
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
            printf $log_fh "\t%d: file cols == table cols.\n", __LINE__
                if ($verbose >= MINVERBOSE);
            return SUCCESS;
        }
        delete $columns_in_tables{$schema_table};
    }
    printf $log_fh "\t%d: file cols != table cols.\n", __LINE__;
    #
    # unique columns in file section
    #
    my %seen = ();
    my @unique_cols_from_file = grep { ! $seen{$_}++ } @cols_from_file;
    printf $log_fh "\n\t%d: unique-cols-from-file %s\n", 
           __LINE__, join(";", @unique_cols_from_file)
        if ($verbose >= MINVERBOSE);
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
    printf $log_fh "\n\t%d: cols-from-table %s\n", 
           __LINE__, join(";", @cols_from_table)
        if ($verbose >= MINVERBOSE);
    #
    # get unique columns from schema/table pair.
    #
    %seen = ();
    my @unique_cols_from_table = grep { ! $seen{$_}++ } @cols_from_table;
    printf $log_fh "\t%d: unique-cols-from-table %s\n", 
           __LINE__, join(";", @unique_cols_from_table)
        if ($verbose >= MINVERBOSE);
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
    #
    foreach my $col (keys %counts)
    {
        if ($counts{$col} == 1)
        {
            push @file_minus_table, $col;
        }
        elsif ($counts{$col} == 2)
        {
            push @table_minus_file, $col;
        }
        else
        {
            push @intersection, $col;
        }
    }
    #
    # die "Column(s) in file, but not in table: " . join(";", @file_minus_table) unless (scalar(@file_minus_table) == 0);
    if (scalar(@file_minus_table) > 0)
    {
        printf $log_fh "%d: Adding to table new column(s) in file, but not already in table: %s\n", __LINE__, join(";", @file_minus_table);
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
        $sql .= "\"$col\" text, ";
    }
    #
    $sql =~ s/, *$//;
    $sql .= " )";
    $sql =~ tr/A-Z/a-z/;
    #
    printf $log_fh "%d: ==>> SQL CREATE DB command: %s\n", __LINE__, $sql;
    #
    my $sth = $dbh->prepare($sql);
    die "Prepare failed: $DBI::errstr\n" 
        unless (defined($sth));
    #
    die "Unable to execute: " . $sth->errstr 
        unless (defined($sth->execute()));
    #
    printf $log_fh "%d: schema.table created: %s.%s\n", 
                    __LINE__, $schema, $table;
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
        printf $log_fh "%d: ERROR: DB connect failed: %s\n", 
                       __LINE__, $DBI::errstr;
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
# load product files, either CRB or MAI
#
sub read_file
{
    my ($prod_file, $praw_data) = @_;
    #
    printf $log_fh "%d: Reading Product file: %s\n", 
        __LINE__, $prod_file
        if ($verbose >= MINVERBOSE);
    #
    if ( ! -r $prod_file )
    {
        printf $log_fh "%d: ERROR: file $prod_file is NOT readable\n\n", __LINE__;
        return FAIL;
    }
    #
    unless (open(INFD, $prod_file))
    {
        printf $log_fh "%d: ERROR: unable to open $prod_file.\n\n", __LINE__;
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    printf $log_fh "%d: Lines read: %d\n", __LINE__, scalar(@{$praw_data}) if ($verbose >= MINVERBOSE);
    #
    return SUCCESS;
}
#
######################################################################
#
# load name-value or list section
#
sub load_name_value
{
    my ($praw_data, $section, $pirec, $max_rec, $pprod_db) = @_;
    #
    push @{$pprod_db->{ORDER}}, $section;
    $pprod_db->{TYPE}->{$section} = SECTION_NAME_VALUE;
    $pprod_db->{DATA}->{$section} = [];
    #
    my $start_irec = $$pirec;
    $$pirec += 1; # skip section name
    #
    for ( ; $$pirec < $max_rec; )
    {
        my $record = $praw_data->[$$pirec];
        #
        if ($record =~ m/^\s*$/)
        {
            $$pirec += 1;
            last;
        }
        elsif ($record =~ m/^\[[^\]]*\]/)
        {
            # section is corrupted. it lacks the required empty
            # line to indicate the end of the section.
            last;
        }
        else
        {
            next unless ($record =~ m/^\s*([^=]*)\s*=\s*([^=]*)\s*$/);
            #
            my $name = $1;
            $name =~ s/^\s*"([^"]*)"\s*$/$1/;
            #
            my $value = $2;
            $value =~ s/^\s*"([^"]*)"\s*$/$1/;
            push @{$pprod_db->{DATA}->{$section}}, "${name}${delimiter}${value}";
            #
            $$pirec += 1;
        }
    }
    #
    printf $log_fh "%d: <%s>\n", 
        __LINE__, 
        join("\n", @{$pprod_db->{DATA}->{$section}})
        if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        printf $log_fh "%d: NO NAME-VALUE DATA FOUND IN SECTION %s. Lines read: %d\n", 
            __LINE__, $section, ($$pirec - $start_irec);
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = "NAME${delimiter}VALUE";
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split /${delimiter}/, $pprod_db->{HEADER}->{$section};
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    printf $log_fh "%d: Number of Columns: %d\n", 
        __LINE__, 
        $number_columns
        if ($verbose >= MINVERBOSE);
    #
    my $nrecs = scalar(@{$pprod_db->{DATA}->{$section}});
    #
    for (my $irec = 0; $irec<$nrecs; ++$irec)
    {
        my $record = $pprod_db->{DATA}->{$section}->[$irec];
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, "${delimiter}");
        my $number_tokens = scalar(@tokens);
        #
        printf $log_fh "%d: Number of tokens in record: %d\n", 
            __LINE__, $number_tokens 
            if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pprod_db->{COLUMN_NAMES}->{$section}}} = @tokens;
            #
            $pprod_db->{DATA}->{$section}->[$irec] = \%data;
        }
        else
        {
            printf $log_fh "%d: ERROR: Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", __LINE__, $section, $number_tokens, $number_columns;
        }
    }
    printf $log_fh "%d: Number of key-value pairs: %d\n", 
        __LINE__, 
        scalar(@{$pprod_db->{DATA}->{$section}})
        if ($verbose >= MINVERBOSE);
    printf $log_fh "%d: Lines read: %d\n", 
        __LINE__, 
        ($$pirec - $start_irec)
        if ($verbose >= MINVERBOSE);
    #
    return SUCCESS;
}
#
sub split_quoted_string
{
    my $rec = shift;
    my $separator = shift;
    #
    my $rec_len = length($rec);
    #
    my $istart = -1;
    my $iend = -1;
    my $in_string = 0;
    #
    my @tokens = ();
    my $token = "";
    #
    for (my $i=0; $i<$rec_len; $i++)
    {
        my $c = substr($rec, $i, 1);
        #
        if ($in_string == 1)
        {
            if ($c eq '"')
            {
                $in_string = 0;
            }
            else
            {
                $token .= $c;
            }
        }
        elsif ($c eq '"')
        {
            $in_string = 1;
        }
        elsif ($c eq $separator)
        {
            # printf $log_fh "Token ... <%s>\n", $token;
            push (@tokens, $token);
            $token = '';
        }
        else
        {
            $token .= $c;
        }
    }
    #
    if (length($token) > 0)
    {
        # printf $log_fh "Token ... <%s>\n", $token;
        push (@tokens, $token);
        $token = '';
    }
    else
    {
        # null-length string
        $token = '';
        push (@tokens, $token);
    }
    #
    # printf $log_fh "Tokens: \n%s\n", join("\n",@tokens);
    #
    return @tokens;
}
#
sub load_list
{
    my ($praw_data, $section, $pirec, $max_rec, $pprod_db) = @_;
    #
    push @{$pprod_db->{ORDER}}, $section;
    $pprod_db->{TYPE}->{$section} = SECTION_LIST;
    $pprod_db->{DATA}->{$section} = [];
    #
    my $start_irec = $$pirec;
    $$pirec += 1; # skip section name
    #
    my @section_data = ();
    for ( ; $$pirec < $max_rec; )
    {
        my $record = $praw_data->[$$pirec];
        #
        if ($record =~ m/^\s*$/)
        {
            $$pirec += 1;
            last;
        }
        elsif ($record =~ m/^\[[^\]]*\]/)
        {
            # section is corrupted. it lacks the required empty
            # line to indicate the end of the section.
            last;
        }
        else
        {
            push @{$pprod_db->{DATA}->{$section}}, $record;
            $$pirec += 1;
        }
    }
    #
    printf $log_fh "%d: <%s>\n", 
        __LINE__, 
        join("\n", @{$pprod_db->{DATA}->{$section}})
        if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        printf $log_fh "%d: NO LIST DATA FOUND IN SECTION %s. Lines read: %d\n", 
            __LINE__, $section, ($$pirec - $start_irec);
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = 
        shift @{$pprod_db->{DATA}->{$section}};
    #
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split / /, $pprod_db->{HEADER}->{$section};
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    printf $log_fh "%d: Number of Columns: %d\n", 
        __LINE__, 
        $number_columns
        if ($verbose >= MINVERBOSE);
    #
    my $nrecs = scalar(@{$pprod_db->{DATA}->{$section}});
    #
    for (my $irec = 0; $irec<$nrecs; ++$irec)
    {
        my $record = $pprod_db->{DATA}->{$section}->[$irec];
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, ' ');
        my $number_tokens = scalar(@tokens);
        #
        printf $log_fh "%d: Number of tokens in record: %d\n", 
            __LINE__, $number_tokens 
            if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pprod_db->{COLUMN_NAMES}->{$section}}} = @tokens;
            #
            $pprod_db->{DATA}->{$section}->[$irec] = \%data;
        }
        else
        {
            printf $log_fh "%d: ERROR: Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", __LINE__, $section, $number_tokens, $number_columns;
        }
    }
    #
    return SUCCESS;
}
#
sub process_data
{
    my ($prod_file, $praw_data, $pprod_db) = @_;
    #
    printf $log_fh "%d: Processing product data: %s\n", 
        __LINE__, $prod_file 
        if ($verbose >= MINVERBOSE);
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        printf $log_fh "%d: Record %04d: <%s>\n", 
            __LINE__, $irec, $rec
               if ($verbose >= MINVERBOSE);
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            printf $log_fh "%d: Section %03d: %s\n", 
                __LINE__, ++$sec_no, $section
                if ($verbose >= MINVERBOSE);
            #
            $rec = $praw_data->[${irec}+1];
            #
            if ($rec =~ m/^\s*$/)
            {
                $irec += 2;
                printf $log_fh "%d: Empty section - %s\n", 
                               __LINE__, $section;
            }
            elsif ($rec =~ m/.*=.*/)
            {
                load_name_value($praw_data, 
                                $section, 
                               \$irec, 
                                $max_rec,
                                $pprod_db);
            }
            else
            {
                load_list($praw_data, 
                          $section, 
                         \$irec, 
                          $max_rec,
                          $pprod_db);
            }
        }
        else
        {
            $irec += 1;
        }
    }
    #
    return SUCCESS;
}
#
######################################################################
#
sub export_section_to_postgres
{
    my ($pprod_db, $schema, $section) = @_;
    #
    my $table = $section;
    $table =~ tr/A-Z/a-z/;
    $table =~ s/[\[\]]//g;
    #
    printf $log_fh "%d: Export section %s to schema.table %s.%s\n", 
                   __LINE__, $section, $schema, $table;
    #
    # check if table exists
    #
    my $pcols = $pprod_db->{COLUMN_NAMES}->{$section};
    if (check_table($pcols, $schema, $table) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Check table failed: section %s, schema.table %s.%s\n", 
                   __LINE__, $section, $schema, $table;
        return FAIL;
    }
    #
    if ($debug_flag == TRUE)
    {
        printf $log_fh "\n%d: ==>> section: %s\n", __LINE__, $section;
        #
        printf $log_fh "%d; schema.table: %s.%s\n", 
                       __LINE__, $schema, $table;
        #
        my $pcols = $pprod_db->{COLUMN_NAMES}->{$section};
        my $local_delimiter = "";
        foreach my $col (@{$pcols})
        {
            printf $log_fh "%s%s", $local_delimiter, $col;
            $local_delimiter = $delimiter;
        }
        printf $log_fh "\n";
        #
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $local_delimiter = "";
            foreach my $col (@{$pcols})
            {
                printf $log_fh "%s%s", $local_delimiter, $prow->{$col};
                $local_delimiter = $delimiter;
            }
            printf $log_fh "\n";
        }
    }
    else
    {
        my $csv_file = "/tmp/csv.$$";
        open(my $outfh, ">" , $csv_file) || die "file is $csv_file: $!";
        #
        my $pcols = $pprod_db->{COLUMN_NAMES}->{$section};
        my $local_delimiter = "";
        foreach my $col (@{$pcols})
        {
            printf $outfh "%s%s", $local_delimiter, $col;
            $local_delimiter = $delimiter;
        }
        printf $outfh "\n";
        #
        foreach my $prow (@{$pprod_db->{DATA}->{$section}})
        {
            my $local_delimiter = "";
            foreach my $col (@{$pcols})
            {
                printf $outfh "%s%s", $local_delimiter, $prow->{$col};
                $local_delimiter = $delimiter;
            }
            printf $outfh "\n";
        }
        #
        close($outfh);
        #
        my @cols_from_file = @{$pcols};
        tr/A-Z/a-z/ for @cols_from_file;
        #
        my $sql = "copy ${schema}.${table} ( \"" . join("\",\"", @cols_from_file) . "\" ) from '${csv_file}' with ( format csv, delimiter '${delimiter}', header ) ";
        printf $log_fh "%d: COPY CMD: %s\n", __LINE__, $sql;
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
sub export_to_postgres
{
    my ($prod_file, $schema, $pprod_db) = @_;
    #
    printf $log_fh "%d: Exporting data file to Postgres: %s\n", 
                   __LINE__, $prod_file;
    #
    my $prod_name = basename($prod_file);
    $prod_name =~ tr/a-z/A-Z/;
    #
    printf $log_fh "%d: Schema, Product Name: %s, %s\n", 
                   __LINE__, $schema, $prod_name;
    #
    my $status = FAIL;
    #
    my $max_isec = scalar(@{$pprod_db->{ORDER}});
    for (my $isec = 0; $isec<$max_isec; ++$isec)
    {
        my $section = $pprod_db->{ORDER}->[$isec];
        #
        printf $log_fh "%d: writing section: %s\n", 
                   __LINE__, $section;
        #
        if ($pprod_db->{TYPE}->{$section} == SECTION_NAME_VALUE)
        {
            printf $log_fh "%d: Name-Value Section: %s\n", 
                   __LINE__, $section;
            $status = export_section_to_postgres($pprod_db,
                                                 $schema,
                                                 $section);
        }
        elsif ($pprod_db->{TYPE}->{$section} == SECTION_LIST)
        {
            printf $log_fh "%d: List Section: %s\n", 
                   __LINE__, $section;
            $status = export_section_to_postgres($pprod_db,
                                                 $schema,
                                                 $section);
        }
        else
        {
            printf $log_fh "%d: Unknown type Section: %s\n", 
                __LINE__, $section;
        }
    }
    #
    return $status;
}
#
sub process_file
{
    my ($prod_file, $schema) = @_;
    #
    printf $log_fh "\n%d: Processing product File, Schema: %s,%s\n", 
                   __LINE__, $prod_file, $schema;
    #
    my @raw_data = ();
    my %prod_db = ();
    #
    my $status = FAIL;
    if (read_file($prod_file, \@raw_data) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Reading product file: %s\n", 
                       __LINE__, $prod_file;
    }
    elsif (process_data($prod_file, \@raw_data, \%prod_db) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Processing product file: %s\n", 
                       __LINE__, $prod_file;
    }
    elsif (export_to_postgres($prod_file, $schema, \%prod_db) != SUCCESS)
    {
        printf $log_fh "%d: ERROR: Exporting product file to CSV: %s\n", 
                       __LINE__, $prod_file;
    }
    else
    {
        printf $log_fh "%d: Success processing product file: %s\n", 
            __LINE__, $prod_file
            if ($verbose >= MINVERBOSE);
        $status = SUCCESS;
    }
    #
    return $status;
}
#
#
######################################################################
#
# build allowed options using usage message
#
my $alwd_opts = "";
$alwd_opts .= '?h'; # -? or -h - print this usage.
$alwd_opts .= 'w';  # -w - enable warning (level=min=1)
$alwd_opts .= 'W';  # -W - enable warning and trace (level=mid=2)
$alwd_opts .= 'v:'; # -v level - verbose level: 0=off,1=min,2=mid,3=max
$alwd_opts .= 'l:'; # -l logfile - log file path
$alwd_opts .= 't:'; # -t path - temp directory path, defaults to '${temp_path}'
$alwd_opts .= 'd:'; # -d delimiter - row delimiter (new line by default)
$alwd_opts .= 'u:'; # -u user name - PostgresQL user name
$alwd_opts .= 'p:'; # -p passwd - PostgresQL user password
$alwd_opts .= 'P:'; # -P port - PostgreSQL port (default = 5432)
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
    elsif ($opt eq 'w')
    {
        $verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq 'v')
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $verbose = $opts{$opt};
        }
        elsif (exists($verbose_levels{$opts{$opt}}))
        {
            $verbose = $verbose_levels{$opts{$opt}};
        }
        else
        {
            printf $log_fh "\n%d: ERROR: Invalid verbose level: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        printf $log_fh "\n%d: Log File: %s\n", __LINE__, $logfile;
    }
    elsif ($opt eq 't')
    {
        $temp_path = $opts{$opt} . '/';
        printf $log_fh "\n%d: Temp directory path: %s\n", __LINE__, $temp_path;
    }
    elsif ($opt eq 'd')
    {
        $delimiter = $opts{$opt};
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
}
#
if (( ! defined($database_name)) ||
    ( ! defined($schema_name)) ||
    ( $schema_name eq "") ||
    ( $database_name eq ""))
{
    printf $log_fh "%d: ERROR: Database or Schema names are undefined.\n", __LINE__;
    usage($cmd);
    exit 2;
}
#
printf $log_fh "\n%d: Open DB for (host,port,db,user) = (%s,%s,%s,%s)\n", 
       __LINE__, 
       $host_name, 
       $port, 
       $database_name, 
       (defined($user_name) ? $user_name : "undef");
#
# clean up upon exit
#
END {
    if (defined($dbh))
    {
        printf $log_fh "\n%d: END block. Closing DB.\n", __LINE__;
        close_db($dbh);
        $dbh = undef;
    }
    else
    {
        printf $log_fh "\n%d: END block. DB already closed.\n", __LINE__;
    }
}
#
# check if db exists.
#
if (create_db($host_name, $port, 
              $database_name, 
              $user_name, $password) != SUCCESS)
{
    printf $log_fh "%d: ERROR: Create DB failed for (host,port,db,user,pass) = (%s,%s,%s,%s,%s)", __LINE__, 
                   $host_name, $port, 
                   $database_name, 
                   (defined($user_name) ? $user_name : "undef"),
                   (defined($password) ? $password : "undef");
    exit 2;
}
#
#
# check if schema exists.
#
if (create_schema($host_name, $port, 
                  $database_name, $schema_name, 
                  $user_name, $password) != SUCCESS)
{
    printf $log_fh "%d: ERROR: Create DB schema failed for (host,port,db,schema,user,pass) = (%s,%s,%s,%s,%s,%s)", __LINE__, 
                   $host_name, $port, 
                   $database_name, $schema_name, 
                   (defined($user_name) ? $user_name : "undef"),
                   (defined($password) ? $password : "undef");
    exit 2;
}
#
if (open_db(\$dbh, $host_name, $port, 
             $database_name, 
             $user_name, $password) != SUCCESS)
{
    printf $log_fh "%d: ERROR: Open DB failed for (host,port,db,user,pass) = (%s,%s,%s,%s,%s)", __LINE__, 
                   $host_name, $port, 
                   $database_name, 
                   (defined($user_name) ? $user_name : "undef"),
                   (defined($password) ? $password : "undef");
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
        printf $log_fh "\n%d: ERROR: No product files given.\n", __LINE__;
        usage($cmd);
        exit 2;
    }
    #
    foreach my $prod_file (@ARGV)
    {
        my $status = process_file($prod_file, $schema_name);
        if ($status != SUCCESS)
        {
            printf $log_fh "\n%d: ERROR: Failed to process %s.\n", 
                            __LINE__, $prod_file;
            exit 2;
        }
    }
}
else
{
    printf $log_fh "\n%d: Reading STDIN for list of files ...\n", __LINE__;
    #
    while( defined(my $prod_file = <STDIN>) )
    {
        chomp($prod_file);
        my $status = process_file($prod_file, $schema_name);
        if ($status != SUCCESS)
        {
            printf $log_fh "\n%d: ERROR: Failed to process %s.\n", 
                            __LINE__, $prod_file;
            exit 2;
        }
    }
}
#
close_db($dbh);
$dbh = undef;
# 
exit 0;

__DATA__

