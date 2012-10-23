package StockCenter::Type::Strain;

use strict;
use warnings;

use Moose;

#use MooseX::Attribute::Dependent;

with 'StockCenter::Parser';

sub validate_headers {
    my ($self) = @_;

    #print "***** $self->headers->is_empty *****";
    #print $self->headers;
}

sub next {
    my ($self) = @_;
    my $row = StockCenter::Parser::Row->new();

    #my $curr_row = $self->curr_row;
    if ( $self->curr_row == 0 && $self->headers->is_empty ) {
        $self->headers(
            StockCenter::Parser::Header->parse(
                $self->get_row( $self->curr_row )
            )
        );
        print "Getting HEADERS\n";
        $self->validate_headers();
    }

    for my $key ( $self->header_keys ) {
        my $cell = $self->spreadsheet->get_cell( $self->curr_row, $key );
        next unless ($cell);
        my $header = $self->get_value($key);
		my $value = $cell->value();
        $row->$header( $value );
    }

}

1;
