
package StockCenter::Parser::Row;

use strict;
use Moose;
use namespace::autoclean;

has 'row' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
        get_row  => 'get',
        set_row  => 'set',
        row_keys => 'keys',
        count    => 'count'
    }
);

1;
