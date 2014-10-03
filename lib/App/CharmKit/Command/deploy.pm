package App::CharmKit::Command::deploy;

# ABSTRACT: Deploy charm

=head1 SYNOPSIS

  $ charmkit deploy (git|http|file)://charm-path(.git|.tar.gz)

=head1 DESCRIPTION

Deploys a charm, accepts locations such as git, http, and local file directories

=cut

use strict;
use warnings;
use App::CharmKit -command;

sub opt_spec {
    return (
        [   "charmdir|c=s",
            "Location of toplevel charm directory, used in local charm deploys"
        ]
    );
}

sub usage_desc {
    "charmkit deploy git\@github.com:battlemidget/charm.git -c ~/charms";
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Needs a charm path")
      unless $args->[0];
    $self->usage_error("No toplevel charm directory found")
      unless $opt->{charmdir};
}

sub execute {
    my ($self, $opt, $args) = @_;
    print("poof.\n");
}

1;

