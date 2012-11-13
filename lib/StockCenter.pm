package StockCenter;

use strict;
use warnings;
use Mojo::Base 'Mojolicious';
use YAML::Tiny;
use StockCenter::Plugin::Adapter;

# This method will run once at server start
sub startup {
    my $self = shift;

    my $db = $self->home->rel_file('db/upload.sqlite');
    $self->plugin(
        'database',
        {   dsn    => "dbi:SQLite:dbname=$db",
            helper => 'upload_db'
        }
    );

    my $mode = defined $ENV{MOJO_MODE} ? $ENV{MOJO_MODE} : 'development';
    $self->plugin(
        'yaml_config' => {
            file      => $self->home->rel_file("conf/$mode.yaml"),
            stash_key => 'config',
            class     => 'YAML::Tiny'
        }
    );
	$self->app->log->debug($self->config->{dsn});
	$self->app->log->debug($self->config->{adapter});

    $self->plugin(
		'StockCenter::Plugin::Adapter',
        {   adapter  => $self->config->{adapter},
            dsn      => $self->config->{dsn},
            user     => $self->config->{user},
            password => $self->config->{password}
        }
    );
	$self->plugin('asset_tag_helpers');

    # Routes
    my $r = $self->routes;
    $r->get(
        '/' => sub {
            my ($self) = @_;
            $self->redirect_to('new_upload');
        }
    );
	#$r->get('/uploads')->to('upload#index');
    $r->route( '/uploads/search', format => 'datatable' )->via('get')
        ->to('upload#search');
    $r->get('/uploads')->name('new_upload')->to('upload#new_record');
    $r->post('/uploads')->name('upload')->to('upload#create');
	$self->app->log->info('All routes set up');

    return;
}

1;
