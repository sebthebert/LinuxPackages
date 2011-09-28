#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use LinuxPackages::Distribution;

my $DIR_DATA = "$FindBin::Bin/../data";

my ($distrib, $release, $arch) = @ARGV;

LinuxPackages::Distribution::Download_From_Archive($distrib, $release, $arch, $DIR_DATA);