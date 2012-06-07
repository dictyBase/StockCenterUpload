use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;

BEGIN { use_ok( 'StockCenter::Parser::Row' ); }

my $row = StockCenter::Parser::Row->new();
isa_ok($row, 'StockCenter::Parser::Row');

has_attribute_ok($row, $_, "It has an attribute $_" ) for qw/num_vials strain_desc comments color storage_date stored_by location/;

dies_ok {$row->num_vials('Hello')} 'Expecting to die';

