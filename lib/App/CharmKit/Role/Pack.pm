package App::CharmKit::Role::Pack;

# ABSTRACT: Fatpack hooks

use Path::Tiny;
use Moo::Role;

=attr src

Source directory for hooks

=cut
has src => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        path('.')->child('src/hooks');
    }
);

=method build()

Packs hooks with required dependencies

=cut
sub build {
    my ($self) = @_;
    my $iter = $self->src->iterator;
    while (my $p = $iter->()) {
        my $cmd = "fatpack pack " . $p->absolute . " > hooks/" . $p->basename. " 2>/dev/null";
        printf("Processing hook: %s\n", $p->basename);
        `$cmd`;
    }
}

1;
