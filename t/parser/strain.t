
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Type::Strain'); }

my $parser = StockCenter::Type::Strain->new();

isa_ok( $parser, 'StockCenter::Type::Strain' );

my $file = catfile( $Bin, '../data', 'strain.xls' );
$parser->file($file);

is( $parser->curr_row,        0,  "Current row initialized" );
is( $parser->row_max,         25, "Row max initialized" );
is( $parser->has_spreadsheet, 1,  "File has a spreadsheet" );
isa_ok( $parser->spreadsheet, 'Spreadsheet::ParseExcel::Worksheet' );

while ( $parser->has_next() ) {
    my $row = $parser->next();
    isa_ok( $row, 'StockCenter::Parser::Row' );
    is( $row->count, 6, "Number of columns is fine" );
    foreach my $k ( $row->row_keys ) {
        isnt( $row->get_row($k), '', "Cell isn't empty" );
    }
}
