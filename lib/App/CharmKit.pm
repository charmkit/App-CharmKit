# ABSTRACT: Additional helper hook routines
package App::CharmKit;

our $VERSION = '2.09';

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

__END__

=encoding utf8

=head1 NAME

App::CharmKit - ez pz charm authoring

=head1 SYNOPSIS

    #!/usr/bin/env perl
    #
    # In hooks/install
    BEGIN {
      system "apt-get install cpanminus";
      system "cpanm -n App::CharmKit";
    }

    use charm;

    pkg ['znc', 'znc-perl', 'znc-tcl', 'znc-python'],
        ensure => "present";

    my $hook_path = $ENV{JUJU_CHARM_DIR};

    file "/etc/systemd/system/znc.service", source => "$hook_path/templates/znc.service";

    my $content = template("$hook_path/templates/znc.conf", port => config 'port');
    file "/home/ubuntu/.znc/configs", ensure => "directory", owner => "ubuntu", group => "ubuntu";
    file "/home/ubuntu/.znc/configs/znc.conf",
      owner     => "ubuntu",
      group     => "ubuntu",
      content   => $content,
      on_change => sub { service znc => "restart" };

=head1 DESCRIPTION

Sugar package for making Juju charm authoring easier. We import several
underlying packages such as L<Rex> and L<Path::Tiny>.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=cut
