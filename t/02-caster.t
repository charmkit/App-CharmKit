#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin../lib";

plan skip_all =>
  'must export JUJU_PASS and JUJU_ENDPOINT to enable these tests'
  unless $ENV{JUJU_PASS} && $ENV{JUJU_ENDPOINT};

diag('Testing caster');

use charm;

my $cast = load_helper(
    'Cast',
    {   endpoint => 'wss://localhost:17070',
        password => 'secret'
    }
);

ok($cast->isa('App::CharmKit::Cast'), 'is cast instance');
ok($cast->juju->isa('Juju'), 'is juju instance');
ok($cast->password eq 'secret');

done_testing();
