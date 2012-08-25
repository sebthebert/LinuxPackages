#!/usr/bin/env perl
use Dancer;

use FindBin;
use lib "$FindBin::Bin/../lib/";

use LinuxPackages::Web;

set layout => 'main';
set template => 'template_toolkit';

dance;
