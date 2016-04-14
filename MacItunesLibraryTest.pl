#!/usr/bin/perl -w

use Mac::iTunes::Library;

sub main() {
  # Assuming a previously created library
  %items = $library->items();
  while (($artist, $artistSongs) = each %items) {
    while (($songName, artistSongItems) = each %$artistSongs) {
      foreach my $item (@$artistSongItems) {
              # Do something here to every item in the library
              print $song->name() . "\n";
	    }
    }
  }
}

main();

# end of file
