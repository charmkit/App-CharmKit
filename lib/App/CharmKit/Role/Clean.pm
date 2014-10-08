package App::CharmKit::Role::Clean;

# ABSTRACT: Project cleaner role

use strict;
use warnings;
use Class::Tiny;

=method clean

Cleans up files.

=cut
sub clean {
    my ($self, $files) = @_;
    map { -f $_ ? $_->remove : $_->remove_tree } @{$files};
}

1;
