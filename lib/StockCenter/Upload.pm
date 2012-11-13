
package StockCenter::Upload;

use strict;
use warnings;

use Mojo::Base 'Mojolicious::Controller';
use Data::Dump qw/pp/;
use StockCenter::Type::Strain;
use File::Temp;

sub new_record {
    my ($self) = @_;
    $self->render( template => 'uploads' );
}

sub create {
    my ($self) = @_;
    my $db     = $self->upload_db;
    my $sth    = $db->prepare(
        "INSERT INTO uploaded_file(file, size, type) VALUES(?, ?, ?)");
    my ($upload) = @{ $self->req->uploads };
    my $filename = $upload->filename;
    my $type     = 'Strain';
    my $filesize = $upload->size / 1000;
    $sth->execute( $filename, $filesize . " KB", $type );
    my $id = $db->last_insert_id( "", "", "", "" );

    my $temp_file = File::Temp->new( SUFFIX => '.dat' );
    $upload->move_to($temp_file);
    $self->app->log->info('File uploaded to /tmp');

#$upload->move_to($self->app->home->rel_file( "uploads/" . $id . "_" . $filename ) );
    my $headers = $self->res->headers;
    $headers->content_type('text/plain');

    #$headers->location( $self->url_for("uploads/$id")->to_abs );
    my $file = $temp_file->filename;

 #my $file = $self->app->home->rel_file( "uploads/" . $id . "_" . $filename );

 	
    $self->app->log->debug('Parsing & loading');
    my $parser = StockCenter::Type::Strain->new;
    $parser->file($file);
	my $adapter = $self->adapter;
    while ( $parser->has_next() ) {
        my $row = $parser->next();
		#for my $k ( $row->row_keys ) {
		#    $self->app->log->debug( $k . " -> " . $row->get_row($k) );
		#}
		#$parser->insert($row);
        $adapter->insert_strain($row);
    }
    $self->rendered(201);
    return;

}

sub search {
    my ($self) = @_;
    my $limit  = $self->param('iDisplayLength');
    my $offset = $self->param('iDisplayStart');
    my $db     = $self->upload_db;
    my $sth
        = $db->prepare(
        "SELECT file, size, type, uploaded_on FROM uploaded_file LIMIT $offset,$limit"
        );
    my $cth     = $db->prepare("SELECT count(id) FROM uploaded_file");
    my ($total) = $db->selectrow_array($cth);
    my $arr     = $db->selectall_arrayref($sth);

    $self->render_json(
        {   sEcho                => $self->param('sEcho'),
            iTotalRecords        => $total,
            iTotalDisplayRecords => $total,
            aaData               => $arr
        }
    );
    return;
}

1;
