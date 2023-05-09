use DBI;
use strict;
use warnings;

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
