requires 'App::Cmd'        => '0.330';
requires 'Class::Tiny'     => '1.004';
requires 'Email::Address'  => '1.908';
requires 'Expect'          => '1.21';
requires 'Exporter::Tiny'  => '0.042';
requires 'File::ShareDir'  => '1.102';
requires 'IO::Socket::SSL' => '1.94';
requires 'Import::Into'    => '1.002005';
requires 'Mojolicious'     => '6.15';
requires 'Path::Tiny'      => '0.076';
requires 'Rex'             => '1.3.3';
requires 'Set::Tiny'       => '0.03';
requires 'Smart::Comments' => '1.06';
requires 'YAML::Tiny'      => '1.69';
requires 'boolean'         => '0.45';

on 'test' => sub {
    requires "Test::More" => "0";
};

on 'configure' => sub {
    requires "ExtUtils::MakeMaker"     => "6.30";
    requires "File::ShareDir::Install" => "0.06";
};
