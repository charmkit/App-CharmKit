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

use Moo;
use namespace::clean;

=method get(STR option)

Queries a config option

=cut
sub get {
  my ($self, $pkgs) = @_;
}

=method set(STR key, STR option)

Sets a configuration variable

=cut
sub set {
  my ($self, $key, $option) = @_;
}

1;
