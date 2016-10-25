use 5.020;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'App::Charmkit',
    VERSION_FROM => 'lib/charm.pm',
    ABSTRACT     => 'Juju charm authoring',
    AUTHOR       => 'Adam Stokes <adamjs@cpan.org>',
    LICENSE      => 'artisitc_2',
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
    PREREQ_PM => {
        'Import::Into'        => '0',
        'utf8::all'           => '0.021',
        'Path::Tiny'          => '0.098',
        'App::Cmd'            => '0.331',
        'HTTP::Tiny'          => '0.070',
        'YAML::Tiny'          => '1.69',
        'JSON::PP'            => '2.27400',
        'Text::MicroTemplate' => '0.24',
        'Exporter::Tiny'      => '0.042',
        'Config::Tiny'        => '2.23',
        'IPC::Run'            => '0',
        'Module::Runtime'     => '0',
        'Params::Util'        => '0',
        'Class::Tiny'         => '0',
        'File::ShareDir'      => '0',
        'Set::Tiny'           => '0',
        'Email::Address'      => '1.908'
    },
    EXE_FILES => ['bin/charmkit'],
    test      => {TESTS => 't/*.t t/*/*.t'}
);
