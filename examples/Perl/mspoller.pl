#!/usr/bin/env perl
use 5.12.2;

use ZeroMQ qw/0.02_02 :all/;    # requires the development version of ZeroMQ

my $ctx = ZeroMQ::Context->new;

my $receiver = $ctx->socket(ZMQ_PULL);
$receiver->connect('tcp://localhost:5557');

my $subscriber = $ctx->socket(ZMQ_SUB);
$subscriber->connect('tcp://localhost:5556');
$subscriber->setsockopt( ZMQ_SUBSCRIBE, '10001 ', 6 );

my $pi = ZMQ::PollItem->new;

$pi->add( $receiver,   ZMQ_POLLIN, sub { } );
$pi->add( $subscriber, ZMQ_POLLIN, sub { } );

$pi->poll(0);

