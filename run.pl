#!/usr/bin/perl

use FindBin qw<$Bin>;
use lib "$Bin/../lib";

use common::sense;
use DateTime;
use Fcntl qw(:flock);

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 is already running. Exiting.\n";
    exit(1);
}

say "Starting app";

while (1) {
    # the following returns UTC timezone
    my $dt = DateTime->now();
    my $now = $dt->iso8601();
    my $filename = $Bin."/data/".$now.'.jpg';
    say "Another run ($filename)";
#    `uvccapture -m -o$Bin/data/$filename > /dev/null`;

#    `fswebcam --info $now --no-timestamp --skip 5 --delay 2 \\
#     --no-title --no-subtitle --no-shadow \\
#     --device /dev/video0 --input 0 --save $Bin/data/$filename`;

    my $cmd = "raspistill -o $filename -e jpg -q 10 -n -t 0 -rot 200 -w 800 -h 600";

    say "Running $cmd";
    `$cmd`;
    `cp $filename ./data/snap`;
    `rsync -avz --delete-after --remove-source-files $Bin/data/* maco\@lists.blava.net:~/public_html/webcam/`;
    sleep 2;
};

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
