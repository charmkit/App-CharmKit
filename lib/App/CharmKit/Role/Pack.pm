package App::CharmKit::Role::Pack;

# ABSTRACT: Fatpack hooks

use Path::Tiny;
use Moo::Role;

=attr src

Path::Tiny object for pristine hooks. Primarily used during development
of non fatpacked hooks.
=cut
has src => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        path('.')->child('src/hooks');
    }
);

=method build()

Uses fatpack to build the hooks and pulls in any necessary
perl dependencies for use
=cut
sub build {
    my ($self) = @_;
    my $iter = $self->src->iterator;
    while (my $p = $iter->()) {
        my $dst = path('hooks')->child($p->basename);
        my $cmd =
            "fatpack pack "
          . $p->absolute . " > "
          . $dst->absolute
          . " 2>/dev/null";
        printf("Processing hook: %s\n", $p->basename);
        `$cmd`;
        $dst->chmod(0777);
    }
}

1;
