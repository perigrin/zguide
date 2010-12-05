#!/usr/bin/env perl
use 5.12.2;    # not neccessary but enables strict and modern features

#  Weather update server (based on the Python)
#  Binds PUB socket to tcp://*:5556
#  Publishes random weather updates

use ZeroMQ qw/:all/;    # import everything

my $ctx    = ZeroMQ::Context->new;
my $socket = $ctx->socket(ZMQ_PUB);
$socket->bind('tcp://*:5555');
$socket->bind('ipc://weather.ipc');

while (1) {
    my $zipcode     = int( rand(100000) + 1 );
    my $temperature = int( rand(215) + 1 ) - 80;
    my $relhumidity = int( rand(50) + 1 ) + 10;

    $socket->send( sprintf '%05d %d %d', $zipcode, $temperature, $relhumidity );
}
