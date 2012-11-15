
package StockCenter::Type::Strain;

use strict;

use Moose;

use StockCenter::Parser::Row;
with 'StockCenter::Parser';
with 'StockCenter::Parser::Header';

sub validate_headers {
    my ($self) = @_;
    my %r = reverse $self->headers;
    if ( !exists $r{'strain_name'} ) {
        return 0;
    }
    elsif ( !exists $r{'genotype'} ) {
        return 0;
    }
    elsif ( !exists $r{'species'} ) {
        return 0;
    }
}

sub next {
    my ($self) = @_;
    my $row = StockCenter::Parser::Row->new();
    if ( $self->curr_row == 0 && $self->has_no_headers ) {
        my $row = $self->get_row( $self->curr_row );
        $self->parse_headers($row);
        $self->curr_row( $self->curr_row + 1 );
    }

    if ( $self->validate_headers() ) {
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
}

1;

__END__

=head1 NAME

C<StockCenter::Type::Strain> - A class to parse strain data

=head1 DESCRIPTION

A class comsuming the Parser & Header role for strain data

=head1 SYNOPSIS

	use StockCenter::Type::Strain;
	
	my $parser = StockCenter::Type::Strain->new;
	my $file = "sample.xls"; 
	$parser->file($file);
	
	while ($parser->has_next()) {
		my $row = $parser->next();
		for my $key ($row->row_keys) {
			print $key . "\t" . $row->get_row($key);
		}
	}

=over

