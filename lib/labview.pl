#!/usr/local/gnu/bin/perl
# Contains:
#  labview(%params) - processed the <cd-LabVIEW> tag
# %params comes from getparams($tag)

#"$Log: head.pl,v $
#";
#'CODEBASE="ftp://ftp.ni.com/support/labview/runtime/windows/8.0/English/LVRunTimeEng.exe">

$Header = '$Header: /home/ratbert5/myoder/cd/visible2/support/lib/RCS/head.pl,v 2.3 2000/04/17 21:35:50 myoder Exp myoder $';

require 'htmlscan.pl';
require 'constants.pl';

#==============
# LabVIEW
#==============

sub labview {
local(%params) = @_;
local($debug) = 1;

# Make some global assignments 

$src    = $params{'src'};	# global assignment for all to use.
$width  = $params{'width'} + 25;
$height = $params{'height'} + 50;
$topVI  = $params{'top'};
$topVI =~ s/_/ /g;              # Hack so top paramter can have spaces in it.
# print "topVI=$topVI\n";
$topVI = $src unless $topVI;
$vers   = $params{'vers'};
my $img = "";
$img = "document.write('<img src=$src.png>');" if(-e "$src.png");

# print "labview called with src=$src, topVI=$topVI width=$width and height=$height vers=$vers\n" if $debug;
#
#  Version 8.2 or 8.5
#
if ($vers eq '82') {
	$num = '8.2.1'; $id = 'AE'; $num3 = '82';
}
if ($vers eq '85') {
	$num = '8.5';   $id = 'AF'; $num3 = '85';
}
if ($vers eq '86') {
	$num = '8.6';   $id = 'B0'; $num3 = '86';
}
if ($vers eq '2010') {
	$num = '2010';   $id = 'B0'; $num3 = '';
}
if ($vers eq '2014') {
	$num = '2014';   $id = 'B0'; $num3 = '';
}
if ($vers eq '82' or $vers eq '85' or $vers eq '86') {
# load script to load LabVIEW
  "<a name=\"LabVIEW\"></a>
<script src=\"" . findpath("labview.js") . "\" type=\"text/javascript\">
</script>

<script type=\"text/javascript\">
<!--
/**************************************************/
var VINAME = \"$src\";	/* set this value */
var LLBNAME = \"LabVIEW$num3/builds/$src/$src\";	/* set this value */
var VIWIDTH = $width		/* set this value */
var VIHEIGHT = $height		/* set this value */
/* LLB's Should be uploaded in the format  .win.llb, .mac.llb .linux.llb */
/**************************************************/
"
. doWin()
. doMac()
.
"
} else {  // Not .mac or .win
    document.write('<p>Sorry, but the <b> ' + BrowserDetect.OS.substring(1) + '</b> platform is not supported at this time.</p>');
}

document.write('<a href=http://www.ni.com/academic target=_blank');
document.write('        onClick=\"javascript:urchinTracker (\\'NI Link\\'); \">');

document.write('<br><img align=right src=\"" . findpath('PoweredByLabVIEWh.jpg') . "\" border=0>');
document.write('</a>');

document.write('<a href=\"" . findpath('labview.htm') . "\" target=_blank><font size=-1 color=blue>LabVIEW Tips and Troubleshooting</font></a></font> ');

document.write('<font size=-2 color=gray>(LV$num ' + BrowserDetect.browser + ' ' + BrowserDetect.version + ' ' + BrowserDetect.OS.substring(1) + ' ' + BrowserDetect.OSversion + ')</font><br><a href=\"' + LLBNAME + BrowserDetect.OS + '.llb' + '\">source</a><p/>');
// -->
</script>
";

}

elsif ($vers eq '2014') {
# load script to load LabVIEW
# print "Found $vers\n";
  "<a name=\"LabVIEW\"></a>

<script src=\"" . findpath("labview.js") . "\" type=\"text/javascript\">
</script>

<script type=\"text/javascript\">
<!--

/**************************************************/
var LLBNAME = \"LabVIEW/builds/$src/$src\";	/* set this value */
/**************************************************/
$img
"
. doWin2014()
. doMac()
.
"
} else {  // Not .mac or .win
    document.write('<p>Sorry, but the <b> ' + BrowserDetect.OS.substring(1) + '</b> platform is not supported at this time.</p>');
}

document.write('<a href=http://www.ni.com/academic target=_blank');
document.write('        onClick=\"javascript:urchinTracker (\\'NI Link\\'); \">');

document.write('<br><img align=right src=\"" . findpath('PoweredByLabVIEWh.jpg') . "\" border=0>');
document.write('</a>');

document.write('<a href=\"" . findpath('labview.htm') . "\" target=_blank><font size=-1 color=blue>LabVIEW Tips and Troubleshooting</font></a></font> ');

document.write('<font size=-2 color=gray>(LV$num ' + BrowserDetect.browser + ' ' + BrowserDetect.version + ' ' + BrowserDetect.OS.substring(1) + ' ' + BrowserDetect.OSversion + ')</font><br><a href=\"' + LLBNAME + BrowserDetect.OS + '.llb' + '\">source</a><p/>');
// -->
</script>
";
}

#
#  Default version (8.2)
#
elsif($vers eq '') {
my $border = 1;
if($width == 0) {$border = 0;}
"<table border=\"$border\" bordercolor=\"#000000\"><tr><td>
<object id=\"LabVIEWControl\"
\tclassid=\"CLSID:A40B0AD4-B50E-4E58-8A1D-8544233807AE\"
\twidth=\"$width\" height=\"$height\"
\tcodebase=\"ftp://ftp.ni.com/support/labview/runtime/windows/8.2/LVRunTimeEng.exe\">
<param name=\"SRC\" value=\"LabVIEW/builds/$src/$src.llb\" />
<param name=\"LVFPPVINAME\" value=\"$topVI.vi\" />
<param name=\"REQCTRL\" value=\"true\" />
<param name=\"RUNLOCALLY\" value=\"true\" />
<embed src=\"LabVIEW/builds/$src/$src.llb\"
\tlvfppviname=\"$topVI.vi\" 
\treqctrl=\"true\"
\trunlocally=\"true\"
\ttype=\"application/x-labviewrpvi82\"
\twidth=\"$width\" height=\"$height\"
\tpluginspage=\"http://digital.ni.com/express.nsf/express?openagent&code=exck2m&\">
</embed>
</object>
</td></tr></table>";
} else {
  print("##### Version $vers not known #####\n");
}

}

#==============
# doWin
#==============
# Produces the javascript code needed to server the Windows LabVIEW
# The LabVIEW is delivered in the browser

sub doWin {
"

if(BrowserDetect.OS.search(/.win/) != -1) {
document.write('<object classid=\"CLSID:A40B0AD4-B50E-4E58-8A1D-8544233807$id\" ');
document.write('	codebase=\"ftp://ftp.ni.com/support/labview/localviexec/' + BrowserDetect.PATH + '\" ');
document.write('	width=\"' + VIWIDTH + '\" height=\"' + VIHEIGHT + '\">');

document.write('<param name=\"SRC\" value=\"'+ LLBNAME + BrowserDetect.OS + '.llb\">');
document.write('<param name=\"LVFPPVINAME\" value=\"'+ VINAME + '.vi\">');
document.write('<param name=\"REQCTRL\" value=\"false\">');
document.write('<param name=\"RUNLOCALLY\" value=\"true\">');
document.write('<embed src=\"'+ LLBNAME + BrowserDetect.OS + '.llb\" ');

document.write('	reqctrl=\"true\" runlocally=\"true\" ');
document.write('	type=\"application/x-labviewrpvi$num3\" ');
document.write('	pluginspage=\"http://digital.ni.com/express.nsf/bycode/cnx$num3\" ');
document.write('	lvfppviname=\"'+ VINAME + '.vi\" width=\"' + VIWIDTH + '\" height=\"' + VIHEIGHT + '\">');

document.write('</object>');

";

}

#==============
# doWin2014
#==============
sub doWin2014 {
"

if(BrowserDetect.OS.search(/.win/) != -1) { 
    document.write('<div><p/>Download here: <a href=\"' + LLBNAME + '/$src.exe\">$src.exe</a>');
    document.write('<p/><p/>');

    document.write('If you have not done so already, download the free LabVIEW runtime engine <a href=\"" . findpath('install.htm') . "\" target=_blank>here.</a>');
    document.write('<p/><p/></div>');

";

}

#==============
# doMac
#==============
# Produces the javascript code needed to server the mac LabVIEW
# The LabVIEW is delivered as a file rather than appearing in the browser.
# Check when cd2html is running to see if the app is there.  If not,
# display a "not available" message.

sub doMac {
my($path) = "LabVIEW$num3/builds/$src/$src.mac.zip";
# print("$path\n");

if(-e $path) {
  print("Found $path\n");
"} else if(BrowserDetect.OS.search(/.mac/) != -1) {
    document.write('<div><p/><b>Mac users</b>: Download here: <a href=\"' + LLBNAME + '.mac.zip\">$src.mac.app</a>');
    document.write('<p/><p/>');
    document.write('If you have not done so already, download the free LabVIEW runtime engine <a href=\"" . findpath('install.htm') . "\" target=_blank>here.</a>');
    document.write('<p/><p/></div>');

";

} else {

"} else if(BrowserDetect.OS.search(/.mac/) != -1) {
    document.write('<p>Sorry, but the <b> ' + BrowserDetect.OS.substring(1) + '</b> platform is not supported at this time.</p>');
";
}
}

1;
