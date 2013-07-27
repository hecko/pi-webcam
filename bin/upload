#!/usr/bin/perl

use FindBin qw<$Bin>;
use lib "$Bin/../lib";

use common::sense;
use Fcntl qw(:flock);
use Utils;

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 is already running. Exiting.\n";
    exit(1);
}

while (1) {
    run("rsync --delay-updates -avz $Bin/../data/* maco\@lists.blava.net:~/public_html/webcam/data/");
};

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
