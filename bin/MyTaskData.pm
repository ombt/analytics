#
# task-specific data
#
package MyTaskData;
#
use MyConstants;
#
# create a data object for given key
#
sub new
{
    my $self = shift;
    my $class = ref($self) || $self;
    #
    $self = {};
    $self->{data} = {};
    #
    if (scalar(@_) > 0)
    {
        my $id = shift;
        $self->{data}->{$id} = { id => $id };
    }
    #
    bless $self, $class;
    #
    return($self);
}
#
sub iterator
{
    my $self = shift;
    #
    my $pdata = $self->{data};
    my @keys = keys %{${pdata}};
    #
    my $max = scalar(@keys);
    my $idx = -1;
    #
    return sub {
        return undef if (++$idx >= $max);
        #
        return $pdata->{$keys[$idx]};
    };
}
#
sub clear
{
    my $self = shift;
    $self->{data} = {};
}
#
sub data
{
    my $self = shift;
    return $self->{data};
}
#
sub get
{
    my $self = shift;
    my $id = shift;
    my $key = shift;
    #
    if (exists($self->{data}->{$id}->{$key}))
    {
        return $self->{data}->{$id}->{$key};
    }
    else
    {
        return undef;
    }
}
#
sub set
{
    my $self = shift;
    my $id = shift;
    my $key = shift;
    my $value = shift;
    #
    $self->{data}->{$id}->{$key} = $value;
    return $self->{$id}->{$key};
}
#
sub exists
{
    my $self = shift;
    my $id = shift;
    my $key = shift;
    #
    # trying to avoid autovivification. have to check each 
    # level before the next level.
    #
    if ((defined($id)) && 
        (defined($key)) &&
        (exists($self->{data}->{$id})) &&
        (exists($self->{data}->{$id}->{$key})))
    {
        return TRUE;
    }
    elsif ((defined($id)) &&
           (exists($self->{data}->{$id})))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub allocate
{
    my $self = shift;
    my $id = shift;
    #
    delete $self->{data}->{$id} if (exists($self->{data}->{$id}));
    $self->{data}->{$id} = { id => $id };
}
#
sub deallocate
{
    my $self = shift;
    my $id = shift;
    #
    delete $self->{data}->{$id} if (exists($self->{data}->{$id}));
}
#
sub reallocate
{
    my $self = shift;
    my $id = shift;
    #
    delete $self->{data}->{$id} if (exists($self->{data}->{$id}));
    $self->{data}->{$id} = { id => $id };
}
#
# exit with success
#
1;
