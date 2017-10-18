# parsing LNB-style XML messages
#
package mylnbxml;
#
use myconstants;
#
sub new
{
    my $class = shift;
    my $self = {};
    #
    $self->{booklist} = undef;
    $self->{xml} = undef;
    $self->{deparse_xml} = undef;
    $self->{logger} = undef;
    $self->{errors} = 0;
    #
    # $self->{xml} = shift if @_;
    # $self->{logger} = shift if @_;
    #
    if (scalar(@_) == 1)
    {
        $self->{logger} = shift;
    }
    elsif (scalar(@_) == 2)
    {
        $self->{xml} = shift;
        $self->{logger} = shift;
    }
    #
    bless $self, $class;
    #
    return($self);
}
#
sub xml
{
    my $self = shift;
    #
    if (@_)
    {
        $self->{xml} = shift;
        $self->{booklist} = undef;
        $self->{deparse_xml} = undef;
        $self->{errors} = 0;
    }
    #
    return($self->{xml});
}
#
sub booklist
{
    my $self = shift;
    #
    return($self->{booklist});
}
#
#
sub errors
{
    my $self = shift;
    #
    return($self->{errors});
}
#
sub accept_token
{
    my $self = shift;
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                $self->accept_token($ptokens, $pidx, __LINE__);
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                $self->element_xml($ptokens, 
                                   $pidx, 
                                   $maxtoken, 
                                   $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            $self->accept_token($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if ($self->is_end_tag($tag_name, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $self->accept_token($ptokens, $pidx, __LINE__);
        $self->element_xml($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
    }
    #
    return($proot);
}
#
sub parse_xml
{
    my $self = shift;
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    $self->start_xml(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
#
sub parse
{
    my $self = shift;
    #
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        $self->{booklist} = $self->parse_xml($self->{xml});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
        }
    }
    #
    return($self->{booklist});
}
#
sub accept_token_2
{
    my $self = shift;
    my ($ptokens, $pidx, $lnno) = @_;
    #
    $$pidx += 1;
}
#
sub is_end_tag_2
{
    my $self = shift;
    my ($start_tag, $token) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    if ($token eq $end_tag)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub element_xml_2
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (($$pidx < $maxtoken) && ($done == FALSE))
    {
        my $token = $ptokens->[$$pidx];
        #
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                push @{$proot}, {
                    NAME       => $token,
                    VALUE      => undef,
                    ATTRIBUTES => [],
                    SIBLINGS   => []
                };
                $self->accept_token_2($ptokens, $pidx, __LINE__);
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                $self->element_xml_2($ptokens, 
                                     $pidx, 
                                     $maxtoken, 
                                     $proot);
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            push @{$proot}, {
                NAME       => $tag_name,
                VALUE      => $tag_value,
                ATTRIBUTES => [],
                SIBLINGS   => []
            };
            $self->accept_token_2($ptokens, $pidx, __LINE__);
            $token = $ptokens->[$$pidx];
            if ($self->is_end_tag_2($tag_name, $token) == TRUE)
            {
                $self->accept_token_2($ptokens, $pidx, __LINE__);
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token_2($ptokens, $pidx, __LINE__);
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token_2($ptokens, $pidx, __LINE__);
                $done = TRUE;
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token_2($ptokens, $pidx, __LINE__);
        }
    }
}
#
sub start_xml_2
{
    my $self = shift;
    my ($ptokens, $pidx, $maxtoken, $proot) = @_;
    #
    my $token = $ptokens->[$$pidx];
    if ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/)
    {
        $self->accept_token_2($ptokens, $pidx, __LINE__);
        $self->element_xml_2($ptokens, $pidx, $maxtoken, $proot);
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
    }
    #
    return($proot);
}
#
sub parse_xml_2
{
    my $self = shift;
    my ($xml_rec) = @_;
    #
    my $idx = 0;
    my @tokens = map { s/^/</; $_; } 
                 grep { ! /^\s*$/ } 
                 split("<", $xml_rec);
    my $proot = [ ];
    #
    $self->start_xml_2(\@tokens, \$idx, scalar(@tokens), $proot);
    #
    return($proot);
}
sub parse_2
{
    my $self = shift;
    #
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        $self->{booklist} = $self->parse_xml_2($self->{xml});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
        }
    }
    #
    return($self->{booklist});
}
#
sub end_tag
{
    my $self = shift;
    my ($start_tag) = @_;
    #
    my $end_tag = $start_tag;
    $end_tag =~ s?^<?</?;
    #
    return($end_tag);
}
#
sub deparse_start_xml
{
    my $self = shift;
    my ($ptree, $pxstr) = @_;
    #
    if (ref($ptree) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$ptree}); ++$i)
        {
            my $name = $ptree->[$i]->{NAME};
            #
            if (scalar(@{$ptree->[$i]->{SIBLINGS}}) > 0)
            {
                $$pxstr .= $name;
                $self->deparse_start_xml($ptree->[$i]->{SIBLINGS}, $pxstr);
                $$pxstr .= $self->end_tag($name);
            }
            elsif (defined($ptree->[$i]->{VALUE}))
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $value . $self->end_tag($name);
            }
            else
            {
                my $value = $ptree->[$i]->{VALUE};
                $$pxstr .= $name . $self->end_tag($name);
            }
        }
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("EXPECTING ARRAY REF: <%s>\n", ref($ptree));
    }
}
#
sub deparse_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml_string = '<?xml version="1.0" encoding="UTF-8"?>';
    $self->deparse_start_xml($ptree, \$xml_string);
    #
    return($xml_string);
}
#
sub deparse
{
    my $self = shift;
    #
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{booklist}))
    {
        $self->{errors} = 0;
        $self->{deparse_xml} = $self->deparse_xml($self->{booklist});
        if ($self->{errors} > 0)
        {
            $self->{logger}->log_err("Deparse failed.\n");
            $self->{deparse_xml} = undef;
        }
    }
    #
    return($self->{deparse_xml});
}
#
sub to_xml
{
    my $self = shift;
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "<$last_element>" if ($i > 0);
            $self->to_xml($ptree->[$i], $pxml, $last_element);
            $$pxml .= "</$last_element>" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            $$pxml .= "<$element>";
            $self->to_xml($ptree->{$element}, $pxml, $element);
            $$pxml .= "</$element>";
        }
    }
    else
    {
        $$pxml .= "$ptree";
    }
}
#
sub msg_to_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml = '<?xml version="1.0" encoding="UTF-8"?>';
    my $last_element = "";
    $self->to_xml($ptree, \$xml, $last_element);
    #
    $self->{xml} = $xml;
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    $self->{errors} = 0;
    #
    return $xml;
}
#
# exit with success
#
1;
