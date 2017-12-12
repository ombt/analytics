# general utility functions
#
package mymaihparser;
#
use strict;
use warnings;
#
use DateTime;
use File::Basename;
use FileHandle;
use base qw( Exporter );
#
use myconstants;
#
our @EXPORT = qw (
    SECTION_UNKNOWN
    SECTION_NAME_VALUE
    SECTION_LIST
);
#
# section types
#
use constant SECTION_UNKNOWN => 0;
use constant SECTION_NAME_VALUE => 1;
use constant SECTION_LIST => 2;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{logger} = shift @_;
    #
    $self->{delimiter} = "\t";
    $self->{delimiter} = shift @_ if (@_);
    #
    bless $self, $class;
    #
    return($self);
}
#
sub delimiter {
    my $self = shift;
    $self->{delimiter} = shift @_ if (@_);
    return($self->{delimiter});
}
#
# load name-value or list section
#
sub load_name_value
{
    my $self = shift;
    my $delimiter = $self->{delimiter};
    #
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
    $self->{logger}->log_vmax("<%s>\n", join("\n", @{$pprod_db->{DATA}->{$section}}));
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        $self->{logger}->log_msg("NO NAME-VALUE DATA FOUND IN SECTION %s. Lines read: %d\n", 
                       $section, ($$pirec - $start_irec));
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = "NAME${delimiter}VALUE";
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split /${delimiter}/, $pprod_db->{HEADER}->{$section};
    #
    # precede each column name with an underscore to prevent clashes
    # with postgresql key words or aliases.
    #
    s/^(.*)$/_$1/ for @{$pprod_db->{COLUMN_NAMES}->{$section}};
    #
    # add filename-id to headers.
    #
    @{$pprod_db->{COLUMN_NAMES_WITH_FID}->{$section}} = 
        @{$pprod_db->{COLUMN_NAMES}->{$section}};
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID}->{$section}}, '_filename_id';
    #
    @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}} = 
        @{$pprod_db->{COLUMN_NAMES}->{$section}};
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}}, '_lot_number';
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}}, '_filename_id';
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $self->{logger}->log_vmid("Number of Columns: %d\n", $number_columns);
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
        my @tokens = $self->split_quoted_string($record, "${delimiter}");
        my $number_tokens = scalar(@tokens);
        #
        $self->{logger}->log_vmax("Number of tokens in record: %d\n", $number_tokens );
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
            $self->{logger}->log_err("Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $section, $number_tokens, $number_columns);
        }
    }
    $self->{logger}->log_vmid("Number of key-value pairs: %d\n", 
                    scalar(@{$pprod_db->{DATA}->{$section}}));
    $self->{logger}->log_vmid("Lines read: %d\n", ($$pirec - $start_irec));
    #
    return SUCCESS;
}
#
sub split_quoted_string
{
    my $self = shift;
    my $delimiter = $self->{delimiter};
    #
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
    my $self = shift;
    my $delimiter = $self->{delimiter};
    #
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
    $self->{logger}->log_vmax("<%s>\n", join("\n", @{$pprod_db->{DATA}->{$section}}));
    #
    if (scalar(@{$pprod_db->{DATA}->{$section}}) <= 0)
    {
        $self->{logger}->log_msg("NO LIST DATA FOUND IN SECTION %s. Lines read: %d\n", $section, ($$pirec - $start_irec));
        return SUCCESS;
    }
    #
    $pprod_db->{HEADER}->{$section} = 
        shift @{$pprod_db->{DATA}->{$section}};
    #
    @{$pprod_db->{COLUMN_NAMES}->{$section}} = 
        split / /, $pprod_db->{HEADER}->{$section};
    #
    # precede each column name with an underscore to prevent clashes
    # with postgresql key words or aliases.
    #
    s/^(.*)$/_$1/ for @{$pprod_db->{COLUMN_NAMES}->{$section}};
    #
    # add filename-id to headers.
    #
    @{$pprod_db->{COLUMN_NAMES_WITH_FID}->{$section}} = 
        @{$pprod_db->{COLUMN_NAMES}->{$section}};
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID}->{$section}}, '_filename_id';
    @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}} = 
        @{$pprod_db->{COLUMN_NAMES}->{$section}};
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}}, '_lot_number';
    unshift @{$pprod_db->{COLUMN_NAMES_WITH_FID_AND_LOT}->{$section}}, '_filename_id';
    #
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $self->{logger}->log_vmid("Number of Columns: %d\n", $number_columns);
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
        my @tokens = $self->split_quoted_string($record, ' ');
        my $number_tokens = scalar(@tokens);
        #
        $self->{logger}->log_vmax("Number of tokens in record: %d\n", $number_tokens );
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
            $self->{logger}->log_err("Section: %s, SKIPPING RECORD - NUMBER TOKENS (%d) != NUMBER COLUMNS (%d)\n", $section, $number_tokens, $number_columns);
        }
    }
    #
    return SUCCESS;
}
#
sub process_data
{
    my $self = shift;
    my ($prod_file, $praw_data, $pprod_db) = @_;
    #
    $self->{logger}->log_vmid("Processing product data: %s\n", $prod_file);
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        $self->{logger}->log_vmid("Record %04d: <%s>\n", $irec, $rec);
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            $self->{logger}->log_vmid("Section %03d: %s\n", ++$sec_no, $section);
            #
            $rec = $praw_data->[${irec}+1];
            #
            if ($rec =~ m/^\s*$/)
            {
                $irec += 2;
                $self->{logger}->log_msg("Empty section - %s\n", $section);
            }
            elsif ($rec =~ m/.*=.*/)
            {
                $self->load_name_value($praw_data, 
                                       $section, 
                                      \$irec, 
                                       $max_rec,
                                       $pprod_db);
            }
            else
            {
                $self->load_list($praw_data, 
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
sub parse_with_ext
{
    my $self = shift;
    my ($fname, $time_zone, $ext, $ptstamp, $pparts) = @_;
    #
    $self->{logger}->log_vmid("File Name (ext=%s): %s\n", $ext, $fname);
    #
    @{$pparts} = undef;
    #
    if (($ext =~ m/^u01$/i) ||
        ($ext =~ m/^u03$/i) ||
        ($ext =~ m/^mpr$/i))
    {
        my ($delimiter_count) = scalar( @{ [ $fname =~ /\+\-\+/gi ] } );
        #
        if ($delimiter_count > 0)
        {
            my @tokens = split /\+\-\+/, $fname;
            #
            if (scalar(@tokens) != 9)
            {
                $self->{logger}->log_err("Incorrect number of file tokens for file: %s\n", $fname);
                return FAIL;
            }
            #
            my $date = shift @tokens;
            my $machine_order = shift @tokens;
            my $stage_no = shift @tokens;
            my $lane_no = shift @tokens;
            my $pcb_serial = shift @tokens;
            my $pcb_id = shift @tokens;
            my $output_no = shift @tokens;
            my $pcb_id_lot_no = shift @tokens;
            my $pcb_id_serial_no = shift @tokens;
            #
            $date =~ m/^(....)(..)(..)(..)(..)(..).*$/;
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
            $self->{logger}->log_vmid("date: %s\nmachine order: %s\nstage: %s\nlane: %s\npcb serial: %s\npcb id: %s\noutput no: %s\npcb id lot no: %s\npcb id serial no: %s\n", 
                $date,
                $machine_order,
                $stage_no,
                $lane_no,
                $pcb_serial,
                $pcb_id,
                $output_no,
                $pcb_id_lot_no,
                $pcb_id_serial_no);
            #
            my $idx = -1;
            #
            $pparts->[++$idx] = $date;
            $pparts->[++$idx] = $machine_order;
            $pparts->[++$idx] = $stage_no;
            $pparts->[++$idx] = $lane_no;
            $pparts->[++$idx] = $pcb_serial;
            $pparts->[++$idx] = $pcb_id;
            $pparts->[++$idx] = $output_no;
            $pparts->[++$idx] = $pcb_id_lot_no;
            $pparts->[++$idx] = $pcb_id_serial_no;
        }
        else
        {
            my @tokens = split /-/, $fname;
            if (scalar(@tokens) < 9)
            {
                $self->{logger}->log_err("Incorrect number of file tokens for file: %s\n", $fname);
                return FAIL;
            }
            #
            my $date = shift @tokens;
            my $machine_order = shift @tokens;
            my $stage_no = shift @tokens;
            my $lane_no = shift @tokens;
            my $pcb_serial = shift @tokens;
            #
            # PCB ID can contain dashes, so we have to kludge
            # along now.
            #
            my $pcb_id_serial_no = pop @tokens;
            my $pcb_id_lot_no = pop @tokens;
            my $output_no = pop @tokens;
            #
            my $pcb_id = join("-", @tokens);
            #
            $date =~ m/^(....)(..)(..)(..)(..)(..).*$/;
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
            $self->{logger}->log_vmid("date: %s\nmachine order: %s\nstage: %s\nlane: %s\npcb serial: %s\npcb id: %s\noutput no: %s\npcb id lot no: %s\npcb id serial no: %s\n", 
                $date,
                $machine_order,
                $stage_no,
                $lane_no,
                $pcb_serial,
                $pcb_id,
                $output_no,
                $pcb_id_lot_no,
                $pcb_id_serial_no);
            #
            my $idx = -1;
            #
            $pparts->[++$idx] = $date;
            $pparts->[++$idx] = $machine_order;
            $pparts->[++$idx] = $stage_no;
            $pparts->[++$idx] = $lane_no;
            $pparts->[++$idx] = $pcb_serial;
            $pparts->[++$idx] = $pcb_id;
            $pparts->[++$idx] = $output_no;
            $pparts->[++$idx] = $pcb_id_lot_no;
            $pparts->[++$idx] = $pcb_id_serial_no;
        }
    }
    elsif ($ext =~ m/^crb$/i) 
    {
        my @tokens = split /_/, $fname;
        if (scalar(@tokens) < 3)
        {
            $self->{logger}->log_err("Incorrect number of file tokens for file: %s\n", $fname);
            return FAIL;
        }
        #
        my $history_id = shift @tokens;
        my $time_stamp = shift @tokens;
        my $crb_file_name = join("_", @tokens);
        my $product_name = $crb_file_name;
        #
        $product_name =~ s/.crb$//i;
        #
        ${$ptstamp} = $time_stamp;
        #
        $self->{logger}->log_vmid("history id: %s\ntime stamp: %s\ncrb file name: %s\nproduct name: %s\n",
                                  $history_id,
                                  $time_stamp,
                                  $crb_file_name,
                                  $product_name);
        #
        my $idx = -1;
        #
        $pparts->[++$idx] = $history_id;
        $pparts->[++$idx] = $time_stamp;
        $pparts->[++$idx] = $crb_file_name;
        $pparts->[++$idx] = $product_name;
    }
    elsif ($ext =~ m/^rst$/i) 
    {
        my @tokens = split /&/, $fname;
        if (scalar(@tokens) < 6)
        {
            $self->{logger}->log_err("Incorrect number of file tokens for file: %s\n", $fname);
            return FAIL;
        }
        #
        my $machine = shift @tokens;
        my $lane = shift @tokens;
        my $date_time = shift @tokens;
        my $serial_number = shift @tokens;
        #
        my $inspection_result = shift @tokens;
        if ($inspection_result == 1)
        {
            $inspection_result = "OK";
        }
        elsif ($inspection_result == 2)
        {
            $inspection_result = "NG";
        }
        else
        {
            $inspection_result = "NA";
        }
        #
        my $board_removed = shift @tokens;
        if ($board_removed == 1)
        {
            $board_removed = "YES";
        }
        else
        {
            $board_removed = "NO";
        }
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
        $self->{logger}->log_vmid("machine: %s\nlane: %s\ndate time: %s\nserial number: %s\ninspection result: %s\nboard removed: %s\n",
                $machine,
            $lane,
            $date_time,
            $serial_number,
            $inspection_result,
            $board_removed);
        #
        my $idx = -1;
        #
        $pparts->[++$idx] = $machine;
        $pparts->[++$idx] = $lane;
        $pparts->[++$idx] = $date_time;
        $pparts->[++$idx] = $serial_number;
        $pparts->[++$idx] = $inspection_result;
        $pparts->[++$idx] = $board_removed;
    }
    else
    {
        $self->{logger}->log_err("Unknown ext %s for %s\n", $ext, $fname);
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub parse_without_ext
{
    my $self = shift;
    my ($fname, $time_zone, $ptstamp, $pparts) = @_;
    #
    $self->{logger}->log_vmid("File Name (ext=none): %s\n", $fname);
    #
    @{$pparts} = undef;
    #
    my $idx = -1;
    #
    ${$ptstamp} = time();
    $pparts->[++$idx] = $fname;
    #
    return SUCCESS;
}
#
sub parse_filename
{
    my $self = shift;
    #
    my $fpath = shift;
    my $pext = shift;
    my $ptstamp = shift;
    my $pparts = shift;
    #
    my $time_zone = "America/Chicago";
    $time_zone = shift @_ if (@_);
    #
    $self->{logger}->log_vmid("Parsing File Path: %s\n", $fpath);
    #
    my $fname = basename($fpath);
    #
    if ($fname =~ m/\.([^\.]+)$/)
    {
        ${$pext} = ${1};
        #
        $fname =~ s/\.${$pext}$//;
        #
        return $self->parse_with_ext($fname, $time_zone, ${$pext}, $ptstamp, $pparts);
    }
    else
    {
        ${$pext} = "";
        return $self->parse_without_ext($fname, $time_zone, $ptstamp, $pparts);
    }
}
#
# exit with success
#
1;

