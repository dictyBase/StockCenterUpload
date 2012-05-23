
package StockCenter::Parser::Row;

use strict;
use Moose;

has [qw/strain_desc stored_by color location comments/] =>
    ( is => 'rw', isa => 'Str' );
has 'storage_date' => ( is => 'rw', isa => 'Str' );
has 'num_vials'    => ( is => 'rw', isa => 'Int' );
