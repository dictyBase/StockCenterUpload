
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
    traits        => [qw/Getopt/],
    documentation => 'Additional database attribute',
    lazy          => 1,
    default       => sub {
        { 'LongReadLen' => 2**25, AutoCommit => 1 };
    }
);

has 'schema' => (
    is      => 'rw',
    isa     => 'DBIx::Class::Schema',
    builder => '_build_schema'
);

sub _build_schema {
    my ($self) = @_;
    $self->schema
        = MOD::SGD->connect( $self->dsn, $self->user, $self->password );
    $self->resultset = $self->schema->resultset('StockCenterInventory');
}

sub insert {
	my ($self, $row) = @_;
}

1;
