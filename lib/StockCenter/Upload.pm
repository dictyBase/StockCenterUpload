package StockCenter::Upload;

use Mojo::Base 'Mojolicious::Controller';
use Data::Dump qw/pp/;
use StockCenter::Parser;

#
sub new_record {
}

# 
sub create {
	my ($self) = @_;
    my $db = $self->upload_db;
    my $sth = $db->prepare("INSERT INTO uploaded_file(name, size) VALUES(?, ?)");
    my ($upload) = @{ $self->req->uploads };
    my $filename = $upload->filename;
    $sth->execute( $filename, $upload->size );
    my $id = $db->last_insert_id( "", "", "", "" );
    $upload->move_to(
		#$self->app->home->rel_file( "uploads/" . $id . "_" . $filename )
		$self->app->home->rel_file( "uploads/" . $filename )
    );
    my $headers = $self->res->headers;
    $headers->content_type('text/plain');
    $headers->location( $self->url_for("uploads/$id")->to_abs );
	#$self->rendered(201);
	my $file = $self->app->home->rel_file("uploads/".$filename);
	my $parser = StockCenter::Parser->new(file => $file);
	my $row;
	print "********** Hello World !!! **********\n";
	while ($parser->has_next()) {
		print "*** In the loop ***\n";
		$row = $parser->next();
		print $row->stored_by."\n";
	}
	$self->rendered(201);
}

#
sub index {
}

# Search local SQLite database for upload history
sub search {
    my ($self) = @_;
    my $limit  = $self->param('iDisplayLength');
    my $offset = $self->param('iDisplayStart');
    my $db = $self->upload_db;
    my $sth = $db->prepare(
        "SELECT name, size, created_at FROM uploaded_file LIMIT $offset,$limit"
    );
    my $cth = $db->prepare("SELECT count(id) FROM uploaded_file");
    my ($total) = $db->selectrow_array($cth);
    my $arr = $db->selectall_arrayref($sth);

    $self->render_json(
        {   sEcho                => $self->param('sEcho'),
            iTotalRecords        => $total,
            iTotalDisplayRecords => $total,
            aaData               => $arr
        }
    );
}

1;
