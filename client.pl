use strict;
use warnings;
use Socket;

my $dest_port = 9000;
my $dest_server = "127.0.0.1";

socket(SOCKET, PF_INET, SOCK_STREAM, (getprotobyname('tcp'))[2])
  or die "Can't create socket $!!\n";

connect(SOCKET,pack_sockaddr_in($dest_port,inet_aton($dest_server)))
  or die "Can't connect to port $dest_port!\n";

my $line;
while ($line = <SOCKET>) {
  print "$line\n";
}

close(SOCKET);
