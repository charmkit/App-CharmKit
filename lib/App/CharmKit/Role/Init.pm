package App::CharmKit::Role::Init;

# ABSTRACT: Initialization of new charms

use Carp;
use YAML::Tiny;
use Software::License;
use Moo::Role;

=method init(Path::Tiny path, HASH project)

Builds the initialization directory structure for
charm authoring.

`project` can consists of the following:

    name => 'charm-test'
    summary => 'charm summary'
    description => 'extended description'
    maintainer => 'Joe Hacker'
=cut
sub init {
    my ($self, $path, $project) = @_;
    $path->child('hooks')->mkpath     or die $!;
    $path->child('src/hooks')->mkpath or die $!;

    # .gitignore
    (   my $gitignore = qq{
fatlib
blib/
.build/
_build/
cover_db/
inc/
Build
!Build/
Build.bat
.last_cover_stats
Makefile
Makefile.old
MANIFEST.bak
MYMETA.*
nytprof.out
pm_to_blib
!META.json
.tidyall.d
_build_params
perltidy.LOG
}
    );
    $path->child('.gitignore')->spew_utf8($gitignore);

    # metadata.yaml
    my $yaml = YAML::Tiny->new($project);
    $yaml->write($path->child('metadata.yaml'));

    # config.yaml
    $yaml = YAML::Tiny->new({options => ""});
    $yaml->write($path->child('config.yaml'));

    # LICENSE
    my $class = "Software::License::" . $project->{license};
    eval "require $class;";
    my $license = $class->new({holder => $project->{maintainer}});
    my $year    = $license->year;
    my $notice  = $license->notice;
    $path->child('LICENSE')->spew_utf8($license->fulltext);

    # README.md
    (   my $readme = qq{
# $project->{name} - $project->{summary}

$project->{description}

# AUTHOR

$project->{maintainer}

# COPYRIGHT

$year $project->{maintainer}

# LICENSE

$notice
}
    );
    $path->child('README.md')->spew_utf8($readme);

}

1;
