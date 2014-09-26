package App::CharmKit::Command::test;

# ABSTRACT: Test your charm project

=head1 SYNOPSIS

  $ charmkit test

=head1 DESCRIPTION

Runs tests against packaged charm project, useful during iterative testing
against local juju deployments.

=cut

use parent 'App::CharmKit::Role::Pack';
use App::CharmKit -command;

sub opt_spec {
    return (
        [   "rebuild|r",
            "force a re-pack of charm project before running tests"
        ]
    );
}

sub usage_desc {'%c test [-r]'}

sub execute {
    my ($self, $opt, $args) = @_;
    if ($opt->{rebuild}) {
        $self->build;
    }
    my $cmd = "prove -lv tests/*.test";
    system($cmd);
}

1;

