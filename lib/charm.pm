package charm;

# ABSTRACT: charm helpers for App::CharmKit

=head1 SYNOPSIS

  use charm;

=cut

=head1 DESCRIPTION

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, utf8, Path::Tiny,
etc ..

    use App::CharmKit::Sys;

or ..

    use charm -sys;
    my $ret = execute(['ls', '/tmp']);
    print($ret->{stdout});
    log('went to the park');

=cut

use strict;
use utf8::all;
use warnings;
use Import::Into;

use feature ();
use Path::Tiny;
use Test::More;

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'utf8::all'->import::into($target);
    'autodie'->import::into($target, ':all');
    'feature'->import::into($target, ':5.14');
    'English'->import::into($target, '-no_match_vars');
    Path::Tiny->import::into($target, qw(path));

    if ($flags{sys}) {
        require 'App/CharmKit/Sys.pm';
        'App::CharmKit::Sys'->import::into($target);
    }

    if ($flags{tester}) {
        Test::More->import::into($target);
    }

    # expose charm helpers by default
    require 'App/CharmKit/Helper.pm';
    'App::CharmKit::Helper'->import::into($target);

    require 'App/CharmKit/Logging.pm';
    'App::CharmKit::Logging'->import::into($target);

}

1;

=head1 MODULES

List of modules exported by helper:

=for :list
* L<Path::Tiny>
Exposes B<path> routine
* L<YAML::Tiny>
Exposes object as B<yaml>
* L<JSON::PP>
Exposes object as B<json>
* L<Text::MicroTemplate>
Exposes object as B<tmpl>
* L<Test::More>
* L<autodie>
* L<utf8::all>

=cut
