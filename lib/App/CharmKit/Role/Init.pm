package App::CharmKit::Role::Init;

# ABSTRACT: Initialization of new charms

use Carp;
use Moo::Role;

=method init(Path::Tiny path, HASHREF project)

Creates new charm project using `path` basename as toplevel directory.
`project` contains information to populate the requirements for a charm
as described at https://juju.ubuntu.com/docs/authors-charm-writing.html

=cut
sub init {
    my ($self, $path, $project) = @_;
    if ($path->exists) {
        croak "$path exists and/or is not empty, please choose a different",
          "charm name or remove the existing directory.";
    }
    $path->child('hooks')->mkpath or die $!;
    $path->child('src')->mkpath   or die $!;
    print "Your project is now ready.\n";
}

1;
