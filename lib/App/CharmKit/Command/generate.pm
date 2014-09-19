package App::CharmKit::Command::generate;

# ABSTRACT: Generate project

use App::CharmKit -command;
use Moo;
with('App::CharmKit::Role::Generate');
use namespace::clean;

sub opt_spec {
    return (
        [   "relation|r",
            "generate a relation hook"
        ]
    );
}

sub abstract { 'Generate a charm skeleton.'}
sub usage_desc {'%c generate [-r] <hook-name>'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Must be a hook of name install, "
          . "config-changed, start, start, upgrade-charm")
      unless $opt->{relation}
      || $args->[0] =~ /^install|config-changed|start|stop|upgrade-charm/;
}

sub execute {
    my ($self, $opt, $args) = @_;
    printf("Generating %s hook ..\n", $args->[0]);
    $self->create_hook($args->[0]);
    printf("Done.\n");
}

1;

