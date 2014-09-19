package App::CharmKit::Command::init;

# ABSTRACT: Initialization of project

use App::CharmKit -command;
use Path::Tiny;
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
    $self->usage_error("Needs a project name") unless shift @{$args};
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $path = shift @{$args};
    printf("Initializing project .");
}

1;

