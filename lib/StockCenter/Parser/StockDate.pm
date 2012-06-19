
package StockCenter::Parser::StockDate;

use strict;
use MooseX::Types -declare => [qw/StockDate/];
use MooseX::Types::Moose qw/Str/;

subtype StockDate, as Str, where {/^^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/};

1;

