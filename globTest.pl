#!/usr/bin/perl -w

use strict;


### my $fileName = "/Volumes/share/terryn/My Documents/My Music/iTunes/iTunes Music/Music/3rd Bass/Pop Goes The Weasel/01 Pop Goes The Weasel (Radio Edit).mp3";
### my $fileName = "/Volumes11/share/terryn/My Documents/My Music/iTunes/iTunes Music/Music/3rd Bass/Pop Goes The Weasel/01 Pop Goes The Weasel (Radio Edit).mp3";
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/*.mp3';
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/03\ Pop\ Goes\ The\ Weasel\ \(Instrumental*.mp3';
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/03\ Pop\ Goes\ The\ Weasel\ \(Instrumental*.mp3';
my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/*.mp3';
print "fileName = [$fileName]\n";
my @foo = glob($fileName);
print "foo = \n[", join("]\n[", @foo), "]\n";
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
print "result = [$result], resultText = [$resultText]\n";

# End of file
