#!/usr/bin/env perl

#use strict;
use warnings;
use Test::More;
use FindBin;
use Mojo::Template;
use lib "$FindBin::Bin../lib";

diag('Testing import::into syntax sugar');

use_ok('charm');

my $contents   = "this is a test";
my $write_path = path('/tmp/test.txt');
ok(spew($write_path, $contents), 'contents written to test.txt');

my $path_string = path('/tmp/test.txt');
ok($path_string->absolute eq '/tmp/test.txt', 'absolute path found');

my $output = tpl()->render('Hello <%= $_[0] %> was <%= $_[1] %>',
                           'Bender', 'here');
chomp($output);
ok($output eq 'Hello Bender was here', 'template rendered properly');

my $contents_in = slurp('/tmp/test.txt');
ok($contents_in =~ /this is a test/, 'contents read from file and matched');
ok($write_path->remove,              'test.txt removed');

sh('mkdir -p /tmp/test');
ok(path('/tmp/test')->exists, 'directory created');
sh('rm -rf /tmp/test');
ok(!path('/tmp/test')->exists, 'directory removed');

done_testing();
