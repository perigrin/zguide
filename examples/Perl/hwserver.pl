#!/usr/bin/env perl
use 5.12.2;    # not neccessary but enables strict and modern features

#   Hello World server in Perl (based on Python version)
#   Binds REP socket to tcp://*:5555
#   Expects "Hello" from client, replies with "World"

use ZeroMQ qw/:all/;

my $ctx    = ZeroMQ::Context->new;
my $socket = $ctx->socket(ZMQ_REP);
$socket->bind('tcp://*:5555');

while (1) {
    my $msg = $socket->recv();
    say "Recieved Request: ${\$msg->data}";

    sleep(1);

    $socket->send("World");
}

