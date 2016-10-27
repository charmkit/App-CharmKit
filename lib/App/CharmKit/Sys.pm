package App::CharmKit::Sys;

=head1 NAME

App::CharmKit::Sys - hook utilities

=head1 SYNOPSIS

  use charm;

or

  use App::CharmKit::Sys;

  apt_update;
  apt_upgrade;
  apt_install ['nginx-common', 'redis-server'];

=head1 DESCRIPTION

Provides system utilities such as installing packages, managing files, and more.

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Path::Tiny;
use English;
use Module::Runtime qw(use_package_optimistically);
use boolean;
use Mojo::Template;
use Rex::Commands::Run;
use base "Exporter::Tiny";

our @EXPORT = qw/
  log
  spew
  tpl
  slurp/;


sub tpl {
    Mojo::Template->new;
}

=over 8

=item log($message)

Utilizies juju-log for any additional logging

=cut

sub log($message) {
    run "juju-log $message";
}

=item spew(SCALAR $path, SCALAR $contents)

writes to a file, defaults to utf8

=cut

sub spew ($path, $contents) {
    $path = path($path);
    $path->spew_utf8($contents);
}

=item slurp(SCALAR $path)

reads a file, defaults to utf8

=cut

sub slurp($path) {
    $path = path($path);
    return $path->slurp_utf8;
}

=back

1;
