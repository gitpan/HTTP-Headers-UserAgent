package HTTP::Headers::UserAgent;

use strict;
use Exporter;
use HTTP::BrowserDetect;

use vars qw( $VERSION @EXPORT_OK $fh %old );

$VERSION = '3.01';

@EXPORT_OK = qw( GetPlatform );

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

  $os = $user_agent->os;

  ( $browser, $version ) = $user_agent->browser;

  #backwards-compatibility with HTTP::Headers::UserAgent 1.00
  $old_platform = HTTP::Headers::UserAgent::GetPlatform $ENV{HTTP_USER_AGENT};

=head1 DESCRIPTION

The HTTP::Headers::UserAgent class represents User-Agent HTTP headers.

This is version 3.00 of the HTTP::Headers::UserAgent class.  It is now
B<depriciated>, and the code is a wrapper around the more well-maintained
HTTP::BrowserDetect module.  You are advised to switch to HTTP::BrowswerDetect.
While the interface provides backward-compatibility with version 1.00, it is
not based on the 1.00 code.

=head1 METHODS

=over 4

=item DumpFile

No-op compatibility method.

=cut

sub DumpFile {
  shift;
}

=item new HTTP_USER_AGENT

Creates a new HTTP::Headers::UserAgent object.  Takes the HTTP_USER_AGENT
string as a parameter.

=cut

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { 'bd' => new HTTP::BrowserDetect(shift) };
  bless( $self, $class);
}


=item string [ HTTP_USER_AGENT ]

If a parameter is given, sets the user-agent string.

Returns the user-agent as an unprocessed string.

=cut

sub string {
  my $self = shift;
  $self->{'bd'}->user_agent(@_);
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

This is the only function which is not yet implemented as a wrapper around
an equivalent function in HTTP::BrowserDetect.

=cut

sub platform {
  my $self = shift;
  for ( $self->{'bd'}{'user_agent'} ) {
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

=item os

Tries to guess the operating system.  Returns irix, win16, win95, win98, 
winnt, win32 (Windows 95/98/NT/?), macos, osf1, linux, solaris, sunos, bsdi,
os2, or unknown.

This is now a wrapper around HTTP::BrowserDetect methods.  Using
HTTP::BrowserDetect natively offers a better interface to OS detection and is
recommended.

=cut

sub os {
  my $self = shift;
  my $os = '';
  foreach my $possible ( qw(
    win31 win95 win98 winnt win2k winme win32 win3x win16 windows
    mac68k macppc mac
    os2
    sun4 sun5 suni86 sun irix
    linux
    dec bsd
  ) ) {
    $os ||= $possible if $self->{'bd'}->$possible();
  }
  $os = 'macos' if $os =~ /^mac/;
  $os = 'osf1' if $os =~ /^dec/;
  $os = 'solaris' if $os =~ /^sun(5$|i86$|$)/;
  $os = 'sunos' if $os eq 'sun4';
  $os = 'bsdi' if $os eq 'bsd';
  $os || 'unknown';
}

=item browser

Returns a list consisting of the browser name and version.  Possible browser
names are:

Netscape, IE, Opera, Lynx, WebTV, AOL Browser, or Unknown

This is now a wrapper around HTTP::BrowserDetect::browser_string

=cut

sub browser {
  my $self = shift;
  my $browser = $self->{'bd'}->browser_string();
  $browser = 'Unknown' unless defined $browser;
  $browser = 'IE' if $browser eq 'MSIE';
  $browser;
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

Ivan Kohler <ivan-useragent@420.am>

Portions of this software were originally taken from the Bugzilla Bug
Tracking system <http://www.mozilla.org/bugs/>, and are reused here with
permission of the original author, Terry Weissman <terry@mozilla.org>.

=head1 COPYRIGHT

Copyright (c) 2001 Ivan Kohler.  All rights reserved.
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 BUGS

Really you should just switch over to the more well-maintained
HTTP::BrowserDetect, which this module is now just a wrapper around.

=head1 SEE ALSO

perl(1), L<HTTP::Headers>, L<HTTP::BrowserDetect>

=cut

1;

