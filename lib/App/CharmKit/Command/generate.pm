package App::CharmKit::Command::generate;

# ABSTRACT: Generate project

use App::CharmKit -command;
use Moo;
use namespace::clean;

sub opt_spec {
    return (
        [   "t|type",
            "generate skelton of type (application, library, or none(default))"
        ]
    );
}

sub abstract { 'Generate a charm skeleton.'}
sub usage_desc {'%c generate -t|--type=library <charm-name>'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error(
        "Incorrect type specified, must be application, library, or none.")
      unless $opt->{type} =~ /^application|library|none/;
}

sub execute {
    my ($self, $opt, $args) = @_;
    printf("Running generate.");
}

1;

