
use Test::More qw/no_plan/;
use Test::Moose;
use Test::Exception;
use FindBin qw/$Bin/;

#use lib "$Bin/data";

print "path is " . $Bin . "\n";
BEGIN { use_ok('StockCenter::Parser'); }
BEGIN { use_ok('Spreadsheet::ParseExcel'); }

my $parser = StockCenter::Parser->new( file => '$Bin/data/sample.xls' );
isa_ok( $parser, 'StockCenter::Parser' );
