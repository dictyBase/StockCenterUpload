package MyHelper;

package MySchema::UnCurated;

use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('uncurated');
__PACKAGE__->add_columns(
    "feature_id",
    {   data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "dbxref_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "organism_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "name",
    {   data_type     => "character varying",
        default_value => undef,
        is_nullable   => 1,
        size          => 255,
    },
    "uniquename",
    { data_type => "text", default_value => undef, is_nullable => 0 },
    "residues",
    { data_type => "text", default_value => undef, is_nullable => 1 },
    "seqlen",
    { data_type => "integer", default_value => undef, is_nullable => 1 },
    "md5checksum",
    {   data_type     => "character",
        default_value => undef,
        is_nullable   => 1,
        size          => 32,
    },
    "type_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "is_analysis",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_obsolete",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_deleted",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "timeaccessioned",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "timelastmodified",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[SELECT gene_features.*
        FROM feature gene_features JOIN cvterm gtype ON gene_features
        . TYPE_ID
        = gtype 
        . cvterm_id JOIN organism ON gene_features 
        . organism_id
        = organism 
        . organism_id WHERE gtype 
        . name
        = 'gene' AND gene_features 
        . is_deleted  = 0 AND organism
        . common_name = 'dicty' AND NOT EXISTS(
              SELECT gene_features
            . feature_id FROM feature verified_features JOIN
            feature_relationship frel ON verified_features 
            . feature_id
            = frel 
            . subject_id JOIN cvterm ftype ON ftype 
            . cvterm_id
            = frel 
            . TYPE_ID JOIN cvterm vtype ON verified_features 
            . TYPE_ID
            = vtype
            . cvterm_id JOIN feature_dbxref fdbxref ON fdbxref
            . feature_id
            = verified_features 
            . feature_id JOIN dbxref ON dbxref 
            . dbxref_id
            = fdbxref 
            . dbxref_id JOIN db ON db 
            . db_id
            = dbxref 
            . db_id WHERE vtype 
            . name = 'mRNA' AND db 
            . name
            = 'GFF_source' AND dbxref 
            . accession
            = 'dictyBase Curator' AND ftype 
            . name
            = 'part_of' AND verified_features 
            . is_deleted
            = 0 AND gene_features 
            . feature_id = frel 
            . object_id
        )
 		  AND NOT EXISTS (
          SELECT gene_features.feature_id
              FROM feature ncrna join cvterm nctype on nctype.cvterm_id=ncrna.type_id
                  join feature_relationship ncfrel ON ncrna.feature_id=ncfrel.subject_id
                      join cvterm ncreltype on ncfrel.type_id=ncreltype.cvterm_id
                      where (nctype.name = 'tRNA' OR nctype.name like '%snoRNA%' OR
                      nctype.name = 'ncRNA'
                      OR nctype.name like 'class%RNA' or nctype.name = 'rRNA' OR 
                      nctype.name = 'snRNA' OR nctype.name LIKE 'RNase%'
                      OR nctype.name LIKE 'SRP%' )
                      AND gene_features.feature_id=ncfrel.object_id
                      AND ncrna.is_deleted=0
                      AND ncreltype.name = 'part_of')
        ]
);

__PACKAGE__->belongs_to(
    "dbxref",
    "Bio::Chado::Schema::General::Dbxref",
    { dbxref_id => "dbxref_id" },
    { join_type => "LEFT" },
);

1;

package MySchema::Curated;

use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('uncurated');
__PACKAGE__->add_columns(
    "feature_id",
    {   data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "dbxref_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "organism_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "name",
    {   data_type     => "character varying",
        default_value => undef,
        is_nullable   => 1,
        size          => 255,
    },
    "uniquename",
    { data_type => "text", default_value => undef, is_nullable => 0 },
    "residues",
    { data_type => "text", default_value => undef, is_nullable => 1 },
    "seqlen",
    { data_type => "integer", default_value => undef, is_nullable => 1 },
    "md5checksum",
    {   data_type     => "character",
        default_value => undef,
        is_nullable   => 1,
        size          => 32,
    },
    "type_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "is_analysis",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_obsolete",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_deleted",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "timeaccessioned",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "timelastmodified",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[SELECT gene_features.*
        FROM feature gene_features JOIN cvterm gtype ON gene_features
        . TYPE_ID
        = gtype 
        . cvterm_id JOIN organism ON gene_features 
        . organism_id
        = organism 
        . organism_id WHERE gtype 
        . name
        = 'gene' AND gene_features 
        . is_deleted  = 0 AND organism
        . common_name = 'dicty' AND EXISTS(
              SELECT gene_features
            . feature_id FROM feature verified_features JOIN
            feature_relationship frel ON verified_features 
            . feature_id
            = frel 
            . subject_id JOIN cvterm ftype ON ftype 
            . cvterm_id
            = frel 
            . TYPE_ID JOIN cvterm vtype ON verified_features 
            . TYPE_ID
            = vtype
            . cvterm_id JOIN feature_dbxref fdbxref ON fdbxref
            . feature_id
            = verified_features 
            . feature_id JOIN dbxref ON dbxref 
            . dbxref_id
            = fdbxref 
            . dbxref_id JOIN db ON db 
            . db_id
            = dbxref 
            . db_id WHERE vtype 
            . name = 'mRNA' AND db 
            . name
            = 'GFF_source' AND dbxref 
            . accession
            = 'dictyBase Curator' AND ftype 
            . name
            = 'part_of' AND verified_features 
            . is_deleted
            = 0 AND gene_features 
            . feature_id = frel 
            . object_id
        )
        AND NOT EXISTS (
          SELECT gene_features.feature_id
              FROM feature ncrna join cvterm nctype on nctype.cvterm_id=ncrna.type_id
                  join feature_relationship ncfrel ON ncrna.feature_id=ncfrel.subject_id
                      join cvterm ncreltype on ncfrel.type_id=ncreltype.cvterm_id
                      where (nctype.name = 'tRNA' OR nctype.name like '%snoRNA%' OR
                      nctype.name = 'ncRNA'
                      or nctype.name like 'class%RNA' or nctype.name = 'rRNA')
                      AND gene_features.feature_id=ncfrel.object_id
                      AND ncrna.is_deleted=0
                      AND ncreltype.name = 'part_of')

        ]
);

__PACKAGE__->belongs_to(
    "dbxref",
    "Bio::Chado::Schema::General::Dbxref",
    { dbxref_id => "dbxref_id" },
    { join_type => "LEFT" },
);

1;

package MySchema::CuratedStd;

use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('uncurated');
__PACKAGE__->add_columns(
    "feature_id",
    {   data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "dbxref_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "organism_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "name",
    {   data_type     => "character varying",
        default_value => undef,
        is_nullable   => 1,
        size          => 255,
    },
    "uniquename",
    { data_type => "text", default_value => undef, is_nullable => 0 },
    "residues",
    { data_type => "text", default_value => undef, is_nullable => 1 },
    "seqlen",
    { data_type => "integer", default_value => undef, is_nullable => 1 },
    "md5checksum",
    {   data_type     => "character",
        default_value => undef,
        is_nullable   => 1,
        size          => 32,
    },
    "type_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "is_analysis",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_obsolete",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_deleted",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "timeaccessioned",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "timelastmodified",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[SELECT gene_features.*
        FROM feature gene_features JOIN cvterm gtype ON gene_features
        . TYPE_ID
        = gtype 
        . cvterm_id JOIN organism ON gene_features 
        . organism_id
        = organism 
        . organism_id WHERE gtype 
        . name
        = 'gene' AND gene_features 
        . is_deleted  = 0 AND organism
        . common_name = 'dicty' AND EXISTS(
              SELECT gene_features
            . feature_id FROM feature verified_features JOIN
            feature_relationship frel ON verified_features 
            . feature_id
            = frel 
            . subject_id JOIN cvterm ftype ON ftype 
            . cvterm_id
            = frel 
            . TYPE_ID JOIN cvterm vtype ON verified_features 
            . TYPE_ID
            = vtype
            . cvterm_id JOIN feature_dbxref fdbxref ON fdbxref
            . feature_id
            = verified_features 
            . feature_id JOIN dbxref ON dbxref 
            . dbxref_id
            = fdbxref 
            . dbxref_id JOIN db ON db 
            . db_id
            = dbxref 
            . db_id WHERE vtype 
            . name = 'mRNA' AND db 
            . name
            = 'GFF_source' AND dbxref 
            . accession
            = 'dictyBase Curator' AND ftype 
            . name
            = 'part_of' AND verified_features 
            . is_deleted
            = 0 AND gene_features 
            . feature_id = frel 
            . object_id
        )
      ]
);

__PACKAGE__->belongs_to(
    "dbxref",
    "Bio::Chado::Schema::General::Dbxref",
    { dbxref_id => "dbxref_id" },
    { join_type => "LEFT" },
);

1;

package MySchema::UnCuratedF;

use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('uncurated');
__PACKAGE__->add_columns(
    "feature_id",
    {   data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "dbxref_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "organism_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "name",
    {   data_type     => "character varying",
        default_value => undef,
        is_nullable   => 1,
        size          => 255,
    },
    "uniquename",
    { data_type => "text", default_value => undef, is_nullable => 0 },
    "residues",
    { data_type => "text", default_value => undef, is_nullable => 1 },
    "seqlen",
    { data_type => "integer", default_value => undef, is_nullable => 1 },
    "md5checksum",
    {   data_type     => "character",
        default_value => undef,
        is_nullable   => 1,
        size          => 32,
    },
    "type_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "is_analysis",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_obsolete",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_deleted",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "timeaccessioned",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "timelastmodified",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[SELECT gene_features.*
        FROM feature gene_features JOIN cvterm gtype ON gene_features
        . TYPE_ID
        = gtype 
        . cvterm_id JOIN organism ON gene_features 
        . organism_id
        = organism 
        . organism_id WHERE gtype 
        . name
        = 'gene' AND gene_features 
        . is_deleted  = 0 AND organism
        . common_name = 'dicty' AND
        gene_features.name NOT LIKE '%_TE%'
        AND gene_features.name NOT LIKE '%RTE%'
        AND gene_features.name NOT LIKE '%_ps%'
        AND NOT EXISTS(
              SELECT gene_features
            . feature_id FROM feature verified_features JOIN
            feature_relationship frel ON verified_features 
            . feature_id
            = frel 
            . subject_id JOIN cvterm ftype ON ftype 
            . cvterm_id
            = frel 
            . TYPE_ID JOIN cvterm vtype ON verified_features 
            . TYPE_ID
            = vtype
            . cvterm_id JOIN feature_dbxref fdbxref ON fdbxref
            . feature_id
            = verified_features 
            . feature_id JOIN dbxref ON dbxref 
            . dbxref_id
            = fdbxref 
            . dbxref_id JOIN db ON db 
            . db_id
            = dbxref 
            . db_id WHERE vtype 
            . name = 'mRNA' AND db 
            . name
            = 'GFF_source' AND dbxref 
            . accession
            = 'dictyBase Curator' AND ftype 
            . name
            = 'part_of' AND verified_features 
            . is_deleted
            = 0 AND gene_features 
            . feature_id = frel 
            . object_id
        )
        AND NOT EXISTS (
          SELECT gene_features.feature_id
              FROM feature ncrna join cvterm nctype on nctype.cvterm_id=ncrna.type_id
                  join feature_relationship ncfrel ON ncrna.feature_id=ncfrel.subject_id
                      join cvterm ncreltype on ncfrel.type_id=ncreltype.cvterm_id
                      where (nctype.name = 'tRNA' OR nctype.name like '%snoRNA%' OR
                      nctype.name = 'ncRNA'
                      or nctype.name like 'class%RNA' or nctype.name = 'rRNA' or
                      nctype.name = 'snRNA' OR nctype.name LIKE 'RNase%'
                      OR nctype.name LIKE 'SRP%'
                      )
                      AND gene_features.feature_id=ncfrel.object_id
                      AND ncrna.is_deleted=0
                      AND ncreltype.name = 'part_of')
        ]
);

__PACKAGE__->belongs_to(
    "dbxref",
    "Bio::Chado::Schema::General::Dbxref",
    { dbxref_id => "dbxref_id" },
    { join_type => "LEFT" },
);

1;

package MySchema::UnCuratedF::Chromosome;

use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('uncurated');
__PACKAGE__->add_columns(
    "feature_id",
    {   data_type         => "integer",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    "dbxref_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    "organism_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "name",
    {   data_type     => "character varying",
        default_value => undef,
        is_nullable   => 1,
        size          => 255,
    },
    "uniquename",
    { data_type => "text", default_value => undef, is_nullable => 0 },
    "residues",
    { data_type => "text", default_value => undef, is_nullable => 1 },
    "seqlen",
    { data_type => "integer", default_value => undef, is_nullable => 1 },
    "md5checksum",
    {   data_type     => "character",
        default_value => undef,
        is_nullable   => 1,
        size          => 32,
    },
    "type_id",
    {   data_type      => "integer",
        default_value  => undef,
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    "is_analysis",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_obsolete",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "is_deleted",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 },
    "timeaccessioned",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
    "timelastmodified",
    {   data_type     => "timestamp without time zone",
        default_value => \"now()",
        is_nullable   => 0,
    },
);
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[SELECT gene_features.*
        FROM feature gene_features JOIN cvterm gtype ON gene_features
        . TYPE_ID
        = gtype 
        . cvterm_id JOIN organism ON gene_features 
        . organism_id
        = organism 
        . organism_id 
        JOIN featureloc floc on floc.feature_id = gene_features.feature_id
        JOIN feature chromosome on chromosome.feature_id = floc.srcfeature_id
        WHERE gtype 
        . name
        = 'gene' AND gene_features 
        . is_deleted  = 0 AND organism
        . common_name = 'dicty' AND
        gene_features.name NOT LIKE '%_TE%'
        AND gene_features.name NOT LIKE '%RTE%'
        AND gene_features.name NOT LIKE '%_ps%'
        AND chromosome.uniquename = ?
        AND NOT EXISTS(
              SELECT gene_features
            . feature_id FROM feature verified_features JOIN
            feature_relationship frel ON verified_features 
            . feature_id
            = frel 
            . subject_id JOIN cvterm ftype ON ftype 
            . cvterm_id
            = frel 
            . TYPE_ID JOIN cvterm vtype ON verified_features 
            . TYPE_ID
            = vtype
            . cvterm_id JOIN feature_dbxref fdbxref ON fdbxref
            . feature_id
            = verified_features 
            . feature_id JOIN dbxref ON dbxref 
            . dbxref_id
            = fdbxref 
            . dbxref_id JOIN db ON db 
            . db_id
            = dbxref 
            . db_id WHERE vtype 
            . name = 'mRNA' AND db 
            . name
            = 'GFF_source' AND dbxref 
            . accession
            = 'dictyBase Curator' AND ftype 
            . name
            = 'part_of' AND verified_features 
            . is_deleted
            = 0 AND gene_features 
            . feature_id = frel 
            . object_id
        )
        AND NOT EXISTS (
          SELECT gene_features.feature_id
              FROM feature ncrna join cvterm nctype on nctype.cvterm_id=ncrna.type_id
                  join feature_relationship ncfrel ON ncrna.feature_id=ncfrel.subject_id
                      join cvterm ncreltype on ncfrel.type_id=ncreltype.cvterm_id
                      where (nctype.name = 'tRNA' OR nctype.name like '%snoRNA%' OR
                      nctype.name = 'ncRNA'
                      or nctype.name like 'class%RNA' or nctype.name = 'rRNA' or
                      nctype.name = 'snRNA' OR nctype.name LIKE 'RNase%'
                      OR nctype.name LIKE 'SRP%'
                      )
                      AND gene_features.feature_id=ncfrel.object_id
                      AND ncrna.is_deleted=0
                      AND ncreltype.name = 'part_of')
        ]
);

__PACKAGE__->belongs_to(
    "dbxref",
    "Bio::Chado::Schema::General::Dbxref",
    { dbxref_id => "dbxref_id" },
    { join_type => "LEFT" },
);

1;

package MySchema;
use strict;
use base qw/Bio::Chado::Schema/;

__PACKAGE__->register_class( 'DictyUnCurated'  => 'MySchema::UnCurated' );
__PACKAGE__->register_class( 'DictyCurated'    => 'MySchema::Curated' );
__PACKAGE__->register_class( 'DictyCuratedS'   => 'MySchema::CuratedStd' );
__PACKAGE__->register_class( 'DictyUnCuratedF' => 'MySchema::UnCuratedF' );
__PACKAGE__->register_class(
    'DictyUnCuratedF::Chr' => 'MySchema::UnCuratedF::Chromosome' );

1;

