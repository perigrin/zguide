#!/usr/bin/env perl 
use 5.12.2;
our $|++;                      # autoflush
use Time::HiRes qw(usleep);    # import microsleep

#  Task worker - design 2
#  Adds pub-sub flow to receive and respond to kill signal

use ZeroMQ qw/0.02_02 :all/;    # use the development version of ZeroMQ

my $ctx = ZeroMQ::Context->new;

my $receiver = $ctx->socket(ZMQ_PULL);
$receiver->conect('tcp://localhost:5557');

my $sender = $ctx->socket(ZMQ_PUSH);
$sender->connect('tcp://localhost:5558');

my $controller = $ctx->socket(ZMQ_SUB);
$controller->connect('tcp://localhost:5559');
$controller->setsockopt( ZMQ_SUBSCRIBE, '', 0 );

my $pi = ZMQ::PollItem->new;

$pi->add(
    $receiver,
    ZMQ_POLLIN,
    sub {

        # process task
        my $message  = $receiver->recv();
        my $workload = $message->data;      # workload in msecs
        usleep($workload);                  # do the work
        $sender->send('0');                 # Send results to sink
        print '.';                          # simple status indicator

    }
);

# Any waiting controller command acts as 'KILL'
$pi->add( $controller, ZMQ_POLLIN, sub { exit; } );

$pi->poll(0);
