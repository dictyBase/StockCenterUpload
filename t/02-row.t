
use Test::More qw/no_plan/;
use Test::Moose;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Type::Strain'); }

my $parser = StockCenter::Type::Strain->new();
my $file = catfile($Bin, 'data', 'strain.xls');
$parser->file($file);

while ($parser->has_next()) {
	my $row = $parser->next();
	isa_ok($row, 'StockCenter::Parser::Row');
}

#has_attribute_ok( $row, $_, "It has an attribute $_" )
#    for
#    qw/num_vials strain_desc comments color storage_date stored_by location/;

