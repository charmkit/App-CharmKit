package App::CharmKit::Logging;

# ABSTRACT: reporting utilities

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

=func log

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

1;
