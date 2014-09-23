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

my $yaml_string = Load("---\noption: 'A yaml option'");
ok $yaml_string->{option} eq 'A yaml option';

my $path_string = path('/tmp/what');
ok $path_string->absolute eq '/tmp/what';

my $json = decode_json('{ "option" : "A json option"}');
ok $json->{option} eq 'A json option';
done_testing();
