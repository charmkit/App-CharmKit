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
        'File::ShareDir'          => '1.102',
        'File::ShareDir::Install' => '0.10',
    },
    PREREQ_PM => {
        "IO::Socket::SSL" => '1.94',
        'App::Cmd'        => '0.330',
        'Class::Tiny'     => '1.004',
        'Email::Address'  => '1.908',
        'Exporter::Tiny'  => '0.042',
        'File::ShareDir'  => '1.102',
        'Import::Into'    => '1.002005',
        'Mojolicious'     => '6.15',
        'Path::Tiny'      => '0.076',
        'Rex'             => '1.3.3',
        'Set::Tiny'       => '0.03',
        'Smart::Comments' => '1.06',
        'YAML::Tiny'      => '1.69',
        'boolean'         => '0.45',
        'Expect'          => '1.21',
        'Test::More'      => 0,
    },
    EXE_FILES => ['bin/charmkit'],
    test      => {TESTS => 't/*.t t/*/*.t'}
);

package MY;
use File::ShareDir::Install qw(postamble);
