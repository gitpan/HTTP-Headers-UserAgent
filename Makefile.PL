use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'HTTP::Headers::UserAgent',
    'VERSION_FROM' => 'UserAgent.pm', # finds $VERSION
    'PREREQ_PM' => {
                     'HTTP::BrowserDetect' => 0,
                   },
);
