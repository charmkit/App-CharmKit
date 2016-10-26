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
use Capture::Tiny ':all';
use English;
use Module::Runtime qw(use_package_optimistically);
use boolean;
use Mojo::Template;
use base "Exporter::Tiny";

our @EXPORT = qw/sh
  apt_install
  apt_upgrade
  apt_update
  apt_add_repo
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
    sh("juju-log $message");
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

=item sh(SCALAR $command)

runs a local command:

   my $ret = sh 'juju-log a message';
   print $ret;

B<Arguments>
  command: command to run

B<Returns>
  output of command

=cut

sub sh($command) {
    my ($stdout, $stderr, $exit) = capture {
        system($command);
    };
    chomp($stdout);
    return $stdout;
}


=item apt_add_repo(SCALAR $repo, SCALAR $key, BOOL $update)

Adds a archive repository or ppa. B<key> is required if adding http source.

B<source> can be in the format of:

  ppa:charmers/example
  deb https://stub:key@private.example.com/ubuntu trusty main

=cut

sub apt_add_repo ($repo, $key = undef, $update = false) {
    if ($repo =~ /^(ppa:|cloud:|http|deb|cloud-archive:)/) {
        sh('apt-add-repository --yes ' . $repo);
    }
    if ($repo =~ /^cloud:/) {
        apt_install(['ubuntu-cloud-keyring']);
    }
    if ($key) {
        sh('apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv'
              . $key);
    }
    if ($update) {
        apt_update();
    }
}

=item apt_install(ARRAYREF $pkgs)

Installs packages via apt-get

   apt_install(['nginx']);

=cut

sub apt_install($pkgs) {
    my $cmd = ['apt-get', '-qyf', 'install'];
    map { push @{$cmd}, $_ } @{$pkgs};
    my $ret = sh($cmd);
    return $ret;
}

=item apt_upgrade

Upgrades system

   apt_upgrade();

=cut

sub apt_upgrade {
    my $cmd = ['apt-get', '-qyf', 'dist-upgrade'];
    my $ret = sh($cmd);
    return $ret;
}

=item apt_update

Update repository sources

   apt_update();

=cut

sub apt_update {
    my $cmd = ['apt-get', 'update'];
    my $ret = sh($cmd);
    return $ret;
}

=back

1;
