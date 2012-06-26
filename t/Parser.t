
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Parser'); }

my $file = catfile( $Bin, 'data', 'sample.xls' );
my $parser = StockCenter::Parser->new( file => $file );
isa_ok( $parser, 'StockCenter::Parser' );
is( $parser->curr_row, 0,  "Current row initialized" );
is( $parser->row_max,  14, "Row max initialized" );
isa_ok( $parser->spreadsheet, 'Spreadsheet::ParseExcel::Worksheet' );

for my $i ( 0 .. 14 ) {
    is( $parser->has_next, 1, 'has_next true' );
    isa_ok( $parser->next, 'StockCenter::Parser::Row' );
    my $row = $parser->next;
    foreach my $header (
        qw/num_vials strain_desc comments color stored_by storage_date location/
        )
    {
        isnt( $row->$header, '', $header . " is not Empty" );
        if ( $header eq 'num_vials' and defined $row->$header ) {
            is( $row->$header, int( $row->$header ), "num_vials is Int" );
        }
    }
}

