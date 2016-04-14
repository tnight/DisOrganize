#!/usr/bin/perl -nw
#
# usage: DisOrganize.pl iTunes\ Library.xml
#

use strict;
use File::Spec;
use URI::Escape;

sub myLog(+@) {
  my $level = shift;
  if ($level eq 'error') {
    print STDERR @_;
  }
  elsif ($level eq 'output') {
    print STDOUT @_;
  }
  else {
    print STDERR "!!! Invalid log level [$level] specified!", @_;
  }
}

sub escapeFileName($;$) {
  my ($fileName, $skipWildcards) = @_;

  if (! $skipWildcards) {
    # If the file name or any directory name leading up to it is
    # "long" (by iTunes XML file format's standards), add a wildcard.
    # We do this first to get an accurate count of string length
    # before we modify the length of the string with substitutions.
    $fileName =~ s|([^/]{35,})/|$1*/|g;
    $fileName =~ s|([^/]{35,})\.mp3|$1*.mp3|g;

    # Handle underscores in directory names and file names. From what
    # I gather, iTunes regards some of the characters that show up in
    # file names as special and replaces them with an underscore (_)
    # in the file name entry of the XML file. Maybe that's because
    # they are treated as special characters in XML? In any case, we
    # need to turn those into wildcards.
    $fileName =~ s{_}{*}g;
  }

  # Escape the HTML entity corresponding to & (&#38;)
  # BASH shell escapes the file name this way:
  # /Volumes/share/terryn/My\ Documents/My\ Music/iTunes/Ben\ Folds/rockin\'\ the\ suburbs/02\ zak\ \&\ sara.mp3
  # Currently this script is escaping it this way:
  # /Volumes/share/terryn/My\ Documents/My\ Music/iTunes/Ben\ Folds/rockin\'\ the\ suburbs/02\ zak\ \&\ sara.mp3
  $fileName =~ s{&#38;}{&}g;

  # Escape the other common 'special' characters
  $fileName =~ s{&}{\\&}g;
  $fileName =~ s{ }{\\ }g;
  $fileName =~ s{,}{\\,}g;
  $fileName =~ s{;}{\\;}g;
  $fileName =~ s{'}{\\'}g;
  $fileName =~ s{`}{\\`}g;
  $fileName =~ s{\(}{\\\(}g;
  $fileName =~ s{\)}{\\\)}g;
  $fileName =~ s{\[}{\\\[}g;
  $fileName =~ s{\]}{\\\]}g;

  return $fileName;
}

sub globExpand($) {
  my ($fileName) = @_;

  my $escapedFileName = escapeFileName($fileName);

  # Check whether the file name inludes a '*' or '&', and if no to
  # both, just return it immediately without globbing.
  if (index($escapedFileName, '*') == -1 && index($escapedFileName, '&') == -1) {
    myLog('error', "escapedFileName = [$escapedFileName], no need to glob so just returning.\n");
    return $fileName;
  }

  myLog('error', "escapedFileName = [$escapedFileName], about to glob...\n");
  my @foo = glob($escapedFileName);
  myLog('error', "foo = \n[", join("]\n[", @foo), "]\n");
  my $result = scalar(@foo);
  my $resultText = '';
  if ($result == 0) {
    $resultText = 'no file found';
  }
  elsif ($result == 1) {
    $resultText = 'file found';
  }
  else {
    $resultText = "$result files found";
  }
  myLog('error', "result = [$result], resultText = [$resultText]\n");

  return ($result > 0) ? @foo : $fileName;
}

sub makeMoveCommand(@) {
  my $destination = pop;
  my @sources = @_;

  my @escapedSources = ();
  foreach my $source (@sources) {
    push(@escapedSources, escapeFileName($source));
  }
  my $escapedDestination = escapeFileName($destination, 'NO_WILDCARDS');
  my (undef, $escapedDestDir, undef) = File::Spec->splitpath($escapedDestination);
  my $comment = '';
  my $moveCommand = '';
  if (index($escapedDestDir, '*') >= 0) {
    $comment = "  # WARNING: destination directory [$escapedDestDir] contains an asterisk!";
  }
  elsif (! -d $escapedDestDir) {
    $moveCommand = "mkdir -pv -m 0700 $escapedDestDir ; ";
  }

  $moveCommand .= "mv -nv " . join(' ', @escapedSources) . ' ' . $escapedDestDir . $comment;
  return $moveCommand;
}

sub findLocations() {
  if (m{<key>location</key>}i) {
    m{<string>(.*?)</string>}i;
    my $location = uri_unescape($1);
    myLog('error', "location = [$location]\n");
    if ($location =~ m{file://localhost(/.*)}i) {
      my $fileName1 = $1;
      my @globbedFileNames1 = globExpand($fileName1);
      my $found1 = -f $globbedFileNames1[0] ? 'true' : 'false';
      # If we found the original file, there is nothing else to do.
      if ($found1 eq 'true') {
        myLog('error', "Found original file [$fileName1] as [", join('][', @globbedFileNames1), "]\n");
      }
      else {
	my $fileName2 = $fileName1;
	$fileName2 =~ s{/iTunes/iTunes Music/Music}{/iTunes};
	my @globbedFileNames2 = globExpand($fileName2);
	my $found2 = -f $globbedFileNames2[0] ? 'true' : 'false';
	if ($found2 eq 'true') {
	  myLog('error', "Original file [$fileName1] *NOT* found; instead found [", join('][', @globbedFileNames2), "].\n");
	  my $destFileName = $globbedFileNames2[0];
          $destFileName =~ s{/iTunes}{/iTunes/iTunes Music/Music};
	  myLog('output', makeMoveCommand(@globbedFileNames2, $destFileName), "\n");
	}
        else {
	  my $fileName3 = $fileName1;
	  $fileName3 =~ s{/iTunes/iTunes Music/Music}{/iTunes/iTunes Music};
	  my @globbedFileNames3 = globExpand($fileName3);
	  my $found3 = -f $globbedFileNames3[0] ? 'true' : 'false';
	  if ($found3 eq 'true') {
	    myLog('error', "Original file [$fileName1] *NOT* found; instead found [", join('][', @globbedFileNames3), "].\n");
	    my $destFileName = $globbedFileNames3[0];
	    $destFileName =~ s{/iTunes/iTunes Music}{/iTunes/iTunes Music/Music};
	    myLog('output', makeMoveCommand(@globbedFileNames3, $destFileName), "\n");
	  }
          else {
	    my $fileName4 = $fileName1;
	    $fileName4 =~ s{/iTunes/iTunes Music/Podcasts}{/iTunes/Podcasts};
	    my @globbedFileNames4 = globExpand($fileName4);
	    my $found4 = -f $globbedFileNames4[0] ? 'true' : 'false';
	    if ($found4 eq 'true') {
	      myLog('error', "Original file [$fileName1] *NOT* found; instead found [", join('][', @globbedFileNames4), "].\n");
	      my $destFileName = $globbedFileNames4[0];
	      $destFileName =~ s{/iTunes/Podcasts}{/iTunes/iTunes Music/Podcasts};
	      myLog('output', makeMoveCommand(@globbedFileNames4, $destFileName), "\n");
	    }
            else {
	      # If we could not find the original file, there is
	      # nothing else to do.
	      myLog('error', "Original file [$fileName1] *NOT* found; did not find a replacement.\n");
	    }
	  }
	}
      }

      # NOTE: File names (before extension) in the iTunes XML file can
      # only be 40 characters long, for example:
      #
      # "/Volumes/share/terryn/My Documents/My Music/iTunes/iTunes Music/Music/3rd Bass/Pop Goes The Weasel/03 Pop Goes The Weasel (Instrumental.mp3"
      # "03 Pop Goes The Weasel (Instrumental.mp3"

      # NOTE: Directory names in the iTunes XML file can only be 40
      # characters long, for example:
      #
      # "APM_ Robert Reich Commentaries from Mark"

    }
  }
}

sub main() {
  findLocations();
}

main();

# End of file
