
package StockCenter::Parser::Row;

use strict;
use Moose;
use Moose::Util::TypeConstraints;
use DateTime::Format::Strptime;

subtype 'StockCenter::StorageDate' => as 'DateTime::Format::Strptime';
coerce 'StockCenter::StorageDate' => from 'Str' => via {
    print "*** $_ ***\n";

    #my ( $y, $m, $d ) = split /-/, $_;
    my $dt = DateTime::Format::Strptime->new(
        pattern  => '%Y-%m-%d',
        on_error => 'croak'
    )->parse_datetime($_);
    return $dt;
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
