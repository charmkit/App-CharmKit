#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin../lib";
use charm -tester;
use Mock::Sub;


diag('Testing import::into syntax sugar');
ok(sh("uname -a"), 'can run sh uname -a');
file("/tmp/test", ensure => "directory");
ok(path('/tmp/test')->exists, 'directory created');
file("/tmp/test", ensure => "absent");
ok(!path('/tmp/test')->exists, 'directory removed');
can_ok(__PACKAGE__, 'sh');
can_ok(__PACKAGE__, 'plugin');
can_ok(__PACKAGE__, 'status');
can_ok(__PACKAGE__, 'config');
can_ok(__PACKAGE__, 'unit');
can_ok(__PACKAGE__, 'resource');

my $mock        = Mock::Sub->new;
my $status_mock = $mock->mock('status');
$status_mock->return_value("status-get active ready.");

like(status(level => 'active', msg => 'ready.'), qr/status-get active ready./, "status-get runs with correct params");

done_testing();
