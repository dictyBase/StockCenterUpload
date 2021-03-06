#!/usr/bin/perl -w

use strict;

use Module::Build;

my $class = Module::Build->subclass(
    code => q{
		sub ACTION_create_db_folder {
			use File::Path qw/make_path/;
			my ($self) = @_;
			make_path ('db', {verbose => 1});
		}

		sub ACTION_create_history_db {
			use DBI;
			my $dbh = DBI->connect("dbi:SQLite:dbname=db/upload.sqlite","","", {});
			$dbh->do("CREATE TABLE uploaded_file ( id INTEGER PRIMARY KEY AUTOINCREMENT, file VARCHAR(100) NOT NULL, size INT NOT NULL, type VARCHAR(50) NOT NULL, uploaded_on  DATETIME NOT NULL DEFAULT current_timestamp )");
		}
	},
);

my $builder = $class->new(
    module_name  => 'StockCenter',
    dist_author  => 'Yogesh Pandit',
    dist_version => '0.1.4',
    dist_abstract =>
        'A Mojolicious web application for stock center data upload',
    license  => 'perl',
    requires => {
        "Bio::Chado::Schema"              => "0.20000",
        "Moose::Util::TypeConstraints"    => "2.0602",
        "MooseX::Attribute::Dependent"    => "1.1.2",
        "Mojolicious::Plugin::Database"   => "1.05",
        "Mojolicious::Plugin::YamlConfig" => "0.1.5",
        "Spreadsheet::ParseExcel"         => "0.59",
        "namespace::autoclean"            => "0.13",
        "DBIx::Class"                     => "0.08196",
        "YAML::Tiny"                      => "1.51",
        "DateTime::Format::Strptime"      => "1.4000",
        "Data::Dump"                      => "1.21",
        "Math::Base36"                    => "0.09",
        "Math::BigInt"                    => "1.99",
        "Test::More"                      => "0.98",
    },
    recommends     => { "DBD::Oracle" => "1.44", },
    add_to_cleanup => ['StockCenter-*'],
    "script_files" => []
);

$builder->create_build_script();

1;
