package charm;

# ABSTRACT: charm helpers for App::CharmKit

=head1 SYNOPSIS

  use charm;

  log "Starting install";
  my $ret = execute(['ls', '/tmp']);
  print($ret->{stdout});

=cut

=head1 DESCRIPTION

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, utf8, Path::Tiny,
etc ..

=cut

use strict;
use utf8::all;
use warnings;
no warnings "experimental::signatures";

use Import::Into;

use feature ();
use Path::Tiny;

our $VERSION = '1.0.8';

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'utf8::all'->import::into($target);
    'autodie'->import::into($target, ':all');
    'feature'->import::into($target, ':5.20');
    'English'->import::into($target, '-no_match_vars');
    Path::Tiny->import::into($target, qw(path));

    # expose system utilities by default
    require 'App/CharmKit/Sys.pm';
    'App::CharmKit::Sys'->import::into($target);

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
* L<boolean>

=cut
