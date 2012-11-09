
use Test::More qw/no_plan/;
use Test::Moose;
use FindBin qw/$Bin/;
use File::Spec::Functions;

BEGIN { use_ok('StockCenter::Type::Strain'); }

my $parser = StockCenter::Type::Strain->new();
my $file = catfile( $Bin, 'data', 'strain.xls' );
$parser->file($file);

if ( $parser->has_next() ) {
    my $row = $parser->next();
}
isa_ok( $parser->headers, 'HASH' );
is($parser->header_count, 6, "\# headers is fine");
foreach $key ( $parser->header_keys ) {
    print "$key ->  $parser->get_header($key)\n";
}

