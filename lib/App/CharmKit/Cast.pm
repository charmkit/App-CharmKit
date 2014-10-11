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
use Path::Tiny qw(path);
use YAML::Tiny;
use Class::Tiny qw(endpoint password), {
    juju => sub {
        my $self = shift;
        my $juju =
          Juju->new(endpoint => $self->endpoint, password => $self->password);
        return $juju;
    }
};

sub BUILD {
    my ($self, $args) = @_;
    $self->get_creds unless $self->endpoint || $self->password;
}

=method get_creds

Attempts to pull creds from a running juju environment

=cut

sub get_creds {
    my ($self)    = @_;
    my $juju_env  = $ENV{JUJU_ENV};
    my $juju_home = $ENV{JUJU_HOME};

    die "Unable to determine the running Juju environment"
      unless defined($juju_env);
    my $env_file = path($juju_home)->child('environments/$juju_env.jenv');
    my $env_yaml = YAML::Tiny->read($env_file->abspath);
    if (defined($env_yaml->{password})) {
        $self->password($env_yaml->{password});
    }
    if (defined($env_yaml->{state_servers})) {
        $self->endpoint($env_yaml->{state_servers}->[0]);
    }
    else {
        die "Unable to determine api state server";
    }
}

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
