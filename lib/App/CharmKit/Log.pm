package App::CharmKit::Log;

# ABSTRACT: logger utilities

=head1 SYNOPSIS

Directly,

use App::CharmKit::Log;

Or sugar,

use charm -log;

log 'this is a log emitter';

=head1 DESCRIPTION

log utilities

=cut

use Exporter qw( import );

our @EXPORT = qw/log/;

=func log(STR message)

Utilizies juju-log for logging

=cut
sub log {
    my ($message) = @_;
    print($message . "\n");
}

1;
