package App::CharmKit::Role::Get;

# ABSTRACT: Download role

use Moo::Role;

=method download(STR location, ARRAYREF opts)

Downloads charm determind by location and processed based on opts

=cut
sub download {
    my ($self, $location, $opts) = @_;
}

1;
