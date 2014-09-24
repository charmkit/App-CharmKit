package App::CharmKit::Command::init;

# ABSTRACT: Generate a charm project

=head1 SYNOPSIS

Create a directory suitable for charm authoring with optional
hook generation.

  $ charmkit init [--with-hooks] <charm-name>

=cut

=head1 OPTIONS

=head2 with-hooks

Generates charm hooks during init.

=cut

use Path::Tiny;
use File::chdir;
use IO::Prompter [-verb];
use App::CharmKit -command;

use Moo;
with 'App::CharmKit::Role::Init', 'App::CharmKit::Role::Generate';

use namespace::clean;

sub opt_spec {
    return (
        [   "category=s",
            "charm category: applications(default), app-servers, "
              . "cache-proxy, databases, file-servers, misc",
            {default => 'applications'}
        ],
        ["with-hooks", "build directory with generated hook files"]
    );
}

sub usage_desc {'%c init [--options] <charm-name>'}

sub validate_args {
    my ($self, $opt, $args) = @_;
    if ($opt->{category} !~
        /^applications|app-servers|cache-proxy|databases|file-servers|misc/)
    {
        $self->usage_error("Incorrect type specified, see help.");
    }

    $self->usage_error("Needs a project name") unless defined $args->[0];

    if ($args->[0] =~ /^[0-9\-]|\-$/) {
        $self->usage_error(
            "Name must start with [a-z] and not end with a '-'");
    }
}

sub execute {
    my ($self, $opt, $args) = @_;
    my $path    = path(shift @{$args});
    my $project = {};
    if ($path->exists) {
        $self->usage_error("Project already exists at $path,"
              . "please pick a new one or remove that directory.");
    }
    printf("Initializing project %s\n", $path->absolute);

    my $default_maintainer = 'Joe Hacker';
    my $default_category   = $opt->{category};
    @ARGV = ();    # IO::Prompter workaround
    $project->{name}    = prompt "Name [default $path]:",    -def => "$path";
    $project->{version} = prompt "Version [default 0.0.1]:", -def => '0.0.1';
    $project->{summary} = prompt 'Summary:';
    $project->{description} = prompt 'Description:';
    $project->{maintainer} =
      prompt "Maintainer [default $default_maintainer]:",
      -def => $default_maintainer;
    $project->{categories} = [
        prompt "Category [default: $default_category]:",
        -def => $default_category
    ];
    $project->{license} = prompt 'License [? for list]:',
      -menu => {
        agpl_3      => 'AGPL_3',
        apache_1_1  => 'Apache_1_1',
        apache_2_0  => 'Apache_2_0',
        artistic_1  => 'Artistic_1_0',
        artistic_2  => 'Artistic_2_0',
        bsd         => 'BSD',
        freebsd     => 'FreeBSD',
        gfdl_1_2    => 'GFDL_1_2',
        gfdl_1_3    => 'GFDL_1_3',
        gpl_1       => 'GPL_1',
        gpl_2       => 'GPL_2',
        gpl_3       => 'GPL_3',
        lgpl_2_1    => 'LGPL_2_1',
        lgpl_3_0    => 'LGPL_3_0',
        mit         => 'MIT',
        mozilla_1_0 => 'Mozilla_1_0',
        mozilla_1_1 => 'Mozilla_1_1',
        openssl     => 'OpenSSL',
        perl_5      => 'Perl_5',
        qpl_1_0     => 'QPL_1_0',
        ssleay      => 'SSLeay',
        sun         => 'Sun',
        zlib        => 'Zlib',
      },
      '>';

    $self->init($path, $project);
    if ($opt->{with_hooks}) {
        {
            local $CWD = $path->absolute;
            $self->create_all_hooks;
        }
    }
    printf("Project skeleton created.\n");
}

1;
