
package DataAdapter::Oracle;

use strict;
use warnings;

use Bio::Chado::Schema;
use Moose;
use MOD::SGD;
use MOD::SGD::StockCenterInventoryDual;

#has 'dsn' => (
#    is            => 'rw',
#    isa           => 'Str',
#    required      => 1,
#    documentation => 'Database DSN',
#    default       => '',
#    lazy          => 1
#);

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

has 'legacy_schema' => (
    is            => 'rw',
    isa           => 'DBIx::Class::Schema',
    lazy          => 1,
    documentation => 'Database schema',
    required      => 1,
    default       => sub {
        my ($self) = @_;
        return MOD::SGD->connect(
            $self->legacy_dsn,      $self->legacy_user,
            $self->legacy_password, $self->attribute
        );
    },
    lazy => 1
);

has [qw/legacy_dsn legacy_user legacy_password/] => (
    is  => 'rw',
    isa => 'Str'
);

has 'schema' => (
    is      => 'rw',
    isa     => 'Bio::Chado::Schema',
    default => sub {
        my ($self) = @_;
        return Bio::Chado::Schema->connect(
            $self->legacy_dsn, $self->user,
            $self->password,   $self->attribute
        );
    },
    lazy => 1
);

has '_curr_dbs_id' => (
    is      => 'rw',
    isa     => 'Str',
    default => sub {
        my ($self) = @_;
        my $dbxref_rs = $self->schema->resultset('General::Dbxref')->search(
            { 'db.name' => 'DB:dictyBase', accession => { -like => 'DBS%' } },
            {   join     => 'db',
                order_by => { -desc => 'accession' },
                select   => 'accession'
            }
        );
        return $dbxref_rs->first->accession;
    },
    lazy => 1,
);

sub insert_strain {
    my ( $self, $row ) = @_;

    #print $self->dsn."\t".$self->user."\t".$self->password."\n";
    my $strain_data;
    my @headers;
    my $dual_rs
        = $self->legacy_schema->resultset('StockCenterDual')
        ->search( undef,
        { select => ['STOCK_CENTER_SEQ.nextval'], as => ['id'], } );

    my $data = $dual_rs->next;
    for my $key ( $row->row_keys ) {
        push( @headers,      $key );
        push( @$strain_data, $row->get_row($key) );

        #print $key. "\t" . $row->get_row($key) . "\n";
    }

    #print "\n";
    if ( scalar @$strain_data > 0 ) {
        my $id = $data->get_column('id');
        unshift @headers,      "id";
        unshift @$strain_data, $id;

        my $new_dbs_val = $self->_curr_dbs_id;
        $new_dbs_val =~ s/^DBS//x;
        $new_dbs_val = $new_dbs_val + 1;

        #print $self->_curr_dbs_id . "\t" . $new_dbs_val . " *#*#*#*# \n";
        $self->_curr_dbs_id( "DBS" . $new_dbs_val );

        #print $self->_curr_dbs_id . "\n";

        $self->legacy_schema->txn_do(
            sub {
                my $dbxref_rs
                    = $self->schema->resultset('General::Dbxref')
                    ->create(
                    { accession => $self->_curr_dbs_id, db_id => '6' } );

                push( @headers,      "dbxref_id" );
                push( @$strain_data, $dbxref_rs->dbxref_id );

                $self->legacy_schema->resultset('StockCenter')
                    ->populate( [ [@headers], [@$strain_data] ] );

    #print "Loaded ", scalar(@$strain_data), " strain data to Stock_Center\n";
            }
        );
    }
    return;
}

sub insert {
    my ( $self, $row ) = @_;
    my $inventory_data;
    my $strain_row
        = $self->schema->resultset('StockCenter')
        ->search( { strain_name => $row->strain_desc }, { rows => 1 } )
        ->single;

    if ( !$strain_row ) {
        return;
    }

    my $dual_rs
        = $self->schema->resultset('StockCenterInventoryDual')->search(
        undef,
        {   select => ['STOCK_CENTER_INVENTORY_SEQ.nextval'],
            as     => ['id'],
        }
        );

    my $storage_date
        = $row->storage_date->day . '-'
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

                #print " Loaded ", scalar @$inventory_data - 1, " data \n ";
            }
        );
    }
    return;
}

1;
