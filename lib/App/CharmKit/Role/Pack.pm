package App::CharmKit::Role::Pack;

# ABSTRACT: Fatpack hooks

use strict;
use warnings;
use Path::Tiny;

=attr src

Path::Tiny object for pristine hooks. Primarily used during development
of non fatpacked hooks.

=attr src_tests

Path::Tiny object for pristine tests. Primarily used during development
of non fatpacked hooks.
=cut

use Class::Tiny {
    src       => path('.')->child('src/hooks'),
    src_tests => path('.')->child('src/tests')
};


=method build()

Uses fatpack to build the hooks and pulls in any necessary
perl dependencies for use
=cut
sub build {
    my ($self) = @_;
    my ($cmd, $dst);
    my $iter = $self->src->iterator;
    while (my $p = $iter->()) {
        $dst = path('hooks')->child($p->basename);
        $cmd =
            "fatpack pack "
          . $p->absolute . " > "
          . $dst->absolute
          . " 2>/dev/null";
        printf("Processing hook: %s\n", $p->basename);
        `$cmd`;
        $dst->chmod(0777);
    }
    my @tests_path = $self->src_tests->children(qr/\.test$/);
    for my $testp (@tests_path) {
        $dst = path('tests')->child($testp->basename);
        $cmd =
            "fatpack pack "
          . $testp->absolute . " > "
          . $dst->absolute
          . " 2> /dev/null";
        `$cmd`;
        $dst->chmod(0777);
        printf("Processing test: %s\n", $testp->basename);
    }
}

1;
