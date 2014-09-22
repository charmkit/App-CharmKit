package charm;

# ABSTRACT: charm helpers for App::CharmKit

=head1 SYNOPSIS

use charm;

=cut

=head1 DESCRIPTION

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, utf8, Path::Tiny,
etc ..

    use charm -sys;

or ..
    use App::CharmKit::Sys;

    my $ret = execute ['ls', '/tmp'];
    print($ret->{stdout});
    log 'went to the park';

=cut

use strict;
use utf8::all;
use warnings;
use Import::Into;

use feature ();
use Path::Tiny qw(path);
use Test::More;
use Carp qw(croak);

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'utf8::all'->import::into($target);
    'autodie'->import::into($target, ':all');
    'feature'->import::into($target, ':5.10');
    'English'->import::into($target, '-no_match_vars');

    if ($flags{sys}) {
        require 'App/CharmKit/Sys.pm';
        'App::CharmKit::Sys'->import::into($target);
        Path::Tiny->import::into($target, qw(path));
    }
    if ($flags{logging}) {
        require 'App/CharmKit/Logging.pm';
        'App::CharmKit::Logging'->import::into($target);
    }
    if ($flags{tester}) {
        Test::More->import::into($target);
    }
}

1;

=head1 MODULES

List of modules exported by helper:

L<Path::Tiny::path>

L<Carp::croak>
=cut
