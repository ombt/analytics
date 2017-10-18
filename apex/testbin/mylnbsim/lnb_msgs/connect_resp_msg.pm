# parsing LNB-style XML messages
#
package connect_resp_msg;
#
use strict;
use warnings;
#
use myconstants;
use base_msg;
#
our @ISA = qw(base_msg);
#
sub new
{
    my ($class) = shift;
    my $self = $class->SUPER::new(@_);
    $self->{command_name} = "Connect";
    bless $self, $class;
    return $self;
}
#
sub parse
{
    my ($self) = shift;
    #
    my $status = $self->SUPER::parse(@_);
    return FAIL unless ($status == SUCCESS);
    my $command_name = $self->header("<CommandName>");
    if (defined($command_name) && ($command_name eq $self->{command_name}))
    {
        return SUCCESS;
    }
    else
    {
        return FAIL;
    }
}
#
# exit with success
#
1;
