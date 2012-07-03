
use strict;
use warnings;

use Module::Build;

my %module_build_args = (
    "build_requires"     => { "Module::Build" => "0.3601" },
    "configure_requires" => { "Module::Build" => "0.3601" },
    "dist_abstract" => "Mojolicious application for StockCenter data upload",
    "dist_author"   => ["Yogesh Pandit"],
    "dist_name"     => "StockCenter",
    "dist_version"  => "0.1",
    "license"       => "perl",
    "module_name"   => "StockCenter",
    "recommends"    => {},
    "recursive_test_files" => 1,
    "requires"             => {
        "Moose"                   => "2.0602",
        "Mojolicious"             => "2.51",
		"Mojolicious::Plugin::Database" => "1.05",
		"Mojolicious::Plugin::YamlConfig" => "0.1.5",
        "Spreadsheet::ParseExcel" => "0.59", 
        "namespace::autoclean" => "0.13",
		"DBD::Oracle" => "1.44",
		"DBI" => "1.622",
		"DBIx::Class" => "0.08196",
		"YAML::Tiny" => "1.51",
		"DateTime::Format::Strptime" => "0.74",
		"Data::Dump" => "1.21",
		"Math::Base36" => "0.09",
		"Math::BigInt" => "1.99"

    },
    "script_files" => []
);

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
