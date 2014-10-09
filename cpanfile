requires "App::Cmd::Setup" => "0";
requires "Class::Tiny" => "0";
requires "Data::Dumper" => "0";
requires "Data::Faker" => "0";
requires "Email::Address" => "0";
requires "English" => "0";
requires "Exporter::Tiny" => "0";
requires "File::ShareDir" => "0";
requires "File::chdir" => "0";
requires "Git::Repository" => "0";
requires "HTTP::Tiny" => "0";
requires "IO::Prompter" => "0";
requires "IO::Socket::PortState" => "0";
requires "IO::Socket::SSL" => "0";
requires "IPC::Run" => "0";
requires "Import::Into" => "0";
requires "JSON::PP" => "0";
requires "Juju" => "0";
requires "Module::Runtime" => "0";
requires "Params::Util" => "0";
requires "Path::Tiny" => "0";
requires "Set::Tiny" => "0";
requires "Software::License" => "0";
requires "Test::More" => "0";
requires "Text::MicroTemplate" => "0";
requires "YAML::Tiny" => "0";
requires "base" => "0";
requires "boolean" => "0";
requires "feature" => "0";
requires "parent" => "0";
requires "strict" => "0";
requires "utf8::all" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "App::FatPacker" => "0";
  requires "App::Prove" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "FindBin" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "IPC::System::Simple" => "0";
  requires "Pod::Elemental::Transformer::List" => "0";
  requires "Pod::Weaver::Plugin::Encoding" => "0";
  requires "Software::License" => "0";
  requires "Test::Compile" => "0";
  requires "Test::Kwalitee" => "0";
  requires "Test::More" => "0";
  requires "autodie" => "0";
  requires "lib" => "0";
  requires "perl" => "5.006";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::ShareDir::Install" => "0.06";
};

on 'develop' => sub {
  requires "Test::Kwalitee" => "1.21";
};
