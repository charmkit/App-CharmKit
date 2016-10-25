package App::CharmKit::Helper;

# ABSTRACT: charm helpers

=head1 SYNOPSIS

  use App::CharmKit::Helper;

or

  use charm;

  my $port = config_get 'port';
  my $database = relation_get 'database';
  my $dbuser = relation_get 'user';

=head1 DESCRIPTION

Charm helpers for composition

=cut

use strict;
use warnings;
use HTTP::Tiny;
use YAML::Tiny;
use JSON::PP;
use Text::MicroTemplate;
use base "Exporter::Tiny";

our @EXPORT = qw/
  json
  yaml
  tmpl
  http/;

=func json

Wrapper for L<JSON::PP>

=cut

sub json { JSON::PP->new->utf8; }

=func yaml

Wrapper for L<YAML::Tiny>

=cut

sub yaml { YAML::Tiny->new(@_); }

=func tmpl

Wrapper for L<Text::MicroTemplate>

=cut

sub tmpl { Text::MicroTemplate->new(@_); }

=func http

Wrapper for L<HTTP::Tiny>

=cut

sub http { HTTP::Tiny->new; }


1;
