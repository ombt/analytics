# timer class
package mytimer;
#
sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	#
	my ($phandler, $expire, $id, $label) = @_;
	#
	$self = {};
	$self->{handler} = $phandler;
	$self->{expire} = $expire;
	$self->{id} = $id;
	$self->{label} = $label;
	$self->{heap} = 0;
	#
	bless $self, $class;
	#
	return($self);
}
#
sub cmp {
	my ($self, $other) = @_;
	my $dexp = $self->{expire} - $other->{expire};
	if ($dexp != 0) {
		return($dexp);
	} else {
		return($self->{id} - $other->{id});
	}
}
#
sub heap {
	my $self = shift;
	$self->{heap} = shift if @_;
	return($self->{heap});
}
#
sub rw_handler {
	my $self = shift;
	$self->{handler} = shift if @_;
	return($self->{handler});
}
sub rw_id {
	my $self = shift;
	$self->{id} = shift if @_;
	return($self->{id});
}
sub rw_expire {
	my $self = shift;
	$self->{expire} = shift if @_;
	return($self->{expire});
}
sub rw_label {
	my $self = shift;
	$self->{label} = shift if @_;
	return($self->{label});
}
#
sub dump {
	my $self = shift;
	my $class = ref($self);
	#
	print STDERR "\n";
	print STDERR "ref class = $class\n";
	print STDERR "handler = ".$self->{handler}."\n";
	print STDERR "expire = ".$self->{expire}."\n";
	print STDERR "id = ".$self->{id}."\n";
	print STDERR "label = ".$self->{label}."\n";
	print STDERR "heap = ".$self->{heap}."\n";
}
# exit with success
1;
