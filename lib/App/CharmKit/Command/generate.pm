package App::CharmKit::Command::generate;

# ABSTRACT: Generator for hook composition

=head1 SYNOPSIS

Generate `install` hook

  $ charmkit generate install

Generate all hooks

  $ charmkit generate -a

Generate a website relation based hook

  $ charmkit -r website-relation-changed

=cut

use App::CharmKit -command;
use Moo;
with('App::CharmKit::Role::Generate');
use namespace::clean;

=head1 OPTIONS

=head2 relation|r

Generates hook based on its relation

=head2 all|a

Generates all known hooks

=cut
sub opt_spec {
    return (
        ["relation|r", "generate a relation hook"],
        ["all|a",      "generate all default hooks"]
    );
}

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
