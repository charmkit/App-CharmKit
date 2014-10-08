package App::CharmKit::Role::Git;

# ABSTRACT: Checkout from git endpoints

use strict;
use warnings;
use Path::Tiny;
use Git::Repository;
use Class::Tiny {
    github => sub {'git@github.com'}
};

=method clone

clone repo from github or another git endpoint

=cut

sub clone {
    my ($self, $location, $dst) = @_;
    my $cmd = ['clone', '-q'];
    if ($location =~ /^\w+\/\w+/) {
        $location = sprintf("%s:%s.git", $self->github, $location);
    }

    # Make sure dst exists, if not create the parent directories
    if (!$dst->exists) {
        $dst->mkpath;
    }

    Git::Repository->run(clone => $location, $dst, { quiet => 1 });
    printf("%s cloned to %s\n", $location, $dst->absolute);
}

1;
