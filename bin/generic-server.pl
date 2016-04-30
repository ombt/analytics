#!/usr/bin/perl -w
#
################################################################
#
# generic server for stream/packet and socket/unix.
#
################################################################
#
use strict;
#
use Getopt::Std;
use Socket;
use FileHandle;
#
################################################################
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
my %verbose_levels =
(
    off => NOVERBOSE(),
    min => MINVERBOSE(),
    mid => MIDVERBOSE(),
    max => MAXVERBOSE()
);
#
# connection types
#
use constant SOCKET_STREAM => 'SOCKET_STREAM';
use constant SOCKET_DGRAM => 'SOCKET_DGRAM';
use constant UNIX_STREAM => 'UNIX_STREAM';
use constant UNIX_DGRAM => 'UNIX_DGRAM';
use constant TTY_STREAM => 'TTY_STREAM';
#
################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
my $default_cfg_file = "generic-server.cfg";
#
# cmd line options
#
my $logfile = '';
my $verbose = NOVERBOSE;
#
################################################################
#
# misc functions
#
sub usage
{
    my ($arg0) = @_;
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [config-file [config-file2 ...]]

where:
    -? or -h - print this usage.
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
sub log_base
{
    my $fmt = shift;
    my @args = @_;
    #
    $fmt = "\n%d: " . $fmt;
    #
    my @data = caller(1);
    #
    my $pkg = $data[0];
    my $fnm = $data[1];
    my $lnno = $data[2];
    my $subr = $data[3];
    #
    printf $log_fh $fmt, $lnno, @args;
}
#
sub log_msg
{
    log_base @_;
}
#
sub log_err_exit
{
    my $fmt = shift;
    my @args = @_;
    log_base "ERROR EXIT: " . $fmt, @args;
    exit 2;
}
#
sub log_err
{
    my $fmt = shift;
    my @args = @_;
    log_base "ERROR: " . $fmt, @args;
}
#
sub log_warn
{
    my $fmt = shift;
    my @args = @_;
    log_base "WARNING: " . $fmt, @args;
}
#
sub log_vmsg
{
    my $vlvl = shift;
    my $fmt = shift;
    my @args = @_;
    #
    $fmt = "\n%d: " . $fmt;
    #
    my @data = caller(1);
    #
    my $pkg = $data[0];
    my $fnm = $data[1];
    my $lnno = $data[2];
    my $subr = $data[3];
    #
    printf $log_fh $fmt, $lnno, @args if ($verbose >= $vlvl);
}
#
sub log_vmin
{
    log_vmsg MINVERBOSE, @_;
}
#
sub log_vmid
{
    log_vmsg MIDVERBOSE, @_;
}
#
sub log_vmax
{
    log_vmsg MAXVERBOSE, @_;
}
#
# disable stdout buffering
#
sub disable_stdout_buffering
{
    $|++;
}
#
################################################################
#
# read and parse data files.
#
sub read_file
{
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        log_err "File %s is NOT readable\n", $file_nm;
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        log_err "Unable to open %s.\n", $file_nm;
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    log_vmin "Lines read: %d\n", scalar(@{$praw_data});
    return SUCCESS;
}
#
sub parse_file
{
    my ($pdata, $pservices) = @_;
    #
    my $service_name = "";
    my $service_type = SOCKET_STREAM;
    my $service_host_name = "localhost";
    my $service_file_name = ""; # for UNIX sockets
    my $service_port = -1;      # for TCP/UDP sockets
    my $service_input_handler = undef;
    my $service_handler = undef;
    #
    my $lnno = 0;
    #
    foreach my $record (@{$pdata})
    {
        log_vmin "Processing record (%d) : %s\n", ++$lnno, $record;
        #
        if (($record =~ m/^\s*#/) || ($record =~ m/^\s*$/))
        {
            # skip comments or white-space-only lines
            next;
        }
        elsif ($record =~ m/^\s*service\s*start\s*$/)
        {
            $service_name = "";
            $service_type = SOCKET_STREAM;
            $service_host_name = "localhost";
            $service_file_name = ""; # for UNIX sockets
            $service_port = -1;      # for TCP/UDP sockets
            $service_input_handler = undef;
            $service_handler = undef;
        }
        elsif ($record =~ m/^\s*service\s*end\s*$/)
        {
            if (($service_name ne "") and 
                (($service_port > 0) or ($service_file_name ne "")))
            {
                log_msg "Storing service: %s\n", $service_name;
                #
                die "ERROR: duplicate service $service_name: $!" 
                    if (exists($pservices->{${service_name}}));
                #
                $pservices->{${service_name}} = 
                {
                    name => $service_name,
                    type => $service_type,
                    host_name => $service_host_name,
                    file_name => $service_file_name,
                    port => $service_port
                };
            }
            else
            {
                log_err "Unknown service name or invalid port.\n";
            }
        }
        elsif ($record =~ m/^\s*name\s*=\s*(.*)$/i)
        {
            $service_name = ${1};
        }
        elsif ($record =~ m/^\s*type\s*=\s*(.*)$/i)
        {
            $service_type = uc(${1});
        }
        elsif ($record =~ m/^\s*host_name\s*=\s*(.*)$/i)
        {
            $service_host_name = ${1};
        }
        elsif ($record =~ m/^\s*file_name\s*=\s*(.*)$/i)
        {
            $service_file_name = ${1};
        }
        elsif ($record =~ m/^\s*port\s*=\s*(.*)$/i)
        {
            $service_port = ${1};
        }
        else
        {
            log_vmin "Skipping record: %s\n", $record;
        }
        #
    }
    #
    return SUCCESS;
}
#
sub read_cfg_file
{
    my ($cfgfile, $pservices) = @_;
    #
    my @data = ();
    if ((read_file($cfgfile, \@data) == SUCCESS) &&
	(parse_file(\@data, $pservices) == SUCCESS))
    {
        log_vmin "Successfully processed cfg file %s.\n", $cfgfile;
        return SUCCESS;
    }
    else
    {
        log_err "Processing cfg file %s failed.\n", $cfgfile;
        return FAIL;
    }
}
#
################################################################
#
# start execution
#
disable_stdout_buffering();
#
my %opts;
if (getopts('?hwWv:l:', \%opts) != 1)
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
    elsif ($opt eq 'w')
    {
	$verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq 'v')
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $verbose = $opts{$opt};
        }
        elsif (exists($verbose_levels{$opts{$opt}}))
        {
            $verbose = $verbose_levels{$opts{$opt}};
        }
        else
        {
            log_msg "ERROR: Invalid verbose level: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        log_msg "Log File: %s\n", $logfile;
    }
}
#
# check if config file was given.
#
my %services = ();
#
if (scalar(@ARGV) == 0)
{
    #
    # use default config file.
    #
    log_msg "Using default config file: %s\n", $default_cfg_file;
    if (read_cfg_file($default_cfg_file, \%services) != SUCCESS)
    {
        log_err_exit "read_cfg_file failed. Done.\n";
    }
}
else
{
    #
    # read in config files and start up services.
    #
    foreach my $cfg_file (@ARGV)
    {
        log_msg "Reading config file %s ...\n", $cfg_file;
        if (read_cfg_file($cfg_file, \%services) != SUCCESS)
        {
            log_err_exit "read_cfg_file failed. Done.\n";
        }
    }
}
exit 0;





__DATA__
#
################################################################
#
# generic server for stream/packet and socket/unix.
#
################################################################
#
use strict;
#
use Getopt::Std;
use Socket;
use FileHandle;
#
################################################################
#
# logical constants
#
use constant TRUE => 1;
use constant FALSE => 0;
#
use constant SUCCESS => 1;
use constant FAIL => 0;
#
# verbose levels
#
use constant NOVERBOSE => 0;
use constant MINVERBOSE => 1;
use constant MIDVERBOSE => 2;
use constant MAXVERBOSE => 3;
#
my %verbose_levels =
(
    off => NOVERBOSE(),
    min => MINVERBOSE(),
    mid => MIDVERBOSE(),
    max => MAXVERBOSE()
);
#
# connection types
#
use constant SOCKET_STREAM => 'SOCKET_STREAM';
use constant SOCKET_DGRAM => 'SOCKET_DGRAM';
use constant UNIX_STREAM => 'UNIX_STREAM';
use constant UNIX_DGRAM => 'UNIX_DGRAM';
use constant TTY_STREAM => 'TTY_STREAM';
# 
################################################################
#
# globals
#
my $cmd = $0;
my $log_fh = *STDOUT;
my $default_cfg_file = "generic-server.cfg";
#
# cmd line options
#
my $logfile = '';
my $verbose = NOVERBOSE;
#
# create connections
#
my %create_connection =
(
    SOCKET_STREAM() => \&create_socket_stream,
    SOCKET_DGRAM() => \&create_socket_dgram,
    UNIX_STREAM() => \&create_unix_stream,
    UNIX_DGRAM() => \&create_unix_dgram,
    TTY_STREAM() => undef
# 
);
#
# default servers
#
my %default_servers =
(
    SOCKET_STREAM() => \&socket_stream_handler,
    SOCKET_DGRAM() => \&socket_dgram_handler,
    UNIX_STREAM() => \&unix_stream_handler,
    UNIX_DGRAM() => \&unix_dgram_handler,
    TTY_STREAM() => \&tty_stream_handler
);
#
# default input handler
#
my %default_servers =
(
    SOCKET_STREAM() => \&socket_stream_handler,
    SOCKET_DGRAM() => \&socket_dgram_handler,
    UNIX_STREAM() => \&unix_stream_handler,
    UNIX_DGRAM() => \&unix_dgram_handler,
    TTY_STREAM() => \&tty_stream_handler
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
################################################################
#
# misc functions
#
sub usage
{
    my ($arg0) = @_;
    print $log_fh <<EOF;

usage: $arg0 [-?] [-h]  \\ 
        [-w | -W |-v level] \\ 
        [-l logfile] \\ 
        [config-file [config-file2 ...]]

where:
    -? or -h - print this usage.
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
sub log_base
{
    my $fmt = shift;
    my @args = @_;
    #
    $fmt = "\n%d: " . $fmt;
    #
    my @data = caller(1);
    #
    my $pkg = $data[0];
    my $fnm = $data[1];
    my $lnno = $data[2];
    my $subr = $data[3];
    #
    printf $log_fh $fmt, $lnno, @args;
}
#
sub log_msg
{
    log_base @_;
}
#
sub log_err_exit
{
    my $fmt = shift;
    my @args = @_;
    log_base "ERROR EXIT: " . $fmt, @args;
    exit 2;
}
#
sub log_err
{
    my $fmt = shift;
    my @args = @_;
    log_base "ERROR: " . $fmt, @args;
}
#
sub log_warn
{
    my $fmt = shift;
    my @args = @_;
    log_base "WARNING: " . $fmt, @args;
}
#
sub log_vmsg
{
    my $vlvl = shift;
    my $fmt = shift;
    my @args = @_;
    #
    $fmt = "\n%d: " . $fmt;
    #
    my @data = caller(1);
    #
    my $pkg = $data[0];
    my $fnm = $data[1];
    my $lnno = $data[2];
    my $subr = $data[3];
    #
    printf $log_fh $fmt, $lnno, @args if ($verbose >= $vlvl);
}
#
sub log_vmin
{
    log_vmsg MINVERBOSE, @_;
}
#
sub log_vmid
{
    log_vmsg MIDVERBOSE, @_;
}
#
sub log_vmax
{
    log_vmsg MAXVERBOSE, @_;
}
#
# disable stdout buffering
#
sub disable_stdout_buffering
{
    $|++;
}
#
################################################################
#
sub read_file
{
    my ($file_nm, $praw_data) = @_;
    #
    if ( ! -r $file_nm )
    {
        log_err "File %s is NOT readable\n", $file_nm;
        return FAIL;
    }
    #
    unless (open(INFD, $file_nm))
    {
        log_err "Unable to open %s.\n", $file_nm;
        return FAIL;
    }
    @{$praw_data} = <INFD>;
    close(INFD);
    #
    # remove any CR-NL sequences from Windose.
    chomp(@{$praw_data});
    s/\r//g for @{$praw_data};
    #
    log_vmin "Lines read: %d\n", scalar(@{$praw_data});
    return SUCCESS;
}
#
sub parse_file
{
    my ($pdata, $pservices) = @_;
    #
    my $service_name = "";
    my $service_type = SOCKET_STREAM;
    my $service_host_name = "localhost";
    my $service_file_name = ""; # for UNIX sockets
    my $service_port = -1;      # for TCP/UDP sockets
    my $service_input_handler = undef;
    my $service_handler = undef;
    #
    my $lnno = 0;
    #
    foreach my $record (@{$pdata})
    {
        log_vmin "Processing record (%d) : %s\n", ++$lnno, $record;
        #
        if (($record =~ m/^\s*#/) || ($record =~ m/^\s*$/))
        {
            // skip comments or white-space-only lines
            next;
        }
        elsif ($record =~ m/^\s*service\s*start\s*$/)
        {
            $service_name = "";
            $service_type = SOCKET_STREAM;
            $service_host_name = "localhost";
            $service_file_name = "";
            $service_port = -1;
        }
        elsif ($record =~ m/^\s*service\s*end\s*$/)
        {
            if (($service_name ne "") and 
                (($service_port > 0) or ($service_file_name ne "")))
            {
                log_msg "Storing service: %s\n", $service_name;
                #
                die "ERROR: duplicate service $service_name: $!" 
                    if (exists($pservices->{${service_name}}));
                #
                $pservices->{${service_name}} = 
                {
                    name => $service_name,
                    type => $service_type,
                    host_name => $service_host_name,
                    file_name => $service_file_name,
                    port => $service_port
                };
            }
            else
            {
                log_err "Unknown service name or invalid port.\n";
            }
        }
        elsif ($record =~ m/^\s*name\s*=\s*(.*)$/i)
        {
            $service_name = ${1};
        }
        elsif ($record =~ m/^\s*type\s*=\s*(.*)$/i)
        {
            $service_type = uc(${1});
        }
        elsif ($record =~ m/^\s*host_name\s*=\s*(.*)$/i)
        {
            $service_host_name = ${1};
        }
        elsif ($record =~ m/^\s*file_name\s*=\s*(.*)$/i)
        {
            $service_file_name = ${1};
        }
        elsif ($record =~ m/^\s*port\s*=\s*(.*)$/i)
        {
            $service_port = ${1};
        }
        else
        {
            log_vmin "Skipping record: %s\n", $record;
        }
        #
    }
    #
    return SUCCESS;
}
#
sub read_cfg_file
{
    my ($cfgfile, $pservices) = @_;
    #
    my @data = ();
    if ((read_file($cfgfile, \@data) == SUCCESS) &&
	(parse_file(\@data, $pservices) == SUCCESS))
    {
        log_vmin "Successfully processed cfg file %s.\n", $cfgfile;
        return SUCCESS;
    }
    else
    {
        log_err "Processing cfg file %s failed.\n", $cfgfile;
        return FAIL;
    }
}
#
################################################################
#
# input handlers
#
sub stdin_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    my $data = <STDIN>;
    chomp($data);
    #
    if (defined($data))
    {
        log_msg "input ... <%s>\n", $data;
    }
}
#
sub socket_stream_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    my $pfh = $pservice->{fh};
    $pservice->{input} = <$$pfh>;
    #
    if (defined($pservice->{input}))
    {
        log_msg "input ... <%s>\n", $pservice->{input};
    }
}
#
sub socket_dgram_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    my $pfh = $pservice->{fh};
    $pservice->{input} = <$$pfh>;
    #
    if (defined($pservice->{input}))
    {
        log_msg "input ... <%s>\n", $pservice->{input};
    }
}
#
sub unix_stream_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    my $pfh = $pservice->{fh};
    $pservice->{input} = <$$pfh>;
    #
    if (defined($pservice->{input}))
    {
        log_msg "input ... <%s>\n", $pservice->{input};
    }
}
#
sub unix_dgram_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    my $pfh = $pservice->{fh};
    $pservice->{input} = <$$pfh>;
    #
    if (defined($pservice->{input}))
    {
        log_msg "input ... <%s>\n", $pservice->{input};
    }
}
#
sub socket_stream_accept_handler
{
    my ($pservice, $pfh_to_service) = @_;
    #
    # do the accept
    #
    my $new_fh = FileHandle->new();
    if (my $client_paddr = accept($new_fh, $pservice->{fh}))
    {
        log_msg "accept() succeeded for service %s\n", $pservice->{name};
        #
        fcntl($new_fh, F_SETFL, O_NONBLOCK);
        #
        my ($client_port, $client_packed_ip) = sockaddr_in($client_paddr);
        my $client_ascii_ip = inet_ntoa($client_packed_ip);
        #
        vec($rin, fileno($new_fh), 1) = 1;
        vec($ein, fileno($new_fh), 1) = 1;
        #
        $pfh_to_service->{fileno($new_fh)} = 
        {
            name => "client_of_" . $pservice->{name},
            input => '',
            output => '',
            client_port => $client_port,
            client_host_name => $client_ascii_ip,
            client_paddr => $client_paddr,
            fh => \$new_fh,
            accept_fh => $pservice->{fh},
            handler => \&socket_stream_handler
        };
    }
    else
    {
        $new_fh = undef;
        log_err "accept() failed for service %s\n", $pservice->{name};
    }
}
#
################################################################
#
sub add_stdin_to_services
{
    my ($pfh_to_service) = @_;
    #
    my $fno = fileno(STDIN);
    #
    $pfh_to_service->{$fno} =
    {
        name => "STDIN",
        type => TTY_STREAM(),
        handler => \&stdin_handler,
        input => ''
    };
    #
    log_msg "Adding STDIN service ...\n";
    log_msg "\nname ... %s\ntype ... %s\n", 
        $pfh_to_service->{$fno}->{name},
        $pfh_to_service->{$fno}->{type};
    #
    vec($rin, fileno(STDIN), 1) = 1;
}
#
sub create_socket_stream
{
    my ($pservice) = @_;
    #
    log_msg "Creating stream socket for %s.\n", $pservice->{name};
    #
    my $fh = FileHandle->new;
    socket($fh, PF_INET, SOCK_STREAM, getprotobyname('tcp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $paddr = sockaddr_in($pservice->{port}, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    listen($fh, SOMAXCONN) or die "listen: $!";
    #
    log_vmin "File Handle is ... $fh, %d\n", fileno($fh);
    #
    $pservice->{fh} = \$fh;
    $pservice->{handler} = \&socket_stream_handler;
    #
    return SUCCESS;
}
#
sub create_socket_dgram
{
    my ($pservice) = @_;
    #
    log_msg "Creating dgram socket for %s.\n", $pservice->{name};
    #
    my $fh = FileHandle->new;
    socket($fh, PF_INET, SOCK_DGRAM, getprotobyname('udp'));
    setsockopt($fh, SOL_SOCKET, SO_REUSEADDR, 1);
    #
    my $ipaddr = gethostbyname($pservice->{host_name});
    defined($ipaddr) or die "gethostbyname: $!";
    #
    my $paddr = sockaddr_in($pservice->{port}, $ipaddr);
    defined($paddr) or die "sockaddr_in: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    #
    log_vmin "File Handle is ... $fh, %d\n", fileno($fh);
    #
    $pservice->{fh} = \$fh;
    $pservice->{handler} = \&socket_dgram_handler;
    #
    return SUCCESS;
}
#
sub create_unix_stream
{
    my ($pservice) = @_;
    #
    log_msg "Creating stream unix pipe for %s.\n", $pservice->{name};
    #
    my $fh = FileHandle->new;
    socket($fh, PF_UNIX, SOCK_STREAM, 0);
    #
    unlink($pservice->{file_name});
    #
    my $paddr = sockaddr_un($pservice->{file_name});
    defined($paddr) or die "sockaddr_un: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    #
    log_vmin "File Handle is ... $fh, %d\n", fileno($fh);
    #
    $pservice->{fh} = \$fh;
    $pservice->{handler} = \&unix_stream_handler;
    #
    return SUCCESS;
}
#
sub create_unix_dgram
{
    my ($pservice) = @_;
    #
    log_msg "Creating dgram unix pipe for %s.\n", $pservice->{name};
    #
    my $fh = FileHandle->new;
    socket($fh, PF_UNIX, SOCK_DGRAM, 0);
    #
    unlink($pservice->{file_name});
    #
    my $paddr = sockaddr_un($pservice->{file_name});
    defined($paddr) or die "sockaddr_un: $!";
    #
    bind($fh, $paddr) or die "bind: $!";
    #
    log_vmin "File Handle is ... $fh, %d\n", fileno($fh);
    #
    $pservice->{fh} = \$fh;
    $pservice->{handler} = \&unix_dgram_handler;
    #
    return SUCCESS;
}
#
sub create_server_connections
{
    my ($pservices, $pfh_to_service) = @_;
    #
    foreach my $service (keys %{$pservices})
    {
        my $type = $pservices->{$service}->{type};
        die "ERROR: connection type $type is unknown: $!" 
            unless (exists($create_connection{$type}));
        my $status = &{$create_connection{$type}}(\%{$pservices->{$service}});
        if ($status == SUCCESS)
        {
            my $pfh = $pservices->{$service}{fh};
            log_msg "Successfully create server socket/pipe for %s (%d)\n", 
                    $service, fileno($$pfh);
            $pfh_to_service->{fileno($$pfh)} = $pservices->{$service};
        }
        else
        {
            log_err "Failed to create server socket/pipe for %s\n", $service;
            return FAIL;
        }
    }
    #
    return SUCCESS;
}
#
sub set_io_nonblock
{
    my ($pservices) = @_;
    #
    foreach my $service (keys %{$pservices})
    {
        my $pfh = $pservices->{$service}{fh};
        fcntl($$pfh, F_SETFL, O_NONBLOCK);
    }
}
#
sub run_event_loop
{
    my ($pservices, $pfh_to_service) = @_;
    #
    # mark all file handles as non-blocking
    #
    set_io_nonblock($pservices);
    #
    foreach my $service (keys %{$pservices})
    {
        my $pfh = $pservices->{$service}{fh};
        vec($rin, fileno($$pfh), 1) = 1;
    }
    #
    # enter event loop
    #
    my $time_to_sleep = 5;
    #
    log_msg "Start event loop ...\n";
    #
    for (my $done = FALSE; $done == FALSE; )
    {
        my ($nf, $timeleft) = select($rout=$rin, 
                                     $wout=$win, 
                                     $eout=$ein, 
                                     $time_to_sleep);
        if ($timeleft <= 0)
        {
            log_msg "Time expired ...\n";
            $done = TRUE;
        }
        elsif ($nf > 0)
        {
            log_msg "NF, TIMELEFT ... (%d,%d)\n", $nf, $timeleft;
            foreach my $fileno (keys %{$pfh_to_service})
            {             
                if (vec($rout, $fileno, 1))
                {
                    my $pservice = $pfh_to_service->{$fileno};
                    #
                    log_msg "input available for %s ...\n", $pservice->{name};
                    #
                    # call input handler
                    #
                    &{$pservice->{handler}}($pfh_to_service, $pservice);
                }
            }             
        }
    }
    #
    log_msg "Event-loop done ...\n";
    return SUCCESS;
}
#
################################################################
#
# start execution
#
disable_stdout_buffering();
#
my %opts;
if (getopts('?hwWv:l:', \%opts) != 1)
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
    elsif ($opt eq 'w')
    {
	$verbose = MINVERBOSE;
    }
    elsif ($opt eq 'W')
    {
        $verbose = MIDVERBOSE;
    }
    elsif ($opt eq 'v')
    {
        if ($opts{$opt} =~ m/^[0123]$/)
        {
            $verbose = $opts{$opt};
        }
        elsif (exists($verbose_levels{$opts{$opt}}))
        {
            $verbose = $verbose_levels{$opts{$opt}};
        }
        else
        {
            log_msg "ERROR: Invalid verbose level: $opts{$opt}\n";
            usage($cmd);
            exit 2;
        }
    }
    elsif ($opt eq 'l')
    {
        local *FH;
        $logfile = $opts{$opt};
        open(FH, '>', $logfile) or die $!;
        $log_fh = *FH;
        log_msg "Log File: %s\n", $logfile;
    }
}
#
# check if config file was given.
#
# my %services = 
# (
#     dummy => {
#         name => "dummy",
#         type => SOCKET_STREAM,
#         host_name => "localhost",
#         port => 12345
#     }
# );
my %services = ();
#
if (scalar(@ARGV) == 0)
{
    #
    # use default config file.
    #
    log_msg "Using default config file: %s\n", $default_cfg_file;
    if (read_cfg_file($default_cfg_file, \%services) != SUCCESS)
    {
        log_err_exit "read_cfg_file failed. Done.\n";
    }
}
else
{
    #
    # read in config files and start up services.
    #
    foreach my $cfg_file (@ARGV)
    {
        log_msg "Reading config file %s ...\n", $cfg_file;
        if (read_cfg_file($cfg_file, \%services) != SUCCESS)
        {
            log_err_exit "read_cfg_file failed. Done.\n";
        }
    }
}
#
# create server sockets or pipes as needed.
#
my %fh_to_service = ();
if (create_server_connections(\%services, \%fh_to_service) != SUCCESS)
{
    log_err_exit "create_server_connections failed. Done.\n";
}
#
# monitor stdin for i/o with user.
#
add_stdin_to_services(\%fh_to_service);
#
# event loop to handle connections, etc.
#
if (run_event_loop(\%services, \%fh_to_service) != SUCCESS)
{
    log_err_exit "run_event_loop failed. Done.\n";
}
#
log_msg "All is well that ends well.\nDone.\n";
#
exit 0;
