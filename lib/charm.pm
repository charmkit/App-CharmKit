package charm;

=head1 NAME

charm - sugary charm entrypoint

=head1 SYNOPSIS

  use charm;

  run "juju-log Starting install";
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
use Rex;
use Rex::Commands;
use Rex::Commands::Box;
use Rex::Commands::Download;
use Rex::Commands::File;
use Rex::Commands::Fs;
use Rex::Commands::MD5;
use Rex::Commands::Network;
use Rex::Commands::Notify;
use Rex::Commands::Pkg;
use Rex::Commands::Rsync;
use Rex::Commands::Run;
use Rex::Commands::SCM;
use Rex::Commands::Service;
use Rex::Commands::User;
use Rex::Commands::Virtualization;
use FindBin;
use lib "$FindBin::Bin/../lib";

our $VERSION = '2.001000';

sub import {
    my $target = caller;
    my $class  = shift;

    my @flags = grep /^-\w+/, @_;
    my %flags = map +($_, 1), map substr($_, 1), @flags;

    'strict'->import::into($target);
    'warnings'->import::into($target);
    'feature'->import::into($target, ':5.20');
    'English'->import::into($target, '-no_match_vars');
    Rex->import::into($target, '-feature' => [qw(no_path_cleanup)]);
    Rex::Commands->import::into($target);
    Rex::Commands::Box->import::into($target);
    Rex::Commands::Download->import::into($target);
    Rex::Commands::File->import::into($target);
    Rex::Commands::Fs->import::into($target);
    Rex::Commands::MD5->import::into($target);
    Rex::Commands::Network->import::into($target);
    Rex::Commands::Notify->import::into($target);
    Rex::Commands::Pkg->import::into($target);
    Rex::Commands::Rsync->import::into($target);
    Rex::Commands::Run->import::into($target);
    Rex::Commands::SCM->import::into($target);
    Rex::Commands::Service->import::into($target);
    Rex::Commands::User->import::into($target);
    Rex::Commands::Virtualization->import::into($target);
    Path::Tiny->import::into($target, qw(path cwd));
}


1;
