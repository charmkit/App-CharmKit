package App::CharmKit::Command::clone;

# ABSTRACT: Clone charm from github

=head1 SYNOPSIS

  $ charmkit clone battlemidget/charm-plone -o plone

=head1 DESCRIPTION

Clones a charm from GitHub

=cut

use strict;
use warnings;
use App::CharmKit -command;
use parent 'App::CharmKit::Role::GitHub';

sub opt_spec {
    return (
        [   "output|o=s",
            "Destination directory to place cloned charm"
        ]
    );
}

sub usage_desc {
    my $self = shift;
    my $eg   = "charmkit get battlemidget/charm-plone -o plone";
    "$eg\n\n%c clone [-o]";
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Needs a location")
      unless $args->[0];
    $self->usage_error("Invalid location specified")
      unless $args->[0] =~ /^\w+\/\w+/;
}

sub execute {
    my ($self, $opt, $args) = @_;
    if ($opt->{output}) {
        $self->clone($args->[0], $opt->{output});
    }
    else {
        $self->clone($args->[0]);
    }
}

1;

