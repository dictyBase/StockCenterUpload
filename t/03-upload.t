
use strict;
use warnings;

use Test::More qw/no_plan/;
use Mojolicious::Lite;
use Test::Mojo;
use StockCenter::Parser;
use Test::DBIx::Class -config_path => [qw(t etc schema)];

#use DBCon::Uploader;
#use Mojo::Asset::File;

$ENV{MOJO_MODE} = "test";
diag("Entering $ENV{MOJO_MODE} mode");

my $dbname = "data/StockCenter_test.db";
my $file
    = "/home/yogesh/Projects/dictyBase/StockCenterUpload/t/data/sample.xls";

my $t = Test::Mojo->new('StockCenter');
$t->app->log->level('error');

$t->get_ok('/uploads/new');

$t->post_form_ok( '/upload', { my_upload => { file => $file } } );

$t->app->plugin(
    'StockCenter::Plugin::Adapter',
    {   'adapter' => 'DataAdapter::SQLite',
        'dsn'     => 'dbi:SQLite:dbname=' . $dbname
    }
);
isa_ok( $t->app->adapter->resultset, 'DBIx::Class::ResultSet' );

fixtures_ok my $upload_test = sub {
    my $self = shift;

    #diag( ref( $t->app->adapter->resultset ) );
    my $u_rs = $t->adapter->resultset;
    my $parser = StockCenter::Parer->new( file => $self->$file );
    while ( $parser->has_next() ) {
        my $row = $parser->next();
        return $u_rs->create(
            {   strain_desc => $row->strain_desc,
                location    => $row->location
            }
        );
    }
}, 'Installed fixtures';

is_fields [qw/strain_desc location/], ResultSet('StockCenter'),
    [ [ 'V10490', '4-50(32)' ], [ 'V10258', '4-50(38)' ], ],
    ' Got expected fields ';

