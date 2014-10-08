package App::CharmKit::Sys;

# ABSTRACT: system utilities

=head1 SYNOPSIS

  use charm;

or

  use App::CharmKit::Sys;

  apt_update();
  apt_upgrade();
  apt_install(['nginx-common', 'redis-server']);

=head1 DESCRIPTION

Provides system utilities such as installing packages, managing files, and more.

=cut

use strict;
use warnings;
use Path::Tiny;
use IPC::Run qw(run timeout);
use English;
use base "Exporter::Tiny";

our @EXPORT = qw/execute
  apt_install
  apt_upgrade
  apt_update
  apt_add_repo
  make_dir
  remove_dir
  set_owner
  getent
  add_user
  del_user
  spew
  slurp
  service_control
  service_status/;


=func spew

writes to a file, defaults to utf8

=cut
sub spew {
    my $path     = path(shift);
    my $contents = shift;
    $path->spew_utf8($contents);
}

=func slurp

reads a file, defaults to utf8

=cut
sub slurp {
    my $path = path(shift);
    return $path->slurp_utf8;
}

=func make_dir

mkdir helper for creating directories

=cut
sub make_dir {
    my $dirs = shift;
    foreach my $dir (@{$dirs}) {
        path($dir)->mkpath;
    }
}

=func remove_dir

removes directories

=cut
sub remove_dir {
    my $dirs = shift;
    foreach my $dir (@{$dirs}) {
        path($dir)->remove_tree;
    }
}

=func set_owner

sets owner of directories

  set_owner('ubuntu', ['/var/lib/mydb', '/etc/mydb/conf'])

=cut
sub set_owner {
    my ($user, $dirs) = @_;
    foreach my $dir (@{$dirs}) {
        execute(['chown', $user, '-R', $dir]);
    }
}


=func getent

accesses user info from nss

B<Params>

=for :list
*  db: nss database to query
*  key: what to query
*  returns: result from C<execute>

=cut

sub getent {
    my ($db, $key) = @_;
    if ($OSNAME eq 'linux') {
        my $ret = execute(['getent', $db, $key]);
        return $ret;
    }
    else {
        print "Unsupported OS\n.";
        return 0;
    }
}

=func add_user

adds user to system

B<Params>

=for :list
* user: username
* homedir: users home directory
* returns: result from C<execute>

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

=func del_user

removes a user, does attempt to remove home directory

=cut
sub del_user {
  my $user = shift;
  my $ret = execute(['deluser', '--remove-home', $user]);
  return $ret;
}

=func execute

Executes a local command:

   my $cmd = ['juju-log', 'a message'];
   my $ret = execute($cmd);
   print $ret->{stdout};

B<Params>

=for :list
* command: command to run
* returns: hash of { stdout =>, stderr =>, has_error =>, error => }

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


=func apt_add_repo

Adds a archive repository or ppa. B<key> is required if adding http source.

B<source> can be in the format of:

  ppa:charmers/example
  deb https://stub:key@private.example.com/ubuntu trusty main

=cut

sub apt_add_repo {
    my $repo   = shift;
    my $update = shift || 0;
    my $key    = shift || undef;
    if ($repo =~ /^(ppa:|cloud:|http|deb|cloud-archive:)/) {
        execute(['apt-add-repository', '--yes', $repo]);
    }
    if ($repo =~ /^cloud:/) {
        apt_install(['ubuntu-cloud-keyring']);
    }
    if ($key) {
        execute(
            [   'apt-key', 'adv', '--keyserver',
                'hkp://keyserver.ubuntu.com:80',
                '--recv', $key
            ]
        );
    }
    if ($update) {
        apt_update();
    }
}

=func apt_install

Installs packages via apt-get

   apt_install(['nginx']);

=cut
sub apt_install {
    my $pkgs = shift;
    my $cmd = ['apt-get', '-qyf', 'install'];
    map { push @{$cmd}, $_ } @{$pkgs};
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func apt_upgrade

Upgrades system

   apt_upgrade();

=cut
sub apt_upgrade {
    my $cmd = ['apt-get', '-qyf', 'dist-upgrade'];
    my $ret = execute($cmd);
    return $ret->{stdout};
}

=func apt_update

Update repository sources

   apt_update();

=cut
sub apt_update {
    my $cmd = ['apt-get', 'update'];
    my $ret = execute($cmd);
    return $ret->{stdout};
}


=func service_control

Controls a upstart service

=cut

sub service_control {
    my $service_name = shift;
    my $action       = shift;
    my $cmd          = ['service', $service_name, $action];
    my $ret          = execute($cmd);
    return $ret;
}

=func service_status

Get running status of service

=cut

sub service_status {
    my $service_name = shift;
    my $ret = service_control($service_name, 'status');
    return $ret->{error};
}


1;
