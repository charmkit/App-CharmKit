package App::CharmKit::Role::Init;

# ABSTRACT: Initialization of new charms

use strict;
use warnings;
use App::CharmKit::Sys qw(execute);
use YAML::Tiny;
use JSON::PP;
use Software::License;
use Module::Runtime qw(use_module);
use Git::Repository;
use Class::Tiny;

=method init

Builds the initialization directory structure for
charm authoring.

B<hooks/> is where the finalized charms are built

B<tests/> is for tests

B<src/hooks/> is where all hook development happens

B<project> hash can consist of the following:

    name => 'charm-test'
    summary => 'charm summary'
    description => 'extended description'
    maintainer => 'Joe Hacker'
=cut
sub init {
    my ($self, $path, $project) = @_;
    $path->child('hooks')->mkpath     or die $!;
    $path->child('tests')->mkpath     or die $!;
    $path->child('src/hooks')->mkpath or die $!;
    $path->child('src/tests')->mkpath or die $!;
    $path->child('src/unittests')->mkpath or die $!;

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

    # git init
    if (!$path->child('.git')->exists) {
        Git::Repository->run(init => $project->{name});
    }

    # tests/tests.yaml
    my $yaml = YAML::Tiny->new({packages => ['perl', 'make']});
    $yaml->write($path->child('tests/tests.yaml'));

    # src/tests/00-basic.test
    (   my $basic_test =
          q{#!/usr/bin/env perl
#
# USAGE:
#
# use charm -tester;
#
# Load cast
# my $cast = load_helper(
#     'Cast',
#     { endpoint => 'wss://localhost:17070',
#       password => 'jujuSecretPassword'
#     }
# );
#
# Example tests
#
# ok($cast->deploy('mysql', 'MY_mysql'), "Mysql was deployed");
# ok($cast->deploy('precise/wordpress', 'MY_wordpress'), "Wordpress was deployed");
# ok($cast->is_listening('mysql', 3306), "Mysql listening on default port");
#
# Always finish with this
done_testing;
}
    );
    $path->child('src/tests/01-deploy.test')->spew_utf8($basic_test);

    # charmkit.json
    my $json          = JSON::PP->new->utf8->pretty;
    my $charmkit_meta = {
        name       => $project->{name},
        version    => $project->{version},
        maintainer => $project->{maintainer},
        series     => ['precise', 'trusty']
    };
    my $json_encoded = $json->encode($charmkit_meta);
    $path->child('charmkit.json')->spew_utf8($json_encoded);

    # metadata.yaml
    $yaml = YAML::Tiny->new(
        {   name        => $project->{name},
            summary     => $project->{summary},
            description => $project->{description},
            maintainer  => $project->{maintainer},
            categories  => $project->{categories},
        }
    );
    $yaml->write($path->child('metadata.yaml'));

    # config.yaml
    $path->child('config.yaml')->touch;

    my $class = "Software::License::" . $project->{license};
    use_module($class);
    my $license = $class->new({holder => $project->{maintainer}});
    my $year    = $license->year;
    my $notice  = $license->notice;

    # copyright
    (   my $copyright =
          qq{Format: http://dep.debian.net/deps/dep5/

Files: *
Copyright: $year, $project->{maintainer}
License: $project->{license}
  <Needs license text here>
}
    );
    $path->child('copyright')->spew_utf8($copyright);

    # README.md
    (   my $readme = qq{
# Juju charm for $project->{name}

$project->{description}

Made with [CharmKit](https://github.com/battlemidget/App-CharmKit)

## How to Deploy

### With CharmKit

```console
> charmkit clone <github-user>/$project->{name} -o ~/charms/<series>/$project->{name}
> charmkit deploy <charm> -c ~/charms -s <series>
```

### Juju

#### Charm Store

```console
> juju deploy cs:<series>/$project->{name}
```

#### Source

```console
> mkdir -p ~/charms && git clone https://github.com/<github-user>/$project->{name} ~/charms/
> juju deploy --repository=charms local:<series>/$project->{name}
```

# AUTHOR

$project->{maintainer}

# COPYRIGHT

$year $project->{maintainer}

# LICENSE

$notice
}
    );
    $path->child('README.md')->spew_utf8($readme);

    (   my $makefile =
          q{PWD := $(shell pwd)
HOOKS_DIR := $(PWD)/hooks
TEST_DIR := $(PWD)/tests

ensure_ck:
	@apt-get -qyf install cpanminus \
		libnet-ssleay-perl \
		libio-socket-ssl-perl \
		libio-prompter-perl \
		libapp-fatpacker-perl \
		libipc-system-simple-perl \
		libsoftware-license-perl \
		libautodie-perl \
		libemail-address-perl \
		libset-tiny-perl \
		libfile-sharedir-perl \
		libboolean-perl \
		libjson-pp-perl \
		libyaml-tiny-perl \
		libtext-microtemplate-perl \
		libipc-run-perl \
		libpath-tiny-perl \
		libimport-into-perl \
		libhttp-tiny-perl \
		libapp-cmd-perl \
		libdata-dumper-perl
		libdata-faker-perl \
		libanyevent-perl
	@cpanm App::CharmKit --notest

pack:
	@charmkit pack

test: clean pack
	@charmkit test

lint: clean pack
	@charmkit lint

clean: ensure_ck
	@charmkit clean

.PHONY: pack test lint ensure_ck
}
    );
    $path->child('Makefile')->spew_utf8($makefile);

}

1;
