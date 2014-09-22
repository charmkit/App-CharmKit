package App::CharmKit::Sys;

# ABSTRACT: system utilities

=head1 SYNOPSIS

use App::CharmKit::Sys;

my $sys = App::CharmKit::Sys->new;
$sys->install_pkg(qw/emacs24 php5 php5-fpm/);

=head1 DESCRIPTION

System utilities such as installing packages, managing files, and more.

=cut

use IPC::Run qw( run timeout );
use Exporter qw( import );

our @EXPORT = qw/execute log/;

=fun execute(ARRAYREF command)

Executes a local command

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

=method log(STR message)

Utilizies juju-log for logging

=cut
sub log {
    my ($message) = @_;
    print($message . "\n");
}

1;
