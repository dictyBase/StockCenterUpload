
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
        header_keys    => 'keys'
    },
);

sub parse_headers {
    my ( $self, $headers ) = @_;
    my @vals = split( '\t', $headers );
    my $hashRef = {};
    for ( my $i = 0; $i < scalar(@vals); $i++ ) {
        $hashRef->{$i} = $vals[$i];
    }
    $self->headers($hashRef);
    #return $self->headers;
}

1;