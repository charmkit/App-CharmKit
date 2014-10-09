package App::CharmKit::Cast;

# ABSTRACT: Wrapper for functional charm testing

=head1 SYNOPSIS

Directly,

  use App::CharmKit::Cast qw(cast);

Or sugar,

  use charm -tester;

  my $cast = load_helper(
    'Cast',
    {   endpoint => 'wss://localhost:17070',
        password => 'secret'
    }
  );

  $cast->deploy('wordpress');
  $cast->deploy('mysql');
  $cast->add_relation('wordpress', 'mysql');

=head1 DESCRIPTION

Helper routines for dealing with functional charm testing

=cut

use strict;
use warnings;
use App::CharmKit::Helper;
use IO::Socket::PortState qw(check_ports);
use Juju;
use Class::Tiny qw(endpoint password), {
    juju => sub {
        my $self = shift;
        my $juju =
          Juju->new(endpoint => $self->endpoint, password => $self->password);
        return $juju;
    }
};

=method deploy

Deploys a charm with default constraints

=cut
sub deploy {
    my ($self, $charm) = @_;
    $self->juju->deploy($charm);
}

=method add_relation

Add relations between services

=cut
sub add_relation {
    my ($self, $endpointa, $endpointb) = @_;
    $self->juju->add_relation($endpointa, $endpointb);
}

=method is_listening

Checks if a service is listening on a port

=cut
sub is_listening {
    my ($self, $service, $port) = @_;

    my $ip = unit_get($service);
    my %porthash = (tcp => $port => {name => $service});
    my $check_port = check_ports($ip, 5, \%porthash);
    return $check_port->{open};
}




1;
