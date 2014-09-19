package App::CharmKit::Role::Init;

# ABSTRACT: Initialization of new charms

use Carp;
use YAML::Tiny;
use Software::License;
use Moo::Role;

=method init(Path::Tiny path, HASH project)

Creates new charm project using `path` basename as toplevel directory.
`project` contains information to populate the requirements for a charm
as described at https://juju.ubuntu.com/docs/authors-charm-writing.html

A project hash consists of:

    name => "my-charm",
    summary => "A simple summary",
    description => "An extended description",
    maintainer => "Joe Hacker",
    categories => "applications"
=cut
sub init {
    my ($self, $path, $project) = @_;
    $path->child('hooks')->mkpath     or die $!;
    $path->child('src/hooks')->mkpath or die $!;

    my $yaml = YAML::Tiny->new($project);
    $yaml->write($path->child('metadata.yaml'));

    $yaml = YAML::Tiny->new({options => ""});
    $yaml->write($path->child('config.yaml'));

    (   my $readme = qq{
# $project->{name} - $project->{summary}

$project->{description}

# AUTHOR

$project->{maintainer}

# COPYRIGHT

<year> $project->{maintainer}

# LICENSE

<insert license here>
}
    );
    $path->child('README.md')->spew_utf8($readme);
    my $class = "Software::License::" . $project->{license};
    eval "require $class;";
    my $license = $class->new({holder => $project->{maintainer}});
    $path->child('LICENSE')->spew_utf8($license->fulltext);
}

1;
