package App::CharmKit::Role::Generate;

# ABSTRACT: Project generation role

use Moo::Role;

=method create(str name)

Creates the project directory and any template files.

=cut
sub create {
    my ($self, $name) = @_;
}

1;
