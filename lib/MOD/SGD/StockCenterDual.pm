package MOD::SGD::StockCenterDual;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("Dual");
__PACKAGE__->add_columns(
    "dummy",
    {   data_type   => "NUMBER",
        is_nullable => 0,
        size        => 1,
    }
);
1;
