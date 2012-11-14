
package StockCenter::Plugin::Adapter;

use strict;
use warnings;
use DataAdapter::SQLite;
use DataAdapter::Oracle;

BEGIN {
    $StockCenter::Plugin::Adapter::VERSION = '0.1.1';
}

use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $config ) = @_;
    my $adapter = $config->{adapter};
    $app->attr(
        'adp' => sub {
            $adapter->new(
                dsn      => $config->{dsn},
                user     => $config->{user},
                password => $config->{password}
            );
        }
    );
    my $helper_name = $config->{helper} || 'adapter';
    $app->helper( $helper_name => sub { return shift->app->adp } );
    return;
}

1;

=head1 NAME

C<StockCenter::Plugin::Adapter> - A Mojolicious plugin for data adapter

=head1 DESCRIPTION

A Mojolicious plugin for data adapter (Oracle || SQLite)

=head1 SYNOPSIS

	$self->plugin(
	'StockCenter::Plugin::Adapter',
        {   adapter  => $adapter,
            dsn      => $dsn,
            user     => $user,
            password => $password
        }
   	);
	my $schema = $self->adapter->schema;

=over

