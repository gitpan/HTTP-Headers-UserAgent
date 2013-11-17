
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "identify browser by parsing User-Agent string (deprecated)",
  "AUTHOR" => "Neil Bowers <neilb\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "HTTP-Headers-UserAgent",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "HTTP::Headers::UserAgent",
  "PREREQ_PM" => {
    "Exporter" => 0,
    "HTTP::BrowserDetect" => "1.35",
    "strict" => 0,
    "vars" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.88"
  },
  "VERSION" => "3.04",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Exporter" => 0,
  "HTTP::BrowserDetect" => "1.35",
  "Test::More" => "0.88",
  "strict" => 0,
  "vars" => 0,
  "warnings" => 0
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



