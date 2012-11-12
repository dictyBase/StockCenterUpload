
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Parser'); }

{

    package TestParser;
    use Moose;
    use namespace::autoclean;
    with 'StockCenter::Parser';

    1;
}

my $file = catfile( $Bin, 'data', 'strain.xls' );

my $parser = TestParser->new;
meta_ok( $parser, '..has ->meta' );
does_ok( $parser, 'StockCenter::Parser', '..does the Parser role' );
has_attribute_ok( $parser, $_, "..has $_ attribute" )
    for qw/file parser spreadsheet row_max col_max curr_row/;

$parser->file($file);
is( $parser->curr_row, 0,  "->curr_row initialized" );
is( $parser->row_max,  25, "->row_max initialized" );
isa_ok( $parser->spreadsheet, 'Spreadsheet::ParseExcel::Worksheet' );

can_ok( $parser, 'get_row' );

can_ok( $parser, 'has_next' );
is( $parser->has_next, 1, '->has_next works well' );
$parser->curr_row(26);
isnt( $parser->has_next, 1, '->has_next does not have more values' );
