package App::CharmKit::Override;

=head1 NAME

App::CharmKit::Override

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Rex::Commands::Run;

use base "Exporter::Tiny";

our @EXPORT = qw(config resource unit status);

=over

=item config($key)

This queries the charms config

=cut

sub config($key) {
    return run "config-get $key";
}

=item resource($key)

Pulls the resource bound to $key

=cut

sub resource($key) {
    return run "resource-get $key";
}

=item unit($key)

Queries the Juju unit for a specific value

C<unit 'public-address';>

This above code would pull the public-address of the unit in the context of the
running charm

=cut

sub unit($key){
    return run "unit-get $key";
}

=item status($level, $msg)

Sets the charm's current status of execution

=cut

=back

sub status($level="active", $msg="Ready") {
    return run "status-set $level $msg";
}

1;
