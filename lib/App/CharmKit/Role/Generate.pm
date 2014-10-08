package App::CharmKit::Role::Generate;

# ABSTRACT: Generators for common tasks

use strict;
use warnings;
use Path::Tiny;

=attr src

Path::Tiny object for pristine hooks. Primarily used during development
of non fatpacked hooks.

=attr default_hooks

Arrayref of default charm hooks used when doing a blanket generate
of all hooks.

=cut

use Class::Tiny {
    src => path('.')->child('src/hooks'),
    default_hooks =>
      ['install', 'config-changed', 'upgrade-charm', 'start', 'stop']
};

=method create_hook

Creates a hook file defined by `hook` parameter, also writes out some
initial starter code to file.

=cut
sub create_hook {
    my ($self, $hook) = @_;

    (   my $hook_heading =
          qq{#!/usr/bin/env perl
# To see what helper functions are available to you automatically, run:
# > perldoc App::CharmKit::Helper
#
# Other functionality can be enabled by putting the following in the beginning
# of the file:
# use charm -sys;

use charm;

log("Start of charm authoring for $hook");
}
    );
    $self->src->child($hook)->spew_utf8($hook_heading);
}

=method create_all_hooks

Iterates `default_hooks` and creates the necessary hook files.

=cut
sub create_all_hooks {
    my ($self) = @_;
    foreach (@{$self->default_hooks}) {
        $self->create_hook($_);
    }
}

1;
