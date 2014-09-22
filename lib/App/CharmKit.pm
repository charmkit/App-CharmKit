package App::CharmKit;

# ABSTRACT: Perl Framework for authoring Juju charms

=head1 OVERVIEW

A perl way to charm authoring. CharmKit allows the creation of charm
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
      tests/
        00-basic.test
    tests/
      00-basic.test
    config.yaml
    metadata.yaml
    LICENSE
    README.md

=head2 WORKFLOW

All development happens within B<src/> and the builtin C<pack> command
is used for generating the proper hooks/tests and dependencies within that
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

=head2 WRITING A HOOK

Hooks are written using perl with automatically imported helpers for convenience.
When developing hooks they should reside in B<src/hooks>.

A typical hook starts with

   #!/usr/bin/env perl

   use charm -helper, -logging;

   log 'Starting install hook for database';
   my $dbhost = relation_get 'dbhost';
   my $dbuser = relation_get 'dbuser';

=head2 WRITING A TEST

Tests are written in the same way and should live in B<src/tests/*.test>.

A typical test starts with

   #!/usr/bin/env perl

   use charm -tester;

   # See if we can use package App::CharmKit
   use_ok('App::CharmKit');

   # finish tests
   done_testing;

Tests are built in a way that the test runner from the charm reviewers will be
able to run and validate your charm.

=head2 PACKING A CHARM FOR RELEASE

Once development is complete and you have your hooks defined and tests written.
Packaging a charm for release to either Git or the Charm Store is a matter of running:

  $ charmkit pack

=cut
use strict;
use warnings;
use App::Cmd::Setup -app;

1;
