
package DataAdapter::Oracle;

use strict;
use warnings;

use Moose;
use MOD::SGD;
use MOD::SGD::StockCenterInventoryDual;
use DateTime::Format::Strptime;

has 'dsn' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
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

#has 'resultset' => (
#    is      => 'rw',
#    isa     => 'DBIx::Class::ResultSet',
#    lazy    => 1,
#    default => sub {
#        my ( $self, $val ) = @_;
#        return $self->schema->resultset($val);
#        }
#);

has 'schema' => (
    is      => 'rw',
    isa     => 'DBIx::Class::Schema',
    lazy    => 1,
    default => sub {
        my ($self) = @_;

        print 'Connecting to MOD::SGD';
        return MOD::SGD->connect( $self->dsn, $self->user, $self->password, $self->attribute );
    }
);

sub insert {
    print '***** Insert; Adapter; DataAdapter::Oracle *****';
    my ( $self, $row ) = @_;
    my $date_parsed = 0;
    my $storage_date;
    my $inventory_data;
    my $strain_row
        = $self->schema->resultset('StockCenter')
        ->search( { strain_name => $row->strain_desc }, { rows => 1 } )
        ->single;
    print "***  $strain_row ***";

    $self->log->debug('***** Checking if strain exists already *****');
    if ( !$strain_row ) {

        #$logger->warn("could not find strain $data[0]");
        last;    # STRAIN;
    }

    if ( !$date_parsed ) {
        print 'Parsing date';
        my $dt = DateTime::Format::Strptime->new( pattern => '%m/%d/%y' )
            ->parse_datetime( $row->storage_date );
        $storage_date = $dt->day . '-' . uc $dt->month_abbr . '-' . $dt->year;
        $date_parsed  = 1;
    }

    my $dual_rs
        = $self->schema->resultset('StockCenterInventoryDual')->search(
        undef,
        {   select => ['STOCK_CENTER_INVENTORY_SEQ.nextval'],
            as     => ['id'],
        }
        );

    print 'Filling up the array';
    my $data = $dual_rs->next;
    push @$inventory_data,
        [
        $data->get_column('id'), $strain_row->id,
        $row->location,          $storage_date,
        $row->num_vials,         $row->color,
        $row->stored_by,         'CGM_DDB_KERRY'
        ];

    print 'Loading the data into database';
    if ( scalar @$inventory_data > 0 ) {
        unshift @$inventory_data, [
            qw/id strain_id location storage_date no_of_vials color
                stored_by created_by/
        ];
        $self->schema->txn_do(
            sub {
                $self->schema->resultset('StockCenterInventory')->populate($inventory_data);
                print "Loaded ", scalar @$inventory_data - 1, " data\n";
            }
        );
    }
}

#$self->resultset->populate(
#    [   {   strain_desc      => $row->strain_desc,
#            no_of_vials      => $row->num_vials,
#            color            => $row->color,
#            storage_comments => $row->comments,
#            stored_by        => $row->stored_by,
#            storage_date     => $row->storage_date,
#            location         => $row->location
#        }
#    ]
#);
#return;
#}

1;
