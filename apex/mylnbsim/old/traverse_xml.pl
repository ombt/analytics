#!/usr/bin/perl
#
use strict;
use XML::Simple;
#
my $depth = 0;
my $verbose = 0;
#
sub read_file {
    my ($infile, $pdata) = @_;
    #
    # is file readable?
    #
    if ( ! -r $infile )
    {
        printf "ERROR: file $infile is NOT readable\n";
        exit -1;
    }
    #
    # read in file 
    #
    unless (open(INFD, $infile))
    {
        printf "ERROR: unable to open $infile.\n";
        exit -1;
    }
    my @buf = <INFD>;
    close(INFD);
    #
    # return data.
    #
    unshift @{$pdata}, @buf;
    #
    return;
}
#
sub traverse {
    my ($p, $pdl) = @_;
    #
    $depth += 1;
    my $indent = (' ' x ($depth*2));
    #
    if (ref($p) eq 'SCALAR')
    {
        print "${indent}SCALAR REF: $p\n";
    }
    elsif (ref($p) eq 'ARRAY')
    {
        print "${indent}ARRAY REF: $p\n" if ($verbose);
        foreach my $element (@{$p})
        {
            traverse($element, $pdl);
        }
    }
    elsif (ref($p) eq 'HASH')
    {
        print "${indent}HASH REF: $p\n" if ($verbose);
        foreach my $key (keys(%{$p}))
        {
            traverse($p->{$key}, $pdl);
        }
    }
    elsif (ref($p) eq 'CODE')
    {
        print "${indent}CODE REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'REF')
    {
        print "${indent}REF REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'GLOB')
    {
        print "${indent}GLOB REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'LVALUE')
    {
        print "${indent}LVALUE REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'FORMAT')
    {
        print "${indent}FORMAT REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'IO')
    {
        print "${indent}IO REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'VSTRING')
    {
        print "${indent}VSTRING REF: $p\n" if ($verbose);
    }
    elsif (ref($p) eq 'Regexp')
    {
        print "${indent}Regexp REF: $p\n" if ($verbose);
    }
    else
    {
        print "${indent}SCALAR: $p\n" if ($verbose);
        $$pdl += length($p);
    }
    #
    $depth -= 1;
}
#
if ($#ARGV>=0)
{
    if ($ARGV[0] eq '-v')
    {
        $verbose = 1;
        shift @ARGV;
    }
}
#
foreach my $xml_file (@ARGV)
{
    printf "\nProcessing XML file: %s\n", $xml_file;
    #
    my @raw_xml = ();
    read_file($xml_file, \@raw_xml);
    #
    my $xml = join '', @raw_xml;
    my $xml_length = length($xml);
    #
    my $ref = XMLin($xml);
    #
    my $data_length = 0;
    traverse($ref,\$data_length);
    #
    printf "XML Tags and Data length: %d\n", $xml_length;
    printf "Data length: %d\n", $data_length;
    printf "Percent Data/(Data+XML) = %6.2f%%\n", 
            100.0*($data_length/$xml_length);
}
#
exit 0;
