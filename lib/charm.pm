package charm;

=head1 NAME

charm - sugary charm entrypoint

=head1 SYNOPSIS

  use charm;

  log "Starting install";
  my $ret = sh 'ls /tmp';
  print($ret);

=cut

=head1 DESCRIPTION

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, utf8, Path::Tiny,
etc ..

=cut

use strict;
use utf8::all;
use warnings;
use Import::Into;
use feature ();
use Path::Tiny;
use Cwd;
use App::CharmKit::Sys;

our $VERSION = '1.0.12';

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'utf8::all'->import::into($target);
    'feature'->import::into($target, ':5.20');
    'English'->import::into($target, '-no_match_vars');
    Cwd->import::into($target);
    Path::Tiny->import::into($target, qw(path));
    App::CharmKit::Sys->import::into($target,
        qw(sh apt_install apt_upgrade apt_update apt_add_repo spew slurp log tpl)
    );
}


1;
