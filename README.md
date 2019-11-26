# NAME

App::CharmKit - ez pz charm authoring

# SYNOPSIS

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

# DESCRIPTION

Sugar package for making Juju charm authoring easier.

# AUTHOR

Adam Stokes <adamjs@cpan.org>
