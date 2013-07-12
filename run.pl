#!/usr/bin/perl

use common::sense;
use DateTime;
use FindBin qw<$Bin>;

use lib "$Bin/../lib";

say "Starting app";

while (1) {
    # the following returns UTC timezone
    my $dt = DateTime->now();
    my $now = $dt->iso8601();
    my $filename = $now;
    say "Another run ($filename)";
#    `uvccapture -m -o$Bin/data/$filename.jpg > /dev/null`;
    `fswebcam --info $now --no-timestamp --skip 5 --delay 2 \\
     --no-title --no-subtitle --no-shadow \\
     --device /dev/video0 --input 0 --save $Bin/data/$filename.jpg`;
    `cp $Bin/data/$filename.jpg $Bin/data/snap.jpg`;
    `rsync -avz --remove-source-files $Bin/data/* maco\@lists.blava.net:~/public_html/webcam/`;
    sleep 5;
};
