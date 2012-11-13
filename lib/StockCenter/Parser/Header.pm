
package StockCenter::Parser::Header;

use strict;
use Moose::Role;
use namespace::autoclean;

has 'headers' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef[Str]',
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
}

1;