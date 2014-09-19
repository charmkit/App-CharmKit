package App::CharmKit::Role::Generate;

# ABSTRACT: Generators for common tasks

use Moo::Role;

=method create_hook(STR hook)

Creates a charm hook based on `hook` name

=cut
sub create_hook {
    my ($self, $hook) = @_;
}

1;
