
package StockCenter::Parser;

=head1 NAME

=head1 SYNOPSIS

=cut

use strict;
use Moose;
use Spreadsheet::ParseExcel;
use namespace::autoclean;

has 'file' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ( $self, $file ) = @_;
        my $sp = $self->parser->parse($file);
        $self->row_max( ( $sp->row_range() )[1] );
        $self->spreadsheet($sp);
    }
);

has 'parser' => (
    is      => 'rw',
    isa     => 'Spreadsheet::ParseExcel',
    default => sub {
        my ($self) = @_;
        return Spreadsheet::ParseExcel->new();
    },
    lazy => 1
);

has 'spreadsheet' => (
    is        => 'rw',
    isa       => 'Spreadsheet::ParseExcel',
    predicate => 'has_spreadsheet'
);

has 'curr_row' => (
    is  => 'rw',
    isa => 'Int'
);

has 'row_max' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
    lazy    => 1
);

sub has_next {
    my ($self) = @_;

    if ( $self->curr_row <= $self->row_max ) {
        $self->curr_row( $self->curr_row + 1 );
        return 1;
    }
}


sub next {
    my ($self) = @_;
    my $curr_row = $self->curr_row;
    $row = StockCenter::Parser::Row->new();
    $row->strain_desc( $spreadsheet->get_cell( $curr_row, 0 ) );
    $row->location( $spreadsheet->get_cell( $curr_row, 1 ) );
    $row->stored_by( $spreadsheet->get_cell( $curr_row, 2 ) );
    $row->storage_date( $spreadsheet->get_cell( $curr_row, 3 ) );
    $row->num_vials( $spreadsheet->get_cell( $curr_row, 4 ) );
    $row->color( $spreadsheet->get_cell( $curr_row, 5 ) );
    $row->comments( $spreadsheet->get_cell( $curr_row, 6 ) );
    return $row;
}

#before 'next' => sub {
#	my ($self) = @_;
#	croak "No spreadsheet is given\n" if !$self->has_spreadsheet;
#};
#

1;

