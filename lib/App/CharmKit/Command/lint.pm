package App::CharmKit::Command::lint;

# ABSTRACT: Charm Linter

=head1 SYNOPSIS

  $ charmkit lint

=cut

use App::CharmKit -command;
use Moo;
with 'App::CharmKit::Role::Lint';
use namespace::clean;

sub opt_spec {
    return ();
}

sub usage_desc {'%c lint'}

sub execute {
    my ($self, $opt, $args) = @_;
    $self->parse();
    exit($self->has_error);
}

1;

