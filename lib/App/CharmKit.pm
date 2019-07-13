# ABSTRACT: Additional helper hook routines
package App::CharmKit;

use base "Exporter::Tiny";
use FindBin;
use lib "$FindBin::Bin/..lib";
use Module::Runtime qw(use_package_optimistically);
use Capture::Tiny 'capture';

our $VERSION = '2.12';
our @EXPORT  = qw(sh plugin config unit resource status);

sub sh {
    my $cmd  = shift;
    my $args = shift;
    my %results;
    my ( $out, $err, $exit_code ) = capture {
        system $cmd, $args;
    };
    return {
        out       => $out,
        err       => $err,
        exit_code => $exit_code
    };
}

sub plugin ( $name, $opts = {} ) {
    return use_package_optimistically("$name")->new($opts);
}

sub config ($key) {

    # return sh "config-get", [$key];
}

sub resource ($key) {

    # return sh "resource-get", $key;
}

sub unit ($key) {

    # return sh "unit-get", $key;
}

sub status {
    my $opts = shift;
    die "Needs a 'level' and 'msg'"
      unless ( exists $opts->{level} && exists $opts->{msg} );
    sh "status-set", $opts->{level}, $opts->{msg};
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
      system "apt-get install -qyf cpanminus";
      system "cpanm -qn App::CharmKit";
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
