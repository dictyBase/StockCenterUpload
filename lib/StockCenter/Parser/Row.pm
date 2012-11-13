
package StockCenter::Parser::Row;

use strict;
use Moose;
use namespace::autoclean;

has 'row' => (
    traits  => ['Hash'],
    is      => 'rw',
    isa     => 'HashRef[Str]',
    handles => {
        get_row  => 'get',
        set_row  => 'set',
        row_keys => 'keys',
        count    => 'count'
    }
);

1;

=head1 NAME

C<StockCenter::Parser::Row> - A row class to hold data in a row as a HashRef of column header (key) and row value

=head1 DESCRIPTION

An iterator over each row of a file returns an object of this class. The key for the HashRef is the column header.

=head1 SYNOPSIS

	use StockCenter::Parser::Row;

	my $row = StockCenter::Parser::Row->new;
	$row->set_row(key => 'value' );

	print $row->get_row('key');

=over

