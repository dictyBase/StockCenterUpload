
package StockCenter::Parser::Header;

use strict;
use Moose;

sub parse {
    my ( $self, $headers ) = @_;
    my @vals = split( '\t', $headers );
    my $hashRef = {};
    for ( my $i = 0; $i < scalar(@vals); $i++ ) {
        $hashRef->{$i} = $vals[$i];
    }
	return $hashRef;
}

1;