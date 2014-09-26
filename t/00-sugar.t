#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin../lib";

diag('Testing import::into syntax sugar');

use_ok('charm');

# testing import::into exposures.
my $yaml = yaml();
my $yaml_string = $yaml->read_string("---\noption: A yaml option");
ok($yaml_string->[0]->{option} eq 'A yaml option',
    'yaml file processed and matched');

my $path_string = path('/tmp/what');
ok($path_string->absolute eq '/tmp/what', 'absolute path found');

my $mt = tmpl(template => 'HI THERE');
ok($mt->render_mt->as_string eq 'HI THERE',
    'template file rendered properly');

my $json = json();
my $json_string = $json->decode("{ \"option\": \"A json option\" }");
ok( $json_string->{option} eq 'A json option',
    'json option processed and matched'
);

my $getent = getent('passwd', 'root');
ok($getent->{error} eq 0, 'genent works');

my $dirtest = make_dir(['/tmp/test']);
ok(path('/tmp/test')->exists, 'directory created');
remove_dir(['/tmp/test']);
ok(!path('/tmp/test')->exists, 'directory removed');

my $contents = "this is a test";
my $write_path = path('/tmp/test.txt');
ok(spew($write_path, $contents), 'contents written to test.txt');

my $contents_in = slurp('/tmp/test.txt');
ok($contents_in =~ /this is a test/, 'contents read from file and matched');
ok($write_path->remove, 'test.txt removed');

done_testing();
