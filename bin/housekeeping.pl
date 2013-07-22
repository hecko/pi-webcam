#!/usr/bin/perl

use FindBin qw<$Bin>;
use lib "$Bin/../lib";

use common::sense;
use Fcntl qw(:flock);
use Utils;
use DateTime;

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 is already running. Exiting.\n";
    exit(1);
}

my $dt = DateTime->now();

my $files = run("find $Bin/../data -name \"*.jpg\"");
for my $file (split(/\n/, $files)) {
    my @stat = stat($file);
    my $age = $dt->epoch()-$stat[9];
    if ($age > 3600) {
        say "Deleting $file ($age)";
        die "Problem deleting file $file" if (!unlink($file));
    } else {
        say "Keeping $file ($age)";
    }
}

__DATA__
This exists so flock() code above works.
DO NOT REMOVE THIS DATA SECTION.
