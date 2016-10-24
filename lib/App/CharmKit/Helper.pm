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
use App::CharmKit::Sys qw/execute/;
use HTTP::Tiny;
use YAML::Tiny;
use JSON::PP;
use Text::MicroTemplate;
use base "Exporter::Tiny";

our @EXPORT = qw/
  config_get
  relation_ids
  relation_get
  relation_set
  relation_list
  relation_type
  relation_id
  local_unit
  remote_unit
  service_name
  hook_name
  in_relation_hook
  open_port
  close_port
  unit_get
  unit_private_ip
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

=func config_get

Queries a config option

=cut

sub config_get {
    my ($key) = @_;
    my $cmd = ['config-get', $key];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func relation_get

Gets relation

=cut

sub relation_get {
    my $attribute = shift || undef;
    my $unit      = shift || undef;
    my $rid       = shift || undef;
    my $cmd       = ['relation-get'];

    if ($rid) {
        push @{$cmd}, '-r';
        push @{$cmd}, $rid;
    }
    if ($attribute) {
        push @{$cmd}, $attribute;
    }
    if ($unit) {
        push @{$cmd}, $unit;
    }
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func relation_set

Relation set

=cut

sub relation_set {
    my $opts = shift;
    my $cmd  = ['relation-set'];
    my $opts_str;
    foreach my $key (keys %{$opts}) {
        $opts_str .= sprintf("%s=%s ", $key, $opts->{$key});
    }
    push @{$cmd}, $opts_str;
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func relation_ids

Get relation ids

=cut

sub relation_ids {
    my ($relation_name) = @_;
    my $cmd = ['relation-ids', $relation_name];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func relation_list

Relation list

=cut

sub relation_list {
    my $rid = shift || undef;
    my $cmd = ['relation-list'];
    if ($rid) {
        push @{$cmd}, '-r';
        push @{$cmd}, $rid;
    }
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func unit_get

Get unit information

=cut

sub unit_get {
    my ($key) = @_;
    my $cmd = ['unit-get', $key];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func unit_private_ip

Get units private ip

=cut

sub unit_private_ip {
    return unit_get('private-address');
}

=func open_port

Open port on service

=cut

sub open_port {
    my $port     = shift;
    my $protocol = shift || 'TCP';
    my $cmd      = ['open-port', "$port/$protocol"];
    my $ret      = execute($cmd);
    return $ret->{stdout};
}

=func close_port

Close port on service

=cut

sub close_port {
    my $port     = shift;
    my $protocol = shift || 'TCP';
    my $cmd      = ['close-port', "$port/$protocol"];
    my $ret      = execute($cmd);
    return $ret->{stdout};
}

=func in_relation_hook

Determine if we're in relation hook

=cut

sub in_relation_hook {
    return defined($ENV{'JUJU_RELATION'});
}

=func relation_type

scope for current relation

=cut

sub relation_type {
    return $ENV{'JUJU_RELATION'} || undef;
}

=func relation_id

relation id for current relation hook

=cut

sub relation_id {
    return $ENV{'JUJU_RELATION_ID'} || undef;
}

=func local_unit

local unit id

=cut

sub local_unit {
    return $ENV{'JUJU_UNIT_NAME'} || undef;
}

=func remote unit

remote unit for current relation hook

=cut

sub remote_unit {
    return $ENV{'JUJU_REMOTE_UNIT'} || undef;
}

=func service_name

name of service running unit belongs too

=cut

sub service_name {
    return (split /\//, local_unit())[0];
}

=func hook_name

name of running hook

=cut

sub hook_name {
    return $0;
}

1;
