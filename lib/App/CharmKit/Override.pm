package App::CharmKit::Override;

=head1 NAME

App::CharmKit:: - additional sugar

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Rex::Commands::Run;

use base "Exporter::Tiny";

our @EXPORT = qw(config resource unit status);

sub config($key) {
    return run "config-get $key";
}

sub resource($key) {
    return run "resource-get $key";
}

sub unit($key){
    return run "unit-get $key";
}

sub status($level="active", $msg="Ready") {
    return run "status-set $level $msg";
}

1;
