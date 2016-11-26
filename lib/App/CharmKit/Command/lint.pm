package App::CharmKit::Command::lint;

# ABSTRACT: CharmKit Lint command

=head1 SYNOPSIS

  $ charmkit lint

=head1 DESCRIPTION

This will try to perform an indepth charm proof check so that uploaded charms
may receive quicker turnaround times during review process.

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use App::CharmKit -command;
use parent 'App::CharmKit::Role::Lint';

sub abstract { "charm linter" }
sub description { "Lints your charm and its hooks" }
sub opt_spec {
    return ();
}

sub usage_desc {'%c lint'}

sub execute($self, $opt, $args) {
    $self->parse();
    exit($self->has_error);
}

1;

