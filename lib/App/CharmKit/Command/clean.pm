package App::CharmKit::Command::clean;

# ABSTRACT: Cleanses project

=head1 SYNOPSIS

  $ charmkit clean

=cut

use App::CharmKit -command;
use Path::Tiny;

use Moo;
with 'App::CharmKit::Role::Clean';
use namespace::clean;

sub opt_spec {
    return ();
}

sub abstract { 'Cleanses project'}
sub usage_desc {'%c clean'}

sub execute {
    my ($self, $opt, $args) = @_;

    my @paths_to_rm = path('tests')->children(qr/\.test/);
    if (path('fatlib')->exists) {
        push @paths_to_rm, path('fatlib');
    }
    push @paths_to_rm, path('hooks')->children;
    $self->clean(\@paths_to_rm);
    print("Finished cleaning project.\n");
}

1;

