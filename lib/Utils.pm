#!/usr/bin/perl

package Utils;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(get_serial);

use common::sense;

sub get_serial {
    my $mac = set_input(`cat /sys/class/net/eth0/address`);
    my $cpu = set_input(`cat /proc/cpuinfo | grep Serial | awk '{ print \$3}'`);

    say "MAC:        $mac";
    say "CPU serial: $cpu";

    my $crypt = crypt($cpu,$mac);
    $crypt =~ s/(\.)|(\/)//g;
    $crypt = lc($crypt);

    sub set_input {
        my ($in) = @_;
        chomp($in);
        $in =~ s/(:)|(\.)//g;
        $in = lc($in);
        return $in;
    }

    return $crypt;
}

1;
