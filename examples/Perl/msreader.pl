#!/usr/bin/env perl
use 5.12.2;
use Time::HiRes qw(usleep);
use ZeroMQ qw/:all/;

my $ctx = ZeroMQ::Context->new;

# connect to the ventilator
my $receiver = $ctx->socket(ZMQ_PULL);
$receiver->connect('tcp://localhost:5557');

# connect to the weather server
my $subscriber = $ctx->socket(ZMQ_SUB);
$subscriber->connect('tcp://localhost:5556');
$subscriber->setsockopt( ZMQ_SUBSCRIBE, '10001 ', 6 );

# process messages from boths ockets
# we prioritize traffic from the task ventilator

while (1) {

    #  Process any waiting tasks
    until ( my $rc ) {
        if ( $rc = $receiver->recv(ZMQ_NOBLOCK) ) { }    # do something
    }

    # Process any waiting weather updates
    until ( my $rc ) {
        if ( $rc = $subscriber->recv(ZMQ_NOBLOCK) ) { }    # do something
    }

    usleep(1);
}
