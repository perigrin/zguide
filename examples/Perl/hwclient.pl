#!/usr/bin/env perl
use 5.12.2;    # not neccessary but enables strict and modern features

#   Hello World client in Perl (based on Python example)
#   Connects REQ socket to tcp://localhost:5555
#   Sends "Hello" to server, expects "World" back

use ZeroMQ qw/:all/;

my $ctx    = ZeroMQ::Context->new;
my $socket = $ctx->socket(ZMQ_REQ);
$socket->connect('tcp://localhost:5555');

for my $request ( 1 .. 10 ) {
    say "Sending request $request";
    $socket->send('Hello');

    # Get the reply
    my $message = $socket->recv();
    say "Received reply ${ \$message->data } message";
}
