package App::CharmKit::Sys;

# ABSTRACT: system utilities

=head1 SYNOPSIS

    use App::CharmKit::Sys;

    my $sys = App::CharmKit::Sys->new;
    $sys->install_pkg(qw/emacs24 php5 php5-fpm/);

=head1 DESCRIPTION

System utilities such as installing packages, managing files, and more.

=cut

use IPC::Run ();
use Moo;
use namespace::clean;

=method run(STR command)

Executes a local command

=cut
sub run {
    my ($self, $command) = @_;
    my $result = IPC::Run::run $command, \my $stdin, \my $stdout,
      \my $stderr;
    chomp for ($stdout, $stderr);

    +{  stdout    => $stdout,
        stderr    => $stderr,
        has_error => $? > 0,
        error     => $?,
    };
}

=method install_pkg(ARRAYREF package)

Installs packages using backends such as B<apt-get>.

   install_pkg(qw/mongodb vim redis-server/);

=cut
sub install_pkg{
  my ($self, $pkgs) = @_;
}

1;
