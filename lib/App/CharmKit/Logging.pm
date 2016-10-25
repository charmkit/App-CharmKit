package App::CharmKit::Logging;

=head1 NAME

App::CharmKit::Logging - logging method

=head1 SYNOPSIS

Directly,

  use App::CharmKit::Logging;

Or sugar,

  use charm;

  log 'this is a log emitter';

=head1 DESCRIPTION

Reporting utilities

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use App::CharmKit::Sys qw/sh/;
use base "Exporter::Tiny";

our @EXPORT = qw/log/;

=over 8

=item log($message, $level)

Utilizies juju-log for any additional logging

=cut

sub log($message, $level=undef) {
    my $cmd = ['juju-log'];
    if ($level) {
      push @{$cmd}, '-l';
      push @{$cmd}, $level;
    }
    push @{$cmd}, $message;
    sh($cmd);
}

=back

1;
