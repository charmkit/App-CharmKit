use 5.020;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share dist => 'share';

WriteMakefile(
    NAME         => 'App::CharmKit',
    VERSION_FROM => 'lib/charm.pm',
    ABSTRACT     => 'Juju charm authoring',
    AUTHOR       => 'Adam Stokes <adamjs@cpan.org>',
    LICENSE      => 'artistic_2',
    META_MERGE   => {
        dynamic_config => 0,
        'meta-spec'    => {version => 2},
        no_index       => {directory => ['examples', 't']},
        prereqs        => {runtime => {requires => {perl => '5.020'}}},
        resources      => {
            bugtracker =>
              {web => 'https://github.com/battlemidget/App-Charmkit/issues'},
            homepage => 'https://github.com/battlemidget/App-Charmkit',
            license =>
              ['http://www.opensource.org/licenses/artistic-license-2.0'],
            repository => {
                type => 'git',
                url  => 'https://github.com/battlemidget/App-Charmkit.git',
                web  => 'https://github.com/battlemidget/App-Charmkit',
            },
            x_IRC => 'irc://freenode.net/#ubuntu-solutions'
        },
    },
    BUILD_REQUIRES => {
        'File::ShareDir::Install' => '0',
    },
    PREREQ_PM => {
        'Import::Into'            => '1.002005',
        'boolean'                 => '0.46',
        'utf8::all'               => '0.021',
        'Path::Tiny'              => '0.098',
        'App::Cmd'                => '0.331',
        'Mojo::Template'          => '0',
        'Capture::Tiny'           => '0',
        'Exporter::Tiny'          => '0.042',
        'Module::Runtime'         => '0.014',
        'Class::Tiny'             => '1.006',
        'File::ShareDir'          => '1.102',
        'Set::Tiny'               => '0.04',
        'Email::Address'          => '1.908'
    },
    EXE_FILES => ['bin/charmkit'],
    test      => {TESTS => 't/*.t t/*/*.t'}
);

package MY;
use File::ShareDir::Install qw(postamble);
