package App::CharmKit::Logging;

# ABSTRACT: reporting utilities

=head1 SYNOPSIS

Directly,

use App::CharmKit::Logging;

Or sugar,

use charm -logging;

log 'this is a log emitter';

=head1 DESCRIPTION

Reporting utilities

=cut

use App::CharmKit::Sys qw/execute/;
use Exporter qw/import/;

our @EXPORT = qw/log/;

=func log(STR message)

Utilizies juju-log for any additional logging

=cut
sub log {
    my ($message) = @_;
    execute(['juju-log', $message]);
}

1;
