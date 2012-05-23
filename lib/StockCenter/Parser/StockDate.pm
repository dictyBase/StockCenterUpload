
package StockCenter::Parser::StockDate;

use MooseX::Types -declare => [qw/StockDate/];
use MooseX::Types::Moose qw/Str/;

use strict;

subtype StockDate, as Str, where {/^^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/};

