
package StockCenter::Parser;

=head1 NAME

=head1 SYNOPSIS

=cut

use strict;
use Moose;
use Spreadsheet::ParseExcel;
use StockCenter::Parser::Row;
use namespace::autoclean;

# Excel file to be read
has 'file' => (
    is      => 'rw',
    isa     => 'Str',
    trigger => sub {
        my ( $self, $file ) = @_;
        my $workbook = $self->parser->parse($file);
		for my $sp ( $workbook->worksheets() ) {
			#my $sp = ($workbook->worksheets())[0];
			my ($min, $max) = $sp->row_range();
			print $max."\n";
			$self->curr_row(0);
        	$self->row_max($max);
        	$self->spreadsheet($sp);
    	}
	}
);

# Object of the class Spreadsheet::ParseExcel
has 'parser' => (
    is      => 'rw',
    isa     => 'Spreadsheet::ParseExcel',
    default => sub {
        my ($self) = @_;
        return Spreadsheet::ParseExcel->new();
    },
    lazy => 1
);

# Spreadsheet headers in a Hash
has 'headers' => (
	is => 'ro',
	isa => 'Hash',
	default => %header 

);

# Spreadsheet::ParseExcel object of the file to be read
has 'spreadsheet' => (
    is        => 'rw',
    isa       => 'Spreadsheet::ParseExcel::Worksheet',
    predicate => 'has_spreadsheet'
);

# Counter to maintain position of current row
has 'curr_row' => (
    is  => 'rw',
    isa => 'Int',
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
		# print "Yes, there is an entry.\n";
        return 1;
    }
}

# Method to return next entry as object of StockCenter::Parser::Row
sub next {
    my ($self) = @_;
    my $curr_row = $self->curr_row;
    my $row = StockCenter::Parser::Row->new();
	my $spreadsheet = $self->spreadsheet;
    $row->strain_desc( ($spreadsheet->get_cell( $curr_row, 0 ))->value() );
    $row->location( ($spreadsheet->get_cell( $curr_row, 1 ))->value() );
    $row->stored_by( ($spreadsheet->get_cell( $curr_row, 2 ))->value() );
    $row->storage_date( ($spreadsheet->get_cell( $curr_row, 3 ))->value() );
    $row->num_vials( ($spreadsheet->get_cell( $curr_row, 4 ))->value() );
    $row->color( ($spreadsheet->get_cell( $curr_row, 5 ))->value() );
    $row->comments( ($spreadsheet->get_cell( $curr_row, 6 ))->value() );
    return $row;
}

1;

