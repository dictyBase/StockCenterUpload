
package StockCenter::Type::Strain;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use Moose;
with 'StockCenter::Parser';
use DataAdapter::Oracle;

sub validate_headers {
    my ($self) = @_;
}

sub next {
    my ($self) = @_;
    my $row = StockCenter::Parser::Row->new();
    $self->app->log->debug( 'Current row: ' . $self->curr_row );
    if ( $self->curr_row == 0 && $self->has_no_headers ) {
        $self->app->log->debug( '***** ' . $self->file );
        $self->app->log->debug(
            "Has spreadsheet: " . $self->has_spreadsheet );
        $self->app->log->debug('Parsing headers ***');
        my $row = $self->get_row( $self->curr_row );
        $self->app->log->debug( "***Row: " . $row );
        $self->parse_headers($row);
    }
    $self->app->log->debug( "Headers count" . $self->count );

    for my $key ( $self->header_keys ) {
        my $cell = $self->spreadsheet->get_cell( $self->curr_row, $key );
        next unless ($cell);
        my $header = $self->get_value($key);
        my $value  = $cell->value();
        $row->$header($value);
    }
    $self->curr_row( $self->curr_row + 1 );
}

sub insert {
    my ( $self, $row ) = @_;

    #$self->adp->schema
    my $strain_data;

}

1;
