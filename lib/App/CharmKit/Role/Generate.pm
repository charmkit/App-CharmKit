package App::CharmKit::Role::Generate;

# ABSTRACT: Project generation role

use Moo::Role;

=method create_hook(str hook)

Generator for tasks.

=cut
sub create_hook {
    my ($self, $hook) = @_;
}

1;
