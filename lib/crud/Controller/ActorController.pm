package crud::Controller::ActorController;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use DBI;
use strict;
use warnings;

# Connect to database postgres
sub connect_db_pg {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";
  return $dbh;
}
# Action showData
sub show {
  my $self = shift;
  # use function connect database
  my $dbh = connect_db_pg();
  # string query to database
  my $sth = $dbh->prepare(qq(SELECT * FROM actor ORDER BY actor_id DESC LIMIT 5;));
  # Show error if false 
  my $rv = $sth->execute() or die $DBI::errstr;
  # show item put out
  ($rv < 0) ? print $DBI::errstr : print "Operation done successfully\n"; 
  # array of data
  my @rows;
  while (my $row = $sth->fetchrow_hashref) {
    push @rows, $row;
  }
  $sth->finish();
  $dbh->disconnect();
  $self->render(
    rows      => \@rows,
    template  => "myTemplates/list"
  );
  return;
}
# Action formAdd
sub fromAdd {
  my $self = shift;
  $self->render(
    template => 'myTemplates/add'
  );
}
# Action Add
sub add {
  my $self = shift;
  # use function connect database
  my $dbh = connect_db_pg();
  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');
  my $last_update = $self->param('last_update');
  # string query to database
  my $query = qq(INSERT INTO actor (first_name, last_name, last_update) VALUES ('$first_name', '$last_name', NOW()););
  my $sth = $dbh->prepare($query);
  # Show error if false 
  my $rv = $sth->execute() or die $DBI::errstr;
  ($rv < 0) ? print $DBI::errstr : print "Operation done successfully\n";
  $sth->finish();
  $dbh->disconnect();
  $self->redirect_to('/');
  return;
}
# Action Delete
sub delete {
  my $self = shift;
  # use function connect database
  my $dbh = connect_db_pg();
  my $id = $self->stash('id');
  my $sth = $dbh->prepare(qq(DELETE FROM actor WHERE actor_id = $id;));
  # string query to database
  my $rv = $sth->execute() or die $DBI::errstr;
  $self->redirect_to('/');
}
# Action formEdit
sub formUpdate {
  my $self = shift;
  # use function connect database
  my $dbh = connect_db_pg();
  my $id = $self->stash('id');
  # string query to database
  my $sth = $dbh->prepare(qq(SELECT * FROM actor WHERE actor_id = $id LIMIT 1));
  my $rv = $sth->execute() or die $DBI::errstr;
  my @rows;
  while (my $row = $sth->fetchrow_hashref) {
    push @rows, $row;
  }
  $self->render(
    rows => \@rows,
    template => 'myTemplates/update'
  );
}
# Action Edit
sub update {
  my $self = shift;
  # use function connect database
  my $dbh = connect_db_pg();
  my $id = $self->stash('id');
  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');
  my $sth = $dbh->prepare(qq(UPDATE actor SET first_name = '$first_name', last_name = '$last_name' WHERE actor_id = $id));
  my $rv = $sth->execute() or die $DBI::errstr;
  $self->redirect_to('/');
}
1;
