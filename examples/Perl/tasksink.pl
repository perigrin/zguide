#!/usr/bin/env perl
use 5.12.2;

# Task sink (Based on Python Version)
# Binds PULL socket to tcp://localhost:5558
# Collects results from workers via that socket

use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new;

my $receiver = $ctx->socket(ZMQ_PULL);
$receiver->bind('tcp://*:5558');

my $s = $receiver->recv();

my $tstart = time();

my $total_msec = 0;
for my $task ( 1 .. 100 ) {
    my $s = $receiver->recv;
    print $task % 10 == 0 ? ':' : '.';
}

my $tend = time();

say sprintf "Total elapsed time: %d", ( ( $tend - $tstart ) * 1000 );