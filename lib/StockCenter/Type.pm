
package StockCenter::Type;

use strict;
use namespace::autoclean;
use Moose;

has 'type' => (

);

requires 'headers';
requires 'next_row';
