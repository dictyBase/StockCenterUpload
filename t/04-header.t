
use Test::More qw/no_plan/;
use Test::Moose;

BEGIN { use_ok('StockCenter::Parser::Header'); }

my $row
    = "strain_descriptor\tstrain_names\tsystematic_name\tparental_strain\tassociated_genes\tplasmid\tmutagenesis_method\tgenetic_modification\tstrain_summary\tgenotype\tstrain_characteristics\tspecies\tpubmed_id\tdate_obtained\tobtained_as\tdepositor\tcomments";
my $headers = StockCenter::Parser::Header->parse($row);

foreach $key ( keys %{$headers} ) { print "$key ->  $headers->{$key}\n"; }

isa_ok( $headers, 'HASH' );

