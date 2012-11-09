
package StockCenter::Type;

use strict;
use namespace::autoclean;
use Moose;

#has 'type' => ();

#has 'headers' => (
#    required   => 1,
#    is         => 'rw',
#    isa        => 'HashRef',
#    dependency => All['file'],
#    trigger    => sub {
#        my ($self) = @_;
#        my $FH = IO::File( $self->file, 'r' );
#        return StockCenter::Parser::Header->parse( $FH->getline );    
#	}

#);

#requires 'headers';
#requires 'next_row';
