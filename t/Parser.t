
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Parser'); }

my $file = catfile( $Bin, 'data', 'sample2.xls' );
my $parser = StockCenter::Parser->new( file => $file );
isa_ok( $parser,         'StockCenter::Parser' );
is( $parser->curr_row, 0,  "Current row initialized" );
is( $parser->row_max,  10, "Row max initialized" );
isa_ok( $parser->spreadsheet, 'Spreadsheet::ParseExcel::Worksheet' );

