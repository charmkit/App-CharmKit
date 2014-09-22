package App::CharmKit::Helper;

# ABSTRACT: Helper routines to use in hooks

=head1 SYNOPSIS

use App::CharmKit::Helper;

my $path = path('.');
=cut

=head1 OVERVIEW

Exposing helper subs from various packages that would be useful in writing
charm hooks. Including but not limited too strict, warnings, utf8, Path::Tiny,
etc ..

=cut

use strict;
use warnings;
use utf8;
no bareword::filehandles;
no indirect 0.16;
use Path::Tiny qw(path);
use Carp qw(croak);
use Import::Into;

sub import {
  my ($class, @args) = @_;
  my $caller = caller;

  croak qq{"$_" is not exported by the $class module} for @args;
  strict->import;
  warnings->import;
  warnings->unimport(qw[recursion qw]);
  utf8->import;
  bareword::filehandles->unimport;
  indirect->unimport(':fatal');
  Path::Tiny->import::into($caller, 'path');
}

1;
