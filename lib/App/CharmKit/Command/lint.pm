package App::CharmKit::Command::lint;

=head1 NAME

App::CharmKit::Command::lint - charm linter

=head1 SYNOPSIS

  $ charmkit lint

=cut

use strict;
use warnings;
use App::CharmKit -command;
use parent 'App::CharmKit::Role::Lint';

sub opt_spec {
    return ();
}

sub usage_desc {'%c lint'}

sub execute {
    my ($self, $opt, $args) = @_;
    $self->parse();
    exit($self->has_error);
}

1;

