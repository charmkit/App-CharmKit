package App::CharmKit::HookUtil;

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Rex::Commands::Run;
use FindBin;
use base "Exporter::Tiny";

our @EXPORT = qw(config resource unit status);

sub config($key) {
    return run "config-get $key";
}

sub resource($key) {
    return run "resource-get $key";
}

sub unit($key) {
    return run "unit-get $key";
}

sub status ($level = "active", $msg = "Ready") {
    return run "status-set $level $msg";
}

1;
