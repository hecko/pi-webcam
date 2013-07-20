#!/usr/bin/perl

use FindBin qw<$Bin>;
use lib "$Bin/../lib";

use common::sense;
use DateTime;
use Fcntl qw(:flock);
use Utils;
use Imager;

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 is already running. Exiting.\n";
    exit(1);
}

my $serial = get_serial();

`echo "Starting app (serial: $serial)" >> /var/log/webcam.log`;

$serial = "b";

while (1) {
    # the following returns UTC timezone
    my $dt = DateTime->now();
    my $path = $Bin."/../data/".$serial."/".$dt->year()."/".$dt->month()."/".$dt->day()."/";
    my $filename = $path.$dt->iso8601().'UTC.jpg';
    `mkdir -p $path`;
    my $cmd = "raspistill --rotation 180 -o $filename -e jpg -q 30 -n -w 800 -h 600";
    say $cmd;
    `$cmd`;
    my $retcode = $? >> 8;
    say "Retcode: $retcode";
    `date >> /var/log/webcam.log`;

    my $img = Imager->new(file => $filename);
    my $font = Imager::Font->new( file => "/usr/share/fonts/truetype/freefont/FreeMono.ttf" );
    $img->string(x => 10, y => 20, string => $dt->iso8601()."UTC", font => $font, size => 25, aa => 1, color => 'white');
    $img->write(file=>$filename);

    `cp $filename $Bin/../data/$serial/latest`;
    $cmd = "rsync -avz --remove-source-files $Bin/../data/* maco\@lists.blava.net:~/public_html/webcam/data/";
    say $cmd;
    `$cmd`;
#    sleep 2;
};

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
