#!/usr/bin/env perl
use 5.12.2;
use Time::HiRes;

# Task ventilator (based on Python version)
# Binds PUSH socket to tcp://localhost:5557
# Sends batch of tasks to workers via that socket

use ZeroMQ qw/:all/;

my $ctx    = ZeroMQ::Context->new;
my $sender = $ctx->socket(ZMQ_PUSH);

$sender->bind('tcp://*:5557');

say "Press enter when the workers are ready: ";
until (<>) { }

say "Sending tasks to workers...";

$sender->send('0');

my $total_msec = 0;

for my $task ( 1 .. 100 ) {
    my $workload = int( rand(100) + 1 );
    $total_msec += $workload;
    $sender->send($workload);
}

say "Total expected cost: $total_msec msec";
sleep(1);
