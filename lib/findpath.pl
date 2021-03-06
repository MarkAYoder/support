# Contains:
# findpath($file, @path) - looks for $file in @path
# relpath($tofile) - finds relative path from current dir to $tofile
# anchor(%params) - returns html for an anchor <a ....> gets parameters
#                   from %params which generated by getparams()
# img(%params) - same as anchor, but for images.

#"$Log: findpath.pl,v $
#Revision 2.3  2000/04/12  20:00:54  myoder
#Still guessing.
#
#Revision 1.20  1997/10/24  16:39:04  myoder
#Added Embedded option in <movie>
#
#Revision 1.18  1997/09/30  17:35:18  myoder
#Commented out a debug message.
#
#Revision 1.17  1997/09/17  22:13:55  myoder
#Hacked anchor to handle onClick=windo.open("this.html".,,).
#so relpath will find the path to this.html.
#Hacked a second argument to relpath.  If 1, relpath will put ""'s around
#the path returned.
#findpath only prints the search path once when it can't find a file.
#
#Revision 1.16  1997/02/28  17:00:49  myoder
#Added plusinspage to <embed> tag.
#
#Revision 1.15  1997/02/27  17:52:58  myoder
#Added <movie> tag.
#
#Revision 1.14  1996/11/12  19:01:13  myoder
#hacked relpath to relpath2 which returns the path from the
#top of the CD structure.
#
#Revision 1.13  1996/06/04  21:08:37  myoder
#Counts number of missing files and only reports the first 10.
#
#Revision 1.12  1996/06/03  17:46:58  myoder
#Added code to findpath and relpath to remove extra ./ in pathes.
#
#Revision 1.11  1995/08/08  17:04:21  myoder
#findpath() will return if the path begins with a /
#
#Revision 1.10  1995/07/06  16:58:22  myoder
#findpath now uses the global variable @path instead of a second parameter.
#relpath simply returns paths that are already relative.
#
#Revision 1.9  1995/06/29  21:46:54  myoder
#Fixed bug:  added & to relpath.
#
#Revision 1.8  1995/06/19  18:26:19  myoder
#Added 1; at the end so it will work with 'require'.
#
#Revision 1.7  1995/06/19  18:16:42  myoder
#*** empty log message ***
#
#Revision 1.6  1995/06/19  18:10:24  myoder
#Fixed comment bug
#
#Revision 1.5  1995/06/01  18:57:57  myoder
#relpath($tofile) now takes only one argument and finds the relative
#path from the current directory.
#If there is no / in $tofile relpath() returns $tofile.
#anchor and img return relative paths.
#anchor and img now use putparams().
#
#Revision 1.4  1995/06/01  16:45:36  myoder
#Changed some comments with % to #
#
#Revision 1.3  1995/06/01  16:43:56  myoder
#Changed comment character to #
#
#Revision 1.2  1995/06/01  16:42:43  myoder
#Changed comment character to #
#
#Revision 1.1  1995/06/01  15:55:20  myoder
#Initial revision
#";
$Header = '$Header: /home/ratbert5/myoder/cd/support/lib/RCS/findpath.pl,v 2.3 2000/04/12 20:00:54 myoder Exp myoder $';

#============
# findpath
#============

sub findpath {
# 
local($file, @path1) = @_;
local($path, $full);
local($debug) = 0;

$_ = $file;

s#/\./#/#g;    # Change /./ to / in pathes
s#^\./##g;     # Remove ./ from the beginning of pathes.
$file = $_;

return $file if(/^\//);	# return if there is a / at the begining
			# of the file name
return $file if(/^http:/);	# return if there is a http: at the begining
			# of the file name
#return $file if(/news/); it's a news reference

foreach $path (@path) {
	$full = $path . "/" . $file;
	print "$full\n" if $debug;
	if(-e $full) {
		return(&relpath($full));
	}
}
return($file) if ($file eq "#");

$missingcount++;
if ($missingcount == 1) {
    print "findpath: Can't find $file in @path\n";
}
elsif ($missingcount < 10) {
    print "findpath: Can't find $file\n";
}
elsif($missingcount == 10) {
    print "More not found";
} else {
    print ".";
}

return($file);
}

#============
# relpath
#============

sub relpath {
# finds a relative path between current directory and tofile

local($tofile, $quot) = @_;
local(@from, @to);
local($debug) = 0;

print "relpath called with $tofile and $quot\n" if $debug;

$_ = $tofile;

s#/\./#/#g;     # Change /./ to /
s#^\./##g;      # Remove ./ from beginning of paths.

$tofile = $_;

#return $tofile if(/[^\/]/);# Don't mess with the file if no /'s.
# return if the path is already relative
if (/^[^\/]/) {
    if($quot) {
	return "\"" .  $tofile . "\"";
    }
    else {
	return $tofile;
    }
}
# return $tofile if /^[^\/]/;

@from = split(/\//, $pwd);
@to   = split(/\//, $tofile);
print "\n@from\n@to\n" if $debug;

while($from[0] eq $to[0] && $#to && $#from) {
	shift(@from);
	shift(@to);
	print "\n@from\n@to\n" if $debug;
}

$count = $#from + 1;
print "count = $count\n" if $debug;
$newpath = "../" x $count . join('/', @to);
print "newpath = $newpath\n" if $debug;

# print "quot = $quot\n";
if($quot) {
    print "Adding quotes\n";
    return("\"" . $newpath . "\"");
}
else {
    return($newpath);
}
}

#============
# relpath2
#============

sub relpath2 {
# finds a relative path between current directory and tofile

local($tofile, $pwd) = @_;
local(@from, @to);
local($debug) = 0;

print "relpath2 called with $tofile\n" if $debug;
print "relpath2 called with $pwd\n" if $debug;

$_ = $tofile;

s#/\./#/#g;     # Change /./ to /
s#^\./##g;      # Remove ./ from beginning of paths.

$tofile = $_;

#return $tofile if(/[^\/]/);# Don't mess with the file if no /'s.
# return if the path is already relative
return $tofile if /^[^\/]/;

@from = split(/\//, $pwd);
@to   = split(/\//, $tofile);
print "\n@from\n@to\n" if $debug;

while($from[0] eq $to[0] && $#to && $#from) {
	shift(@from);
	shift(@to);
	print "\n@from\n@to\n" if $debug;
}

$count = $#from;
print "count = $count\n" if $debug;
$newpath = "../" x $count . join('/', @to[1..$#to]);
print "newpath = $newpath\n" if $debug;
$newpath;

}

#============
# anchor
#============

sub anchor {
local(%params) = @_;
local($tag, @keys, @values);
local($debug) = 0;

# @path is a global variable

@params = %params;
print "anchor: @params\n" if $debug;

$_ = $params{'href'};
if($_) {
	if(/[^\/]/) {
#		$params{'href'} = "\"" . &relpath(&findpath($_)) . "\"";
		$params{'href'} = &relpath(&findpath($_));
		}
	}

$_ = $params{'onclick'};
if($_) {
#    print "found onclick with $_\n";
    s/'(.*.htm)'/&relpath(&findpath($1),1)/e;
    $params{'onclick'} = $_;
#    print "found onclick with $_\n";
	}

$_ = $params{'title'}; # remove <tags> from title
if($_) {
#    print "found title with $_\n";
    if(s/<[^>]*>//g) {
	$params{'title'} = $_;
	print "cd2html: Fixed title with $_\n";
	}
    }

$tag = "<a " . &putparams(%params) . ">";
print "$tag\n" if $debug;
$tag;
}

#============
# img
#============

sub img {
local(%params) = @_;
local($tag, @keys, @values);

# @path is a global variable

$_ = $params{'alt'};	# If no alt tag is given, add one
if(!$_) {
	$params{'alt'} = $params{'src'};
	}

$_ = $params{'src'};
if($_) {
	if(/[^\/]/) {
		$params{'src'} = &relpath(&findpath($_));
		}
	}

$tag = "<img " . &putparams(%params) . " />";

}

#============
# movie
#============

sub movie {
local(%params) = @_;
local($tag, @keys, @values);

# @path is a global variable

# print "Found movie\n";
# Fix the path to the movie source.
$_ = $params{'src'};
if($_) {
	if(/[^\/]/) {
		$params{'src'} = &relpath(&findpath($_));
		}
	}

# Now fix the path to the image source.  If the image source isn't given,
# use the same path as for the movie with .mov changed to gif.
$_ = $params{'imgsrc'};
if($_) {
    delete $params{'imgsrc'};
    $imgsrc = $_;
	if(/[^\/]/) {
		$imgsrc = &relpath(&findpath($_));
		}
} else {
    $imgsrc = $params{'src'};
    $imgsrc =~ s/.mov$/.gif/;
}

# Check to see if the plugin version of the movie exists.
# if so, use it.
# $src  = $params{'src'};
# $srca = $src;
# $srca =~ s/.mov$/a.mov/;

# if(-e  $srca) {
#  $params{'src'} = $srca;
#  }

if(!$opt_e) {
    print "Embedding $src\n";

$tag = "
<video width=\"" . $params{'width'} . "\" height=\"" . $params{'height'} .
  "\" controls>
  <source src=\"" .  $params{'src'} . "\" type=\"video/mp4\">
Your browser does not support the video tag.
</video>
";
# my $parm;
# for $parm (keys %params) {
  # $tag .= "<param name=\"" . $parm . "\" value=\"" . $params{$parm} . "\" />\n";
  # print "parm = $parm\n";
# }
$tag;
}
else {
    print "Not embedding $src\n";
    $tag = "<a href=$srca><img src=$imgsrc></a>\n";
}
}

1;
