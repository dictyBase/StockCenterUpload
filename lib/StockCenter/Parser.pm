
package StockCenter::Parser;

use strict;
use namespace::autoclean;

#use Moose;
use Spreadsheet::ParseExcel;
use StockCenter::Parser::Row;
use StockCenter::Parser::Header;

use Moose::Role;
requires 'validate_headers', 'next';

# Excel file to be read
has 'file' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ( $self, $file ) = @_;
		my $FH = IO::File->new($file);
		$self->headers(StockCenter::Parser::Header->parse($FH->getline));
        my $workbook = $self->parser->parse($file);
        if ( !$workbook ) {
            die $self->parser->error, " :problem\n";
        }
        my $sp = $workbook->worksheet(0);
        my ( $rmin, $rmax ) = $sp->row_range();
        my ( $cmin, $cmax ) = $sp->col_range();
        $self->curr_row(1);
        $self->row_max($rmax);
        $self->col_max($cmax);
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

has 'headers' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef',
    handles => {
        get_value   => 'get',
        is_empty    => 'is_empty',
        count       => 'count',
        header_keys => 'keys'
    }
);

# Spreadsheet::ParseExcel object of the file to be read
has 'spreadsheet' => (
    is        => 'rw',
    isa       => 'Spreadsheet::ParseExcel::Worksheet',
    predicate => 'has_spreadsheet'
);

# Maximum number of entries in the excel file
has [qw/row_max col_max curr_row/] => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
    lazy    => 1
);

sub get_row {
    my ( $self, $row_num ) = @_;
    my $row;
    for ( my $c = 0; $c < $self->col_max; $c++ ) {
		print "Getting HEADER from $row, $c\n";
        $row = $row . $self->spreadsheet->get_cell( $row_num, $c );
        $row = $row . "\t";
    }
    return chomp($row);
}

# Method to check if next element exists
sub has_next {
    my ($self) = @_;
    if ( $self->curr_row <= $self->row_max ) {
        $self->curr_row( $self->curr_row + 1 );
        return 1;
    }
}

# Method to return next entry as object of StockCenter::Parser::Row
#sub next {
#    my ($self)      = @_;
#    my $curr_row    = $self->curr_row;
#    my $row         = StockCenter::Parser::Row->new();
#    my $spreadsheet = $self->spreadsheet;
#
#    if ( $self->curr_row == 0 && $self->headers->is_empty ) {
#        $self->headers(
#            StockCenter::Parser::Header->parse(
#                $self->get_row( $self->curr_row )
#            )
#        );
#    }
#
#    for my $key ( $self->header_keys ) {
#        my $cell = $spreadsheet->get_cell( $curr_row, $key );
#        next unless ($cell);
#        my $meth_name = $self->get_value($key);
#        my $value     = $cell->value();
#        if ( $meth_name eq 'num_vials' ) {
#            $value = int($value);
#        }
#        $row->$meth_name($value);
#    }
#    return $row;
#}
#
1;
