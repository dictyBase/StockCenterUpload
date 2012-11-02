
package StockCenter::Parser::Header;

use strict;
use Moose;
use namespace::autoclean;

use StockCenter::Parser::Row;

has 'headers' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
        get_value   => 'get',
        is_empty    => 'is_empty',
        count       => 'count',
        header_keys => 'keys'
    },
    trigger => sub {
        my ($self) = @_;
        my $row = StockCenter::Parser::Row->new;
        for my $key ( $self->header_keys ) {
            $row->meta->add_attribute( $self->get_value($key) );
        }
    },
    default => sub { () },
    lazy    => 1
);

sub parse {
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