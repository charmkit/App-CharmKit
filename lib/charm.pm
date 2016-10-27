package charm;

=head1 NAME

charm - sugary charm entrypoint

=head1 SYNOPSIS

  use charm;

  log "Starting install";
  my $output = run 'ls /tmp';
  print($output);

=cut

=head1 DESCRIPTION

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, Path::Tiny, Rex, Mojolicious,
etc ..

=cut

use strict;
use warnings;
use Import::Into;
use feature ();
use Path::Tiny;
use App::CharmKit::Sys;
use Rex;
use Rex::Commands;
use Rex::Commands::Run;
use Rex::Commands::File;
use Rex::Commands::Download;
use Rex::Commands::Pkg;
use FindBin;
use lib "$FindBin::Bin/../lib";

our $VERSION = '1.14_02';

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'feature'->import::into($target, ':5.20');
    'English'->import::into($target, '-no_match_vars');
    Rex->import::into($target, '-feature '.[qw(no_path_cleanup)]);
    Rex::Commands->import::into($target);
    Rex::Commands::Run->import::into($target);
    Rex::Commands::Pkg->import::into($target);
    Rex::Commands::Download->import::into($target);
    Rex::Commands::File->import::into($target);
    Path::Tiny->import::into($target, qw(path cwd));
    App::CharmKit::Sys->import::into($target, qw(spew slurp log tpl));
}


1;
