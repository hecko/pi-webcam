#!/usr/bin/perl

use FindBin qw<$Bin>;
use lib "$Bin/../lib";

use common::sense;
use DateTime;
use Fcntl qw(:flock);
use Utils;
use Imager;

our $LocalTZ = DateTime::TimeZone->new( name => 'local' );

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 is already running. Exiting.\n";
    exit(1);
}

my $serial = get_serial();

say "Starting app (serial: $serial)";

while (1) {
    my $utc = DateTime->now();
    my $dt = DateTime->now( time_zone => $LocalTZ );

    my $path = $Bin."/../data/".$serial."/".$utc->year()."/".$utc->month()."/".$utc->day()."/";
    my $filename = $path.$utc->iso8601().'.jpg';
    run("mkdir -p $path");
    run("raspistill --rotation 180 -o $filename -e jpg -q 50 -n -w 800 -h 600");

    my $img = Imager->new( file => $filename );
    my $font = Imager::Font->new( file => "/usr/share/fonts/truetype/freefont/FreeMono.ttf" );
    $img->box( xmax  => 205,     ymax => 12, 
               color => 'black', filled => 1 );
    $img->string( x     => 2,     y    => 11, string => $dt->iso8601().($dt->offset()/3600), 
                  font  => $font, size => 15, aa     => 1, 
                  color => 'white' );
    $img->write( file=>$filename );

    run("cp $filename $Bin/../data/$serial/latest");
};

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
