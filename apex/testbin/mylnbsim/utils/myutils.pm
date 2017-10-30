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
# exit with success
#
1;
