#!/usr/bin/perl -w
#
use strict;
#
use DBI;
#
my $pnames = 
[
    { fname => 'bugs', lname => 'bunny', email => 'bugs@gmail.com' },
    { fname => 'daffy', lname => 'duck', email => 'daffy@gmail.com' },
    { fname => 'elmer', lname => 'fudd', email => 'elmer@gmail.com' },
    { fname => 'wiley', lname => 'coyote', email => 'wiley@gmail.com' },
];
#
sub table_exists
{
    my ($dbh, $table_name) = @_;
    my $sth = $dbh->table_info(undef, 'public', $table_name, 'TABLE');
    $sth->execute;
    my @info = $sth->fetchrow_array;
    my $exists = scalar @info;
    return $exists;
}
#
my $prod_db_path = '/tmp/prod_db';
my $table_name = 'people';
my $pprod_db = ();
#
$pprod_db->{sqlite}->{dsn} = "dbi:SQLite:dbname=${prod_db_path}";
$pprod_db->{sqlite}->{user} = "";
$pprod_db->{sqlite}->{password} = "";
$pprod_db->{sqlite}->{dbh} = 
    DBI->connect(
        $pprod_db->{sqlite}->{dsn},
        $pprod_db->{sqlite}->{user},
        $pprod_db->{sqlite}->{password},
        {
            PrintError => 0,
            RaiseError => 1,
            AutoCommit => 1,
            FetchHashKeyName => 'NAME_lc'
        });
#
my $create_tbl = sprintf <<'END_SQL', ${table_name};
create table %s (
    id integer primary key,
    fname varchar(100),
    lname varchar(100),
    email varchar(100) unique not null,
    password varchar(20)
)
END_SQL
#
if ( ! table_exists($pprod_db->{sqlite}->{dbh}, ${table_name}))
{
    printf "creating table %s.\n", $table_name;
    $pprod_db->{sqlite}->{dbh}->do($create_tbl);
}
else
{
    printf "table %s exists.\n", $table_name;
}
#
my $select_sql = 'select fname, lname, email from ?';
my $sth = $pprod_db->{sqlite}->{dbh}->prepare($select_sql);
$sth->execute($table_name);
my @row = $sth->fetchrow_array();
if (scalar(@row) > 0)
{
    my $i = 0;
    printf "%02d; fname: %s, lname: %s, email: %s\n", 
        ++$i, $row[0], $row[1], $row[2];
    while (@row = $sth->fetchrow_array())
    {
        printf "%02d; fname: %s, lname: %s, email: %s\n", 
            ++$i, $row[0], $row[1], $row[2];
    }
}
else
{
    my $insert_sql = 
       'insert into people (fname, lname, email) values (?, ?, ?)';
    foreach my $pitem (@{$pnames})
    {
        $pprod_db->{sqlite}->{dbh}->do($insert_sql, 
                                       undef, 
                                       $pitem->{fname},
                                       $pitem->{lname},
                                       $pitem->{email});
    }
    #
    $sth->execute($table_name);
    @row = $sth->fetchrow_array();
    my $i = 0;
    printf "%02d; fname: %s, lname: %s, email: %s\n", 
        ++$i, $row[0], $row[1], $row[2];
    while (@row = $sth->fetchrow_array())
    {
        printf "%02d; fname: %s, lname: %s, email: %s\n", 
            ++$i, $row[0], $row[1], $row[2];
    }
}
#
$pprod_db->{sqlite}->{dbh}->disconnect;
#
exit 0;
