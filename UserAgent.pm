package HTTP::Headers::UserAgent;

use strict;
use Exporter;

use vars qw( $VERSION @EXPORT_OK $fh %bugzilla_platform %bugzilla_os %old );

$VERSION = '2.00';

@EXPORT_OK = qw( GetPlatform );

%bugzilla_platform = (
  ia32    => 'PC',
  ppc     => 'Macintosh',
  alpha   => 'DEC',
  hppa    => 'HP',
  mips    => 'SGI',
  sparc   => 'Sun',
  unknown => 'Other',
);

%bugzilla_os = (
  irix    => 'IRIX',
  macos   => 'Mac System 8.5',
  osf1    => 'OSF/1',
  linux   => 'Linux',
  solaris => 'Soalris',
  sunos   => 'SunOS',
  bsdi    => 'BSDI',
  win16   => 'Windows 3.1',
  win95   => 'Windows 95',
  #win98   => 'Windows 98',
  win98   => 'Windows 95',
  winnt   => 'Windows NT',
  win32   => 'Windows 95',
  os2     => 'other',
  unknown => 'other',
);

%old = (
  irix    => 'UNIX',
  macos   => 'MAC',
  osf1    => 'UNIX',
  linux   => 'Linux',
  solaris => 'UNIX',
  sunos   => 'UNIX',
  bsdi    => 'UNIX',
  win16   => 'Win3x',
  win95   => 'Win95',
  win98   => 'Win98',
  winnt   => 'WINNT',
  win32   => undef,
  os2     => 'OS2',
  unknown => undef,
);

=head1 NAME

HTTP::Headers::UserAgent - Class encapsulating the HTTP User-Agent header

=head1 SYNOPSIS

  use HTTP::Headers::UserAgent;

  HTTP::Headers::UserAgent->DumpFile( $fh );

  $user_agent = new HTTP::Headers::UserAgent $ENV{HTTP_USER_AGENT};

  $user-agent->string( $ENV{HTTP_USER_AGENT} );

  $string = $user_agent->string;

  $platform = $user_agent->platform;

  $bugzilla_platform = $user_agent->bugzilla_platform;

  $os = $user_agent->os;

  $bugzilla_os = $user_agent->os;

  ( $browser, $version ) = $user_agent->browser;

  #backwards-compatibility with HTTP::Headers::UserAgent 1.00
  $old_platform = HTTP::Headers::UserAgent::GetPlatform $ENV{HTTP_USER_AGENT};

=head1 DESCRIPTION

The HTTP::Headers::UserAgent class represents User-Agent HTTP headers.

This is version 2.00 of the HTTP::Headers::UserAgent class.  While the
interface provides backward-compatibility with version 1.00, it is not based
on the 1.00 code.

=head1 METHODS

=over 4

=item DumpFile FILEHANDLE

Class method - pass an open filehandle to this method, and all unparsable
user-agent strings will be written to this filehandle.

This will be triggered when you actually call the platform, os or browser
methods.

Pass the undefined value to disable this behavior.

=cut

sub DumpFile {
  my $self = shift;
  $fh = shift;
}

=item new HTTP_USER_AGENT

Creates a new HTTP::Headers::UserAgent object.  Takes the HTTP_USER_AGENT
string as a parameter.

=cut

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = {};
  bless( $self, $class);
  $self->string( shift ) if @_;
  $self;
}


=item string [ HTTP_USER_AGENT ]

If a parameter is given, sets the user-agent string.

Returns the user-agent as an unprocessed string.

=cut

sub string {
  my $self = shift;
  $self->{'string'} = shift if @_;
  $self->{'string'};
}

=item platform

Tries to guess the platform.  Returns ia32, ppc, alpha, hppa, mips, sparc, or
unknown.

  ia32   Intel archetecure, 32-bit (x86)
  ppc    PowerPC
  alpha  DEC (now Compaq) Alpha
  hppa   HP
  mips   SGI MIPS
  sparc  Sun Sparc

=cut

sub platform {
  my $self = shift;
  for ( $self->string ) {
    /Win/             && return "ia32";
    /Mac/             && return "ppc";
    /Linux.*86/       && return "ia32";
    /Linux.*alpha/    && return "alpha";
    /OSF/             && return "alpha";
    /HP-UX/           && return "hppa";
    /IRIX/            && return "mips";
    /(SunOS|Solaris)/ && return "sparc";
  }
  print $fh $self->string if $fh;
  "unknown";
}

=item bugzlla_platform

Same as the platform method, with the following translations (for bugzilla
compatbility):

  ia32    PC
  ppc     Macintosh
  alpha   DEC     
  hppa    HP
  mips    SGI
  sparc   Sun
  unknown Other

=cut

sub bugzilla_platform {
  my $self = shift;
  $bugzilla_platform{ $self->platform };
};

=item os

Tries to guess the operating system.  Returns irix, win16, win95, win98, 
winnt, win32 (Windows 95/98/NT/?), macos, osf1, linux, solaris, sunos, bsdi,
os2, or unknown.

=cut

sub os {
  my $self = shift;
  for ( $self->string ) {
    /Win(dows )?(95|98|NT)/            && return lc "win$2";
    /Mozilla.*\(.*;.*; IRIX.*\)/       && return "irix";
    /Mozilla.*\(.*;.*; (68K|PPC).*\)/  && return "macos";
    /Moailla.*\(.*;.*; Mac.*\)/        && return "macos";
    /Mozilla.*\(.*;.*; OSF.*\)/        && return "osf1";
    /Mozilla.*\(.*;.*; Linux.*\)/      && return "linux";
    /Mozilla.*\(.*;.*; SunOS 5.*\)/    && return "solaris";
    /Mozilla.*\(.*;.*; SunOS.*\)/      && return "sunos";
    /Mozilla.*\(.*;.*; BSD\/OS.*\)/    && return "bsdi";
    /Mozilla.*\(.*;.*; BSD\/OS.*\)/    && return "bsdi";
    /Mozilla.*\(Win16.*\)/             && return "win16";
    /Mozilla.*\(.*;.*; 32bit.*\)/      && return "win32";
    /Mozilla.*\(.*;.*; 16bit.*\)/      && return "win16";
    /OS\/2/                            && return "os2";
  }
  print $fh $self->string if $fh;
  "unknown";
}


=item bugzilla_os

Same as the os method, with the following translations (for bugzilla):

  irix     IRIX
  macos    Mac System 8.5
  osf1     OSF/1
  linux    Linux
  solaris  Soalris
  sunos    SunOS
  bsdi     BSDI
  win16    Windows 3.1
  win95    Windows 95
  win98    Windows 95
  winnt    Windows NT
  win32    Windows 95
  os2      other
  unknown  other

=cut 

sub bugzilla_os {
  my $self = shift;
  $bugzilla_os{ $self->os };
}

=item browser

Returns a list consisting of the browser name and version.  Possible browser
names are:

Netscape, IE, Opera, Lynx, Mozilla, Emacs-W3, or Unknown

=cut

sub browser {
  my $self = shift;
  if ( $self->string =~ /^Mozilla\/(\S+)/ ) { #mozillas
    my $moz_version = $1;
    if ( $self->string =~ /compatible; (MSIE |Opera\/)([^;]+);/ ) {
      if ( $1 eq 'MSIE ' ) {
        'IE', $2;
      } elsif ( $1 eq 'Opera/' ) {
        'Opera', $2;
      } else {
        print $fh $self->string if $fh;
        "Unknown", 0;
      }
    } elsif ( $moz_version < 5 ) {
      'Netscape', $moz_version;
    } else {
      'Mozilla', $moz_version;
    }
  } elsif ( $self->string =~ /^(Lynx|Emacs-W3)\/(\s+)/ ) {
    $1, $2;
  } else {
    print $fh $self->string if $fh;
    "Unknown", 0;
  }
}

=back

=head1 BACKWARDS COMPATIBILITY

For backwards compatibility with HTTP::Headers::UserAgent 1.00, a GetPlatform
subroutine is provided.

=over 4

=item GetPlatform HTTP_USER_AGENT

Returns Win95, Win98, WinNT, UNIX, MAC, Win3x, OS2, Linux, or undef.

In some cases ( `Win32', `Windows CE' ) where HTTP::Headers::UserAgent 1.00
would have returned `Win95', will return undef instead.

Will return `UNIX' for some cases where HTTP::Headers::UserAgent would have
returned undef.

=cut

sub GetPlatform {
  my $string = shift;
  my $object = new HTTP::Headers::UserAgent $string;
  $old{ $object->os };
}

=back

=head1 AUTHOR

Ivan Kohler <ivan-useragent@sisd.com>

Portions of this software were originally taken from the Bugzilla Bug
Tracking system <http://www.mozilla.org/bugs/>, and are reused here with
permission of the original author, Terry Weissman <terry@mozilla.org>.

=head1 COPYRIGHT

Copyright (c) 1999 iQualify, Inc. <http://www.iqualify.com/>
All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 BUGS

Needs more testing, especially with less common platforms/OSs/browsers.  Help
save the world!  Send unparsable user-agent headers (and the
platform/OS/browser that generated them) to <ivan-useragent@sisd.com>.  Please
be sure you have the latest version of HTTP::Headers::UserAgent first!

bugzilla_os returns "Windows 95" instead of "Windows 98", because stock
Bugzilla doesn't have a "Windows 98" choice.  You can work around this by 
setting $HTTP::Headers::UserAgent::bugzilla_os{win98} = "Windows 98";

The bugzilla_* methods are a kludge and should probably replaced with a general
method for doing arbitrary translation tables.

The version number is 2.00 rather than the more traditional 0.01, because the
previous HTTP::Headers::UserAgent module had version number 1.00.

=head1 SEE ALSO

perl(1), L<HTTP::Headers>

=cut

1;


