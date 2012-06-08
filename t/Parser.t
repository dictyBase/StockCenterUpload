
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Parser'); }

#if (-e catfile($Bin, "data", "sample.xls")) {
#	diag "Found the test fixture\n";
#}

my $parser = StockCenter::Parser->new(
    file => catfile( $Bin, "data", "sample.xls" ) );
isa_ok( $parser,         'StockCenter::Parser' );
isa_ok( $parser->parser, 'Spreadsheet::ParseExcel' );

$parser->file( file => catfile( $Bin, "data", "sample.xls" ) );
is( $parser->curr_row, 0,  "Current row initialized" );
is( $parser->row_max,  10, "Row max initialized" );
isa_ok( $parser->spreadsheet, 'Spreadsheet::ParseExcel::Worksheet' );

