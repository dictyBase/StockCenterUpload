
use strict;
use warnings;

use Test::More qw/no_plan/;
use Test::DBIx::Class -config_path => [qw(t etc schema)];
use Mojolicious::Lite;
use Test::Mojo;
use DBCon::Uploader;

BEGIN {
    use_ok('StockCenter::Plugin::Adapter') || print "Bail out!
		";
}

diag(
    "Testing StockCenter::Plugin::Adapter $StockCenter::Plugin::Adapter::VERSION, Perl $], $^X"
);

$ENV{MOJO_MODE} = "test";
diag("Entering $ENV{MOJO_MODE} mode");

my $dbname = "data/StockCenter_test.db";

my $t = Test::Mojo->new('StockCenter');
$t->app->plugin(
    'StockCenter::Plugin::Adapter',
    {   'adapter' => 'DataAdapter::SQLite',
        'dsn'     => 'dbi:SQLite:dbname=' . $dbname
    }
);

isa_ok( $t->app->adapter,            'DataAdapter::SQLite' );
isa_ok( $t->app->adapter->resultset, 'DBIx::Class::ResultSet' );

fixtures_ok [
    StockCenter => [
        [   'id',           'strain_desc', 'location',  'stored_by',
            'storage_date', 'color',       'num_vials', 'comments'
        ],
        [   '1',      'V10211', '4-50(31)', 'Kerry',
            '8/1/11', 'yellow', '5',        'Testing'
        ],
        [   '2',      'V12342', '5-23(45)', 'Bob',
            '9/2/12', 'red',    '8',        'Hello World'
        ],
    ],
    ],
    'Installed some basic fixtures';

ok ResultSet('StockCenter'), "Yeah, some data has been entered.";
