
use Test::More qw/no_plan/;
use Test::Moose;

BEGIN { use_ok('StockCenter::Parser::Row'); }

my $row = StockCenter::Parser::Row->new;
isa_ok( $row, 'StockCenter::Parser::Row' );

$row->set_row(
    species                => 'Dictyostelium discoideum',
    strain_characteristics => 'FLAG-tagged',
    systematic_name        => 'DBS0236490'
);

is( scalar( $row->row_keys ),
    $row->count,
    'set_row sets proper values. count & row_keys return proper values' );

is( $row->get_row('species'),
    'Dictyostelium discoideum',
    'get_row returns proper value'
);
