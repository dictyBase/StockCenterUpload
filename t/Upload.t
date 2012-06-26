
use strict;
use warnings;

use Test::More qw/no_plan/;

use Mojolicious::Lite;
use Test::Mojo;
use StockCenter::Plugin::Adapter;
use DBCon::Uploader;
use Test::DBIx::Class;

$ENV{MOJO_MODE} = "test";
diag("Entering $ENV{MOJO_MODE} mode");

my $dbname = "data/test.db";

my $t = Test::Mojo->new('StockCenter');
$t->get_ok('/uploads/new');

post '/uploads' => sub {
    my ($self) = @_;

    my $f = $self->param( filename => 'data/cox_strains.xls' );
	diag($f);

    #diag("File $f found");
    $self->render( text => 'Uploading file' );
};

$t->post_ok('/uploads')->status_is(200);
