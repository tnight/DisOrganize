#!/usr/bin/perl -w

use strict;
use File::Spec;

### my $fileName = "/Volumes/share/terryn/My Documents/My Music/iTunes/iTunes Music/Music/3rd Bass/Pop Goes The Weasel/01 Pop Goes The Weasel (Radio Edit).mp3";
### my $fileName = "/Volumes11/share/terryn/My Documents/My Music/iTunes/iTunes Music/Music/3rd Bass/Pop Goes The Weasel/01 Pop Goes The Weasel (Radio Edit).mp3";
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/*.mp3';
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/03\ Pop\ Goes\ The\ Weasel\ \(Instrumental*.mp3';
### my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/03\ Pop\ Goes\ The\ Weasel\ \(Instrumental*.mp3';
my $fileName = '/Volumes/share/terryn/My\ Documents/My\ Music/iTunes/iTunes\ Music/3rd\ Bass/Pop\ Goes\ The\ Weasel/*.mp3';
print "fileName    = [$fileName]\n";

my (undef, $directories, undef) = File::Spec->splitpath( $fileName );
print "directories = [$directories]\n";

# End of file
