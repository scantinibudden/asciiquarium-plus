use strict;
use warnings;
use Test::More;

# bad options must die with the usage text before curses takes over the terminal
my @bad = (
	[ '-x',          'unknown flag' ],
	[ '-d nope',     'unknown decoration' ],
	[ '-e soon',     'non-numeric cooldown' ],
	[ '-e -5',       'negative cooldown' ],
	[ '-e 1.5',      'fractional cooldown' ],
);

for my $case (@bad) {
	my ($args, $name) = @$case;
	my $out = `$^X asciiquarium $args 2>&1 </dev/null`;
	isnt($? >> 8, 0, "$name exits non-zero");
	like($out, qr/^usage: /m, "$name prints usage");
}

my $usage = `$^X asciiquarium -x 2>&1 </dev/null`;
like($usage, qr/-d random\|anchor\|castle\|skull\|treasure\b/, 'usage lists every decoration');
like($usage, qr/default random/, 'usage documents the random default');
like($usage, qr/-e seconds/, 'usage documents the event cooldown');

done_testing();
