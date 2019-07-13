package charm;

use strict;
use warnings;
no bareword::filehandles;

use true                   ();
use feature                ();
use Path::Tiny             ();
use Test::More             ();

use Sub::Install;
use Import::Into;

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'English'->import::into($target, '-no_match_vars');

    warnings->unimport('once');
    warnings->unimport('experimental');
    warnings->unimport('experimental::signatures');
    warnings->unimport('reserved');

    feature->import(':5.24');
    feature->import('signatures');
    true->import;

    Path::Tiny->import::into($target, qw(path cwd));

    if ($flags{tester}) {
        Test::More->import::into($target);
    }

    # overrides
    require 'App/CharmKit.pm';
    'App::CharmKit'->import::into($target);
}


1;
