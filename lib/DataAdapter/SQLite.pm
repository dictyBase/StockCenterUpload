
package DataAdapter::SQLite;

use strict;
use warnings;

use Moose;

has 'dsn' => (
    is            => 'rw',
    isa           => 'Str',
    documentation => 'Database attributes'
);

has [qw/user password/] => (
    is => 'rw',
    default => undef
);

has 'resultset' => (
    is      => 'rw',
    isa     => 'DBIx::Class::ResultSet',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return $self->schema->resultset('StockCenter');
    }
);

has 'schema' => (
    is      => 'rw',
    isa     => 'DBIx::Class::Schema',
    lazy    => 1,
    default => sub {
        my ($self) = @_;
        return DBCon::Uploader->connect( $self->dsn );
    }
);

sub insert {
    my ( $self, $row ) = @_;
    $self->resultset->populate(
        [   {   strain_desc  => $row->strain_desc,
                num_vials    => $row->num_vials,
                color        => $row->color,
                comments     => $row->comments,
                stored_by    => $row->stored_by,
                storage_date => $row->storage_date,
                location     => $row->location
            }
        ]
    );
    return;
}

1;
