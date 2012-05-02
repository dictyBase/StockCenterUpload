package StockCenter;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  	my $self = shift;

  	# Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
  	$self->plugin('PODRenderer');

	my $db = $self->home->rel_file('db/upload.db');
	$self->plugin('database',  {
  		dsn => "dbi:SQLite:dbname=$db",
  		helper => 'upload_db'
  	});

  	# Routes
  	my $r = $self->routes;
  	$r->get('/' => sub {
  		my ($self) = @_;
  		$self->redirect_to('new_upload');
  	});
  	$r->get('/uploads')->to('upload#index');
  	$r->route('/uploads/search', format => 'datatable')->via('get')->to('upload#search');
  	$r->get('/uploads/new')->name('new_upload')->to('upload#new_record');
  	$r->post('/uploads')->name('upload')->to('upload#create');
}

1;
