
package DataAdapter::SQLite;

use strict;
use warnings;

use Moose;

has [qw/dsn user password/] => (
    is            => 'rw',
    isa           => 'Str',
    documentation => 'Database attributes'
);

has 'resultset' => (
    is  => 'rw',
    isa => 'DBIx::Class::ResultSet'
);

has 'schema' => (
    is      => 'rw',
    isa     => 'DBIx::Class::Schema',
    builder => '_build_schema'
);

sub _build_schema {
    my ($self) = @_;
    $self->schema    = DBCon::Uploader->connect( $self->dsn );
    $self->resultset = $self->schema->resultset('StockCenter');
}

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
