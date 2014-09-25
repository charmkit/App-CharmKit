package App::CharmKit::Sys;

# ABSTRACT: system utilities

=head1 SYNOPSIS

  use charm -sys;

or

  use App::CharmKit::Sys;

  apt_update();
  apt_upgrade();
  apt_inst(['nginx-common', 'redis-server']);

=head1 DESCRIPTION

Provides system utilities such as installing packages, managing files, and more.

=cut

use Path::Tiny;
use IPC::Run qw(run timeout);
use Exporter qw(import);

our @EXPORT = qw/execute
  apt_inst
  apt_upgrade
  apt_update
  make_dir
  remove_dir
  set_owner
  add_user
  del_user
  spew
  slurp
  getent/;

=func spew(STR path, STR contents)

writes to a file, defaults to utf8

=cut
sub spew {
  my $path = path(shift);
  my $contents = shift;
  $path->spew_utf8($contents);
}

=func slurp(STR path)

reads a file, defaults to utf8

=cut
sub slurp {
    my $path = path(shift);
    return $path->slurp_utf8;
}

=func make_dir(ARRAYREF dirs)

mkdir helper for creating directories

=cut
sub make_dir {
    my $dirs = shift;
    foreach my $dir (@{$dirs}) {
        path($dir)->mkpath;
    }
}

=func remove_dir(ARRAYREF dirs)

removes directories

=cut
sub remove_dir {
    my $dirs = shift;
    foreach my $dir (@{$dirs}) {
        path($dir)->remove_tree;
    }
}

=func set_owner(STR user, ARRAYREF dirs)

sets owner of directories

=cut
sub set_owner {
    my ($user, $dirs) = @_;
    foreach my $dir (@{$dirs}) {
        execute(['chown', $user, '-R', $dir]);
    }
}

=func getent(STR db, STR key)

accesses user info from nss

Params:
  db: nss database to query
  key: what to query

=cut
sub getent {
    my ($db, $key) = @_;
    my $ret = execute(['getent', $db, $key]);
    return $ret;
}

=func add_user(STR user, STR homedir)

adds user to system

=cut
sub add_user {
    my $user    = shift;
    my $homedir = shift || undef;
    my $cmd     = ['adduser', '--gecos ""', '--disabled-password'];
    if ($homedir) {
        push @{$cmd}, ['--home', $homedir];
    }
    my $ret = execute($cmd);
    return $ret;
}

=func del_user(STR user)

removes a user, does attempt to remove home directory

=cut
sub del_user {
  my $user = shift;
  my $ret = execute(['deluser', '--remove-home', $user]);
  return $ret;
}

=func execute(ARRAYREF command)

Executes a local command:

   my $cmd = ['juju-log', 'a message'];
   my $ret = execute($cmd);
   print $ret->{stdout};

=cut
sub execute {
    my ($command) = @_;
    my $result = run $command, \my $stdin, \my $stdout, \my $stderr;
    chomp for ($stdout, $stderr);

    +{  stdout    => $stdout,
        stderr    => $stderr,
        has_error => $? > 0,
        error     => $?,
    };
}

=func apt_inst(ARRAYREF pkgs)

Installs packages via apt-get

   apt_inst(['nginx']);

=cut
sub apt_inst {
    my $pkgs = shift;
    my $cmd = ['apt-get', '-qyf', 'install'];
    map { push @{$cmd}, $_ } @{$pkgs};
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func apt_upgrade()

Upgrades system

   apt_upgrade();

=cut
sub apt_upgrade {
    my $cmd = ['apt-get', '-qyf', 'dist-upgrade'];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func apt_update()

Update repository sources

   apt_update();

=cut
sub apt_update {
    my $cmd = ['apt-get', 'update'];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

1;
