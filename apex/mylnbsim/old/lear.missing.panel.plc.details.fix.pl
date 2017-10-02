#!/usr/bin/perl -w
#
#########################################################################
#
# FYI: panel placement details and header schema 
#
# panel_placement_details panel_placement_id
# panel_placement_details reel_id
# panel_placement_details nc_placement_id
# panel_placement_details pattern_no
# panel_placement_details z_num
# panel_placement_details pu_num
# panel_placement_details part_no
# panel_placement_details custom_area1
# panel_placement_details custom_area2
# panel_placement_details custom_area3
# panel_placement_details custom_area4
# panel_placement_details ref_designator
# panel_placement_details pattern_idnum
# panel_placement_details pattern_barcode
# panel_placement_details pattern_designator
#
# panel_placement_header panel_equipment_id
# panel_placement_header equipment_id
# panel_placement_header master_placement_id
# panel_placement_header panel_placement_id
# panel_placement_header timestamp
# panel_placement_header trx_product_id
#
#########################################################################
#
use strict;
#
use Getopt::Std;
use FileHandle;
use Cwd;
#
#########################################################################
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
use constant SECTION_UNKNOWN => 0;
use constant SECTION_NAME_VALUE => 1;
use constant SECTION_LIST => 2;
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
use constant SINGLE_FEEDER => 1;
use constant DOUBLE_FEEDER => 2;
use constant TRIPLE_FEEDER => 3;
#
# #########################################################################
#
# global parameters
#
my $cmd = $0;
my $mai_path = '';
my %ppd_data = ();
my %mai_file_list = ();
my %known_mix_names = ();
my $my_bsql = '';
my $sql_cmd_no = 0;
my $verbose = NOVERBOSE;
my %nc_version_to_ncpd = ();
my %nc_version_to_master_placement_id = ();
my %last_nc_version_for_eqids = ();
my $update_slave_headers = TRUE;
my %pu_to_reel_id = ();
my %machine_slot_to_pu = ();
#
my $max_sql_queue_size = 1000;
my @sql_queue = ();
#
my %verbose_levels =
(
    off => NOVERBOSE(),
    min => MINVERBOSE(),
    mid => MIDVERBOSE(),
    max => MAXVERBOSE()
);
#
##########################################################################
#
# misc. functions
#
sub usage
{
    my ($arg0) = @_;
    print <<EOF;

# usage: $arg0 [-?|-h] [-U] [-w|-W|-v level] [-Q queue size] MAI_DIR_PATH 

EOF
}
#
sub dump_hash
{
    my ($label, $phash) = @_;
    #
    printf "%04d: %s\n", __LINE__, $label;
    while ( my( $key, $val ) = each %{$phash} )
    {
        printf "%04d: <%s> ==>> <%s>\n", __LINE__, $key, $val;
    }
}
#
sub dump_array
{
    my ($label, $parray) = @_;
    #
    printf "%04d: %s\n", __LINE__, $label;
    #
    my $imax = scalar(@{$parray});
    for (my $i=0; $i<$imax; ++$i)
    {
        printf "%04d: <%d> ==>> <%s>\n", __LINE__, $i, $parray->[$i];
    }
}
#
sub read_raw_file
{
    my ($msg, $file, $pdata) = @_;
    #
    printf "\n%04d: Read in file: %s\n", 
           __LINE__, 
           $file;
    #
    open(RTDIN, $file) or die $!;
    @{$pdata} = <RTDIN>;
    close(RTDIN);
    #
    chomp(@{$pdata});
    s/\r//g for @{$pdata};
    #
    printf "\n%04d: Number Of %s Records Read: %d\n", 
            __LINE__, 
            $msg, 
            scalar(@{$pdata});
}
#
##########################################################################
#
# track mix names
#
sub is_mix_name_known
{
    my ($mix_name) = @_;
    #
    die "NULL-length MIX NAME!" unless ($mix_name ne "");
    #
    if (exists($known_mix_names{$mix_name}))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub insert_mix_name
{
    my ($mix_name) = @_;
    #
    die "NULL-length MIX NAME!" unless ($mix_name ne "");
    #
    $known_mix_names{$mix_name} = TRUE;
}
#
sub remove_mix_name
{
    my ($mix_name) = @_;
    #
    die "NULL-length MIX NAME!" unless ($mix_name ne "");
    #
    delete $known_mix_names{$mix_name} if (exists($known_mix_names{$mix_name}))
}
#
##########################################################################
#
# execute sql commands.
#
sub write_sql
{
    my ($sql, $sql_fname) = @_;
    #
    local *FH;
    open(FH, '>', $sql_fname) or die $!;
    printf FH "%s\n", $sql;
    close(FH);
}
#
sub write_my_bsql
{
    $my_bsql = "${mai_path}/my_bsql.sh";
    #
    local *FH;
    open(FH, '>', $my_bsql) or die $!;
    #
    print FH <<'PERL_EOF';
#!/bin/bash
#
infile=${1}
outfile=${2}
#
if [[ ! -r "${infile}" ]]
then
    echo -e "\nERROR: SQL file ${infile} is NOT READABLE. Exiting."
    exit 2
fi
#
if [[ -z "${outfile}" ]]
then
    echo -e "\nERROR: Output file was NOT GIVEN. Exiting."
    exit 2
fi
#
echo -e "\nSQL IN: ${infile}"
echo -e "SQL OUT: ${outfile}"
#
cat >/tmp/$$.sql <<EOF
USE ${DB_NAME};
GO
EOF
#
cat ${infile} >>/tmp/$$.sql
#
cat >>/tmp/$$.sql <<EOF
GO
BYE
EOF
#
tsql -H ${DB_SERVER} -p ${DB_PORT_NO} -U cim -P cim < /tmp/$$.sql 2>&1 |
sed -e "s|[0-9][0-9]*> ||g" \
    -e "s|(return status = 0)||g" \
    -e "s|local.*$||g" \
    -e "s|[	 ]*$||g" |
grep -v "^[	 ]*$" > ${outfile}
#
rm /tmp/$$.sql 
#
exit 0
PERL_EOF
    #
    close(FH);
    #
    chmod 0755, $my_bsql;
}
#
sub exec_sql
{
    my ($sql, $praw_data) = @_;
    #
    flush_sql_queue(TRUE);
    #
    $sql_cmd_no += 1;
    #
    my $sql_in = "query.${sql_cmd_no}.sql";
    my $sql_out = "query.${sql_cmd_no}.sql.out";
    write_sql($sql, $sql_in);
    system("$my_bsql $sql_in $sql_out");
    read_raw_file("SQL Query ${sql_cmd_no}",
                  $sql_out,
                  $praw_data);
}
#
sub exec_sql_only
{
    my ($sql) = @_;
    #
    flush_sql_queue(TRUE);
    #
    $sql_cmd_no += 1;
    #
    my $sql_in = "query.${sql_cmd_no}.sql";
    my $sql_out = "query.${sql_cmd_no}.sql.out";
    write_sql($sql, $sql_in);
    system("$my_bsql $sql_in $sql_out");
}
#
sub exec_sql_file
{
    my ($sql_in, $sql_out, $praw_data) = @_;
    #
    flush_sql_queue(TRUE);
    #
    system("$my_bsql $sql_in $sql_out");
    read_raw_file("SQL Query File ${sql_in}",
                  $sql_out,
                  $praw_data);
}
#
sub exec_sql_file_only
{
    my ($sql_in, $sql_out) = @_;
    #
    system("$my_bsql $sql_in $sql_out");
}
#
sub insert_sql_queue
{
    my ($sql_cmd) = @_;
    #
    push @sql_queue, $sql_cmd;
    #
    flush_sql_queue(FALSE);
}
#
sub flush_sql_queue
{
    my ($unconditional) = @_;
    #
    if ((scalar(@sql_queue) > 0) &&
        ((scalar(@sql_queue) >= $max_sql_queue_size) ||
         ($unconditional == TRUE)))
    {
        $sql_cmd_no += 1;
        #
        my $sql_in = "query.${sql_cmd_no}.sql";
        my $sql_out = "query.${sql_cmd_no}.sql.out";
        #
        local *FH;
        open(FH, '>', $sql_in) or die $!;
        #
        my $isqlmax = scalar(@sql_queue);
        for (my $isql = 0; $isql<$isqlmax; ++$isql)
        {
            printf FH "%s\ngo\n", $sql_queue[$isql];
        }
        #
        close(FH);
        #
        undef @sql_queue;
        #
        if ($update_slave_headers == TRUE)
        {
            exec_sql_file_only($sql_in, $sql_out);
        }
    }
}
#
##########################################################################
#
# parse MAI/CRB files.
#
sub load_name_value
{
    my ($praw_data, $section, $pirec, $max_rec, $pprod_db) = @_;
    #
    $pprod_db->{found_data}->{$section} = FALSE;
    $pprod_db->{section_type}->{$section} = SECTION_NAME_VALUE;
    #
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
        push @section_data, $record;
        $$pirec += 1;
    }
    #
    printf "%04d: <%s>\n", 
           __LINE__, 
           join("\n", @section_data) if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@section_data) <= 0)
    {
        $pprod_db->{$section} = {};
        printf "%04d: NO NAME-VALUE DATA FOUND IN SECTION %s. Lines read: %d\n", 
               __LINE__, 
               $section, 
               scalar(@section_data);
        return FAIL;
    }
    #
    %{$pprod_db->{$section}->{data}} = 
        map { split /\s*=\s*/, $_, 2 } @section_data;
    #
    # remove any double quotes.
    #
    for my $key (keys %{$pprod_db->{$section}->{data}})
    {
        $pprod_db->{$section}->{data}->{$key} =~ s/^\s*"([^"]*)"\s*$/$1/;
    }
    #
    $pprod_db->{found_data}->{$section} = TRUE;
    #
    printf "%04d: Number of key-value pairs: %d\n", 
           __LINE__, 
           scalar(keys %{$pprod_db->{$section}->{data}})
           if ($verbose >= MIDVERBOSE);
    printf "%04d: Lines read: %d\n", 
           __LINE__, 
           scalar(@section_data)
           if ($verbose >= MIDVERBOSE);
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
    $pprod_db->{found_data}->{$section} = FALSE;
    $pprod_db->{section_type}->{$section} = SECTION_LIST;
    #
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
        push @section_data, $record;
        $$pirec += 1;
    }
    #
    printf "%04d: <%s>\n", 
        __LINE__, 
        join("\n", @section_data) 
        if ($verbose >= MAXVERBOSE);
    #
    if (scalar(@section_data) <= 0)
    {
        $pprod_db->{$section} = {};
        printf "%04d: NO LIST DATA FOUND IN SECTION %s. Lines read: %d\n", 
            __LINE__, 
            $section, scalar(@section_data) if ($verbose >= MIDVERBOSE);
        return SUCCESS;
    }
    #
    $pprod_db->{$section}->{header} = shift @section_data;
    @{$pprod_db->{$section}->{column_names}} = 
        split / /, $pprod_db->{$section}->{header};
    my $number_columns = scalar(@{$pprod_db->{$section}->{column_names}});
    #
    @{$pprod_db->{$section}->{data}} = ();
    #
    printf "%04d: Number of Columns: %d\n", 
           __LINE__, 
           $number_columns
           if ($verbose >= MIDVERBOSE);
    #
    foreach my $record (@section_data)
    {
        #
        # sanity check since MAI or CRB file may be corrupted.
        #
        last if (($record =~ m/^\[[^\]]*\]/) ||
                 ($record =~ m/^\s*$/));
        #
        my @tokens = split_quoted_string($record, ' ');
        my $number_tokens = scalar(@tokens);
        #
        printf "%04d: Number of tokens in record: %d\n", 
               __LINE__, 
               $number_tokens
               if ($verbose >= MAXVERBOSE);
        #
        if ($number_tokens == $number_columns)
        {
            my %data = ();
            @data{@{$pprod_db->{$section}->{column_names}}} = @tokens;
            #
            unshift @{$pprod_db->{$section}->{data}}, \%data;
            printf "%04d: Current Number of Records: %d\n", 
                   __LINE__, 
                   scalar(@{$pprod_db->{$section}->{data}}) if ($verbose >= MAXVERBOSE);
        }
        else
        {
            printf "%04d: ERROR: Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", 
                   __LINE__, 
                   $section, 
                   $number_tokens, 
                   $number_columns;
        }
    }
    #
    $pprod_db->{found_data}->{$section} = TRUE;
    #
    return SUCCESS;
}
#
sub process_data
{
    my ($pdata, $prod_file, $praw_data, $pprod_db) = @_;
    #
    printf "%04d: Processing product data: %s\n", 
           __LINE__, 
           $prod_file;
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            printf "%04d: Section %03d: %s\n", 
                __LINE__, 
                ++$sec_no, 
                $section if ($verbose >= MIDVERBOSE);
            #
            $rec = $praw_data->[${irec}+1];
            #
            if ($rec =~ m/^\s*$/)
            {
                $irec += 2;
                printf "%04d: Empty section - %s\n", 
                       __LINE__, 
                      $section if ($verbose >= MIDVERBOSE);
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
sub parse_mai_recipe_file
{
    my ($pdata, $prod_fname, $praw_data, $pprod_db) = @_;
    #
    printf "\n%04d: Processing product File: %s\n", 
           __LINE__, 
           $prod_fname;
    #
    my $status = process_data($pdata, $prod_fname, $praw_data, $pprod_db);
    if ($status != SUCCESS)
    {
        printf "%d: ERROR: Processing product file: %s\n", 
               __LINE__, 
               $prod_fname;
    }
    #
    return $status;
}
#
##########################################################################
#
# read in MAI file history data
#
sub dump_mai_file_list
{
    foreach my $mai_fname (sort keys %mai_file_list)
    {
        my @keys = keys %{$mai_file_list{$mai_fname}};
        printf "%04d: MAI File %s records: %d\n", 
               __LINE__,
               $mai_fname, 
               scalar(@keys);
        foreach my $key (sort @keys)
        {
            printf "%04d: \t%d ==>> %s\n", 
                   __LINE__,
                   $key, 
                   $mai_file_list{$mai_fname}{$key}
        }
    }
}
#
sub get_mai_file_list
{
    #
    opendir(DIR, $mai_path) || die "Can't open directory $mai_path: $!";
    my @all_files = grep { (!/^\./) && -f "$mai_path/$_" } readdir(DIR);
    closedir DIR;
    #
    printf "%04d: Number of files in %s: %d\n", 
           __LINE__,
           $mai_path, 
           scalar(@all_files);
    #
    my $mai_file_num = 0;
    foreach my $fname (@all_files)
    {
        # is it an MAI file?
        if ($fname =~ m/^[^_]+_[^_]+.MAI$/)
        {
            printf "%04d: Found MAI file: %s\n", 
                   __LINE__,
                   $fname;
            #
            $mai_file_num += 1;
            #
            my @data = split(/_/, $fname);
            my $tstamp = $data[0];
            my $mai_fname = $data[1];
            #
            $mai_file_list{$mai_fname}{$tstamp} = $fname;
        }
        else
        {
            printf "%04d: Skipping NON-MAI file: %s\n", 
                   __LINE__,
                   $fname if ($verbose >= MAXVERBOSE);
        }
    }
    #
    if ($mai_file_num <= 0)
    {
        printf "%04d: \nERROR: NO MAI FILE FOUND IN %s. Exiting.\n", 
               __LINE__,
               $mai_path;
        exit 2;
    }
    #
    dump_mai_file_list();
    #
    printf "%04d: Found %d MAI files.\n", 
           __LINE__,
           $mai_file_num;
}
#
sub find_mai_product
{
    my ($tstamp, $mai_fname) = @_;
    #
    my $mai_version = undef;
    if (exists($mai_file_list{$mai_fname}))
    {
        my @mai_tstamps = sort keys %{$mai_file_list{$mai_fname}};
        foreach my $mai_tstamp (sort @mai_tstamps)
        {
            if ($mai_tstamp <= $tstamp)
            {
                $mai_version = $mai_file_list{$mai_fname}{$mai_tstamp};
            }
            elsif ($mai_tstamp > $tstamp)
            {
                last;
            }
        }
    }
    else
    {
        printf "%d: MAI FNAME NOT FOUND FOR tstamp <%d>, mai_fname <%s> \n", 
               __LINE__, $tstamp, $mai_fname;
    }
    #
    return $mai_version;
}
#
##########################################################################
#
# create nc_placement_data for nc_summary records without details.
#
sub ncpd_db_data_exists
{
    my ($pdata) = @_;
    #
    # check if we have any nc placement details for this nc_version. we should 
    # not, but check if they were regenerated, but the PPD data were not 
    # generated.
    #
    my $sql_cmd = "select count(*) from nc_placement_detail where nc_version = $pdata->{nc_version}",
    my @sql_data = ();
    exec_sql($sql_cmd, \@sql_data);
    die "Wrong number of records!" unless (scalar(@sql_data) == 1);
    if ($sql_data[0] > 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub create_ncpd_db_data
{
    my ($pdata, $pmai_p, $pmai_pd) = @_;
    #
    dump_array("MAI RECIPE FILE PositionData column_names DATA", 
             \@{$pmai_pd->{'[PositionData]'}->{column_names}})
        if ($verbose >= MIDVERBOSE);
    dump_array("MAI RECIPE FILE PositionData data DATA", 
             \@{$pmai_pd->{'[PositionData]'}->{data}})
        if ($verbose >= MIDVERBOSE);
    dump_array("MAI RECIPE FILE PartsData column_names DATA", 
             \@{$pmai_pd->{'[PartsData]'}->{column_names}})
        if ($verbose >= MIDVERBOSE);
    dump_array("MAI RECIPE FILE PartsData data DATA", 
             \@{$pmai_pd->{'[PartsData]'}->{data}})
        if ($verbose >= MIDVERBOSE);
    #
    # map IDNUM to Part name
    #
    my %idnum_to_partname = ();
    #
    my $ppartscols = $pmai_pd->{'[PartsData]'}->{column_names};
    my $ppartsdata = $pmai_pd->{'[PartsData]'}->{data};
    #
    my $ipartsmax = scalar(@{$ppartsdata});
    for (my $iparts=0; $iparts<$ipartsmax; ++$iparts)
    {
        dump_hash("Data Entry: $iparts", $ppartsdata->[$iparts])
            if ($verbose >= MIDVERBOSE);
        $idnum_to_partname{$ppartsdata->[$iparts]->{IDNUM}} = 
                           $ppartsdata->[$iparts]->{NAME};
    }
    #
    dump_hash("IDNUM-TO-PARTNAME", \%idnum_to_partname)
        if ($verbose >= MIDVERBOSE);
    #
    # open sql file to for writing the inserts for this NC_VERSION.
    #
    my $nc_version = $pdata->{nc_version};
    my $equipment_id = $pdata->{equipment_id};
    #
    my $ncpd_sql = "ncpd.${equipment_id}.${nc_version}.sql";
    my $ncpd_sql_out = "ncpd.${equipment_id}.${nc_version}.sql.out";
    my @ncpd_sql_data = ();
    #
    local *FH;
    open(FH, '>', $ncpd_sql) or die $!;
    #
    # scan Position Data to get records for NC_PLACEMENT_DETAILS
    #
    my $pposcols = $pmai_pd->{'[PositionData]'}->{column_names};
    my $pposdata = $pmai_pd->{'[PositionData]'}->{data};
    #
    my $iposmax = scalar(@{$pposdata});
    for (my $ipos=0; $ipos<$iposmax; ++$ipos)
    {
        dump_hash("Data Entry: $ipos", $pposdata->[$ipos])
            if ($verbose >= MIDVERBOSE);
        #
        my $idnum = $pposdata->[$ipos]->{IDNUM};
        my $ref_designator = $pposdata->[$ipos]->{C};
        if (( ! defined($ref_designator)) || ($ref_designator eq ''))
        {
            printf "%04d: WARNING: Skipping record with NO REF_DESIGNATOR.\n", 
                   __LINE__;
            next;
        }
        my $pattern_number = $pposdata->[$ipos]->{B};
        my $part_name = '';
        if ((defined($idnum_to_partname{$pposdata->[$ipos]->{PARTS}})) &&
            (exists($idnum_to_partname{$pposdata->[$ipos]->{PARTS}})))
        {
            $part_name = $idnum_to_partname{$pposdata->[$ipos]->{PARTS}}; 
        }
        else
        {
            $part_name = '';
        }
        #
        if (( ! defined($part_name)) || ($part_name eq ''))
        {
            printf "%04d: WARNING: Skipping record with NO PART NAME.\n", 
                   __LINE__;
            next;
        }
        #
        printf "%04d: IDNUM (IDNUM) = %d\n", __LINE__, $idnum;
        printf "%04d: C (REF_DESIGNATOR) = '%s'\n", __LINE__, $ref_designator;
        printf "%04d: B (PATTERN_NUMBER) = %d\n", __LINE__, $pattern_number;
        printf "%04d: PART_NAME (PART_NAME) = '%s'\n", __LINE__, $part_name;
        #
        # write out the sql insert statement
        #
        print FH <<EOF;
insert into nc_placement_detail
(
    idnum,
    nc_version,
    ref_designator,
    pattern_number,
    part_name
)
values
(
    $idnum,
    $nc_version,
    '$ref_designator',
    $pattern_number,
    '$part_name'
)
go
EOF
    }
    #
    close(FH);
    #
    # insert the data now ...
    #
    exec_sql_file($ncpd_sql, $ncpd_sql_out, \@ncpd_sql_data);
    #
    # now read in the data which was just inserted. it will now 
    # have the nc_placement_id which will be used to create the
    # panel_placement_detail records.
    #
    my @ncpd_raw_data = ();
    exec_sql("select nc_placement_id, idnum, ref_designator, part_name, pattern_number, nc_version from nc_placement_detail where nc_version = ${nc_version}", \@ncpd_raw_data);
    #
    dump_array("NEW NCPD data for NC_VERSION = $nc_version", \@ncpd_raw_data);
    #
    # save data for later use
    #
    my @cols = split(/\t/, shift @ncpd_raw_data);
    #
    while (scalar(@ncpd_raw_data))
    {
        my @data = split(/\t/, shift @ncpd_raw_data);
        my %hash = ();
        @hash{@cols} = @data;
        $nc_version_to_ncpd{$nc_version}{$hash{idnum}} = \%hash;
    }
    #
    return TRUE;
}
#
##########################################################################
#
# process PPH WO details data. 
#
# don't use the following function. 
# it is excessively slow !!! 
# left here for reference.
#
sub get_reel_id_via_db_read
{
    my ($pdata, $pu_num) = @_;
    #
    my $equipment_id = $pdata->{equipment_id};
    my $timestamp = $pdata->{timestamp};
    #
    my @reel_data = ();
    exec_sql("select fh.equipment_id, fh.carriage_no, fh.slot, fh.subslot, fh.time_on, fh.time_off, fh.reel_id, fh.feeder_id, fh.pu_number from feeder_history fh where fh.equipment_id = $equipment_id and fh.time_on <= $timestamp and $timestamp <= fh.time_off and fh.pu_number in ( '$pu_num' )", \@reel_data);
    return -1 if (scalar(@reel_data) < 2);
    #
    my @cols = split(/\t/, shift @reel_data);
    my @data = split(/\t/, shift @reel_data);
    my %hash = ();
    @hash{@cols} = @data;
    #
    return $hash{reel_id};
}
#
sub get_reel_id
{
    my ($pdata, $pu_no) = @_;
    #
    my $reel_id = -1;
    my $eqid = $pdata->{equipment_id};
    my $tstamp = $pdata->{timestamp};
    #
    if (exists($pu_to_reel_id{$eqid}{$pu_no}))
    {
        foreach my $time_on (sort keys %{$pu_to_reel_id{$eqid}{$pu_no}})
        {
            my $time_off = $pu_to_reel_id{$eqid}{$pu_no}{$time_on}{time_off};
            if (($time_on <= $tstamp) && ($tstamp < $time_off))
            {
                $reel_id = $pu_to_reel_id{$eqid}{$pu_no}{$time_on}{reel_id};
                last;
            }
        }
    }
    #
    return $reel_id;
}
#
sub get_zno
{
    my ($pdata, $pu_no) = @_;
    #
    my $eqid = $pdata->{equipment_id};
    #
    if (exists($machine_slot_to_pu{$eqid}{$pu_no}))
    {
         return $machine_slot_to_pu{$eqid}{$pu_no}{z_number};
    }
    else
    {
        return -1;
    }
}
#
sub process_feeder_history_data
{
    my ($praw) = @_;
    #
    my @cols = split(/\t/, shift @{$praw});
    printf "\n%04d: Number of fields in header record: %d\n", 
           __LINE__,
           scalar(@cols) if ($verbose >= MINVERBOSE);
    my $number_of_cols = scalar(@cols);
    #
    for (my $rec_no = 2; scalar(@{$praw}) > 0; $rec_no+=1)
    {
        my $rec = shift @{$praw};
        printf "\n%04d: Processing record: %s\n", 
               __LINE__,
               $rec if ($verbose >= MINVERBOSE);
        #
        my @data = split(/\t/, $rec);
        my %fh = ();
        @fh{@cols} = @data;
        #
        printf "%04d: Number of fields in record: %d\n", 
               __LINE__,
                scalar(keys %fh) if ($verbose >= MINVERBOSE);
        die "number of fields in record != number of header columns"
            unless (scalar(keys %fh) == $number_of_cols);
        #
        my $equipment_id = $fh{equipment_id};
        my $pu_number = $fh{pu_number};
        my $time_on = $fh{time_on};
        my $time_off = $fh{time_off};
        my $reel_id = $fh{reel_id};
        #
        $pu_to_reel_id{$equipment_id}{$pu_number}{$time_on} = {
            time_on => $time_on,
            time_off => $time_off,
            reel_id => $reel_id
        };
    }
    #
    if ($verbose >= MIDVERBOSE)
    {
        foreach my $equipment_id (sort keys %pu_to_reel_id)
        {
            printf "\tEQID: %s\n", $equipment_id;
            foreach my $pu_no (sort keys %{$pu_to_reel_id{$equipment_id}})
            {
               printf "\t\tPU_NUMBER: %s\n", $pu_no;
               foreach my $time_on (sort keys %{$pu_to_reel_id{$equipment_id}{$pu_no}})
               {
                   printf "\t\t\tTIME ON: %s\n", 
                          $pu_to_reel_id{$equipment_id}{$pu_no}{$time_on}{time_on};
                   printf "\t\t\tTIME OFF: %s\n", 
                          $pu_to_reel_id{$equipment_id}{$pu_no}{$time_on}{time_off};
                   printf "\t\t\tREEL ID: %s\n", 
                          $pu_to_reel_id{$equipment_id}{$pu_no}{$time_on}{reel_id};
               }
           }
        }
    }
}
#
sub process_machine_slot_to_pu_data
{
    my ($praw) = @_;
    #
    my @cols = split(/\t/, shift @{$praw});
    printf "\n%04d: Number of fields in header record: %d\n", 
           __LINE__,
           scalar(@cols) if ($verbose >= MINVERBOSE);
    my $number_of_cols = scalar(@cols);
    #
    for (my $rec_no = 2; scalar(@{$praw}) > 0; $rec_no+=1)
    {
        my $rec = shift @{$praw};
        printf "\n%04d: Processing record: %s\n", 
               __LINE__,
               $rec if ($verbose >= MINVERBOSE);
        #
        my @data = split(/\t/, $rec);
        my %ms2pu = ();
        @ms2pu{@cols} = @data;
        #
        printf "%04d: Number of fields in record: %d\n", 
               __LINE__,
                scalar(keys %ms2pu) if ($verbose >= MINVERBOSE);
        die "number of fields in record != number of header columns"
            unless (scalar(keys %ms2pu) == $number_of_cols);
        #
        my $equipment_id = $ms2pu{equipment_id};
        my $slot = $ms2pu{slot};
        my $subslot = $ms2pu{subslot};
        my $z_number = $ms2pu{z_number};
        my $pu_number = $ms2pu{pu_number};
        my $stage_no = $ms2pu{stage_no};
        my $display_z_pu = $ms2pu{display_z_pu};
        my $display_table_slot = $ms2pu{display_table_slot};
        my $display_subslot = $ms2pu{display_subslot};
        #
        $machine_slot_to_pu{$equipment_id}{$display_z_pu} = {
            equipment_id => $ms2pu{equipment_id},
            slot => $ms2pu{slot},
            subslot => $ms2pu{subslot},
            z_number => $ms2pu{z_number},
            pu_number => $ms2pu{pu_number},
            stage_no => $ms2pu{stage_no},
            display_z_pu => $ms2pu{display_z_pu},
            display_table_slot => $ms2pu{display_table_slot},
            display_subslot => $ms2pu{display_subslot}
        };
    }
    #
    foreach my $equipment_id (sort keys %machine_slot_to_pu)
    {
        printf "\tEQID: %s\n", $equipment_id;
        foreach my $pu_no (sort keys %{$machine_slot_to_pu{$equipment_id}})
        {
            printf "\t\tDISPLAY Z PU: %s\n", $pu_no;
            foreach my $key (sort keys %{$machine_slot_to_pu{$equipment_id}{$pu_no}})
            {
                printf "\t\t\t%s: %s\n",
                       $key, 
                       $machine_slot_to_pu{$equipment_id}{$pu_no}{$key};
            }
        }
    }
}
#
sub pu_to_stage
{
    my ($pu_num) = @_;
    #
    my $table = -1;
    if ($pu_num < 10000)
    {
        $table = int($pu_num/1000);
    }
    else
    {
        $table = int($pu_num/10000);
    }
    #
    my $stage = -1;
    if (($table == 1) || ($table == 2))
    {
        $stage = 1;
    }
    elsif (($table == 3) || ($table == 4))
    {
        $stage = 2;
    }
    #
    return $stage;
}
#
sub create_ppd_data_from_mai_file
{
    my ($pdata, $mai_product) = @_;
    #
    printf "%04d: Creating PPD data from MAI file %s.\n", 
            __LINE__, 
            $mai_product;
    #
    # read in mai product file.
    #
    my @mai_raw_product_data = ();
    read_raw_file("MAI Recipe File",
              $mai_product,
             \@mai_raw_product_data);
    #
    my %mai_product_data = ();
    parse_mai_recipe_file($pdata, 
                          $mai_product, 
                          \@mai_raw_product_data,
                          \%mai_product_data);
    dump_hash("MAI RECIPE FILE DATA", 
             \%mai_product_data)
            if ($verbose >= MIDVERBOSE);
    dump_hash("MAI RECIPE FILE PositionData DATA", 
            \%{$mai_product_data{'[PositionData]'}})
            if ($verbose >= MIDVERBOSE);
    dump_hash("MAI RECIPE FILE PartsData DATA", 
            \%{$mai_product_data{'[PartsData]'}})
            if ($verbose >= MIDVERBOSE);
    #
    # first determine if we already have NC_PLACEMENT_DETAILS. these
    # may have been generated after the fact. if they exist, then use
    # the existing data
    #
    my $nc_version = $pdata->{nc_version};
    if (ncpd_db_data_exists($pdata) == TRUE)
    {
        #
        # the NCPD data does exist. may have been recreated as part of the
        # hotfix. use it to generate the missing PPD data.
        #
        my @ncpd_raw_data = ();
        exec_sql("select nc_placement_id, idnum, ref_designator, part_name, pattern_number, nc_version from nc_placement_detail where nc_version = ${nc_version}", \@ncpd_raw_data);
        #
        dump_array("USING EXISTING NCPD data for NC_VERSION = $nc_version", \@ncpd_raw_data);
        #
        # save data for later use
        #
        my @cols = split(/\t/, shift @ncpd_raw_data);
        #
        while (scalar(@ncpd_raw_data))
        {
            my @data = split(/\t/, shift @ncpd_raw_data);
            my %hash = ();
            @hash{@cols} = @data;
            $nc_version_to_ncpd{$nc_version}{$hash{idnum}} = \%hash;
        }
    }
    elsif (create_ncpd_db_data($pdata, $mai_product, \%mai_product_data) == FALSE)
    {
        printf "%04d: ERROR: Unable to create NCPD Data for %s.\n", 
               __LINE__,
              $pdata->{mix_name};
        return FALSE;
    }
    #
    # recreate the PPD data ... finally.
    #
    # here's the process. it is assumed that this is the first 
    # record for this nc_version. then this panel placement header will
    # have placement id = panel_placement_id (identity field). all other
    # records for this nc-version will have the master placement id pointing
    # to this first record.
    #
    # scan Position Data to create PPD records
    #
    my $stage_no = $pdata->{stage_no};
    my $equipment_id = $pdata->{equipment_id};
    my $panel_placement_id = $pdata->{panel_placement_id};
    $panel_placement_id = -1 if ( ! defined($panel_placement_id));
    #
    my $ppd_sql = "ppd.insert.${panel_placement_id}.sql";
    my $ppd_sql_out = "ppd.insert.${panel_placement_id}.sql.out";
    #
    local *FH;
    open(FH, '>', $ppd_sql) or die $!;
    #
    my $pposcols = $mai_product_data{'[PositionData]'}->{column_names};
    my $pposdata = $mai_product_data{'[PositionData]'}->{data};
    #
    my %pu_to_feeder_type = ();
    my $pstockcols = $mai_product_data{'[StockData]'}->{column_names};
    my $pstockdata = $mai_product_data{'[StockData]'}->{data};
    #
    my $istockmax = scalar(@{$pstockdata});
    for (my $istock=0; $istock<$istockmax; ++$istock)
    {
        my $pu = $pstockdata->[$istock]->{N};
        my $ta = $pstockdata->[$istock]->{TA};
        my $tb = $pstockdata->[$istock]->{TB};
        my $tc = $pstockdata->[$istock]->{TC};
        #
        printf "\n%04d: (PU,TA,TB,TC) = (%s,%d,%d,%d)\n",
               __LINE__,
               $pu,
               $ta,
               $tb,
               $tc;
        #
        if ($tc != 0)
        {
            printf "\n%04d: PU %s ==>> TRIPLE FEEDER (%d)\n",
                   __LINE__,
                   $pu,
                   TRIPLE_FEEDER;
            $pu_to_feeder_type{$pu} = TRIPLE_FEEDER;
        }
        elsif ($tb != 0)
        {
            printf "\n%04d: PU %s ==>> DOUBLE FEEDER (%d)\n",
                   __LINE__,
                   $pu,
                   DOUBLE_FEEDER;
            $pu_to_feeder_type{$pu} = DOUBLE_FEEDER;
        }
        elsif ($ta != 0)
        {
            printf "\n%04d: PU %s ==>> SINGLE FEEDER (%d)\n",
                   __LINE__,
                   $pu,
                   SINGLE_FEEDER;
            $pu_to_feeder_type{$pu} = SINGLE_FEEDER;
        }
        else
        {
            printf "\n%04d: ERROR: PU %s ==>> NO FEEDER TYPE ASSIGNED\n",
                   __LINE__,
                   $pu;
        }
    }
    #
    my $records_inserted = 0;
    my $iposmax = scalar(@{$pposdata});
    for (my $ipos=0; $ipos<$iposmax; ++$ipos)
    {
        dump_hash("Data Entry: $ipos", $pposdata->[$ipos])
            if ($verbose >= MINVERBOSE);
        #
        my $idnum = $pposdata->[$ipos]->{IDNUM};
        my $parts = $pposdata->[$ipos]->{PARTS};
        my $b = $pposdata->[$ipos]->{B};
        #
        # set known fields.
        #
        my $part_no = $nc_version_to_ncpd{$nc_version}{$idnum}->{part_name};
        next if (( ! defined($part_no)) or ($part_no eq ''));
        #
        my $custom_area4 = $part_no;
        #
        my $ref_designator = $nc_version_to_ncpd{$nc_version}{$idnum}->{ref_designator};
        $ref_designator = ''
            if ( ! defined($ref_designator));
        #
        my $nc_placement_id = $nc_version_to_ncpd{$nc_version}{$idnum}->{nc_placement_id};
        $nc_placement_id = -1 
            if ( ! defined($nc_placement_id));
        #
        my $pattern_idnum = $pposdata->[$ipos]->{B};
        $pattern_idnum = -1 
            if ( ! defined($pattern_idnum));
        #
        # set known unknown fields.
        #
        my $custom_area1 = '';
        my $custom_area2 = '';
        my $custom_area3 = '';
        my $pattern_no = -1;
        my $pattern_barcode =  '';
        my $pattern_designator =  '';
        #
        # TBD
        #
        my $z_num = -1;
        my $bare_pu_num = "$pposdata->[$ipos]->{PU}";
        my $pu_num = "$pposdata->[$ipos]->{PU}";
        my $reel_id = -1;
        if (defined($pu_num))
        {
            if (exists($pu_to_feeder_type{$pu_num}))
            {
                my $feeder_type = $pu_to_feeder_type{$pu_num};
                if ($feeder_type == SINGLE_FEEDER)
                {
                    if ($pposdata->[$ipos]->{SIDE} == 0)
                    {
                        $pu_num .= "L";
                    }
                    else
                    {
                        printf "%04d: WARNING: Single feeder (%s), SIDE (%d), but NO SIDE ASSIGNED! FORCING TO 'L'.\n",
                               __LINE__, 
                               $pu_num, 
                               $pposdata->[$ipos]->{SIDE};
                        $pu_num .= "L";
                    }
                }
                elsif ($feeder_type == DOUBLE_FEEDER)
                {
                    if ($pposdata->[$ipos]->{SIDE} == 1)
                    {
                        $pu_num .= "L";
                    }
                    elsif ($pposdata->[$ipos]->{SIDE} == 2)
                    {
                        $pu_num .= "R";
                    }
                    else
                    {
                        printf "%04d: ERROR: Double feeder (%s), SIDE (%d), but NO SIDE ASSIGNED!\n",
                               __LINE__, 
                               $pu_num, 
                               $pposdata->[$ipos]->{SIDE};
                    }
                }
                elsif ($feeder_type == TRIPLE_FEEDER)
                {
                    if ($pposdata->[$ipos]->{SIDE} == 1)
                    {
                        $pu_num .= "L";
                    }
                    elsif ($pposdata->[$ipos]->{SIDE} == 2)
                    {
                        $pu_num .= "R";
                    }
                    elsif ($pposdata->[$ipos]->{SIDE} == 3)
                    {
                        $pu_num .= "T";
                    }
                    else
                    {
                        printf "%04d: ERROR: Triple feeder (%s), SIDE (%d), but NO SIDE ASSIGNED!\n",
                               __LINE__, 
                               $pu_num, 
                               $pposdata->[$ipos]->{SIDE};
                    }
                }
            }
            else
            {
                printf "\n%04d: ERROR: Unknown feeder type: (pu,eqid,time) = (%s,%d,%d)\n",
                    __LINE__,
                    $pu_num,
                    $pdata->{equipment_id},
                    $pdata->{timestamp},
            }
            # 
            $reel_id = get_reel_id($pdata, $pu_num);
            if ($reel_id <= 0)
            {
                printf "\n%04d: ERROR: Unable to get REEL ID: (eqid,time,pu_no) = (%d,%d,%s)\n",
                        __LINE__,
                        $pdata->{equipment_id},
                        $pdata->{timestamp},
                        $pu_num;
            }
            $z_num = get_zno($pdata, $pu_num);
            if ($z_num <= 0)
            {
                printf "\n%04d: ERROR: Unable to get ZNO: (eqid,time,pu_no) = (%d,%d,%s)\n",
                        __LINE__,
                        $pdata->{equipment_id},
                        $pdata->{timestamp},
                        $pu_num;
            }
        }
        else
        {
            printf "\n%04d: ERROR: Undefined PU NO: (eqid,time) = (%d,%d)\n",
                    __LINE__,
                    $pdata->{equipment_id},
                    $pdata->{timestamp},
        }
        #
        # filter for stage number - 
        #
        # table 1,2 ==>> stage 1
        # table 3,4 ==>> stage 2
        #
        if (pu_to_stage($bare_pu_num) == $stage_no)
        {
            printf "%04d: (PU %d,PU Stage %d) == Stage %d. Using.\n",
                    __LINE__,
                    $bare_pu_num,
                    pu_to_stage($bare_pu_num),
                    $stage_no;
        }
        else
        {
            printf "%04d: (PU %d,PU Stage %d) != Stage %d. Skipping.\n",
                    __LINE__,
                    $bare_pu_num,
                    pu_to_stage($bare_pu_num),
                    $stage_no;
            next;
        }
        #
        # write out the sql insert statement
        #
        $records_inserted += 1;
        print FH <<EOF;
insert into panel_placement_details
(
    panel_placement_id,
    reel_id,
    nc_placement_id,
    pattern_no,
    z_num,
    pu_num,
    part_no,
    custom_area1,
    custom_area2,
    custom_area3,
    custom_area4,
    ref_designator,
    pattern_idnum,
    pattern_barcode,
    pattern_designator
)
values
(
    $panel_placement_id,
    $reel_id,
    $nc_placement_id,
    $pattern_no,
    $z_num,
   '$pu_num',
   '$part_no',
   '$custom_area1',
   '$custom_area2',
   '$custom_area3',
   '$custom_area4',
   '$ref_designator',
    $pattern_idnum,
   '$pattern_barcode',
   '$pattern_designator'
)
go
EOF
    }
    #
    print FH <<EOF;
update 
    panel_placement_header
set
    master_placement_id = panel_placement_id
where
    panel_placement_id = $panel_placement_id
go
EOF
    #
    close(FH);
    #
    exec_sql_file_only($ppd_sql, $ppd_sql_out);
    #
    $nc_version_to_master_placement_id{$nc_version}{$stage_no} = $panel_placement_id;
    #
    printf "%04d: Inserted %d records for MAI %s\n", 
               __LINE__,
               $records_inserted,
               $mai_product;
    #
    return TRUE;
}
#
sub create_ppd_data
{
    my ($pdata) = @_;
    #
    # read in the MAI file for this mix name.
    #
    my $status = FALSE;
    my $mai_file = $pdata->{lot_name} . $pdata->{mai_fname} . ".MAI";
    my $timestamp = $pdata->{timestamp};
    my $mai_product = find_mai_product($timestamp, $mai_file);
    if (defined($mai_product))
    {
        printf "%04d: Found MAI PRODUCT ... (%d,%s) -->> %s\n", 
               __LINE__,
               $timestamp, $mai_file, $mai_product;
        if (create_ppd_data_from_mai_file($pdata, $mai_product) == TRUE)
        {
            insert_mix_name($pdata->{mix_name});
            $status = TRUE;
        }
        else
        {
            printf "%04d: ERROR: CREATING PPD DATA FAILED ... (%d,%s) -->> %s\n", 
               __LINE__,
               $timestamp, $mai_file, $mai_product;
        }
    }
    else
    {
        printf "%04d: ERROR: MAI PRODUCT NOT FOUND ... (%d,%s) -->> UNDEF\n", 
               __LINE__,
               $timestamp, $mai_file;
    }
    #
    return $status;
}
#
sub update_panel_placement_header
{
    my ($pdata) = @_;
    #
    my $stage_no = $pdata->{stage_no};
    my $nc_version = $pdata->{nc_version};
    my $master_placement_id = 
           $nc_version_to_master_placement_id{$nc_version}{$stage_no};
    my $panel_placement_id = $pdata->{panel_placement_id};
    #
    my $pph_sql = "update panel_placement_header set master_placement_id = $master_placement_id where panel_placement_id = $panel_placement_id";
    #
    insert_sql_queue($pph_sql);
}
##########################################################################
#
# process PPH WO details data. 
#
sub process_pph_wo_details_rec
{
    my ($rec_no, $pdata) = @_;
    #
    # get MAI filename, LOT name and LOT number from mix name.
    # this is used to map the setup ID to the correct MAI file.
    #
    my @lot_cols = qw ( mai_fname lot_name lot_num );
    my @lot_vals = split(/_/, $pdata->{mix_name});
    die "Mix Name format is NOT MAI_LOTNM_LOTNO !!!" 
        unless (scalar(@lot_cols) == scalar(@lot_vals));
    #
    # @{%{$pdata}}{@lot_cols} = @lot_vals;
    #
    $pdata->{mai_fname} = $lot_vals[0];
    $pdata->{lot_name} = $lot_vals[1];
    $pdata->{lot_num} = $lot_vals[2];
    #
    dump_hash("Data for record: $rec_no", $pdata) if ($verbose >= MIDVERBOSE);
    #
    # check if we generated these details data before
    #
    my $equipment_id = $pdata->{equipment_id};
    my $stage_no = $pdata->{stage_no};
    my $nc_version = $pdata->{nc_version};
    my $last_nc_version_for_eqid = -1;
    if (exists($last_nc_version_for_eqids{$equipment_id}{$stage_no}))
    {
        $last_nc_version_for_eqid = 
            $last_nc_version_for_eqids{$equipment_id}{$stage_no};
    }
    #
    if (($last_nc_version_for_eqid == $nc_version) &&
        (exists($nc_version_to_master_placement_id{$nc_version}{$stage_no})))
    {
        printf "%04d: For record %d, use existing PPD Data for %s.\n", 
               __LINE__,
               $rec_no,
               $pdata->{mix_name};
        update_panel_placement_header($pdata);
    }
    else
    {
        printf "%04d: For record %d, creating PPD Data for %s.\n", 
               __LINE__,
               $rec_no,
               $pdata->{mix_name};
        if (create_ppd_data($pdata) == FALSE)
        {
            printf "%04d: ERROR: Unable to create PPD Data for %s.\n", 
                   __LINE__,
                   $pdata->{mix_name};
            return;
        }
        else
        {
            $last_nc_version_for_eqids{$equipment_id}{$stage_no} = $nc_version;
        }
    }
}
#
sub process_pph_wo_details_data
{
    my ($praw) = @_;
    #
    my @pph_cols = split(/\t/, shift @{$praw});
    printf "\n%04d: Number of fields in header record: %d\n", 
           __LINE__,
           scalar(@pph_cols) if ($verbose >= MINVERBOSE);
    my $number_of_cols = scalar(@pph_cols);
    #
    for (my $rec_no = 2; scalar(@{$praw}) > 0; $rec_no+=1)
    {
        my $pph_rec = shift @{$praw};
        printf "\n%04d: Processing record: %s\n", 
               __LINE__,
               $pph_rec if ($verbose >= MINVERBOSE);
        #
        my @pph_data = split(/\t/, $pph_rec);
        my %pph = ();
        @pph{@pph_cols} = @pph_data;
        #
        printf "%04d: Number of fields in record: %d\n", 
               __LINE__,
                scalar(keys %pph) if ($verbose >= MINVERBOSE);
        die "number of fields in record != number of header columns"
            unless (scalar(keys %pph) == $number_of_cols);
        #
        process_pph_wo_details_rec($rec_no, \%pph);
    }
    #
    # flush out any remaining sql cmds.
    #
    flush_sql_queue(TRUE);
}
#
##########################################################################
#
# check command line arguments
#
my %opts;
if (getopts('?hwWv:Q:U', \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (keys %opts)
{
    printf "\n%04d: Option: $opt = $opts{$opt}\n", __LINE__;
    #
    if (($opt eq 'h') or ($opt eq '?'))
    {
        usage($cmd);
        exit 0;
    }
    elsif ($opt eq 'U')
    {
        $update_slave_headers = FALSE;
    }
    elsif ($opt eq 'w')
    {
        $verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq 'Q')
    {
        $max_sql_queue_size = $opts{$opt};
        die "Queue size is NOT numeric or less than one." 
            unless ($opts{$opt} =~ m/^[1-9][0-9]*$/);
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
            printf "\n%04d: Invalid verbose level: $opts{$opt}\n", __LINE__;
            usage($cmd);
            exit 2;
        }
    }
}
#
if (scalar(@ARGV) != 1)
{
    printf "\n%04d: ERROR: Incorrect number of arguments!\n",
           __LINE__;
    usage($cmd);
    exit 2;
}
#
$mai_path = $ARGV[0];
#
printf "\n%04d: MAI Path: %s\n", 
       __LINE__,
       $mai_path;
printf "\n%04d: Max SQL Queue Size: %d\n", 
       __LINE__,
       $max_sql_queue_size;
#
# change directory to MAI path. all the input files are there.
#
( -d "$mai_path" ) or
   die "ERROR: $mai_path is NOT a directory or does not exist.";
chdir($mai_path) or 
   die "ERROR: cannot change directory: $!";
#
# write out any scripts we need.
#
write_my_bsql();
#
# get a listing of the MAI files. each file has a timestamp
# attached to the file name to help in determining which MAI
# file to use to generate the PPD data.
#
get_mai_file_list();
#
# read in feeder history data
#
my $feeder_history_sql_out = "feeder_history.sql.out", 
my @feeder_history_data = ();
read_raw_file("Feeder History",
              $feeder_history_sql_out,
             \@feeder_history_data);
process_feeder_history_data(\@feeder_history_data);
#
# read in machine slot to pu data
#
my $machine_slot_to_pu_sql_out = "machine_slot_to_pu.sql.out", 
my @machine_slot_to_pu_data = ();
read_raw_file("Machine Slot to PU",
              $machine_slot_to_pu_sql_out,
             \@machine_slot_to_pu_data);
process_machine_slot_to_pu_data(\@machine_slot_to_pu_data);
#
# read in list of panel placement headers which are missing details records
#
my $pph_wo_details_sql_out = "pph_wo_details.sql.out", 
my @pph_wo_details_data = ();
read_raw_file("PPH WO Details",
              $pph_wo_details_sql_out,
             \@pph_wo_details_data);
#
# process the list of panel placement headers without details. 
#
process_pph_wo_details_data \@pph_wo_details_data;
#
exit 0;
