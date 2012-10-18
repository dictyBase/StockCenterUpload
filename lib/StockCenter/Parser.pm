
package StockCenter::Parser;

use strict;
use namespace::autoclean;
use Moose;
use Spreadsheet::ParseExcel;
use StockCenter::Parser::Row;

# Excel file to be read
has 'file' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ( $self, $file ) = @_;
        my $workbook = $self->parser->parse($file);
        if ( !$workbook ) {
            die $self->parser->error, " :problem\n";
        }
        my $sp = $workbook->worksheet(0);
        my ( $min, $max ) = $sp->row_range();
        $self->curr_row(0);
        $self->row_max($max);
        $self->spreadsheet($sp);
    }
);

# Object of the class Spreadsheet::ParseExcel
has 'parser' => (
    is      => 'rw',
    isa     => 'Spreadsheet::ParseExcel',
    default => sub {
        return Spreadsheet::ParseExcel->new();
    },
    lazy => 1
);

# Spreadsheet headers in a Hash
has 'headers' => (
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        {   '0' => 'strain_desc',
            '1' => 'location',
            '2' => 'stored_by',
            '3' => 'storage_date',
            '4' => 'num_vials',
            '5' => 'color',
            '6' => 'comments'
        };
    },
    handles => {
        get_value   => 'get',
        is_empty    => 'is_empty',
        count       => 'count',
        header_keys => 'keys'
    },
);

# Spreadsheet::ParseExcel object of the file to be read
has 'spreadsheet' => (
    is        => 'rw',
    isa       => 'Spreadsheet::ParseExcel::Worksheet',
    predicate => 'has_spreadsheet'
);

# Counter to maintain position of current row
has 'curr_row' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0
);

# Maximum number of entries in the excel file
has 'row_max' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
    lazy    => 1
);

# Method to check if next element exists
sub has_next {
    my ($self) = @_;
    if ( $self->curr_row <= $self->row_max ) {
        $self->curr_row( $self->curr_row + 1 );
        return 1;
    }
}

# Method to return next entry as object of StockCenter::Parser::Row
sub next {
    my ($self)      = @_;
    my $curr_row    = $self->curr_row;
    my $row         = StockCenter::Parser::Row->new();
    my $spreadsheet = $self->spreadsheet;

    for my $key ( $self->header_keys ) {
        my $cell = $spreadsheet->get_cell( $curr_row, $key );
        next unless ($cell);
        my $meth_name = $self->get_value($key);
        my $value     = $cell->value();
        if ( $meth_name eq 'num_vials' ) {
            $value = int($value);
        }
        $row->$meth_name($value);
    }
    return $row;
}

1;

