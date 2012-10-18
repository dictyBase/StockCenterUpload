package StockCenter::Type::Strain;

use strict;
use warnings;

use Moose;
use MooseX::Attribute::Dependent;

has 'headers' => (
    required   => 1,
    is         => 'rw',
    isa        => 'HashRef',
    lazy       => 1,
    dependency => All ['file'],
    trigger    => sub {
        my ($self) = @_;
        my $FH = IO::File( $self->file, 'r' );
        return StockCenter::Parser::Header->parse( $FH->getline );    
	}

);

has 'file' => (

);


