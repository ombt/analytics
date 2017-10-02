# parsing LNB-style XML messages
#
package base_msg;
#
use strict;
use warnings;
#
use myconstants;
use myxml;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{xml} = undef;
    $self->{logger} = undef;
    $self->{parser} = undef;
    $self->{command_name} = undef;
    #
    if (scalar(@_) == 1)
    {
        $self->{logger} = shift;
        $self->{parser} = myxml->new($self->{logger});
    }
    elsif (scalar(@_) == 2)
    {
        $self->{xml} = shift;
        $self->{logger} = shift;
        $self->{parser} = myxml->new($self->{xml}, $self->{logger});
    }
    else
    {
        $self->{parser} = myxml->new();
    }
    #
    bless $self, $class;
    #
    return($self);
}
#
sub parse
{
    my $self = shift;
    #
    $self->{xml} = shift if @_;
    #
    if ($self->{parser}->parse($self->{xml}) == SUCCESS)
    {
        $self->{command_name} = $self->command_name();
        return SUCCESS;
    }
    else
    {
        $self->{command_name} = undef;
        return FAIL;
    }
}
#
sub deparse
{
    my $self = shift;
    #
    return $self->{parser}->deparse();
}
#
sub xml
{
    my $self = shift;
    #
    return $self->{parser}->{xml};
}
#
sub logger
{
    my $self = shift;
    #
    return $self->{parser}->{logger};
}
#
sub booklist
{
    my $self = shift;
    #
    return $self->{parser}->booklist();
}
#
sub find
{
    my $self = shift;
    #
    return $self->{parser}->names_to_value(@_);
}
#
sub header
{
    my $self = shift;
    if (scalar(@_) > 0)
    {
        return $self->{parser}->names_to_value("<Header>", @_);
    }
    else
    {
        return $self->{parser}->names_to_value("<Header>");
    }
}
#
sub command_name
{
    my $self = shift;
    return $self->{parser}->names_to_value("<Header>", "<CommandName>");
}
#
sub response_xml
{
    my $self = shift;
    #
    my $result_code = 0;
    $result_code = shift if (scalar(@_));
    #
    my $system_name = 
           $self->{parser}->names_to_value("<Header>", "<SystemName>");
    my $command_name = 
           $self->{parser}->names_to_value("<Header>", "<CommandName>");
    my $connect_option = 
           $self->{parser}->names_to_value("<Header>", "<ConnectOption>");
    my $system_version = 
           $self->{parser}->names_to_value("<Header>", "<SystemVersion>");
    my $session_id = 
           $self->{parser}->names_to_value("<Header>", "<SessionId>");
    #
    my $root = '<?xml version="1.0" encoding="UTF-8"?><root><Header>';
    $root .= '<CommandName>' . "$command_name" . '</CommandName>';
    $root .= '<ConnectOption>' . "$connect_option" . '</ConnectOption>';
    $root .= '<ResultCode>' . "$result_code" . '</ResultCode>';
    $root .= '<SessionId>' . "$session_id" . '</SessionId>';
    $root .= '<SystemName>' . "$system_name" . '</SystemName>';
    $root .= '<SystemVersion>' . "$system_version" . '</SystemVersion></Header>';
    $root .= '</SystemVersion></Header></root>';
    #
    return $root;
}
#
# exit with success
#
1;
