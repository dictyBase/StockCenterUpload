
package DataAdapter::Oracle;

use strict;
use warnings;

=head1 DESCRIPTION

=head1 USAGE

=cut

use Moose;
use MOD::SGD;
use MOD::SGD::StockCenterInventoryDual;
use DateTime::Format::Strptime;

has 'dsn' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    documentation => 'Database DSN'
);

has [qw/user password/] => (
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

has 'schema' => (
    is            => 'rw',
    isa           => 'DBIx::Class::Schema',
    lazy          => 1,
    documentation => 'Database schema',
    required      => 1,
    default       => sub {
        my ($self) = @_;
        return MOD::SGD->connect( $self->dsn, $self->user, $self->password,
            $self->attribute );
    }
);

sub insert {
    my ( $self, $row ) = @_;
    my $inventory_data;
    my $strain_row =
      $self->schema->resultset('StockCenter')
      ->search( { strain_name => $row->strain_desc }, { rows => 1 } )->single;

    if ( !$strain_row ) {
        return;
    }

    my $dual_rs = $self->schema->resultset('StockCenterInventoryDual')->search(
        undef,
        {
            select => ['STOCK_CENTER_INVENTORY_SEQ.nextval'],
            as     => ['id'],
        }
    );

    my $storage_date =
        $row->storage_date->day . '-'
      . uc $row->storage_date->month_abbr . '-'
      . $row->storage_date->year;
    my $data = $dual_rs->next;
    push @$inventory_data,
      [
        $data->get_column('id'), $strain_row->id,
        $row->location,          $storage_date,
        $row->num_vials,         $row->color,
        $row->stored_by,         'CGM_DDB_KERRY',
        $row->comments
      ];

    if ( scalar @$inventory_data > 0 ) {
        unshift @$inventory_data, [
            qw/id strain_id location storage_date no_of_vials color
              stored_by created_by storage_comments/
        ];
        $self->schema->txn_do(
            sub {
                $self->schema->resultset('StockCenterInventory')
                  ->populate($inventory_data);
                print " Loaded ", scalar @$inventory_data - 1, " data \n ";
            }
        );
    }
    return;
}

1;
