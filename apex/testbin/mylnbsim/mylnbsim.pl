#!/usr/bin/perl -w
#
################################################################
#
# LNB simulator
#
################################################################
#
use strict;
use warnings;
#
################################################################
#
# read official and local mods
#
my $binpath;
#
BEGIN
{
    use File::Basename;
    #
    $binpath = dirname($0);
    $binpath = "." if ($binpath eq "");
}
#
# perl mods
#
use Getopt::Std;
use Socket;
use FileHandle;
use POSIX qw(:errno_h);
use Data::Dumper;
use DBI;
#
# my mods
#
use lib "$binpath";
use lib "$binpath/utils";
use lib "$binpath/lnb_msgs";
#
use myconstants;
use mylogger;
use mytimer;
use mytimerpqueue;
use mytaskdata;
use myutils;
#
use base_msg;
#
################################################################
#
# local constants
#
use constant SOH => 1;
use constant STX => 2;
use constant ETX => 3;
#
################################################################
#
# globals
#
my $cmd = $0;
my $default_cfg_file = "mylnbsim.cfg";
#
my $putils = myutils->new();
die "Unable to create utils: $!" unless (defined($putils));
#
my $plog = mylogger->new();
die "Unable to create logger: $!" unless (defined($plog));
#
my $pq = mytimerpqueue->new();
die "Unable to create priority queue: $!" unless (defined($pq));
#
my $pservices = mytaskdata->new();
die "Unable to create services data: $!" 
    unless (defined($pservices));
#
my $pfh_services = mytaskdata->new();
die "Unable to create file-handler-to-services data: $!" 
    unless (defined($pfh_services));
#
my $pfh_data = mytaskdata->new();
die "Unable to create task-specific data: $!" 
    unless (defined($pfh_data));
#
my $event_loop_done = FALSE;
#
my %service_params =
(
    name => {
        required => FALSE(),
        handler => FALSE(),
    },
    service => {
        required => TRUE(),
        handler => FALSE(),
        alternative => 'port',
    },
    host_name => {
        required => TRUE(),
        handler => FALSE(),
    },
    io_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    service_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    timer_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_io_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_service_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    client_timer_handler => {
        required => TRUE(),
        handler => TRUE(),
    },
    enabled => {
        required => TRUE(),
    },
    port => {
        required => FALSE(),
    },
    route_name => {
        required => FALSE(),
    },
);
#
# vectors for select()
#
my $rin = '';
my $win = '';
my $ein = '';
#
my $rout = '';
my $wout = '';
my $eout = '';
#
# check if db parameters exist.
#
$! = EINVAL();
#
my $db_server = undef;
$db_server = $ENV{DB_SERVER} if (exists($ENV{DB_SERVER}));
die "DB_SERVER not defined: $!" unless (defined($db_server));
#
my $db_port = undef;
$db_port = $ENV{DB_PORT_NO} if (exists($ENV{DB_PORT_NO}));
die "DB_PORT_NO not defined: $!" unless (defined($db_port));
#
my $db_name = undef;
$db_name = $ENV{DB_NAME} if (exists($ENV{DB_NAME}));
die "DB_NAME not defined: $!" unless (defined($db_name));
#
my $db_user = 'cim';
my $db_passwd = 'cim';
#
# route data
#
my %routes = ( );
my %route_ids = ( );
my %route_names = ( );
my %mc_nos_via_eqid = ( );
my %mc_nos_via_eqnm = ( );
my %equipment_via_eqid = ( );
my %equipment_via_eqnm = ( );
my %products_via_rtid = ( );
my %products_via_rtnm = ( );
#
# dump data structure
#
my $pdd_data =
[
    {
        name => "routes",
        pdata => \%routes
    },
    {
        name => "route_ids",
        pdata => \%route_ids
    },
    {
        name => "route_names",
        pdata => \%route_names
    },
    {
        name => "mc_nos_via_eqid",
        pdata => \%mc_nos_via_eqid
    },
    {
        name => "mc_nos_via_eqnm",
        pdata => \%mc_nos_via_eqnm
    },
    {
        name => "equipment_via_eqid",
        pdata => \%equipment_via_eqid
    },
    {
        name => "equipment_via_eqnm",
        pdata => \%equipment_via_eqnm
    },
    {
        name => "products_via_rtid",
        pdata => \%products_via_rtid
    },
    {
        name => "products_via_rtnm",
        pdata => \%products_via_rtnm
    },
];
#
################################################################
#
# miscellaneous functions
#
sub usage
{
    my ($arg0) = @_;
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h] \\ 
        [-t] [-w | -W |-v level] \\ 
        [ [-l logfile] | [ -T teefile] \\ 
        [config-file [config-file2 ...]]

where:
    -? or -h - print this usage.
    -t - turn on trace
    -w - enable warning (level=min=1)
    -W - enable warning and trace (level=mid=2)
    -v - verbose level: 0=off,1=min,2=mid,3=max
    -l logfile - log file path

config-file is the configuration file containing lists of
services to create. one or more config files can be given.
if a config file is not given, then the default is to look
for the file generic-server.cfg in the current directory.

EOF
}
#
sub read_file
{
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        $plog->log_err("File %s is NOT readable\n", $file_nm);
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        $plog->log_err("Unable to open %s.\n", $file_nm);
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from windows.
    #
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    $plog->log_vmid("Lines read: %d\n", scalar(@{$praw_data}));
    return SUCCESS;
}
#
################################################################
#
# db functions
#
sub open_db_connection
{
    my ($db_server, $db_port, $db_name, $db_user, $db_passwd, $pdbh) = @_;
    #
    my $dsn = "DBI:Sybase:host=$db_server;port=$db_port";
    $dsn .= ";database=$db_name" if ($db_name ne "");
    #
    $$pdbh = DBI->connect($dsn, $db_user, $db_passwd, {PrintError => 0});
    # 
    unless ($$pdbh) {
        die "ERROR: Failed to connect to server ($db_server).\nERROR MESSAGE: $DBI::errstr";
    }
}
#
sub close_db_connection
{
    my ($dbh) = @_;
    $dbh->disconnect;
}
#
sub read_route_data
{
    $plog->log_msg("Reading route data ... %s,%d,%s,%s,%s\n",
                   $db_server, $db_port, $db_name, $db_user, $db_passwd);
    #
    my $dbh;
    open_db_connection($db_server, $db_port, $db_name, $db_user, $db_passwd, \$dbh);
    #
    my $sql = ' 
select
    r.route_id,
    r.route_name,
    rl.pos,
    zl.equipment_id,
    eq.equipment_name,
    z.trace_level,
    m.model_number,
    m.double_feeder_mode,
    m.single_lane_mode,
    m.num_stages
from
    routes r
inner join
    route_layout rl
on
    rl.route_id = r.route_id
inner join
    zones z
on
    rl.zone_id = z.zone_id
inner join
    zone_layout zl
on
    z.zone_id = zl.zone_id
inner join
    machines m
on
    m.equipment_id = zl.equipment_id
inner join
    equipment eq
on
    eq.equipment_id = m.equipment_id
where
    r.valid_flag = \'T\'
order by
    r.route_id asc,
    rl.pos asc';
    #
    my $sth;
    unless ($sth = $dbh->prepare($sql))
    {
        $dbh->disconnect;
        die "ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    unless ($sth->execute)
    {
        $dbh->disconnect;
        die "ERROR: Failed to execute query.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    my $mc_no = -1;
    my $prev_route_id = -1;
    #
    while (my @values = $sth->fetchrow)
    {
        $plog->log_msg("%s\n", join(",", @values));
        #
        my ($route_id, 
            $route_name, 
            $pos, 
            $equipment_id, 
            $equipment_name,
            $trace_level,
            $model_number,
            $double_feeder_mode,
            $single_lane_mode,
            $num_stages) = @values;
        #
        if ($prev_route_id != $route_id)
        {
            $mc_no = -1;
            $prev_route_id = $route_id;
        }
        $mc_no += 1;
        #
        $route_ids{$route_name} = $route_id;
        $route_names{$route_id} = $route_name;
        #
        unshift @{$routes{$route_name}},
        {
            mc_no => $mc_no,
            route_pos => $pos,
            equipment_id => $equipment_id, 
            equipment_name => $equipment_name,
            trace_level => $trace_level,
            model_number => $model_number,
            double_feeder_mode => $double_feeder_mode,
            single_lane_mode => $single_lane_mode,
            num_stages => $num_stages
        };
        #
        $mc_nos_via_eqid{$equipment_id} = $mc_no;
        $mc_nos_via_eqnm{$equipment_name} = $mc_no;
        #
        $equipment_via_eqid{$equipment_id} = {
            mc_no => $mc_no,
            route_pos => $pos,
            equipment_id => $equipment_id, 
            equipment_name => $equipment_name,
            route_id => $route_id,
            route_name => $route_name,
            trace_level => $trace_level,
            model_number => $model_number,
            double_feeder_mode => $double_feeder_mode,
            single_lane_mode => $single_lane_mode,
            num_stages => $num_stages
        };
        #
        $equipment_via_eqnm{$equipment_name} = {
            mc_no => $mc_no,
            route_pos => $pos,
            equipment_id => $equipment_id, 
            equipment_name => $equipment_name,
            route_id => $route_id,
            route_name => $route_name,
            trace_level => $trace_level,
            model_number => $model_number,
            double_feeder_mode => $double_feeder_mode,
            single_lane_mode => $single_lane_mode,
            num_stages => $num_stages
        };
    }
    #
    $sth->finish;
    #
    close_db_connection($dbh);
    #
    $plog->log_vmin("routes Dumper: %s\n", Dumper(\%routes));
    $plog->log_vmin("route_ids Dumper: %s\n", Dumper(\%route_ids));
    $plog->log_vmin("route_names Dumper: %s\n", Dumper(\%route_names));
    $plog->log_vmin("mc_nos_via_eqid Dumper: %s\n", Dumper(\%mc_nos_via_eqid));
    $plog->log_vmin("mc_nos_via_eqnm Dumper: %s\n", Dumper(\%mc_nos_via_eqnm));
    $plog->log_vmin("equipment_via_eqid Dumper: %s\n", Dumper(\%equipment_via_eqid));
    $plog->log_vmin("equipment_via_eqnm Dumper: %s\n", Dumper(\%equipment_via_eqnm));
    #
    return SUCCESS;
}
#
sub read_route_product_data
{
    $plog->log_msg("Reading route product data ... %s,%d,%s,%s,%s\n",
                   $db_server, $db_port, $db_name, $db_user, $db_passwd);
    #
    my $dbh;
    open_db_connection($db_server, $db_port, $db_name, $db_user, $db_passwd, \$dbh);
    #
    my $sql = ' 
select
    r.route_id,
    r.route_name,
    r.flow_direction,
    r.lnb_host_name,
    ps.product_id,
    pd.product_name,
    ps.mix_name,
    ps.setup_id,
    ps.machine_file_name,
    ps.model_string,
    ps.top_bottom,
    ps.pcb_name,
    pd.dos_product_name,
    pd.patterns_per_panel,
    pclm.cerberos_file_name,
    pclm.lot_name,
    pclm.lot_num,
    pclm.version
from
    routes r
inner join
    product_setup ps
on
    ps.route_id = r.route_id
inner join
    product_data pd
on
    pd.product_id = ps.product_id
inner join
    product_cerberos_lot_map pclm
on
    pclm.mix_name = ps.mix_name
where
    r.valid_flag = \'T\'';
    #
    my $sth;
    unless ($sth = $dbh->prepare($sql))
    {
        $dbh->disconnect;
        die "ERROR: Failed to prepare SQL statement.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    unless ($sth->execute)
    {
        $dbh->disconnect;
        die "ERROR: Failed to execute query.\nSQL: $sql\nERROR MESSAGE: $DBI::errstr";
    }
    #
    while (my @values = $sth->fetchrow)
    {
        $plog->log_msg("%s\n", join(",", @values));
        #
        my ($route_id,
            $route_name,
            $flow_direction,
            $lnb_host_name,
            $product_id,
            $product_name,
            $mix_name,
            $setup_id,
            $machine_file_name,
            $model_string,
            $top_bottom,
            $pcb_name,
            $dos_product_name,
            $patterns_per_panel,
            $cerberos_file_name,
            $lot_name,
            $lot_num,
            $version) = @values;
        #
        $products_via_rtid{$route_id}{$setup_id}{$mix_name} = {
            route_id => $route_id,
            route_name => $route_name,
            flow_direction => $flow_direction,
            lnb_host_name => $lnb_host_name,
            product_id => $product_id,
            product_name => $product_name,
            mix_name => $mix_name,
            setup_id => $setup_id,
            machine_file_name => $machine_file_name,
            model_string => $model_string,
            top_bottom => $top_bottom,
            pcb_name => $pcb_name,
            dos_product_name => $dos_product_name,
            patterns_per_panel => $patterns_per_panel,
            cerberos_file_name => $cerberos_file_name,
            lot_name => $lot_name,
            lot_num => $lot_num,
            version => $version
        };
        $products_via_rtnm{$route_name}{$setup_id}{$mix_name} = {
            route_id => $route_id,
            route_name => $route_name,
            flow_direction => $flow_direction,
            lnb_host_name => $lnb_host_name,
            product_id => $product_id,
            product_name => $product_name,
            mix_name => $mix_name,
            setup_id => $setup_id,
            machine_file_name => $machine_file_name,
            model_string => $model_string,
            top_bottom => $top_bottom,
            pcb_name => $pcb_name,
            dos_product_name => $dos_product_name,
            patterns_per_panel => $patterns_per_panel,
            cerberos_file_name => $cerberos_file_name,
            lot_name => $lot_name,
            lot_num => $lot_num,
            version => $version
        };
    }
    #
    $sth->finish;
    #
    close_db_connection($dbh);
    #
    $plog->log_vmin("products_via_rtid Dumper: %s\n", Dumper(\%products_via_rtid));
    $plog->log_vmin("products_via_rtnm Dumper: %s\n", Dumper(\%products_via_rtnm));
    #
    return SUCCESS;
}
#
################################################################
#
# read and parse config file.
#
sub check_service_data
{
    my ($pservice) = @_;
    #
    foreach my $key (keys %service_params)
    {
        if ((!exists($pservice->{$key})) &&
            ($service_params{$key}{required} == TRUE))
        {
            if (exists($service_params{$key}{alternative}))
            {
                my $alternative = $service_params{$key}{alternative};
                next if (exists($pservice->{$alternative}));
            }
            $plog->log_err("Required field missing: %s\n", $key);
            return FALSE;
        }
    }
    #
    return TRUE;
}
#
sub parse_cfg_file
{
    my ($pdata) = @_;
    #
    my $lnno = 0;
    my $pservice = { };
    my $in_service = FALSE;
    #
    foreach my $record (@{$pdata})
    {
        $plog->log_vmin("Processing record (%d) : %s\n", ++$lnno, $record);
        #
        if (($record =~ m/^\s*#/) || ($record =~ m/^\s*$/))
        {
            # skip comments or white-space-only lines
            next;
        }
        elsif ($record =~ m/^\s*service\s*start\s*$/)
        {
            if ($in_service != FALSE)
            {
                $plog->log_err("Previous service not ended (%d).\n", $lnno);
                return FAIL;
            }
            #
            $pservice = { };
            $in_service = TRUE;
        }
        elsif ($record =~ m/^\s*service\s*end\s*$/)
        {
            if ($in_service != TRUE)
            {
                $plog->log_err("Missing service name (%d).\n", $lnno);
                return FAIL;
            }
            elsif ((exists($pservice->{name})) &&
                   ($pservice->{name} ne ""))
            {
                my $name = $pservice->{name};
                #
                if ($pservices->exists($name) == TRUE)
                {
                    $plog->log_err("Duplicate service name (%d): %s\n", $lnno, $name);
                    return FAIL;
                }
                #
                if (check_service_data($pservice) != TRUE)
                {
                    $plog->log_err("Service sanity check failed (%d): %s\n", $lnno, $name);
                    return FAIL;
                }
                #
                if ($pservice->{enabled} eq "true")
                {
                    $plog->log_msg("Storing service: %s\n", $name);
                    $pservices->set($name, $pservice);
                }
            }
            else
            {
                $plog->log_err("Unknown service name (%d).\n", $lnno);
                return FAIL;
            }
            #
            $pservice = { };
            $in_service = FALSE;
        }
        elsif ($record =~ m/^\s*([^\s]+)\s*=\s*(.*)$/i)
        {
            my $key = ${1};
            my $value = ${2};
            #
            if (exists($service_params{$key}))
            {
                $plog->log_vmin("Setting %s to %s (%d)\n", $key, $value, $lnno);
                $pservice->{$key} = $value;
            }
            else
            {
                $plog->log_err("Record %d with unknown key: %s\n", $lnno, $key, $record);
                return FAIL;
            }
        }
        else
        {
            $plog->log_err("Unknown record %d: %s\n", $lnno, $record);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub read_cfg_file
{
    my ($cfgfile) = @_;
    #
    my @data = ();
    if ((read_file($cfgfile, \@data) == SUCCESS) &&
	(parse_cfg_file(\@data) == SUCCESS))
    {
        $plog->log_vmin("Successfully processed cfg file %s.\n", $cfgfile);
        return SUCCESS;
    }
    else
    {
        $plog->log_err("Processing cfg file %s failed.\n", $cfgfile);
        return FAIL;
    }
}
#
################################################################
#
# generic service handlers
#
sub socket_stream_accept_io_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    # do the accept
    #
    my $pfh = $pservice->{fh};
    # my $new_fh = FileHandle->new();
    my $new_fh = undef;
    if (my $client_paddr = accept($new_fh, $$pfh))
    {
        $plog->log_msg("accept() succeeded for service %s\n", $pservice->{name});
        #
        fcntl($new_fh, F_SETFL, O_NONBLOCK);
        #
        my ($client_port, $client_packed_ip) = sockaddr_in($client_paddr);
        my $client_ascii_ip = inet_ntoa($client_packed_ip);
        #
        vec($rin, fileno($new_fh), 1) = 1;
        vec($ein, fileno($new_fh), 1) = 1;
        #
        my $io_handler = undef;
        die "unknown client io handler: $!" 
            unless (exists($pservice->{client_io_handler}));
        $io_handler = $pservice->{client_io_handler};
        #
        my $service_handler = undef;
        die "unknown client service handler: $!" 
            unless (exists($pservice->{client_service_handler}));
        $service_handler = $pservice->{client_service_handler};
        #
        my $timer_handler = $pservice->{client_timer_handler};
        #
        my $pnew_service = 
        {
            client => TRUE(),
            name => "client_of_" . $pservice->{name},
            client_port => $client_port,
            client_host_name => $client_ascii_ip,
            client_paddr => $client_paddr,
            fh => \$new_fh,
            io_handler => $io_handler,
            service_handler => $service_handler,
            timer_handler => $timer_handler,
            total_buffer => "",
        };
        #
        my $fileno = fileno($new_fh);
        $pfh_services->set($fileno, $pnew_service);
        $pfh_data->reallocate($fileno);
        #
        # call ctor if it exists.
        #
        my $ctor = $pservice->{'ctor'};
        if (defined($ctor))
        {
            my $status = &{$ctor}($pnew_service);
        }
        return SUCCESS;
    }
    else
    {
        $plog->log_err("accept() failed for service %s\n", $pservice->{name});
        return FAIL;
    }
}
#
sub generic_stream_io_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    $plog->log_msg("entering generic_stream_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $buffer = undef;
    my $nr = sysread($$pfh, $buffer, 1024*4);
    #
    if (defined($nr))
    {
        if ($nr > 0)
        {
            #
            # read something ... process it ...
            #
            my $local_buffer = unpack("H*", $buffer);
            $plog->log_msg("nr ... <%d>\n", $nr);
            $plog->log_msg("buffer ... <%s>\n", $buffer);
            $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
            #
            $pfh_data->set($fileno, 'input', $buffer);
            $pfh_data->set($fileno, 'input_length', $nr);
            #
            return &{$pservice->{service_handler}}($pservice);
        }
        else
        {
            #
            # EOF. close socket and clean up.
            #
            vec($rin, $fileno, 1) = 0;
            vec($ein, $fileno, 1) = 0;
            vec($win, $fileno, 1) = 0;
            #
            close($$pfh);
            #
            $plog->log_msg("closing socket (%d) for service %s ...\n", 
                           $fileno,
                           $pservice->{name});
            $pfh_services->deallocate($fileno);
            $pfh_data->deallocate($fileno);
            #
            return SUCCESS;
        }
    }
    elsif ($! != EAGAIN)
    {
        #
        # some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_err("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
        #
        return FAIL;
    }
    else
    {
        # EAGAIN ... try again
        return SUCCESS;
    }
}
#
sub generic_stream_service_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    $plog->log_msg("entering generic_stream_service_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = $pfh_data->get($fileno, 'input_length');
    my $buffer = $pfh_data->get($fileno, 'input');
    #
    $plog->log_msg("sending back buffer: %s\n", $buffer);
    #
    if ( ! defined(send($$pfh, $buffer, $nr)))
    {
        return FAIL;
    }
    #
    return SUCCESS;
}
#
sub generic_stream_client_service_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = base_msg->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if (defined($pxml->parse()))
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
            return FAIL;
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
        return FAIL;
    }
    #
    $pxml = undef;
    return SUCCESS;
}
#
################################################################
#
# DGS-Automation service handlers
#
sub dgs_auto_service_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    $plog->log_msg("entering dgs_auto_service_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = $pfh_data->get($fileno, 'input_length');
    my $buffer = $pfh_data->get($fileno, 'input');
    #
    # my $sleep_time = 5;
    # $plog->log_msg("sleeping for : %d\n", $sleep_time);
    # sleep($sleep_time);
    #
    $plog->log_msg("dgs service handler ... nr ... <%d>\n", $nr);
    $plog->log_msg("dgs service handler ... buffer ... <%s>\n", $buffer);
    #
    $plog->log_msg("sending back buffer: \n<<<<%s>>>>\n", $buffer);
    #
    my $n2w = $nr;
    while ( $n2w > 0 )
    {
        my $nw = send($$pfh, $buffer, $n2w);
        if ( ! defined($nw))
        {
            return FAIL;
        }
        elsif ($nw == $n2w)
        {
            last;
        }
        else
        {
            $buffer = substr($buffer, 0, $nw);
            $n2w -= $nw;
        }
    }
    #
    return SUCCESS;
}
#
################################################################
#
# LNB-specific io handler
#
sub lnb_io_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    $plog->log_msg("entering lnb_io_handler() for %s\n", 
                   $pservice->{name});
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $nr = 0;
    my $buffer = undef;
    #
    # for testing use a small buffer ...
    # while (defined($nr = sysread($$pfh, $buffer, 8*4)) && ($nr > 0))
    #
    while (defined($nr = sysread($$pfh, $buffer, 1024*4)) && ($nr > 0))
    {
        $plog->log_msg("nr ... <%d>\n", $nr);
        $plog->log_msg("buffer ... <%s>\n", $buffer);
        #
        my $local_buffer = unpack("H*", $buffer);
        $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buffer);
        #
        if ($nr > 0)
        {
             my $total_buffer = $pfh_data->get($fileno, 'total_buffer');
             $total_buffer = $total_buffer . $buffer;
             my $tblen = length($total_buffer);
             my $sohi = -1;
             my $stxi = -1;
             my $etxi = -1;
             for (my $tbi = 0; $tbi < $tblen; $tbi += 1)
             {
                 my $ch = substr($total_buffer, $tbi, 1);
                 if ($ch =~ m/^\x01/)
                 {
                     $sohi = $tbi;
                     $stxi = -1;
                     $etxi = -1;
                 }
                 elsif ($ch =~ m/^\x02/)
                 {
                     $stxi = $tbi;
                 }
                 elsif ($ch =~ m/^\x03/)
                 {
                     $etxi = $tbi;
                 }
                 #
                 if (($stxi != -1) && ($etxi != -1))
                 {
                     my $xml_start = $stxi + 1;
                     my $xml_end = $etxi - 1;
                     my $xml_length = $xml_end - $xml_start + 1;
                     my $xml_buffer = substr($total_buffer, 
                                             $xml_start, 
                                             $xml_length);
                     #
                     $pfh_data->set($fileno, 'input', $xml_buffer);
                     $pfh_data->set($fileno, 'input_length', $xml_length);
                     #
                     &{$pservice->{service_handler}}($pservice);
                     #
                     $sohi = -1;
                     $stxi = -1;
                     $etxi = -1;
                 }
             }
             #
             # reset for partially read messages.
             #
             if ($sohi != -1)
             {
                 $plog->log_msg("Partial read ... got back for more.\n");
                 $total_buffer = substr($total_buffer, $sohi);
                 $pfh_data->set($fileno, 'total_buffer', $total_buffer);
             }
        }
    }
    #
    if ((( ! defined($nr)) && ($! != EAGAIN)) ||
        (defined($nr) && ($nr == 0)))
    {
        #
        # EOF or some error
        #
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
    }
    #
    return SUCCESS;
}
#
sub send_xml_msg
{
    my ($pservice, $xml) = @_;
    #
    my $pfh = $pservice->{fh};
    #
    my $buflen = sprintf("%06d", length($xml));
    #
    # c  ==>> SOH
    # A* ==>> XML length
    # c  ==>> STX
    # A* ==>> XML
    # c  ==>> ETX
    #
    my $buf = pack("cA*cA*c", SOH, $buflen, STX, $xml, ETX);
    #
    # len(SOH) + len(xml_length) + len(STX) + len(xml) + len(ETX)
    #
    my $nw = 1 + 6 + 1 + length($xml) + 1;
    #
    my $local_buf = unpack("H*", $buf);
    $plog->log_vmin("unpacked buffer ... <%s>\n", $local_buf);
    #
    # handle partial writes.
    #
    # die $! if ( ! defined(send($$pfh, $buf, $nw)));
    for (my $ntow=$nw; 
         ($ntow > 0) &&
         defined($nw = send($$pfh, $buf, $ntow));
         $ntow -= $nw) { }
    die $! if ( ! defined($nw) );
}
#
################################################################
#
# lnb message handlers
#
sub send_fail_response
{
    my ($pservice, $pxml) = @_;
    #
    my $resp_xml = $pxml->response_xml(1);
    if (defined($resp_xml))
    {
        $plog->log_msg("getting response succeeded.\n");
        send_xml_msg($pservice, $resp_xml);
    }
    else
    {
        $plog->log_err("getting response failed.\n");
    }
    #
    return FAIL;
}
#
sub send_success_response
{
    my ($pservice, $pxml) = @_;
    #
    my $resp_xml = $pxml->response_xml(0);
    if (defined($resp_xml))
    {
        $plog->log_msg("getting response succeeded.\n");
        send_xml_msg($pservice, $resp_xml);
        return SUCCESS;
    }
    else
    {
        $plog->log_err("getting response failed.\n");
        return FAIL;
    }
}
#
sub handle_program_data_request
{
    my ($pservice, $pxml) = @_;
    #
    my $pd_req = $pxml->find("<root>", "<ProgramDataRequest>");
    if ( ! defined($pd_req))
    {
        $plog->log_err("Program Data Request section NOT FOUND.\n");
        return send_fail_response($pservice, $pxml);
    }
    #
    if (ref($pd_req) eq "HASH")
    {
        $plog->log_msg("Program Data Request is a hash ....\n");
        $plog->log_msg("Hash Dumper: %s\n", Dumper($pd_req));
        if ($pd_req->{'<Element>'}->{'<MCNo>'} >= 0)
        {
            return send_success_response($pservice, $pxml);
        }
        else
        {
            $plog->log_err("Invalid MCNo ... %d.\n", $pd_req->{MCNo});
            return send_fail_response($pservice, $pxml);
        }
    }
    elsif (ref($pd_req) eq "ARRAY")
    {
        $plog->log_msg("Program Data Request is an array ....\n");
        for (my $i=0; $i<scalar(@{$pd_req}); ++$i)
        {
            $plog->log_msg("Array Dumper: %s\n", Dumper($pd_req->[$i]));
        }
        return send_success_response($pservice, $pxml);
    }
    else
    {
        $plog->log_msg("Dumper: %s\n", Dumper($pd_req));
        return send_success_response($pservice, $pxml);
    }
}
#
################################################################
#
# lnb service handlers
#
sub test_lnb_client_service_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = base_msg->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if ($pxml->parse() == SUCCESS)
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        $xml = $pxml->deparse();
        if (defined($xml))
        {
            $plog->log_msg("Deparsing succeeded.\n");
            send_xml_msg($pservice, $xml);
            $pxml = undef;
            return SUCCESS;
        }
        else
        {
            $plog->log_err("Deparsing failed.\n");
            $pxml = undef;
            return FAIL;
        }
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
        $pxml = undef;
        return FAIL;
    }
}
#
sub lnbhost_client_service_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    my $pfh = $pservice->{fh};
    my $fileno = fileno($$pfh);
    #
    my $xml = $pfh_data->get($fileno, 'input');
    my $xml_len = $pfh_data->set($fileno, 'input_length');
    #
    $plog->log_msg("%s: xml <%s>\n", $pservice->{name}, $xml);
    #
    my $pxml = base_msg->new($xml, $plog);
    die "Unable to create xml parser: $!" unless (defined($pxml));
    #
    if ($pxml->parse() == SUCCESS)
    {
        $plog->log_msg("Parsing succeeded.\n");
        #
        if (($pxml->command_name() eq "Connect") ||
            ($pxml->command_name() eq "HealthCheck") ||
            ($pxml->command_name() eq "InterlockRelease"))
        {
            # $pxml->header()->{"<ResultCode>"} = 0;
            # $xml = $pxml->deparse();
            $xml = $pxml->response_xml(0);
            if (defined($xml))
            {
                $plog->log_msg("Deparsing succeeded.\n");
                send_xml_msg($pservice, $xml);
                $pxml = undef;
                return SUCCESS;
            }
            else
            {
                $plog->log_err("Deparsing failed.\n");
                $pxml = undef;
                return FAIL;
            }
        }
        elsif ($pxml->command_name() eq "ProgramDataRequest")
        {
            handle_program_data_request($pservice, $pxml);
        }
        elsif ($pxml->command_name() eq "TimeOut")
	{
            $plog->log_err("Timeout received. Closing Client: FileNo: %d, Service: %s\n", 
                           $fileno,
                           $pservice->{name});
            vec($rin, $fileno, 1) = 0;
            vec($ein, $fileno, 1) = 0;
            vec($win, $fileno, 1) = 0;
            #
            my $pfh = $pservice->{fh};
            close($$pfh);
            #
            $plog->log_err("closing socket (%d) for service %s ...\n", 
                           $fileno,
                           $pservice->{name});
            $pfh_services->deallocate($fileno);
            $pfh_data->deallocate($fileno);
            return FAIL;
        }
        else
        {
            $pxml->header()->{"<ResultCode>"} = 1;
            $xml = $pxml->deparse();
            if (defined($xml))
            {
                $plog->log_msg("Deparsing succeeded.\n");
                send_xml_msg($pservice, $xml);
                $pxml = undef;
                return SUCCESS;
            }
            else
            {
                $plog->log_err("Deparsing failed.\n");
                $pxml = undef;
                return FAIL;
            }
        }
        #
    }
    else
    {
        $plog->log_err("Parsing failed.\n");
        $pxml = undef;
        return FAIL;
    }
}
#
#
sub lnbcvthost_client_io_handler
{
    $plog->wep();
    return lnb_io_handler(@_);
}
#
sub lnbcvthost_client_service_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    #
    return lnbhost_client_service_handler($pservice);
}
#
sub lnbcvthost_client_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbcvthost_io_handler
{
    $plog->wep();
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbcvthost_service_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbcvthost_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnblmhost_client_io_handler
{
    $plog->wep();
    return lnb_io_handler(@_);
}
#
sub lnblmhost_client_service_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    #
    return lnbhost_client_service_handler($pservice);
}
#
sub lnblmhost_client_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnblmhost_io_handler
{
    $plog->wep();
    return socket_stream_accept_io_handler(@_);
}
#
sub lnblmhost_service_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnblmhost_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbmihost_client_io_handler
{
    $plog->wep();
    return lnb_io_handler(@_);
}
#
sub lnbmihost_client_service_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    #
    return lnbhost_client_service_handler($pservice);
}
#
sub lnbmihost_client_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbmihost_io_handler
{
    $plog->wep();
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbmihost_service_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbmihost_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspcvthost_client_io_handler
{
    $plog->wep();
    return lnb_io_handler(@_);
}
#
sub lnbspcvthost_client_service_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    #
    return lnbhost_client_service_handler($pservice);
}
#
sub lnbspcvthost_client_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspcvthost_io_handler
{
    $plog->wep();
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbspcvthost_service_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspcvthost_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspmihost_client_io_handler
{
    $plog->wep();
    return lnb_io_handler(@_);
}
#
sub lnbspmihost_client_service_handler
{
    my ($pservice) = @_;
    #
    $plog->wep();
    #
    return lnbhost_client_service_handler($pservice);
}
#
sub lnbspmihost_client_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspmihost_io_handler
{
    $plog->wep();
    return socket_stream_accept_io_handler(@_);
}
#
sub lnbspmihost_service_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub lnbspmihost_timer_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub my_echo_io_handler
{
    $plog->wep();
    return generic_stream_io_handler(@_);
}
#
sub my_echo_service_handler
{
    $plog->wep();
    return generic_stream_service_handler(@_);
}
#
sub null_handler
{
    $plog->wep();
    return SUCCESS;
}
#
sub stdin_timer_handler
{
    my ($ptimer, $pservice) = @_;
    $plog->wep();
    $plog->fbt(4);
    #
    $plog->log_vmin("sanity timer handler ... %s\n", $ptimer->{label});
    #
    start_timer($ptimer->{fileno},
                $ptimer->{delta},
                $ptimer->{label});
}
#
sub toggle_trace
{
    if ($plog->trace() == TRUE)
    {
        $plog->log_msg("Turn trace OFF.\n");
        $plog->trace(FALSE);
    }
    else
    {
        $plog->log_msg("Turn trace ON.\n");
        $plog->trace(TRUE);
    }
}
#
sub print_services
{
    my $pfhit = $pfh_services->iterator('n');
    while (defined(my $fileno = $pfhit->()))
    {
        my $pservice = $pfh_services->get($fileno);
        $plog->log_msg("FileNo: %d, Service: %s\n", 
                       $fileno,
                       $pservice->{name});
        if ((defined($pservice->{port})) &&
            ($pservice->{port} > 0))
            
        {
            $plog->log_msg("FileNo: %d, Port: %s\n", 
                       $fileno,
                       $pservice->{port});
        }
        if ((defined($pservice->{file_name})) &&
            ($pservice->{file_name} ne ""))
        {
            $plog->log_msg("FileNo: %d, File Name: %s\n", 
                       $fileno,
                       $pservice->{file_name});
        }
        if ((defined($pservice->{client_host_name})) &&
            ($pservice->{client_host_name} ne ""))
        {
            $plog->log_msg("FileNo: %d, Client Host Name: %s\n", 
                       $fileno,
                       $pservice->{client_host_name});
        }
        if ((defined($pservice->{client_port})) &&
            ($pservice->{client_port} > 0))
        {
            $plog->log_msg("FileNo: %d, Client Port: %d\n", 
                       $fileno,
                       $pservice->{client_port});
        }
    }             
}
#
sub list_all_services
{
    my $pfhit = $pfh_services->iterator('n');
    while (defined(my $fileno = $pfhit->()))
    {
        my $pservice = $pfh_services->get($fileno);
        $plog->log_msg("FileNo: %d, Service: %s\n", 
                       $fileno,
                       $pservice->{name});
    }             
}
#
sub list_servers
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pservice = $pservices->get($service);
        if ((defined($pservice)) && 
            (( ! defined($pservice->{client})) ||
            ($pservice->{client} != TRUE)))
        {
            my $fileno = -1;
            $fileno = fileno(${$pservice->{fh}})
                if (exists($pservice->{fh}));
            $plog->log_msg("Server: FileNo: %d, Service: %s\n", 
                           $fileno,
                           $pservice->{name});
        }
        else
        {
            $plog->log_msg("Service %s is undefined.\n", 
                           $pservice->{name});
        }
    }             
}
#
sub start_a_service
{
    my @available_services = ();
    #
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pservice = $pservices->get($service);
        if ((defined($pservice)) && 
            (( ! defined($pservice->{client})) ||
            ($pservice->{client} != TRUE)))
        {
            my $fileno = -1;
            $fileno = fileno(${$pservice->{fh}})
                if (exists($pservice->{fh}));
            
            unshift @available_services,
            {
                service => $service,
                fileno => $fileno
            };
        }
    }             
    #
    my $maxi = scalar(@available_services);
    for (my $i=0; $i < $maxi; ++$i)
    {
        printf "%d ==>> %s\n", $i, $available_services[$i]->{service};
    }
    printf "Choose service to create: ";
    my $choice = <STDIN>;
    chomp($choice);
    if ($putils->is_valid_menu_option(0, $choice, $maxi) == TRUE)
    {
        if ($available_services[$choice]->{fileno} > 0)
        {
            stop_service($available_services[$choice]->{service});
        }
        create_service($available_services[$choice]->{service});
    }
    else
    {
        printf "Invalid choice.\n";
    }
}
#
sub close_a_service
{
    my @available_services = ();
    #
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pservice = $pservices->get($service);
        if ((defined($pservice)) && 
            (( ! defined($pservice->{client})) ||
            ($pservice->{client} != TRUE)))
        {
            my $fileno = -1;
            $fileno = fileno(${$pservice->{fh}})
                if (exists($pservice->{fh}));
            
            unshift @available_services,
            {
                service => $service,
                fileno => $fileno
            };
        }
    }             
    #
    my $maxi = scalar(@available_services);
    for (my $i=0; $i < scalar(@available_services); ++$i)
    {
        printf "%d ==>> %s\n", $i, $available_services[$i]->{service};
    }
    printf "Choose service to close: ";
    my $choice = <STDIN>;
    chomp($choice);
    if ($putils->is_valid_menu_option(0, $choice, $maxi) == TRUE)
    {
        if ($available_services[$choice]->{fileno} > 0)
        {
            stop_service($available_services[$choice]->{service});
        }
        else
        {
            printf "Service %s is not running\n", 
                   $available_services[$choice]->{service};
        }
    }
}
#
sub list_clients
{
    my $pfhit = $pfh_services->iterator('n');
    while (defined(my $fileno = $pfhit->()))
    {
        my $pservice = $pfh_services->get($fileno);
        if ((defined($pservice->{client})) &&
            ($pservice->{client} == TRUE))
        {
            $plog->log_msg("Client: FileNo: %d, Service: %s\n", 
                           $fileno,
                           $pservice->{name});
        }
    }             
}
#
sub close_all_clients
{
    my $pfhit = $pfh_services->iterator('n');
    while (defined(my $fileno = $pfhit->()))
    {
        my $pservice = $pfh_services->get($fileno);
        if ((defined($pservice->{client})) &&
            ($pservice->{client} == TRUE))
        {
            $plog->log_msg("Closing Client: FileNo: %d, Service: %s\n", 
                           $fileno,
                           $pservice->{name});
            vec($rin, $fileno, 1) = 0;
            vec($ein, $fileno, 1) = 0;
            vec($win, $fileno, 1) = 0;
            #
            my $pfh = $pservice->{fh};
            close($$pfh);
            #
            $plog->log_msg("Closing socket (%d) for service %s ...\n", 
                           $fileno,
                           $pservice->{name});
            $pfh_services->deallocate($fileno);
            $pfh_data->deallocate($fileno);
        }
    }             
}
#
sub close_client
{
    my $fileno_to_close = shift;
    #
    if (defined($fileno_to_close) && ($fileno_to_close >= 0))
    {
        my $pfhit = $pfh_services->iterator('n');
        while (defined(my $fileno = $pfhit->()))
        {
            my $pservice = $pfh_services->get($fileno);
            if ((defined($pservice->{client})) &&
                ($pservice->{client} == TRUE) &&
                ($fileno == $fileno_to_close))
            {
                $plog->log_msg("Closing Client: FileNo: %d, Service: %s\n", 
                               $fileno,
                               $pservice->{name});
                vec($rin, $fileno, 1) = 0;
                vec($ein, $fileno, 1) = 0;
                vec($win, $fileno, 1) = 0;
                #
                my $pfh = $pservice->{fh};
                close($$pfh);
                #
                $plog->log_msg("Closing socket (%d) for service %s ...\n", 
                               $fileno,
                               $pservice->{name});
                $pfh_services->deallocate($fileno);
                $pfh_data->deallocate($fileno);
            }
        }             
    }
    else
    {
        $plog->log_msg("Invalid client file no.\n");
    }
}
#
sub show_menu
{
    my $log_fh = $plog->log_fh();
    print $log_fh <<EOF;
Available commands:

    q - quit 			? - help
    h - help			dd - dump data

    t - print timers 		d - toggle trace
    v0 - no verbose 		v1 - min verbose
    v2 - mid verbose 		v3 - max verbose

    ss - start a service 	sas - start all services

    cs - close a service 	cas - close all services
    cc <fileno> - close client 	cac - close all clients

    l - list all services 	ls - list servers
    lc - list clients 		s - print services

EOF
}
#
sub dump_data
{
    my $maxi = scalar(@{$pdd_data});
    for (my $i=0; $i<$maxi; ++$i)
    {
        printf "%d ==>> %s\n", $i, $pdd_data->[$i]->{name};
    }
    #
    printf "Choose one to dump: ";
    my $choice = <STDIN>;
    if ($putils->is_valid_menu_option(0, $choice, $maxi) == TRUE)
    {
        printf "%d - %s Dumper: %s\n", 
               $choice, 
               $pdd_data->[$choice]->{name},
               Dumper($pdd_data->[$choice]->{pdata});
    }
    else
    {
        printf "Invalid choice.\n";
    }
}
#
sub stdin_handler
{
    my ($pservice) = @_;
    $plog->wep();
    #
    my $data = <STDIN>;
    chomp($data);
    #
    if (defined($data))
    {
        $plog->log_msg("input ... <%s>\n", $data);
        if ($data =~ m/^q$/i)
        {
            $event_loop_done = TRUE;
        }
        elsif (($data =~ m/^[h?]$/i) ||
               ($data eq ""))
        {
            show_menu();
        }
        elsif ($data =~ m/^d$/i)
        {
            toggle_trace();
        }
        elsif ($data =~ m/^dd$/i)
        {
            dump_data();
        }
        elsif ($data =~ m/^v0$/i)
        {
            $plog->verbose(NOVERBOSE);
        }
        elsif ($data =~ m/^v1$/i)
        {
            $plog->verbose(MINVERBOSE);
        }
        elsif ($data =~ m/^v2$/i)
        {
            $plog->verbose(MIDVERBOSE);
        }
        elsif ($data =~ m/^v3$/i)
        {
            $plog->verbose(MAXVERBOSE);
        }
        elsif ($data =~ m/^s$/i)
        {
            print_services();
        }
        elsif ($data =~ m/^l$/i)
        {
            list_all_services();
        }
        elsif ($data =~ m/^ls$/i)
        {
            list_servers();
        }
        elsif ($data =~ m/^ss$/i)
        {
            start_a_service();
        }
        elsif ($data =~ m/^cs$/i)
        {
            close_a_service();
        }
        elsif ($data =~ m/^lc$/i)
        {
            list_clients();
        }
        elsif ($data =~ m/^cac$/i)
        {
            close_all_clients();
        }
        elsif ($data =~ m/^cc\s*(\d+)\s*$/i)
        {
            my $fileno_to_close = $1;
            close_client($fileno_to_close);
        }
        elsif ($data =~ m/^t$/i)
        {
            $pq->dump();
        }
        elsif ($data =~ m/^sas$/i)
        {
            if (create_services() != SUCCESS)
            {
                $plog->log_err("Creating all services failed.\n");
            }
        }
        elsif ($data =~ m/^cas$/i)
        {
            if (stop_services() != SUCCESS)
            {
                $plog->log_err("Stopping all services failed.\n");
            }
        }
        else
        {
            printf "Unknown command: %s\n", $data;
        }
    }
}
#
################################################################
#
# create services and service handlers
#
sub add_stdin_to_services
{
    my $fno = fileno(STDIN);
    #
    $pfh_services->set($fno, {
        name => "STDIN",
        io_handler => \&stdin_handler,
        timer_handler => \&stdin_timer_handler,
    });
    #
    $pfh_data->reallocate($fno);
    #
    $plog->log_msg("Adding STDIN service ... %s\n",
                  $pfh_services->get($fno, 'name'));
    #
    vec($rin, fileno(STDIN), 1) = 1;
}
#
sub function_defined
{
    my ($func_name) = @_;
    if (defined(&{$func_name}))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
#
sub get_handler
{
    my ($handler) = @_;
    #
    if (function_defined($handler) == TRUE)
    {
        # turn off strict so we can convert name to function.
        no strict 'refs';
        return \&{$handler};
    }
    else
    {
        $plog->log_err("Function %s does NOT EXIST.\n", $handler);
        return undef
    }
}
#
sub create_socket_stream
{
    my ($pservice) = @_;
    #
    $plog->log_msg("Creating stream socket for %s.\n", $pservice->{name});
    #
    my $fh = undef;
    socket($fh, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    $plog->log_msg("calling gethostbyname($pservice->{host_name})\n");
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $port = undef;
    if (exists($pservice->{service}) && 
        defined($pservice->{service}))
    {
        # get port from services file
        $port = getservbyname($pservice->{service}, 'tcp') or
            die "Can't get port for service $pservice->{service}: $!";
        $plog->log_msg("getservbyname($pservice->{service}, 'tcp') port = $port\n");
        $pservice->{port} = $port;
    }
    else
    {
        $port = $pservice->{port};
        $plog->log_msg("Config file port = $port\n");
    }
    my $paddr = sockaddr_in($port, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind error for $pservice->{name}: $!";
    listen($fh, SOMAXCONN) or die "listen: $!";
    #
    $plog->log_vmin("File Handle is ... $fh, %d\n", fileno($fh));
    #
    $pservice->{fh} = \$fh;
    #
    # check for handlers
    #
    foreach my $key (keys %service_params)
    {
        if (exists($service_params{$key}{handler}) &&
            ($service_params{$key}{handler} == TRUE))
        {
            my $handler = $pservice->{$key};
            $pservice->{$key} = get_handler($handler);
            if ( ! defined($pservice->{$key}))
            {
                $plog->log_err("Function %s does NOT EXIST.\n", $key);
                return FAIL;
            }
        }
    }
    #
    # mark all file handles as non-blocking
    #
    set_io_nonblock();
    #
    return SUCCESS;
}
#
sub create_service
{
    my ($service) = @_;
    $plog->wep();
    #
    $plog->log_msg("Creating service connection for %s ...\n", $service);
    #
    my $pservice = $pservices->get($service);
    if ( ! defined($pservice))
    {
        $plog->log_err("Service %s not found.\n", $service);
        return FAIL;
    }
    if ((exists($pservice->{'fh'})) &&
        (fileno(${$pservice->{'fh'}}) >= 0))
    {
        $plog->log_warn("Socket or pipe already exists for %s\n", $service);
        return SUCCESS;
    }
    #
    if (create_socket_stream($pservice) != SUCCESS)
    {
        $plog->log_err("Failed to create server socket/pipe for %s\n", $service);
        return FAIL;
    }
    #
    my $pfh = $pservice->{'fh'};
    my $fileno = fileno($$pfh);
    $plog->log_msg("Successfully create server socket/pipe for %s (%d)\n", 
                   $service, $fileno);
    $pfh_services->set($fileno, $pservice);
    $pfh_data->reallocate($fileno);
    #
    vec($rin, $fileno, 1) = 1;
    #
    return SUCCESS;
}
#
sub create_services
{
    $plog->wep();
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        $plog->log_msg("Creating service %s ...\n", $service);
        #
        if (create_service($service) != SUCCESS)
        {
            $plog->log_err("Service %s not created.\n", $service);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub stop_service
{
    my ($service) = @_;
    $plog->wep();
    #
    $plog->log_msg("Stopping service connection for %s ...\n", $service);
    #
    my $pservice = $pservices->get($service);
    if ( ! defined($pservice))
    {
        $plog->log_err("Service %s not found.\n", $service);
        return FAIL;
    }
    #
    if (exists($pservice->{'fh'}))
    {
        my $pfh = $pservice->{'fh'};
        my $fileno = fileno($$pfh);
        #
        $plog->log_msg("Closing Client: FileNo: %d, Service: %s\n", 
                       $fileno,
                       $pservice->{name});
        vec($rin, $fileno, 1) = 0;
        vec($ein, $fileno, 1) = 0;
        vec($win, $fileno, 1) = 0;
        #
        close($$pfh);
        #
        $plog->log_msg("closing socket (%d) for service %s ...\n", 
                       $fileno,
                       $pservice->{name});
        $pfh_services->deallocate($fileno);
        $pfh_data->deallocate($fileno);
        #
        delete $pservice->{'fh'};
    }
    else
    {
        $plog->log_msg("Service %s not running.\n", $service);
    }
    #
    return SUCCESS;
}
#
sub stop_services
{
    $plog->wep();
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        $plog->log_msg("Stopping service %s ...\n", $service);
        #
        if (stop_service($service) != SUCCESS)
        {
            $plog->log_err("Service %s not stopped.\n", $service);
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
################################################################
#
# real-time events loop
#
sub set_io_nonblock
{
    my $piter = $pservices->iterator();
    while (defined(my $service = $piter->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        next unless (defined($pfh));
        fcntl($$pfh, F_SETFL, O_NONBLOCK);
    }
}
#
sub start_timer
{
    my ($fileno, $delta, $label) = @_;
    #
    my $timerid = int(rand(1000000000));
    #
    if ($delta <= 0)
    {
        $plog->log_err("Timer length is zero for %s. Skipping it.\n", $fileno);
        return;
    }
    #
    $plog->log_vmin("starttimer: " .
                    "fileno=${fileno} " .
                    "label=${label} " .
                    "delta=${delta} " .
                    "id=$timerid ");
    #
    my $ptimer = mytimer->new($fileno, $delta, $timerid, $label);
    #
    $plog->log_vmin("fileno = $ptimer->{fileno} " .
                    "delta = $ptimer->{delta} " .
                    "expire = $ptimer->{expire} " .
                    "id = $ptimer->{id} " .
                    "label = $ptimer->{label} ");
    #
    $pq->enqueue($ptimer);
}
#
sub run_event_loop
{
    my $psit = $pservices->iterator();
    while (defined(my $service = $psit->()))
    {
        my $pfh = $pservices->get($service, 'fh');
        next unless (defined($pfh));
        vec($rin, fileno($$pfh), 1) = 1;
    }
    #
    # enter event loop
    #
    my $sanity_time = 30;
    #
    $plog->log_msg("Start event loop ...\n");
    #
    my $mydelta = 0;
    my $start_time = time();
    my $current_time = $start_time;
    my $previous_time = 0;
    #
    while ($event_loop_done == FALSE)
    {
        #
        # save current time as the last time we did anything.
        #
        $previous_time = $current_time;
        #
        if ($pq->is_empty())
        {
            start_timer(fileno(STDIN),
                        $sanity_time, 
                        "sanity-timer");
        }
        #
        my $ptimer = undef;
        die "Empty timer queue: $!" unless ($pq->front(\$ptimer) == 1);
        #
        $mydelta = $ptimer->{expire} - $current_time;
        $mydelta = 0 if ($mydelta < 0);
        #
        my ($nf, $timeleft) = select($rout=$rin, 
                                     $wout=$win, 
                                     $eout=$ein, 
                                     $mydelta);
        #
        # update current timers
        #
        $current_time = time();
        #
        if ($timeleft <= 0)
        {
            $plog->log_vmid("Time expired ...\n");
            #
            $ptimer = undef;
            while ($pq->dequeue(\$ptimer) != 0)
            {
                if ($ptimer->{expire} > $current_time)
                {
                    $pq->enqueue($ptimer);
                    last;
                }
                #
                my $fileno = $ptimer->{fileno};
                my $pservice = $pfh_services->get($fileno);
                #
                &{$pservice->{timer_handler}}($ptimer, $pservice);
                $ptimer = undef;
            }
        }
        elsif ($nf > 0)
        {
            $plog->log_vmid("NF, TIMELEFT ... (%d,%d)\n", $nf, $timeleft);
            my $pfhit = $pfh_services->iterator();
            while (defined(my $fileno = $pfhit->()))
            {
                my $pfh = $pfh_services->get($fileno, 'fh');
                my $pservice = $pfh_services->get($fileno);
                #
                if (vec($eout, $fileno, 1))
                {
                    #
                    # EOF or some error
                    #
                    vec($rin, $fileno, 1) = 0;
                    vec($ein, $fileno, 1) = 0;
                    vec($win, $fileno, 1) = 0;
                    #
                    close($$pfh);
                    #
                    $plog->log_msg("closing socket (%d) for service %s ...\n", 
                                   $fileno,
                                   $pservice->{name});
                    $pfh_services->deallocate($fileno);
                }
                elsif (vec($rout, $fileno, 1))
                {
                    #
                    # ready for a read
                    #
                    $plog->log_vmid("input available for %s ...\n", $pservice->{name});
                    #
                    # call handler
                    #
                    &{$pservice->{io_handler}}($pservice);
                }
            }             
        }
    }
    #
    $plog->log_msg("Event-loop done ...\n");
    #
    return SUCCESS;
}
#
################################################################
#
# start of main
#
$plog->trace(FALSE);
$plog->disable_stdout_buffering();
#
my %opts;
if (getopts('?htwWv:l:', \%opts) != 1)
{
    usage($cmd);
    exit 2;
}
#
foreach my $opt (%opts)
{
    if (($opt eq 'h') or ($opt eq '?'))
    {
	usage($cmd);
	exit 0;
    }
    elsif ($opt eq 't')
    {
	$plog->trace(TRUE);
    }
    elsif ($opt eq 'w')
    {
	$plog->verbose(MINVERBOSE);
    }
    elsif ($opt eq 'W')
    {
        $plog->verbose(MIDVERBOSE);
    }
    elsif ($opt eq 'v')
    {
        if (!defined($plog->verbose($opts{$opt})))
        {
            $plog->log_err("Invalid verbose level: $opts{$opt}\n");
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        $plog->logfile($opts{$opt});
        $plog->log_msg("Log File: %s\n", $opts{$opt});
    }
}
#
# check if config file was given.
#
if (scalar(@ARGV) == 0)
{
    #
    # use default config file.
    #
    $plog->log_msg("Using default config file: %s\n", $default_cfg_file);
    if (read_cfg_file($default_cfg_file) != SUCCESS)
    {
        $plog->log_err_exit("read_cfg_file failed. Done.\n");
    }
}
else
{
    #
    # read in config files and start up services.
    #
    foreach my $cfg_file (@ARGV)
    {
        $plog->log_msg("Reading config file %s ...\n", $cfg_file);
        if (read_cfg_file($cfg_file) != SUCCESS)
        {
            $plog->log_err_exit("read_cfg_file failed. Done.\n");
        }
    }
}
#
# read in db data
#
if (read_route_data() != SUCCESS)
{
    $plog->log_err_exit("read_route_data failed. Done.\n");
}
if (read_route_product_data() != SUCCESS)
{
    $plog->log_err_exit("read_route_product_data failed. Done.\n");
}
#
# monitor stdin for i/o with user.
#
add_stdin_to_services();
#
# event loop to handle connections, etc.
#
if (run_event_loop() != SUCCESS)
{
    $plog->log_err_exit("run_event_loop failed. Done.\n");
}
#
$plog->log_msg("All is well that ends well.\n");
#
exit 0;

__DATA__

