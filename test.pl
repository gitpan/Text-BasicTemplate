# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..10\n"; }
END {print "not ok 1\n" unless $loaded;}
use Text::BasicTemplate;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

use Text::BasicTemplate;

my $pp;
my %arg;
@arg{strip_html_comments,strip_c_comments,strip_cpp_comments,strip_perl_comments} =
 (1,1,1,1);
@arg{condense_whitespace,use_cache,simple_ssi,eval_conditionals,eval_subroutine_refs} = (1,1,1,1,1);
$arg{document_root} = '.';
print "not " unless $pp = new Text::BasicTemplate(%arg);
print "ok 1\n";

my $buf = "foo";
print "not " unless $pp->push(\$buf);
print "ok 2\n";
print "not " unless $pp->push(\$buf,"key=value");
print "ok 3\n";

my $strip_comment_buffer = <<"EOT";
C /* C comment */
C++ // C++ comment
sharp \# perl comment
html <!-- html comment -->
EOT
print "not " unless (join(',',split(/\s+/m,$pp->push(\$strip_comment_buffer)))
		       eq 'C,C++,sharp,html');
print "ok 4\n";

my $repl_buffer = "%foo%";
print "not " unless ($pp->push(\$repl_buffer,foo => bar) eq 'bar');
print "ok 5\n";

my $cond_buffer = "%?one==1%true%false% %?one==2%true%false%";
print "not " unless ($pp->push(\$cond_buffer,one => 1) eq 'true false');
print "ok 6\n";

my $fn = "/tmp/test-text_parseprint_$$";
if (open(TESTFILE,">$fn")) {
  print TESTFILE "%foo%";
  close TESTFILE;
  print "not " unless ($pp->push($fn,foo => 'bar') eq 'bar');
  unlink $fn;
} else {
  warn "Couldn't open /tmp/text_parseprint_$$: $!";
  print "not ";
}
print "ok 7\n";

my $subref_buffer = '%snaf% %one%';
print "not " unless $pp->push(\$subref_buffer,
			      snaf => sub { 'u' },
			      one => 2) eq 'u 2';
print "ok 8\n";

print "not " unless $pp->list_cache;
print "ok 9\n";

print "not " unless $pp->purge_cache;
print "ok 10\n";
