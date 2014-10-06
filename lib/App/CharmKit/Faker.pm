package App::CharmKit::Faker;

# ABSTRACT: data faker utilities

=head1 SYNOPSIS

Directly,

  use App::CharmKit::Faker;

Or sugar,

  use charm;

  log 'this is a fake company'. faker->company;
  log 'this is a random ip4'. faker->ip_address;

=head1 DESCRIPTION

Data faker utilities for generating fake data

=cut

use strict;
use warnings;
use Data::Faker;
use base "Exporter::Tiny";

our @EXPORT = qw/faker/;

=func faker

Wrapper for L<Data::Faker>

=cut
sub faker { Data::Faker->new(@_); }

1;
