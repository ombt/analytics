# general utility functions
#
package myutils;
#
use strict;
use warnings;
#
use myconstants;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{logger} = undef;
    $self->{logger} = shift if @_;
    #
    bless $self, $class;
    #
    return($self);
}
#
sub read_file
{
    my $self = shift;
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        $self->{logger}->log_err("File %s is NOT readable\n", $file_nm);
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        $self->{logger}->log_err("Unable to open %s.\n", $file_nm);
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from windows.
    #
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    $self->{logger}->log_vmid("Lines read: %d\n", scalar(@{$praw_data}));
    #
    return SUCCESS;
}
#
sub is_integer
{
    my $self = shift;
    if (defined($_[0]) && ($_[0] =~ /^[+-]?\d+$/))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub is_positive_integer
{
    my $self = shift;
    if (defined($_[0]) && ($_[0] =~ /^[+]?\d+$/))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub is_valid_menu_option
{
    my $self = shift;
    #
    my $min = shift;
    return FALSE unless (defined($min));
    my $idx = shift;
    return FALSE unless (defined($idx));
    my $max = shift;
    return FALSE unless (defined($max));
    #
    if (($self->is_positive_integer($idx) == TRUE) &&
        ($min <= $idx) && ($idx < $max))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
#
sub is_float
{
    my $self = shift;
    if (defined($_[0]) && ($_[0] =~ /^[+-]?\d+(\.\d+)?$/))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
# following function is from here:
#
# http://billauer.co.il/blog/2011/05/perl-crc32-crc-xs-module/
#
# but modified so it can be called from this mod.
#
our @lookup_table = ();
our $init_lookup_table = TRUE;
#
sub crc32
{
    my $self = shift;
    #
    my $input = shift @_;
    #
    my $init_value = 0;
    $init_value = shift @_ if @_;
    #
    my $polynomial = 0xedb88320;
    $polynomial = shift @_ if @_;
    #
    if ($init_lookup_table == TRUE)
    {
        for (my $i=0; $i<256; $i++)
        {
            my $x = $i;
            for (my $j=0; $j<8; $j++)
            {
                if ($x & 1)
                {
                    $x = ($x >> 1) ^ $polynomial;
                }
                else
                {
                    $x = $x >> 1;
                }
            }
            push @lookup_table, $x;
        }
        $init_lookup_table = FALSE;
    }
    #
    my $crc = $init_value ^ 0xffffffff;
    #
    foreach my $x (unpack ('C*', $input))
    {
        $crc = (($crc >> 8) & 0xffffff) ^ $lookup_table[ ($crc ^ $x) & 0xff ];
    }
    #
    $crc = $crc ^ 0xffffffff;
    #
    return $crc;
}
#
# exit with success
#
1;
