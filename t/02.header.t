
use Test::More qw/no_plan/;
use Test::Moose;

BEGIN { use_ok('StockCenter::Parser::Header'); }

{

    package TestHeader;
    use Moose;
    use namespace::autoclean;
    with 'StockCenter::Parser::Header';

    1;
}

my $tClass = TestHeader->new;

meta_ok( $tClass, '..has ->meta' );
does_ok( $tClass, 'StockCenter::Parser::Header', '..does the Header role' );
has_attribute_ok( $tClass, 'headers', '..has \'headers\' attribute' );

# Sample data
my $headers = "strain_id\tspecies\tgenotype\tplasmid\tsystematic_name";

is( $tClass->has_no_headers, 1, '->has_no_headers works fine' );
can_ok( $tClass, 'parse_headers' );
ok( $tClass->parse_headers($headers), 'Parsing works fine' );

isa_ok( $tClass->headers, 'HASH' );
is( $tClass->header_count, 5, "->header_count returns correct number" );
is( scalar( $tClass->header_keys ),
    $tClass->header_count,
    'Has correct number of keys'
);
is( $tClass->get_header(0),
    'strain_id', '->get_header returns correct value' );

