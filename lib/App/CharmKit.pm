package App::CharmKit;

# ABSTRACT: Perl Framework for authoring Juju charms

=head1 OVERVIEW

An alternative to python charm-tools. CharmKit allows the creation of charm
projects for publishing to the Charm Store. In addition, there is built in
charm linter, packaging of all hooks and their dependencies, testing framework,
and helper routines to aide in the development of charms.

=head2 DIRECTORY LAYOUT

A charm directory created with CharmKit is:

  charm-project/
    hooks/
      install
      config-changed
      start
      stop
    src/
      hooks/
        install
        config-changed
        start
        stop
    config.yaml
    metadata.yaml
    LICENSE
    README.md

=head2 WORKFLOW

All development happens within B<src/hooks> and the builtin C<pack> command
is used for generating the proper hooks and dependencies within B<hooks/>
directory so Juju is able to act upon them. Hooks within B<hooks/> directory
are always overwritten, think of this similar to a B<dist> or B<release> directory.

To start a project:

  $ charmkit init [--with-hooks] <charm-name>

If used C<--with-hooks> then B<src/hooks/> will be populated with all the default
hooks. A few questions will be prompted and then the project is generated with
B<config.yaml, metadata.yaml, LICENSE, and README.md>.

In order to create additional hooks:

  $ charmkit generate -r database-relation-joined
  $ charmkit generate upgrade-charm

To package a releasable charm after B<src/hooks/> is populated with completed
charm definitions, running the following will finalize the charm for release:

  $ charmkit pack

=cut
use strict;
use warnings;
use App::Cmd::Setup -app;

1;
