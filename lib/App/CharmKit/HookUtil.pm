package App::CharmKit::HookUtil;

# ABSTRACT: Additional helper hook routines

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Rex::Commands::Run;
use FindBin;
use base "Exporter::Tiny";

our @EXPORT = qw(config resource unit status plugin);

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

sub unit($key) {
    return run "unit-get $key";
}

=item status($level, $msg)

Sets the charm's current status of execution

=cut


sub status ($level = "active", $msg = "Ready") {
    return run "status-set $level $msg";
}

=item plugin($name, %opts)

Load a plugin, optionally passing options

=back

=cut

sub plugin($name, $opts={}) {
    my $name_path = "$FindBin::Bin/../lib/$name.pm";
    require $name_path;
    return "$name"->new($opts);
}


1;
