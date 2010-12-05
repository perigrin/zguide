#!/usr/bin/env perl
use 5.12.2;
our $|++;                      # autoflush
use Time::HiRes qw(usleep);    # import microsleep

# Task worker
# Connects PULL socket to tcp://localhost:5557
# Collects workloads from ventilator via that socket
# Connects PUSH socket to tcp://localhost:5558
# Sends results to sink via that socket

use ZeroMQ qw/:all/;

my $ctx      = ZeroMQ::Context->new;
my $receiver = $ctx->socket(ZMQ_PULL);
$receiver->connect('tcp://localhost:5557');

my $sender = $ctx->socket(ZMQ_PUSH);
$sender->connect('tcp://localhost:5558');

while (1) {
    my $s = $receiver->recv();
    print 'w';    # simple progress indicator

    # do the work
    usleep( $s->data );

    # send the results to the sink
    $sender->send('');
}
