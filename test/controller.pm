use DBI;
use strict;
use warnings;
do './database.pm';

sub show {
   my $self = shift;

   # Connect to the database
   my $dbh = connect_to_db();

   # test query add
   # my $query = qq(
   #    INSERT INTO actor 
   #    (first_name, last_name, last_update) 
   #    VALUES ('sinh', 'sun', NOW());
   # );

   # test query delete
   # my $query = qq(
   #    DELETE FROM actor 
   #    WHERE actor_id = 270;
   # );

   # test query update
   my $query = qq(
      UPDATE actor 
      SET first_name = 'sinh', last_name = 'cong' 
      WHERE actor_id = 271;
   );

   # Prepare and execute a SELECT statement
   my $sth = $dbh->prepare($query);

   # Show error if false 
   my $rv = $sth->execute() or die $DBI::errstr;

   print "$query,\n";

   # show item put out 
   ($rv < 0) ? print $DBI::errstr : print "Operation done successfully\n";

   # while(my @row = $sth->fetchrow_array()) {
   #    print "ID         : ".   $row[0] ."\n";
   #    print "FIRSTNAME  : ".   $row[1] ."\n";
   #    print "LASTNAME   : ".   $row[2] ."\n";
   # }

   $sth->finish();

   # Disconnect from the database
   $dbh->disconnect();
   return;
}

#Sử dụng controller qua router
show();



