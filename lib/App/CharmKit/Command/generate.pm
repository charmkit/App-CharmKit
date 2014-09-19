package App::CharmKit::Command::generate;

# ABSTRACT: Generator for hook composition

use App::CharmKit -command;
use Moo;
with('App::CharmKit::Role::Generate');
use namespace::clean;

=method opt_spec

--relation|-r

Generates a relation based hook defined by the charms access to
interfaces.  For example, to generate a relation hook that requires a
database interface, run:

    $ charmkit generate -r database-relation-joined

--all|-a

Generates all known default hooks

    $ charmkit generate --all

=cut
sub opt_spec {
    return (
        ["relation|r", "generate a relation hook"],
        ["all|a",      "generate all default hooks"]
    );
}

sub abstract { 'Generator for hook composition'}
sub usage_desc {'%c generate [-r] <hook-name>'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    if (!$opt->{all}) {
        $self->usage_error("Must be a hook of name install, "
              . "config-changed, start, start, upgrade-charm")
          unless $opt->{relation}
          || $args->[0] =~ /^install|config-changed|start|stop|upgrade-charm/;
    }
}

=method execute

Executes the associated Role passing in any hook argument

=cut
sub execute {
    my ($self, $opt, $args) = @_;
    if ($opt->{all}) {
        printf("Generating all hooks ..\n");
        $self->create_all_hooks;
    }
    else {
        printf("Generating %s hook ..\n", $args->[0]);
        $self->create_hook($args->[0]);
    }
    printf("Done.\n");
}

1;
