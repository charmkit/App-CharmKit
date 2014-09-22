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

Utilizies log for logging

=cut
sub log {
    my ($message) = @_;
    my $cmd = execute(['juju-log', $message]);
    print($cmd->{stdout});
}

1;
