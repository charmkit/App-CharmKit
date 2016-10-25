package App::CharmKit::Sys;

=head1 NAME

App::CharmKit::Sys

=head1 SYNOPSIS

  use charm;

or

  use App::CharmKit::Sys;

  apt_update();
  apt_upgrade();
  apt_install ['nginx-common', 'redis-server'];

=head1 DESCRIPTION

Provides system utilities such as installing packages, managing files, and more.

=cut

use strict;
use warnings;
no warnings 'experimental::signatures';
use feature 'signatures';
use Path::Tiny;
use IPC::Run qw(run timeout);
use English;
use Module::Runtime qw(use_package_optimistically);
use Params::Util qw(_HASH);
use Config::Tiny;
use boolean;
use base "Exporter::Tiny";

our @EXPORT = qw/sh
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
  service_status
  load_helper
  read_ini/;

=over 8

=item spew(STR $path, STR $contents)

writes to a file, defaults to utf8

=cut

sub spew ($path, $contents) {
    $path = path($path);
    $path->spew_utf8($contents);
}

=item slurp(STR $path)

reads a file, defaults to utf8

=cut

sub slurp($path) {
    $path = path($path);
    return $path->slurp_utf8;
}

=item make_dir(STR $dir)

mkdir helper for creating directories

=cut

sub make_dir($dir) {
    path($dir)->mkpath;
}

=item remove_dir(STR $dir)

removes directories

=cut

sub remove_dir($dir) {
    path($dir)->remove_tree;
}

=item set_owner(STR $user, ARRAYREF $dirs)

sets owner of directories

  set_owner('ubuntu', ['/var/lib/mydb', '/etc/mydb/conf'])

=cut

sub set_owner ($user, $dirs) {
    foreach my $dir (@{$dirs}) {
        sh(['chown', $user, '-R', $dir]);
    }
}


=item getent(STR $db, STR $key)

accesses user info from nss

B<Params>

*  db: nss database to query
*  key: what to query
*  returns: result from C<sh>

=cut

sub getent ($db, $key) {
    if ($OSNAME eq 'linux') {
        my $ret = sh(['getent', $db, $key]);
        return $ret;
    }
    else {
        print "Unsupported OS\n.";
        return 0;
    }
}

=item add_user(STR $user, STR $homedir)

adds user to system

B<Params>

* user: username
* homedir: users home directory
* returns: result from C<sh>

=cut

sub add_user ($user, $homedir = false) {
    my $cmd = ['adduser', '--gecos ""', '--disabled-password'];
    if ($homedir) {
        push @{$cmd}, ['--home', $homedir];
    }
    my $ret = sh($cmd);
    return $ret;
}

=item del_user(STR $user)

removes a user, does attempt to remove home directory

=cut

sub del_user($user) {
    my $ret = sh(['deluser', '--remove-home', $user]);
    return $ret;
}

=item sh(ARRAYREF $command)

Shs a local command:

   my $ret = sh(['juju-log', 'a message']);
   print $ret->{stdout};

B<Params>

* command: command to run
* returns: hash of { stdout =>, stderr =>, has_error =>, error => }

=cut

sub sh($command) {
    my $result = run $command, \my $stdin, \my $stdout, \my $stderr;
    chomp for ($stdout, $stderr);

    +{  stdout    => $stdout,
        stderr    => $stderr,
        has_error => $? > 0,
        error     => $?,
    };
}


=item apt_add_repo(STR $repo, STR $key, BOOL $update)

Adds a archive repository or ppa. B<key> is required if adding http source.

B<source> can be in the format of:

  ppa:charmers/example
  deb https://stub:key@private.example.com/ubuntu trusty main

=cut

sub apt_add_repo ($repo, $key = undef, $update = false) {
    if ($repo =~ /^(ppa:|cloud:|http|deb|cloud-archive:)/) {
        sh(['apt-add-repository', '--yes', $repo]);
    }
    if ($repo =~ /^cloud:/) {
        apt_install(['ubuntu-cloud-keyring']);
    }
    if ($key) {
        sh(
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

=item apt_install(ARRAYREF $pkgs)

Installs packages via apt-get

   apt_install(['nginx']);

=cut

sub apt_install($pkgs) {
    my $cmd = ['apt-get', '-qyf', 'install'];
    map { push @{$cmd}, $_ } @{$pkgs};
    my $ret = sh($cmd);
    return $ret->{stdout};
}

=item apt_upgrade

Upgrades system

   apt_upgrade();

=cut

sub apt_upgrade {
    my $cmd = ['apt-get', '-qyf', 'dist-upgrade'];
    my $ret = sh($cmd);
    return $ret->{stdout};
}

=item apt_update

Update repository sources

   apt_update();

=cut

sub apt_update {
    my $cmd = ['apt-get', 'update'];
    my $ret = sh($cmd);
    return $ret->{stdout};
}


=item service_control(STR $service_name, STR $action)

Controls a upstart service

=cut

sub service_control ($service_name, $action) {
    my $cmd = ['systemctl', $action, $service_name];
    my $ret = sh($cmd);
    return $ret;
}

=item service_status(STR $service_name)

Get running status of service

=cut

sub service_status($service_name) {
    my $ret = service_control($service_name, 'status');
    return $ret->{error};
}


=item load_helper(STR $name, HASHREF $opts)

Helper for bringing in additional utilities. A lot of utilities are
exported automatically however, this is useful if more control is
required over the helpers.

B<Params>

* C<opts> Options to pass into helper class

=cut

sub load_helper ($name, $opts) {
    _HASH($opts) or die "Options should be a HASH";
    my $klass = "App::CharmKit::$name";
    return use_package_optimistically($klass)->new(%{$opts});
}


=item read_ini(STR $path)

Basic config parsing for ini like files like whats found in most of B</etc/default>.
This will also automatically return its root property.

B<Params>

* C<path>
Path of config file to read

=cut

sub read_ini($path) {
    $path = path($path);
    my $cfg = Config::Tiny->new;
    return $cfg->read($path)->{_};
}

=back

1;
