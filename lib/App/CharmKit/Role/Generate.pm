package App::CharmKit::Role::Generate;

# ABSTRACT: Generators for common tasks

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

=attr default_hooks

Arrayref of default charm hooks used when doing a blanket generate
of all hooks.

=cut
has default_hooks => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        ['install', 'config-changed', 'upgrade-charm', 'start', 'stop'];
    }
);

=method create_hook(STR hook)

Creates a hook file defined by `hook` parameter, also writes out some
initial starter code to file.

=cut
sub create_hook {
    my ($self, $hook) = @_;

    (   my $hook_heading =
          qq{#!/usr/bin/env perl

# Work starts here
}
    );
    $self->src->child($hook)->spew_utf8($hook_heading);
}

=method create_all_hooks()

Iterates `default_hooks` and creates the necessary hook files.

=cut
sub create_all_hooks {
    my ($self) = @_;
    foreach (@{$self->default_hooks}) {
        $self->create_hook($_);
    }
}

1;
