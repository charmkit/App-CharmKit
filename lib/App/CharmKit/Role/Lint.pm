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
use DDP;

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
        ERR_CONFIG_SYNTAX => {
            message =>
              'Issue with an item, could be duplicate or a conflicting key',
            level => 'FATAL'
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
            message => 'Required file does not exist',
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
        $self->validate_attributes($meta);
        if ($meta->{name} =~ /^metadata\.yaml/) {
            $self->validate_metadata($meta);
        }
        if ($meta->{name} =~ /^config\.yaml/) {
            $self->validate_configdata($meta);
        }
    }
    foreach my $hook (@{$rules->{hooks}}) {
        $self->validate_hook($hook);
    }
}

=method validate_configdata(HASHREF configdata)

Validates B<config.yaml>

=cut
sub validate_configdata {
    my ($self, $configdata) = @_;
    my $config_on_disk = YAML::Tiny->read($configdata->{name})->[0];
    my $filepath       = path($configdata->{name});
    $self->check_error(sprintf("%s:options", $configdata->{name}),
        'ERR_REQUIRED_CONFIG_ITEM')
      unless defined($config_on_disk->{options});

    foreach my $option (keys %{$config_on_disk->{options}}) {
        my $check_opt = $config_on_disk->{options}->{$option};
        if (   !defined($check_opt->{type})
            || !defined($check_opt->{description})
            || !defined($check_opt->{default}))
        {
            $self->check_error(sprintf("%s:%s", $filepath, $option),
                'ERR_REQUIRED_CONFIG_ITEM');
        }
    }
}


=method validate_metadata(HASHREF metadata)

Validates B<metadata.yaml>

=cut
sub validate_metadata {
    my ($self, $metadata) = @_;
    my $meta_on_disk = YAML::Tiny->read($metadata->{name})->[0];
    my $filepath     = path($metadata->{name});
    foreach my $metakey (@{$metadata->{known_meta_keys}}) {
        if ($metakey =~ /name|summary|description/
            && !defined($meta_on_disk->{$metakey}))
        {
            $self->check_error(sprintf("%s:%s", $metadata->{name}, $metakey),
                'ERR_REQUIRED_CONFIG_ITEM');
        }
        elsif (!defined($meta_on_disk->{$metakey})) {
            $self->check_error(sprintf("%s:%s", $metadata->{name}, $metakey),
                'ERR_CONFIG_ITEM');
        }
    }
    foreach my $re (@{$metadata->{parse}}) {

        # Dont parse if file doesn't exist and wasn't required
        next if !$filepath->exists;
        my $input  = $filepath->slurp_utf8;
        my $search = $re->{pattern};
        if ($input !~ /$search/m) {
            $self->check_error($filepath, $re->{error});
        }
    }
}


=method validate_hook(HASHREF hookmeta)

Validates charm hooks

=cut
sub validate_hook {
    my ($self, $hookmeta) = @_;
    my $filepath = path('hooks')->child($hookmeta->{name});
    my $name     = $filepath->stringify;
    foreach my $attr (@{$hookmeta->{attributes}}) {
        if ($attr =~ /EXISTS/) {
            $self->check_error($name, 'ERR_EXISTS') unless $filepath->exists;
        }
        if ($attr =~ /NOT_EMPTY/ && -z $filepath) {
            $self->check_error($name, 'ERR_EMPTY');
        }
    }
}

=method validate_attributes(HASHREF filemeta)

Performs validation of file based on available attribute

=head2 Available Attributes

=for :list
* NOT_EMPTY
* EXISTS

=cut

sub validate_attributes {
    my ($self, $filemeta) = @_;
    my $filepath = path($filemeta->{name});
    my $name     = $filemeta->{name};
    foreach my $attr (@{$filemeta->{attributes}}) {
        if ($attr =~ /NOT_EMPTY/ && -z $name) {
            $self->check_error($name, 'ERR_EMPTY');
        }
        if ($attr =~ /EXISTS/) {

            # Verify any file aliases
            my $alias_exists = 0;
            foreach my $alias (@{$filemeta->{aliases}}) {
                next unless path($alias)->exists;
                $alias_exists = 1;
            }
            if (!$alias_exists) {
                $self->check_error($name, 'ERR_EXISTS')
                  unless $filepath->exists;
            }
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
