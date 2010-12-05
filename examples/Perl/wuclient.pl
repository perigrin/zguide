#!/usr/bin/env perl
use 5.12.2;    # not neccessary but enables strict and modern features

#
#   Weather update client
#   Connects SUB socket to tcp://localhost:5556
#   Collects weather updates and finds avg temp in zipcode
#

use ZeroMQ qw/:all/;    # import everything

my $ctx    = ZeroMQ::Context->new;
my $socket = $ctx->socket(ZMQ_SUB);
$socket->connect('tcp://localhost:5555');

my $filter = $ARGV[0] // '10001';    # defined or
$socket->setsockopt( ZMQ_SUBSCRIBE, $filter );

my $total_temp = 0;

for my $update ( 0 .. 5 ) {
    my $msg = $socket->recv();
    my ( $zipcode, $temperature, $relhumidity ) = split ' ', $msg->data;
    $total_temp += $temperature;
}

my $average = $total_temp / 5;
print "Average temperature for zipcode $filter was $average";