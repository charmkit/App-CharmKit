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

use IPC::Run qw(run timeout);
use Exporter qw(import);

our @EXPORT = qw/execute apt_inst apt_upgrade apt_update/;

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

    die $stderr unless $? eq 0;
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
