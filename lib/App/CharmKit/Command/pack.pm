package App::CharmKit::Command::pack;

# ABSTRACT: Package hooks for distribution

use App::CharmKit -command;

use Moo;
with('App::CharmKit::Role::Pack');

use namespace::clean;

sub opt_spec {
    return ();
}

sub abstract { 'Build distributable hooks for charm deployment'}
sub usage_desc {'%c pack'}

sub execute {
    my ($self, $opt, $args) = @_;
    $self->build;
}

1;
