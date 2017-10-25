# general utility functions
#
package mymaihparser;
#
use strict;
use warnings;
#
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
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $self->{logger}->log_vmin("Number of Columns: %d\n", $number_columns);
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
    $self->{logger}->log_vmin("Number of key-value pairs: %d\n", 
                    scalar(@{$pprod_db->{DATA}->{$section}}));
    $self->{logger}->log_vmin("Lines read: %d\n", ($$pirec - $start_irec));
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
    my $number_columns = scalar(@{$pprod_db->{COLUMN_NAMES}->{$section}});
    #
    $self->{logger}->log_vmin("Number of Columns: %d\n", $number_columns);
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
    $self->{logger}->log_vmin("Processing product data: %s\n", $prod_file);
    #
    my $max_rec = scalar(@{$praw_data});
    my $sec_no = 0;
    #
    for (my $irec=0; $irec<$max_rec; )
    {
        my $rec = $praw_data->[$irec];
        #
        $self->{logger}->log_vmin("Record %04d: <%s>\n", $irec, $rec);
        #
        if ($rec =~ m/^(\[[^\]]*\])/)
        {
            my $section = ${1};
            #
            $self->{logger}->log_vmin("Section %03d: %s\n", ++$sec_no, $section);
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
# exit with success
#
1;

