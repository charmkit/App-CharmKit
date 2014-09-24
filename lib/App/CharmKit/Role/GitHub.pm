package App::CharmKit::Role::GitHub;

# ABSTRACT: Checkout from github

use Path::Tiny;
use Moo::Role;

=method clone(STR location, STR dst)

clone repo from github

=cut
sub clone {
    my $self = shift;
    my $location = shift;
    my $dst = shift || (split /\//, $location)[-1];
    my $cmd = sprintf("git clone -q git\@github.com:%s.git %s", $location, $dst);
    `$cmd`;
    printf("%s cloned to %s\n", $location, $dst);
}

1;
