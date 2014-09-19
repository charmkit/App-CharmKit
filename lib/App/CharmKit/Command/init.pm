package App::CharmKit::Command::init;

# ABSTRACT: Initialization of project

use Path::Tiny;
use IO::Prompter [-verb];
use App::CharmKit -command;

use Moo;
with('App::CharmKit::Role::Init');

use namespace::clean;

sub opt_spec {
    return (
        [   "category=s",
            "generate skelton of category: applications(default), app-servers, "
              . "cache-proxy, databases, file-servers, misc",
            {default => 'applications'}
        ]
    );
}

sub abstract { 'Generate a charm skeleton.'}
sub usage_desc {'%c init [--options] <charm-name>'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    if ($opt->{category} !~
        /^applications|app-servers|cache-proxy|databases|file-servers|misc/)
    {
        $self->usage_error("Incorrect type specified, see help.");
    }

    $self->usage_error("Needs a project name") unless defined $args->[0];

    if ($args->[0] =~ /^[0-9\-]|\-$/) {
        $self->usage_error(
            "Name must start with [a-z] and not end with a '-'");
    }
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $path    = path(shift @{$args});
    my $project = {};
    if ($path->exists) {
        $self->usage_error("Project already exists at $path,"
              . "please pick a new one or remove that directory.");
    }
    printf("Initializing project %s\n", $path->absolute);

    @ARGV = ();    # IO::Prompter workaround
    $project->{name}        = prompt 'Name:', -def => "$path";
    $project->{summary}     = prompt 'Summary:';
    $project->{description} = prompt 'Description:';
    $project->{maintainer}  = prompt 'Maintainer:', -def => 'Hedgey Hedgehog';
    $project->{categories}  = [prompt 'Category:', -def => $opt->{category}];

    $self->init($path, $project);
    printf("Project skeleton created.\n");
}

1;
