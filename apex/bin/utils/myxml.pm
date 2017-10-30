# parsing XML messages
#
package myxml;
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
    $self->{booklist} = undef;
    $self->{xml} = undef;
    $self->{deparse_xml} = undef;
    $self->{logger} = undef;
    $self->{errors} = 0;
    $self->{tokenizer} = { };
    $self->{use_new_parser} = TRUE();
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
    elsif (scalar(@_) == 3)
    {
        $self->{xml} = shift;
        $self->{logger} = shift;
        $self->{use_new_parser} = shift;
    }
    #
    bless $self, $class;
    #
    return($self);
}
#
sub booklist
{
    my $self = shift;
    #
    return $self->{booklist};
}
#
sub init_tokenizer
{
    my $self = shift;
    #
    $self->{tokenizer} = { };
    #
    my $pxml = undef;
    $pxml = shift if (@_);
    #
    if ((defined($pxml)) && (ref($pxml) eq 'ARRAY'))
    {
        $self->{tokenizer}->{xml} = [];
        @{$self->{tokenizer}->{xml}} = map { s/>[	 ]*$/>/; $_; } 
                                       map { s/^[	 ]*/</; $_; } 
                                       grep { ! /^\s*$/ } 
                                       split("<", join('', @{$pxml}));
        $self->{tokenizer}->{max_idx} = scalar(@{$self->{tokenizer}->{xml}});
        $self->{tokenizer}->{idx} = 0;
        #
        return SUCCESS;
    }
    elsif (defined($pxml) && (length($pxml) > 0))
    {
        @{$self->{tokenizer}->{xml}} = map { s/^[	 ]*/</; $_; } 
                                       grep { ! /^\s*$/ } 
                                       split("<", $pxml);
        $self->{tokenizer}->{max_idx} = scalar(@{$self->{tokenizer}->{xml}});
        $self->{tokenizer}->{idx} = 0;
        return SUCCESS;
    }
    else
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("XML buffer is NOT an array reference.\n");
        return FAIL;
    }
}
#
sub reset_tokenizer
{
    my $self = shift;
    #
    $self->{tokenizer}->{idx} = 0;
    #
    return SUCCESS;
}
#
sub accept_token
{
    my $self = shift;
    #
    $self->{tokenizer}->{idx} += 1;
}
#
sub current_token
{
    my $self = shift;
    #
    if ($self->{tokenizer}->{idx} < $self->{tokenizer}->{max_idx})
    {
        return $self->{tokenizer}->{xml}->[$self->{tokenizer}->{idx}];
    }
    else
    {
        return undef;
    }
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
    #
    my ($proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    #
    while (defined(my $token = $self->current_token()) && ($done == FALSE))
    {
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
                $self->accept_token();
                #
                $proot = $proot->[-1]->{SIBLINGS};
            }
            else
            {
                $self->element_xml($proot);
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
            $self->accept_token();
            if (defined($token = $self->current_token()) &&
                ($self->is_end_tag($tag_name, $token) == TRUE))
            {
                $self->accept_token();
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token();
                return FAIL;
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token();
                $done = TRUE;
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
                $self->accept_token();
                return FAIL;
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token();
        }
    }
    #
    return SUCCESS;
}
#
sub new_element_xml
{
    my $self = shift;
    #
    my ($proot) = @_;
    #
    my $done = FALSE;
    my $first_start_tag = "";
    my $initial_proot = $proot;
    #
    while (defined(my $token = $self->current_token()) && ($done == FALSE))
    {
        if ($token =~ m/^<[^\/>]+>$/)
        {
            # a start tag alone
            if ($first_start_tag eq "")
            {
                $first_start_tag = $token;
                #
                $initial_proot = $proot;
                $$proot->{$token} = undef;
                $proot = \$$proot->{$token};
                $self->accept_token();
            }
            elsif ($first_start_tag eq $token)
            {
                # we have an array
                if (ref($$initial_proot->{$token}) eq 'ARRAY')
                {
                    # more than two elements in the array
                    push @{$$initial_proot->{$token}}, undef;
                    $proot = \$$initial_proot->{$token}->[-1];
                }
                else
                {
                    # second element. need to convert hash to an array
                    my $save_proot_contents = $$proot;
                    $$initial_proot->{$token} = undef;
                    $$initial_proot->{$token} = [ ];
                    push @{$$initial_proot->{$token}}, $save_proot_contents;
                    push @{$$initial_proot->{$token}}, undef;
                    $proot = \$$initial_proot->{$token}->[-1];
                };
                $self->accept_token();
                if ($self->new_element_xml($proot) != SUCCESS)
                {
                    $self->{errors} += 1;
                    $self->{logger}->log_err("new element xml failed.\n");
                    return FAIL;
                }
            }
            else
            {
                $$proot->{$token} = undef;
                if ($self->new_element_xml($proot) != SUCCESS)
                {
                    $self->{errors} += 1;
                    $self->{logger}->log_err("new element xml failed.\n");
                    return FAIL;
                }
            }
        }
        elsif ($token =~ m/^(<[^\/>]+>)(.+)$/)
        {
            # a start tag with a value
            my $tag_name = $1;
            my $tag_value = $2;
            #
            $$proot->{$tag_name} = $tag_value;
            $self->accept_token();
            #
            if (defined($token = $self->current_token()) &&
                ($self->is_end_tag($tag_name, $token) == TRUE))
            {
                $self->accept_token();
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("MISSING END TAG : <%s,%s>\n", 
                                         $tag_name, $token);
                $self->accept_token();
                return FAIL;
            }
        }
        elsif ($token =~ m/^<\/[^>]+>$/)
        {
            if ($first_start_tag eq "")
            {
                $done = TRUE;
            }
            elsif ($self->is_end_tag($first_start_tag, $token) == TRUE)
            {
                $self->accept_token();
                my $look_ahead = $self->current_token();
                if ((! defined($look_ahead)) ||
                    ($first_start_tag eq "") ||
                    ($look_ahead ne $first_start_tag))
                {
                    $done = TRUE;
                }
            }
            else
            {
                $self->{errors} += 1;
                $self->{logger}->log_err("UNEXPECTED END TAG : <%s>\n", $token);
                $self->accept_token();
                return FAIL;
            }
        }
        else
        {
            $self->{errors} += 1;
            $self->{logger}->log_err("UNEXPECTED TOKEN : <%s>\n", $token);
            $self->accept_token();
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub parse_xml
{
    my $self = shift;
    #
    my ($pxml) = @_;
    #
    if ($self->init_tokenizer($pxml) != SUCCESS)
    {
        $self->{errors} += 1;
        $self->{logger}->log_err("Initializing parser failed.\n");
        return FAIL;
    }
    #
    my $token = $self->current_token();
    if (defined($token) &&
        ($token =~ m/<.xml\s+version="1.0"\s+encoding="UTF-8".>/))
    {
        my $status = undef;
        $self->accept_token();
        if ($self->{use_new_parser} == TRUE)
        {
            $self->{booklist} = undef;
            $status = $self->new_element_xml(\$self->{booklist});
        }
        else
        {
            $self->{booklist} = [];
            $status = $self->element_xml($self->{booklist});
        }
        #
        if ($status != SUCCESS)
        {
            $self->{booklist} = undef;
            $self->{errors} += 1;
            return FAIL;
        }
        #
        return SUCCESS;
    }
    else
    {
        $self->{booklist} = undef;
        $self->{errors} += 1;
        $self->{logger}->log_err("NOT XML 1.0 DOC: <%s>\n", $token);
        return FAIL;
    }
}
#
sub parse
{
    my $self = shift;
    #
    $self->{xml} = shift if @_;
    $self->{booklist} = undef;
    $self->{deparse_xml} = undef;
    #
    if (defined($self->{xml}))
    {
        $self->{errors} = 0;
        if (($self->parse_xml($self->{xml}) != SUCCESS) ||
            ($self->{errors} > 0))
        {
            $self->{logger}->log_err("Parse failed.\n");
            $self->{booklist} = undef;
            return FAIL;
        }
        return SUCCESS;
    }
    else
    {
        $self->{logger}->log_err("No XML buffer given.\n");
        return FAIL;
    }
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
sub to_xml
{
    my $self = shift;
    my ($ptree, $pxml, $last_element) = @_;
    #
    my $ref_type = ref($ptree);
    #
    my $last_element_end_tag = $last_element;
    $last_element_end_tag =~ s?^<?</?;
    #
    if ($ref_type eq "ARRAY")
    {
        my $imax = scalar(@{$ptree});
        #
        for (my $i=0; $i<$imax; ++$i)
        {
            $$pxml .= "$last_element" if ($i > 0);
            $self->to_xml($ptree->[$i], $pxml, $last_element);
            $$pxml .= "$last_element_end_tag" if ($i < ($imax-1));
        }
    }
    elsif ($ref_type eq "HASH")
    {
        foreach my $element ( sort keys %{$ptree} )
        {
            my $element_end_tag = $element;
            $element_end_tag =~ s?^<?</?;
            #
            $$pxml .= "$element";
            $self->to_xml($ptree->{$element}, $pxml, $element);
            $$pxml .= "$element_end_tag";
        }
    }
    else
    {
        $$pxml .= "$ptree" if (defined($ptree));
    }
}
#
sub new_deparse_start_xml
{
    my $self = shift;
    my ($ptree, $pxml) = @_;
    #
    my $last_element = "";
    $self->to_xml($ptree, $pxml, $last_element);
    #
    return;
}
#
sub deparse_xml
{
    my $self = shift;
    my ($ptree) = @_;
    #
    my $xml_string = '<?xml version="1.0" encoding="UTF-8"?>';
    if ($self->{use_new_parser} == TRUE)
    {
        $self->new_deparse_start_xml($ptree, \$xml_string);
    }
    else
    {
        $self->deparse_start_xml($ptree, \$xml_string);
    }
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
sub search_booklist
{
    my $self = shift;
    my ($proot, $tag_name, $ptag_value) = @_;
    #
    if (ref($proot) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$proot}); ++$i)
        {
            if ($proot->[$i]->{NAME} eq $tag_name)
            {
                if (defined($proot->[$i]->{VALUE}))
                {
                    $$ptag_value = $proot->[$i]->{VALUE};
                }
                else
                {
                    $$ptag_value = $proot->[$i]->{SIBLINGS};
                }
                return TRUE;
            }
            elsif (exists($proot->[$i]->{SIBLINGS}) &&
                  (scalar(@{$proot->[$i]->{SIBLINGS}}) > 0))
            {
                if ($self->search_booklist($proot->[$i]->{SIBLINGS}, 
                                           $tag_name, 
                                           $ptag_value) == TRUE)
                {
                    return TRUE;
                }
            }
        }
    }
    #
    $$ptag_value = undef;
    return FALSE;
}
#
sub new_search_booklist
{
    my $self = shift;
    my ($proot, $tag_name, $ptag_value) = @_;
    #
    if (defined($proot) && (ref($proot) eq "HASH"))
    {
        if (exists($proot->{$tag_name}))
        {
            $$ptag_value = $proot->{$tag_name};
            return TRUE;
        }
        else
        {
            foreach my $key (keys %{$proot})
            {
                if ($self->new_search_booklist($proot->{$key}, 
                                               $tag_name, 
                                               $ptag_value) == TRUE)
                {
                    return TRUE;
                }
            }
        }
    }
    #
    $$ptag_value = undef;
    return FALSE;
}
#
sub name_to_value
{
    my $self = shift;
    #
    my ($tag_name) = @_;
    my $tag_value = undef;
    #
    if (defined($self->{booklist}) && defined($tag_name))
    {
        my $status = FAIL;
        if ($self->{use_new_parser} == TRUE)
        {
            $status = $self->new_search_booklist($self->{booklist}, 
                                                 $tag_name, 
                                                \$tag_value);
        }
        else
        {
            $status = $self->search_booklist($self->{booklist}, 
                                             $tag_name, 
                                            \$tag_value);
        }
        #
        if ($status != TRUE)
        {
            $tag_value = undef;
        }
    }
    #
    return($tag_value);
}
#
sub multi_search_booklist
{
    my $self = shift;
    my ($proot, $tag_name, $ptag_names, $ptag_value) = @_;
    #
    if (ref($proot) eq "ARRAY")
    {
        for (my $i=0; $i<scalar(@{$proot}); ++$i)
        {
            if ($proot->[$i]->{NAME} eq $tag_name)
            {
                if (scalar(@{$ptag_names}) > 0)
                {
                    my $next_tag_name = shift @{$ptag_names};
                    if ($self->multi_search_booklist($proot->[$i]->{SIBLINGS},
                                                     $next_tag_name, 
                                                     $ptag_names, 
                                                     $ptag_value) == TRUE)
                    {
                        return TRUE;
                    }
                    else
                    {
                        # do not return
                        $tag_name = $next_tag_name;
                    }
                }
                elsif (defined($proot->[$i]->{VALUE}))
                {
                    $$ptag_value = $proot->[$i]->{VALUE};
                    return TRUE;
                }
                else
                {
                    $$ptag_value = $proot->[$i]->{SIBLINGS};
                    return TRUE;
                }
            }
            elsif (exists($proot->[$i]->{SIBLINGS}) &&
                  (scalar(@{$proot->[$i]->{SIBLINGS}}) > 0))
            {
                if ($self->multi_search_booklist($proot->[$i]->{SIBLINGS}, 
                                                 $tag_name, 
                                                 $ptag_names, 
                                                 $ptag_value) == TRUE)
                {
                    return TRUE;
                }
            }
        }
    }
    #
    $$ptag_value = undef;
    return FALSE;
}
#
sub new_multi_search_booklist
{
    my $self = shift;
    my ($proot, $tag_name, $ptag_names, $ptag_value) = @_;
    #
    if (defined($proot) && (ref($proot) eq "HASH"))
    {
        if (exists($proot->{$tag_name}))
        {
            if (scalar(@{$ptag_names}) > 0)
            {
                if (ref($proot->{$tag_name}) eq "ARRAY")
                {
                    my $i = 0;
                    my $next_tag_name = shift @{$ptag_names};
                    #
                    while ($tag_name eq $next_tag_name)
                    {
                        $i += 1;
                        if (scalar(@{$ptag_names}) == 0)
                        {
                            if ($i < scalar(@{$proot->{$tag_name}}))
                            {
                                $$ptag_value = $proot->{$tag_name}->[$i];
                                return TRUE;
                            }
                            else
                            {
                                $$ptag_value = undef;
                                return FALSE;
                            }
                        } 
                        $next_tag_name = shift @{$ptag_names};
                    }
                    #
                    return $self->new_multi_search_booklist(
                                      $proot->{$tag_name}->[$i],
                                      $next_tag_name, 
                                      $ptag_names, 
                                      $ptag_value);
                }
                else
                {
                    my $next_tag_name = shift @{$ptag_names};
                    return $self->new_multi_search_booklist($proot->{$tag_name}, 
                                                            $next_tag_name, 
                                                            $ptag_names, 
                                                            $ptag_value);
                }
            }
            else
            {
                $$ptag_value = $proot->{$tag_name};
                return TRUE;
            }
        }
        else
        {
            foreach my $key (keys %{$proot})
            {
                if ($self->new_multi_search_booklist($proot->{$key}, 
                                                     $tag_name, 
                                                     $ptag_names, 
                                                     $ptag_value) == TRUE)
                {
                    return TRUE;
                }
            }
        }
    }
    #
    $$ptag_value = undef;
    return FALSE;
}
#
sub names_to_value
{
    my $self = shift;
    #
    my @tag_names = @_;
    my $tag_value = undef;
    #
    if (defined($self->{booklist}) && (scalar(@tag_names) > 0))
    {
        my $status = FAIL;
        my $tag_name = shift @tag_names;
        if ($self->{use_new_parser} == TRUE)
        {
            $status = $self->new_multi_search_booklist($self->{booklist}, 
                                                      $tag_name, 
                                                     \@tag_names, 
                                                     \$tag_value);
        }
        else
        {
            $status = $self->multi_search_booklist($self->{booklist}, 
                                                   $tag_name, 
                                                  \@tag_names, 
                                                  \$tag_value);
        }
        #
        if ($status != TRUE)
        {
            $tag_value = undef;
        }
    }
    #
    return($tag_value);
}
#
# exit with success
#
1;
