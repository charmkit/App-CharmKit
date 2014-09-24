package App::CharmKit::Command::get;

# ABSTRACT: Download a charm

=head1 SYNOPSIS

GitHub checkout

  $ charmkit get battlemidget/charm-plone -o plone

Git checkout

  $ charmkit get git@github.com:battlemidget/charm-plone -o plone
  $ charmkit get https://github.com/battlemidget/charm-plone -o plone

Tarball

  $ charmkit get http://charmkit.io/charms/charm-plone-0.11.tar.xz -o plone

=head1 DESCRIPTION

Downloads a charm, supports git cloning and downloading via url

=cut

use App::CharmKit -command;
use Moo;
with('App::CharmKit::Role::Get');

use namespace::clean;

sub opt_spec {
    return (
        [   "output|o",
            "Destination directory to place downloaded charm"
        ]
    );
}

sub usage_desc {'%c test [-r]'}

sub execute {
    my ($self, $opt, $args) = @_;
    my $get_opts = [];
    if ($opt->{output}) {
      push @{$get_opts}, $opt->{output}
    }

    $self->download($args->[0], $get_opts);
}

1;

