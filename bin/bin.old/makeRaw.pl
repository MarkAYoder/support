#!/usr/bin/perl

use strict;

print "@ARGV\n";

my $file;
foreach $file (@ARGV) {
  if($file =~ s/.csd$//) {
    # Convert the .csd file to a .wav file
    system("pcm_decompressor $file.csd $file.raw");
    system("sox -r 8000 -s -w -v \$(sox -r 8000 -s -w $file.raw -e stat -v 2>&1) $file.raw $file.wav");
    system("sox $file.wav -r8000 -s -w $file.raw");
    # unlink ("$num.csd");
    # unlink ("$num.raw");
  } else {
    print "Skipping $file\n";
  }
}
