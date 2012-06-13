
package DBCon::Uploader::Result::StockCenter;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('StockCenter');
__PACKAGE__->add_columns(
    qw/ id strain_desc location num_vials color stored_by storage_date comments /
);
__PACKAGE__->set_primary_key('id');

1;