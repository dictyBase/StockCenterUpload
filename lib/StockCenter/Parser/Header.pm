
package StockCenter::Parser::Header;

use strict;
use Moose::Role;
use namespace::autoclean;

has 'headers' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
        get_header     => 'get',
        has_no_headers => 'is_empty',
        header_count   => 'count',
        header_keys    => 'keys',
        set_header     => 'set'
    },
);

sub parse_headers {
    my ( $self, $headers ) = @_;
    my @vals = split( '\t', $headers );
    for ( my $i = 0; $i < scalar(@vals); $i++ ) {
        $self->set_header( $i => $vals[$i] );
    }
    return $self->headers;
}

1;

=head1 NAME

C<StockCenter::Parser::Header> - A C<Moose::Role> to handle column headers

=head1 DESCRIPTION

A C<Moose::Role> with an attribute to hold headers as a C<HASH> with column number as the key and a method to parse a string and fill up the C<HASH>

=head1 SYNOPSIS

	with 'StockCenter::Parser::Header'
	
	my $line = "col1\tcol2\tcol3"; 
	$self->parse_headers($line);
	
	print $self->get_header('col1');

=over

