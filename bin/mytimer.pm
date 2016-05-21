# timer class
#
package mytimer;
#
sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	#
	my ($fileno, $delta, $id, $label) = @_;
	#
	$self = {};
	$self->{fileno} = $fileno;
	$self->{delta} = $delta;
	$self->{expire} = time() + $delta;
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
sub rw_fileno {
	my $self = shift;
	$self->{fileno} = shift if @_;
	return($self->{fileno});
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
	print STDERR "fileno = ".$self->{fileno}."\n";
	print STDERR "delta = ".$self->{delta}."\n";
	print STDERR "expire = ".$self->{expire}."\n";
	print STDERR "id = ".$self->{id}."\n";
	print STDERR "label = ".$self->{label}."\n";
	print STDERR "heap = ".$self->{heap}."\n";
}
# exit with success
1;
