
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
        "Spreadsheet::ParseExcel" => "0.59"
    },
    "script_files" => []
);

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
