#!/usr/local/gnu/bin/perl
#
# pre		--- produced pre-formatted HTML text
#
# Author: Oscar Nierstrasz (June 25, 1993)
# 4.8.93 -- incorporated url'href.

foreach $file (@ARGV) {
	print "<TITLE>Asci file: $file</TITLE>\n<PRE>\n";
	while(<>) {
		study;
		s/&/&amp;/g;
		s/</&lt;/g;
		s/>/&gt;/g;
		&url'href;
		print;
	}
	print "</PRE>\n";
}

# Try to recognize URLs and ftp file indentifiers and convert them into HREFs:
# This routine is evolving.  The patterns are not perfect.
# This is really a parsing problem, and not a job for perl ...
# It is also generally impossible to distinguish ftp site names
# from newsgroup names if the ":<directory>" is missing.
# An arbitrary file name ("runtime.pl") can also be confused.
sub url'href {
	# study; # doesn't speed things up ...

	# to avoid special cases for beginning & end of line
	s|^|>>>|; s|$|<<<|;

	# URLS:
	s|(news:[\w.]+)|<A HREF="$&">$&</A>|g;
	s|(http:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	s|(file:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	s|(ftp:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	s|(wais:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	s|(gopher:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	s|(telnet:[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;
	# s|(\w+://[\w/.:+\-]+)|<A HREF="$&">$&</A>|g;

	# catch some newsgroups to avoid confusion with sites:
	s|([^\w\-/.:@>])(alt\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(bionet\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(bit\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(comp\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(gnu\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(misc\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(news\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;
	s|([^\w\-/.:@>])(rec\.[\w.+\-]+[\w+\-]+)|$1<A HREF="news:$2">$2</A>|g;

	# FTP locations (with directory):
	s|(anonymous@)([a-zA-Z][\w.+\-]+\.[a-zA-Z]{2,}):(\s*)([\w+\-/.]+)|$1<A HREF="file://$2/$4">$2:$4</A>$3|g;
	s|(ftp@)([a-zA-Z][\w.+\-]+\.[a-zA-Z]{2,}):(\s*)([\w+\-/.]+)|$1<A HREF="file://$2/$4">$2:$4</A>$3|g;
	s|([^\w\-/.:@>])([a-zA-Z][\w.+\-]+\.[a-zA-Z]{2,}):(\s*)([\w+\-/.]+)|$1<A HREF="file://$2/$4">$2:$4</A>$3|g;
	# NB: don't confuse an http server with a port number for
	# an FTP location!
	# internet number version:
	s|([^\w\-/.:@])(\d{2,}\.\d{2,}\.\d+\.\d+):([\w+\-/.]+)|$1<A HREF="file://$2/$3">$2:$3</A>|g;

	# just the site name (assume two dots):
	s|([^\w\-/.:@>])([a-zA-Z][\w+\-]+\.[\w.+\-]+\.[a-zA-Z]{2,})([^\w\-/.:!])|$1<A HREF="file://$2">$2</A>$3|g;
	# NB: can be confused with newsgroup names!
	# <site>.com has only one dot:
	s|([^\w\-/.:@>])([a-zA-Z][\w.+\-]+\.com)([^\w\-/.:])|$1<A HREF="file://$2">$2</A>$3|g;

	# just internet numbers:
	s|([^\w\-/.:@])(\d+\.\d+\.\d+\.\d+)([^\w\-/.:])|$1<A HREF="file://$2">$2</A>$3|g;
	# unfortunately inet numbers can easily be confused with
	# european telephone numbers ...

	s|^>>>||; s|<<<$||;
}







