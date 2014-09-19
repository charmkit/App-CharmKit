package App::CharmKit::Command::pack;

# ABSTRACT: Generate project

use App::CharmKit -command;

use Moo;
with('App::CharmKit::Role::Pack');

use namespace::clean;

sub opt_spec {
    return (
        ["build", "generate distributable hooks with included dependencies"],
        [   "release",
            "release final hooks into a charm resolvable hooks directory. "
              . "this will call --build automatically."
        ]
    );
}

sub abstract { 'Package hooks'}
sub usage_desc {'%c pack [--build|--release]'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Must specify --build or --release.")
      unless $opt->{build} || $opt->{release};
}

sub execute {
    my ($self, $opt, $args) = @_;
    if ($opt->{build}) {
      printf("Performing build hooks ..\n");
      $self->build;
      return;
    }
    if ($opt->{release}) {
      printf("Processing hooks for release ..\n");
      $self->release;
    }
}

1;

