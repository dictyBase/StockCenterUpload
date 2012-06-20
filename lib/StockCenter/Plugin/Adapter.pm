
package StockCenter::Plugin::Adapter;

use strict;
use warnings;

#
BEGIN {
    $StockCenter::Plugin::Adapter::VERSION = '0.1';
}

use Mojo::Base 'Mojolicious::Plugin';

#
sub register {

    my $self   = shift;
    my $app    = shift;
    my $config = shift || {};

    #
    my $adapter = $config->{adapter};

    #
    $app->attr(
        'adp' => sub {
            $adapter->new(
                dsn      => $config->{dsn},
                user     => $config->{user},
                password => $config->{password}
            );
        }
    );

    #
    my $helper_name = $config->{helper} || 'adapter';
    $app->helper( $helper_name => sub { return shift->app->adp } );
}

1;
__END__
