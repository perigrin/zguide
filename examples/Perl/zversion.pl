#!/usr/bin/env perl 
use 5.12.2;    # not neccessary but enables strict and modern features

#   Report 0MQ version

use ZeroMQ ();    # we don't need to import anything.

say 'Current 0MQ version is ' . ZeroMQ::version();
