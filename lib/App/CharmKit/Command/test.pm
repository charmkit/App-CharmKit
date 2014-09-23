package App::CharmKit::Command::test;

# ABSTRACT: Runs a test runner

=head1 SYNOPSIS

  $ charmkit test

=head1 DESCRIPTION

Runs tests against packaged charm project, useful during iterative testing
against local juju deployments.

=cut

use App::CharmKit -command;
use Moo;
with('App::CharmKit::Role::Pack');

use namespace::clean;

sub opt_spec {
    return (
        [   "rebuild|r",
            "force a re-pack of charm project before running tests"
        ]
    );
}

sub abstract { 'Tests your charm project'}
sub usage_desc {'%c test [-r]'}

sub execute {
    my ($self, $opt, $args) = @_;
    if ($opt->{rebuild}) {
        $self->build;
    }
    my $cmd = "prove -v tests/*.test";
    system($cmd);
}

1;

