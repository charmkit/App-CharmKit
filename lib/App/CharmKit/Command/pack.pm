package App::CharmKit::Command::pack;

# ABSTRACT: Package hooks for distribution

=head1 OVERVIEW

In order for a charm to be utilized by juju all hooks must be executable
and located within your `<toplevel-dir>/hooks` folder. In order to provide
all dependencies needed by the hooks a method of `fatpacking` occurs to
bake in all necessary code for each hook to utilize.

The `pack` command will handle all the heavy lifting of fatpacking and
producing the hooks needed by Juju and if necessary the charm store during
publishing.

=head1 SYNOPSIS

Coerce your charm code to a releasable charm.

  $ charmkit pack

=cut

use App::CharmKit -command;

use Moo;
with('App::CharmKit::Role::Pack');

use namespace::clean;

sub opt_spec {
    return ();
}

sub usage_desc {'%c pack'}

sub execute {
    my ($self, $opt, $args) = @_;
    $self->build;
}

1;
