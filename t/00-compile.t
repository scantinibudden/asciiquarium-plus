use strict;
use warnings;
use Test::More tests => 1;

my $out = `$^X -c asciiquarium 2>&1`;
like($out, qr/syntax OK/, 'asciiquarium compiles') or diag($out);
