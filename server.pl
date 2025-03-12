use strict;
use warnings;
use feature 'say';

use IO::Socket qw(AF_INET AF_UNIX SOCK_STREAM SHUT_WR);
use Socket qw(TCP_KEEPINTVL SO_KEEPALIVE TCP_KEEPIDLE SOL_SOCKET IPPROTO_TCP TCP_NODELAY);

my $server = IO::Socket->new(
  Domain    => AF_INET,
  Listen    => 1,
  Type      => SOCK_STREAM,
  Proto     => 'tcp',
  LocalAddr => 'localhost',
  LocalPort => 9000,
)
or die "Cannot create socket $@\n";

$server->setsockopt(SOL_SOCKET, SO_KEEPALIVE, 1);
$server->setsockopt(IPPROTO_TCP, TCP_KEEPIDLE, 5);
$server->setsockopt(IPPROTO_TCP, TCP_KEEPINTVL, 5);

say "Waiting on 9000";

# waiting for a new client connection
my $client = $server->accept();

# get information about a newly connected client
my $client_address = $client->peerhost();
my $client_port = $client->peerport();
say "Connection from $client_address:$client_port";

# write response data to the connected client
my $data = "this is the data\n";
$client->send($data);

sleep(60);

# write response data to the connected client
$data = "this is the data again\n";
$client->send($data);

# notify client that response has been sent
$client->shutdown(SHUT_WR);
sleep(5);

$client->close();
$server->close();
