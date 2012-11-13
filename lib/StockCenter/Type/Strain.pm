
package StockCenter::Type::Strain;

use strict;

use Moose;

use StockCenter::Parser::Row;
with 'StockCenter::Parser';
with 'StockCenter::Parser::Header';

sub validate_headers {
    my ($self) = @_;
}

sub next {
    my ($self) = @_;
    my $row = StockCenter::Parser::Row->new();
    if ( $self->curr_row == 0 && $self->has_no_headers ) {
        my $row = $self->get_row( $self->curr_row );
        $self->parse_headers($row);
        $self->curr_row( $self->curr_row + 1 );
    }

    for my $key ( $self->header_keys ) {
        my $cell = $self->spreadsheet->get_cell( $self->curr_row, $key );
        next unless ($cell);
        my $header = $self->get_header($key);
        my $value  = $cell->value();
        $row->set_row( $header => $value );
    }
    $self->curr_row( $self->curr_row + 1 );
    return $row;
}

1;
