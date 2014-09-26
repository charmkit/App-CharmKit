package App::CharmKit::Role::Lint;

# ABSTRACT: charm linter

=head1 SYNOPSIS

  $ charmkit lint

=head1 DESCRIPTION

Performs various lint checks to make sure the charm is in accordance with
Charm Store policies.

=head1 Format of lint rules

Lint rules are loaded from B<lint_rules.yaml> in the distributions share directory.
The format for rules is as follows:

  ---
  files:
    file:
      name: 'config.yaml'
      attributes:
        - NOT_EMPTY
        - EXISTS
    file:
      name: 'copyright'
      attributes:
        - NOT_EMPTY
        - EXISTS
      parse:
        - pattern: '^options:\s*\n'
          error: 'ERR_INVALID_COPYRIGHT'

=attr errors

Errors hash, current list of errors:

=for :list
* ERR_INVALID_COPYRIGHT
* ERR_REQUIRED_CONFIG_ITEM
* ERR_CONFIG_ITEM
* ERR_NO_REQUIRES
* ERR_NO_PEERS
* ERR_NO_PROVIDERS
* ERR_NO_SUBORDINATES
* ERR_EXISTS
* ERR_EMPTY

=attr rules

Lint rules file

=attr has_error

Stores whether or not a fatal error was found

=cut
use strict;
use warnings;
use YAML::Tiny;
use Path::Tiny;
use File::ShareDir qw(dist_file);

use Class::Tiny {
    errors => {
        ERR_INVALID_COPYRIGHT => {
            message => 'Copyright is malformed or missing',
            level   => 'WARNING'
        },
        ERR_REQUIRED_CONFIG_ITEM => {
            message => 'Missing required configuration item',
            level   => 'FATAL'
        },
        ERR_CONFIG_ITEM => {
            message => 'Missing optional configuration item',
            level   => 'WARNING'
        },
        ERR_NO_REQUIRES => {
            message => 'No requires set for charm relations',
            level   => 'WARNING'
        },
        ERR_NO_PROVIDES => {
            message => 'No provides set for charm relations',
            level   => 'WARNING'
        },
        ERR_NO_PEERS => {
            message => 'No peers set for charm relations',
            level   => 'INFO'
        },
        ERR_NO_SUBORDINATES => {
            message => 'No subordinates set for charm relations',
            level   => 'INFO'
        },
        ERR_EXISTS => {
            message => 'File does not exist',
            level   => 'FATAL'
        },
        ERR_EMPTY => {
            message => 'File is empty',
            level   => 'FATAL'
        }
    },
    rules => YAML::Tiny->read(dist_file('App-CharmKit', 'lint_rules.yaml')),
    has_error => 0
};

=method parse

Parses charm

=cut
sub parse {
    my ($self) = @_;

    # Check attributes
    my $rules = $self->rules->[0];
    foreach my $meta (@{$rules->{files}}) {
        $self->validate($meta);
    }
}

=method validate(HASHREF filemeta)

Performs validation of file based on available attribute

=head2 Available Attributes

=for :list
* NOT_EMPTY
* EXISTS

=cut
sub validate {
    my ($self, $filemeta) = @_;
    my $filepath = path($filemeta->{name});
    my $name     = $filemeta->{name};
    foreach my $attr (@{$filemeta->{attributes}}) {
        if ($attr =~ /NOT_EMPTY/ && -z $name) {
            $self->check_error($name, 'ERR_EMPTY');
        }
        if ($attr =~ /EXISTS/ && !$filepath->exists) {
            $self->check_error($name, 'ERR_EXISTS');
        }
    }

    foreach my $re (@{$filemeta->{parse}}) {

        # Dont parse if file doesn't exist and wasn't required
        next if !$filepath->exists;
        my $input  = $filepath->slurp_utf8;
        my $search = $re->{pattern};
        if ($input !~ /$search/m) {
            $self->check_error($name, $re->{error});
        }
    }
}

=method check_error(STR key, STR error_key)

Processes errors from matched_result

key: file or object being matched against

=cut
sub check_error {
    my ($self, $key, $error_key) = @_;
    my $err = $self->errors->{$error_key};
    $self->lint_print($key, $err);

    # Only set error on fatals
    if ($err->{level} =~ /FATAL/) {
        $self->has_error(1);
    }
}

=method lint_print(STR item, HASHREF error)

Prints out lint errors

=cut
sub lint_print {
    my ($self, $item, $error) = @_;
    printf("%s: (%s) %s\n",
        substr($error->{level}, 0, 1),
        $item, $error->{message});
}

1;
