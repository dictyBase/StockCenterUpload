
package StockCenter::Parser::Header;

use strict;
use Moose;

has [qw/strain_desc stored_by color/] => ( is => 'rw', isa => 'Str' );
has 'storage_date' => ( is => 'rw', isa => 'Str' );