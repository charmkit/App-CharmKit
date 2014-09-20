package App::CharmKit::Command::clean;

# ABSTRACT: Cleanses project

=head1 SYNOPSIS

  $ charmkit clean

=cut

use App::CharmKit -command;
use Path::Tiny;

use Moo;
use namespace::clean;

sub opt_spec {
    return ();
}

sub abstract { 'Cleanses project'}
sub usage_desc {'%c clean'}

sub execute {
    my ($self, $opt, $args) = @_;
    my $path = path('.');
    if ($path->child('fatlib')->exists) {
        $path->child('fatlib')->remove_tree;
    }
}

1;

