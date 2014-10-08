package App::CharmKit::Command::deploy;

# ABSTRACT: Deploy charm

=head1 SYNOPSIS

  $ charmkit deploy <charmname> -c ~/charms

=head1 DESCRIPTION

Deploys a charm, accepts locations such as git, http, and local file directories

=cut

use strict;
use warnings;
use Path::Tiny;
use App::CharmKit::Sys "execute" => { -as => "run" };
use App::CharmKit -command;

sub opt_spec {
    return (
        [   "charmdir|c=s",
            "Location of toplevel charm directory, used in local charm deploys"
        ],
        ["series|s=s", "Series of charm, defaults to trusty"]
    );
}

sub usage_desc {
    "charmkit deploy <charmname> -c ~/charms";
}

sub validate_args {
    my ($self, $opt, $args) = @_;
    $self->usage_error("Needs a charm name")
      unless $args->[0];
    $self->usage_error("No toplevel charm directory found")
      unless $opt->{charmdir};
    $self->usage_error("Charm directory does not exist")
      unless path($opt->{charmdir})->exists;
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $series = $opt->{series} || "trusty";
    my $cmd = sprintf("juju deploy --repository=%s local:%s/%s",
        $opt->{charmdir}, $series, $args->[0]);
    my $out = run([$cmd]);
    if ($out->{error}) {
        printf("Deployed failed: %s", $out->{stderr});
    }
    else {
        printf("Deployed: %s", $out->{stdout});
    }
}

1;


