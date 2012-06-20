
package DataAdapter::Oracle;

use strict;
use warnings;

use Moose;

has [qw/dsn user password/] => (
    is  => 'rw',
    isa => 'Str',
);

has 'attribute' => (
    is            => 'rw',
    isa           => 'HashRef',
    documentation => 'Additional database attribute',
    lazy          => 1,
    default       => sub {
        { 'LongReadLen' => 2**25, AutoCommit => 1 };
    }
);

has 'resultset' => (
    is      => 'rw',
    isa     => 'DBIx::Class::ResultSet',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return $self->schema->resultset('StockCenterInventory');
    }
);

has 'schema' => (
    is      => 'rw',
    isa     => 'DBIx::Class::Schema',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return MOD::SGD->connect( $self->dsn, $self->user, $self->password );
    }
);

sub insert {
    my ( $self, $row ) = @_;
    return;
}

1;
