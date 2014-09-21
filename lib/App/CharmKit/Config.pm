package App::CharmKit::Config;

# ABSTRACT: juju configuration query

=head1 SYNOPSIS

# `config.yaml` contains a `port` option

use App::CharmKit::Config;

my $conf = App::CharmKit::Config->new;
$conf->get('port');

=head1 DESCRIPTION

Juju configuration getter/setters

=cut

use App::CharmKit::Sys;
use Moo;
use namespace::clean;

=attr sys

App::CharmKit::Sys object

=cut
has sys => (
    is      => 'ro',
    lazy    => 1,
    default => sub { App::CharmKit::Sys->new; }
);

=method get(STR option)

Queries a config option

=cut
sub get {
    my ($self, $key) = @_;
    my @cmd = qw/config-get $key/;
    return $self->run(\@cmd);
}

=method set(STR key, STR option)

Sets a configuration variable

=cut
sub set {
  my ($self, $key, $option) = @_;
}

1;
