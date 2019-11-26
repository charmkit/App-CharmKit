#!perl

use FindBin;
use lib "$FindBin::Bin../lib";

use Mojo::Base -role, -signatures;
use Test::More;
use Mock::Sub;

diag('Testing charm');
use_ok('charm');
ok( sh( "uname", qw(-a) ), 'can run sh uname -a' );

can_ok( __PACKAGE__, 'sh' );
can_ok( __PACKAGE__, 'plugin' );
can_ok( __PACKAGE__, 'status' );
can_ok( __PACKAGE__, 'config' );
can_ok( __PACKAGE__, 'unit' );
can_ok( __PACKAGE__, 'resource' );

diag('Checking status mock result');
my $mock        = Mock::Sub->new;
my $status_mock = $mock->mock('status');
$status_mock->return_value(
    {
        out       => "status-get active ready.",
        err       => undef,
        exit_code => 0
    }
);

my $status_result = status( level => 'active', msg => 'ready.' );
like(
    $status_result->{out},
    qr/status-get active ready./,
    "status-get runs with correct params"
);

done_testing();
