#!/usr/bin/perl

package Utils;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(get_serial run);

use common::sense;

sub get_serial {
    my $mac = set_input(`cat /sys/class/net/eth0/address`);
    my $cpu = set_input(`cat /proc/cpuinfo | grep Serial | awk '{ print \$3}'`);

    say "MAC:        $mac";
    say "CPU serial: $cpu";

    sub set_input {
        my ($in) = @_;
        chomp($in);
        return $in;
    }

    $cpu =~ s/^0+//;
    return $cpu;
}

sub run {
    my $cmd = shift;
    say $cmd;
    my $cmd_out = `$cmd`;
    my $retcode = $? >> 8;
    warn "Retcode $retcode when running $cmd: $cmd_out" if ($retcode != 0);
    return $cmd_out;
}

1;
