use utf8;
package My::Uploader::Result::StockCenterUpload;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

My::Uploader::Result::StockCenterUpload

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<StockCenterUpload>

=cut

__PACKAGE__->table("StockCenterUpload");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 strain_id

  data_type: 'text'
  is_nullable: 1

=head2 location

  data_type: 'text'
  is_nullable: 1

=head2 no_of_vials

  data_type: 'integer'
  is_nullable: 1

=head2 color

  data_type: 'text'
  is_nullable: 1

=head2 stored_by

  data_type: 'text'
  is_nullable: 1

=head2 storage_date

  data_type: 'text'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "strain_id",
  { data_type => "text", is_nullable => 1 },
  "location",
  { data_type => "text", is_nullable => 1 },
  "no_of_vials",
  { data_type => "integer", is_nullable => 1 },
  "color",
  { data_type => "text", is_nullable => 1 },
  "stored_by",
  { data_type => "text", is_nullable => 1 },
  "storage_date",
  { data_type => "text", is_nullable => 1 },
  "comments",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07022 @ 2012-05-03 14:02:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g9mNbRh58xLOEDzmSUcwPw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
