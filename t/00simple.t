#!/usr/bin/perl -w
# $Id: 00simple.t,v 1.4 1999/12/20 23:32:39 aqua Exp $

BEGIN { $| = 1; print "1..7\n"; }
END {print "not ok 1\n" unless $loaded;}
use Text::BasicTemplate;
$loaded = 1;
print "ok 1\n";

use strict;

my $bt = new Text::BasicTemplate;
$bt or print "not ";
print "ok 2\n";

my %ov = (
	  'foo' => 'bar',
	  'bar' => 'foo',
	  'numbers' => [ 1, 2, 3 ],
	  'recipe' => { fee => 'fi',
			fo => 'fum',
			bones => 'bread' }
);

my @templates = (
		 [ 'foo=%foo%' => 'foo=bar' ],
		 [ 'numbers=%numbers%' => 'numbers=1, 2, 3' ],
		 [ 'recipe=%recipe%' => 'recipe=fee=fi, fo=fum, bones=bread' ],
		 [ '%foo% %% %bar%' => 'bar % foo' ],
		);


my $tn = 3;
my $parsed;
for (@templates) {
    open(T1,">/tmp/maketest-00simple-$$-$tn.tmpl") || do {
	warn "/tmp/maketest-00simple-$$-$tn.tmpl: $!";
	print "not ok ".($tn+3)."\n";
	next;
    };
    print T1 $_->[0];
    close T1;
    $parsed = $bt->parse("/tmp/maketest-00simple-$$-$tn.tmpl",\%ov);
    if ($parsed ne $_->[1]) {
#	print STDERR "[$parsed] ne [$_->[1]]\n";
	print "not ";
    }
    print "ok ".($tn++)."\n";
}

my $ss = "%x% %y% %z%";
print "not " if $bt->parse(\$ss,
			  { x => 1 },{ y => 2 },{ z => 3}) ne '1 2 3';
print "ok ",$tn++,"\n";
			  
