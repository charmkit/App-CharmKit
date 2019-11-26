# ABSTRACT: Additional helper hook routines
package App::CharmKit;

our $VERSION = '2.13_01';

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

    sh("apt", qw(-qyf install znc znc-perl znc-tcl znc-python));

    my $hook_path = $ENV{JUJU_CHARM_DIR};

=head1 DESCRIPTION

Sugar package for making Juju charm authoring easier.

=head1 AUTHOR

Adam Stokes E<lt>adamjs@cpan.orgE<gt>

=cut
