package App::CharmKit::Role::Generate;

# ABSTRACT: Generators for common tasks

use Path::Tiny;
use Moo::Role;

has src => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        path('.')->child('src/hooks');
    }
);

has default_hooks => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        ['install', 'config-changed', 'upgrade-charm', 'start', 'stop'];
    }
);

sub create_hook {
    my ($self, $hook) = @_;

    (   my $hook_heading =
          qq{#!/usr/bin/env perl

# Work starts here
}
    );
    $self->src->child($hook)->spew_utf8($hook_heading);
}

sub create_all_hooks {
    my ($self) = @_;
    foreach (@{$self->default_hooks}) {
        $self->create_hook($_);
    }
}

1;
