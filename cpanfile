requires "App::Cmd::Setup" => "0";
requires "Carp" => "0";
requires "Exporter" => "0";
requires "File::chdir" => "0";
requires "IO::Prompter" => "0";
requires "IPC::Run" => "0";
requires "Import::Into" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "Path::Tiny" => "0";
requires "Software::License" => "0";
requires "Test::More" => "0";
requires "Text::MicroTemplate" => "0";
requires "YAML::Tiny" => "0";
requires "feature" => "0";
requires "namespace::clean" => "0";
requires "strict" => "0";
requires "utf8::all" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "App::FatPacker" => "0";
  requires "Pod::Elemental::Transformer::List" => "0";
  requires "Software::License" => "0";
  requires "Test::Mojo" => "0";
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
  requires "autobox" => "0";
  requires "autodie" => "0";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::More" => "0";
  requires "Test::NoTabs" => "0";
};
