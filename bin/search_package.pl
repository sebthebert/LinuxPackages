#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use LinuxPackages::Package;

my ($distrib, $release, $arch, $pattern) = @ARGV;

my $distribs = [ qw/Debian Ubuntu/ ];
my $releases = [ qw/Debian-3.0 Debian-4.0 lucid maverick natty/ ];

my $packages = LinuxPackages::Package::Search($distribs, $releases, $arch, $pattern);

foreach my $p (@{$packages})
{
    printf "Package\n\tdistribution: %s\n\trelease: %s\n\tname: %s\n\tversion: %s\n\tsection: %s\n\tpriority: %s\n", 
        $p->{distribution},
        $p->{distribution_release},
        $p->{name}, 
        $p->{version},
        $p->{section},
        $p->{priority};
}