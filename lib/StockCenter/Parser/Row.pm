
package StockCenter::Parser::Row;

use strict;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime::Format::Oracle;

subtype 'StockCenter::StorageDate' => as class_type('DateTime');
coerce 'StockCenter::StorageDate' => from 'Str' => via {
    my ( $y, $m, $d ) = split /-/, $_;
    return DateTime::Format::Strptime->new(
        pattern  => '%Y-%m-%d',
        on_error => 'croak'
    )->parse_datetime( DateTime->new( year => $y, month => $m, day => $d ) );
};

has [qw/strain_desc stored_by color location comments/] => (
    is  => 'rw',
    isa => 'Str'
);

has 'storage_date' => (
    is     => 'rw',
    isa    => 'StockCenter::StorageDate',
    coerce => 1
);

has 'num_vials' => (
    is  => 'rw',
    isa => 'Int'
);

1;
