package App::CharmKit::Role::Generate;

# ABSTRACT: Generators for common tasks

use Path::Tiny;
use Moo::Role;

=attr src

Source directory for hooks

=cut
has src => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        path('.')->child('src/hooks');
    }
);


=method create_hook(STR hook)

Creates a charm hook based on `hook` name

=cut
sub create_hook {
    my ($self, $hook) = @_;

    (my $hook_heading = qq{#!/usr/bin/env perl

# PODNAME: $hook

use App::CharmKit::Helpers;

# begin your $hook below



# end hook code

__END__

=begin

=head1 $hook

Description of hook

=head1 SYNOPSIS

Any usage here

=cut
});
    $self->src->child($hook)->spew_utf8($hook_heading);
}

1;
