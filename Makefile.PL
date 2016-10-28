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
            bugtracker => {web => 'https://github.com/battlemidget/App-Charmkit/issues'},
            homepage   => 'https://github.com/battlemidget/App-Charmkit',
            license    => ['http://www.opensource.org/licenses/artistic-license-2.0'],
            repository => {
                type => 'git',
                url  => 'https://github.com/battlemidget/App-Charmkit.git',
                web  => 'https://github.com/battlemidget/App-Charmkit',
            },
            x_IRC => 'irc://freenode.net/#ubuntu-solutions'
        },
    },
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker'     => '7',
        'File::ShareDir'          => 0,
        'File::ShareDir::Install' => '0.11',
    },
    PREREQ_PM => {
        "IO::Socket::SSL" => '1.94',
        'App::Cmd'        => '0.331',
        'Class::Tiny'     => '1.006',
        'Email::Address'  => '1.908',
        'Exporter::Tiny'  => '0.042',
        'File::ShareDir'  => '1.102',
        'Import::Into'    => '1.002005',
        'Mojolicious'     => 0,
        'Path::Tiny'      => '0.098',
        'Rex'             => '1.4.1',
        'Set::Tiny'       => '0.04',
        'Smart::Comments' => 0,
        'YAML::Tiny'      => 0,
        'boolean'         => '0.46',
        'Expect'          => 0
    },
    EXE_FILES => ['bin/charmkit'],
    test      => {TESTS => 't/*.t t/*/*.t'}
);

package MY;
use File::ShareDir::Install qw(postamble);
