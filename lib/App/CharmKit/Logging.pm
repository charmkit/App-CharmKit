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
use App::CharmKit::Sys qw/execute/;
use base "Exporter::Tiny";

our @EXPORT = qw/log/;

=over 8

=item log($level, $msg)

Utilizies juju-log for any additional logging

=cut

sub log {
    my $message = shift;
    my $level = shift || undef;
    my $cmd = ['juju-log'];
    if ($level) {
      push @{$cmd}, '-l';
      push @{$cmd}, $level;
    }
    push @{$cmd}, $message;
    execute($cmd);
}

=back

1;
