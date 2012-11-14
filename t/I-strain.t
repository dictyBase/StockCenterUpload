
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Type::Strain'); }
require_ok('StockCenter::Parser');
require_ok('StockCenter::Parser::Header');

my $file = catfile( $Bin, 'data', 'strain.xls' );

my $strain_parser = StockCenter::Type::Strain->new();
isa_ok( $strain_parser, 'StockCenter::Type::Strain' );
meta_ok( $strain_parser, '..has ->meta' );
does_ok( $strain_parser, 'StockCenter::Parser', '..does the Parser role' );
does_ok( $strain_parser, 'StockCenter::Parser::Header',
    '..does the Header role' );

has_attribute_ok( $strain_parser, 'file', '..has the \'file\' attribute' );
has_attribute_ok( $strain_parser, 'spreadsheet',
    '..has the \'spreadsheet\' attribute' );
has_attribute_ok( $strain_parser, 'headers',
    '..has the \'headers\' attribute' );

isnt( $strain_parser->has_spreadsheet, 1, 'File not parsed yet' );
$strain_parser->file($file);
is( $strain_parser->has_spreadsheet, 1, 'File is parsed' );

has_attribute_ok( $strain_parser, 'row_max',
    "Max rows in file " . $strain_parser->row_max );
can_ok( $strain_parser, 'next' );
can_ok( $strain_parser, 'has_next' );
can_ok( $strain_parser, 'get_row' );
can_ok( $strain_parser, 'parse_headers' );

$strain_parser->curr_row(2);
is( $strain_parser->has_next, 1, '->has_next() True. ->curr_row = 2' );
$strain_parser->curr_row(100);
isnt( $strain_parser->has_next, 1, '->has_next() False. ->curr_row = 100' );

isnt( $strain_parser->has_no_headers, 0, 'Headers yet to be assigned' );
$strain_parser->curr_row(0);
is( $strain_parser->curr_row, 0, '->curr_row works fine' );
my $row = $strain_parser->next;
isa_ok( $row, 'StockCenter::Parser::Row' );
is( $row->count,
    $strain_parser->header_count,
    'Number of elements in row is fine'
);
is( $strain_parser->has_no_headers, 0, 'Headers assigned properly' );
my $h = $strain_parser->get_header(1);
isnt( $row->get_row($h), ' ', 'Row values are assigned properly' );

#while ( $strain_parser->has_next() ) {
#    my $row = $strain_parser->next();
#    isa_ok( $row, 'StockCenter::Parser::Row' );
#    is( $row->count, 6, "Number of columns is fine" );
#    foreach my $k ( $row->row_keys ) {
#        isnt( $row->get_row($k), '', "Cell isn't empty" );
#    }
#}
