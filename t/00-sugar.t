#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin../lib";
use DDP;

diag('Testing import::into syntax sugar');

use_ok('charm');

# testing import::into exposures.

my $yaml = yaml();
my $yaml_string = $yaml->read_string("---\noption: A yaml option");
ok $yaml_string->[0]->{option} eq 'A yaml option';

my $path_string = path('/tmp/what');
ok $path_string->absolute eq '/tmp/what';

my $mt = tmpl(template => 'HI THERE');
ok $mt->render_mt->as_string eq 'HI THERE';

my $json = json();
my $json_string = $json->decode("{ \"option\": \"A json option\" }");
ok $json_string->{option} eq 'A json option';

my $getent = getent('passwd', 'root');
ok $getent->{error} eq 0;

my $dirtest = make_dir(['/tmp/test']);
ok path('/tmp/test')->exists;
remove_dir(['/tmp/test']);

done_testing();
