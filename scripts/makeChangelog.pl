#!/usr/bin/perl -w

# This is a utility to convert the ChangeLog file to HTML

###################################################################
#
# Some useful definitions
#
###################################################################

# where the CVS tree ChangeLog file is
my $cvsfile = "$ENV{HOME}/cvsemboss/ChangeLog";

# where the web page file is
my $htmlfile = "$ENV{HOME}/sfdoc/developers/changelog.html";


my @headings;	# list of heading titles
my $line;
my $i;
my $count;
my $pre_flag;

open (IN, "< $cvsfile") || die "Can't open $cvsfile\n";
open (OUT, "> $htmlfile") || die "Can't open $htmlfile\n";


# start HTML
print OUT qq|<HTML>

|;

# write warning note
print OUT qq|<!-- 

***                         DO NOT EDIT THIS FILE                        ***
*** IT IS AUTOMATICALLY PRODUCED BY THE EMBOSS SCRIPT 'makeChangelog.pl' ***

-->

|;


# write header stuff
print OUT qq|
<HEAD>
  <TITLE>
  EMBOSS: Change Log
  </TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" text="#000000">

<table align=center border=0 cellspacing=0 cellpadding=0>
<tr><td valign=top>
<A HREF="/index.html" ONMOUSEOVER="self.status='Go to the EMBOSS home page';return true"><img border=0 src="/images/emboss_icon.jpg" alt="" width=150 height=48></a>
</td>
<td align=left valign=middle>
<b><font size="+6">

Change Log

</font></b>
</td></tr>
</table>
<br>&nbsp;
<p>

|;

# parse source for headings
@headings = ();
while ($line = <IN>) {
    if ($line !~ /^\s/) {
	push @headings, $line
    }
}

# write contents list
print OUT qq|<H2>Contents</H2>
<UL>
|;
$count = 0;
foreach $i (@headings) {
    print OUT qq|<LI><A HREF="#$count">$i</A></LI>|;
    $count++;
}
print OUT qq|</UL>
|;

# parse source for text
seek IN, 0, 0;	# go back to start of file

$count = 0;
$pre_flag = 0;
while ($line = <IN>) {

# heading found
    if ($line !~ /^\s/) {
	if ($pre_flag) {
            print OUT qq|</PRE>|;
            $pre_flag = 0;
        }
	print OUT qq|<H2><A NAME="$count">$line</A></H2>|;
        $count++;
        next;
    }

# blank line is a paragraph end
    if ($line =~ /^\s*$/ || $line =~ /^\t*$/) {
	if ($pre_flag) {
            print OUT qq|</PRE>|;
            $pre_flag = 0;
        }
	print OUT qq|<P>|;
        next;
    }

# indent of more than a TAB is the start of a <PRE> block
    if ($line =~ /^\t\s+/ || $line =~ /^\t\t+/) {
        if (! $pre_flag) {
            $pre_flag = 1;
            print OUT qq|<PRE>|;
        }
        print OUT qq|$line|;
        next;
    }

# else just print the line
    if ($pre_flag) {
        print OUT qq|</PRE>|;
        $pre_flag = 0;
    }
    print OUT qq|$line|;

}



# end HTML
print OUT qq|</BODY>
</HTML>
|;

close (OUT);
close (IN);



print "Done.\n";
    