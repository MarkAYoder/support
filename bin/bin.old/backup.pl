#!/usr/bin/perl
use strict;
use File::Backup("backup");

# my $dir = '/var/www/html/mortgage-broker';
# chdir($dir) or die "Can't chdir to $dir";
# backup(from          => "Phase1.7",
#        to            => "/tmp",
#       );

my $dir = '/auto/';
chdir($dir) or die "Can't chdir to $dir";
backup(from          => "myoder",
       to            => "/tmp",
      );
