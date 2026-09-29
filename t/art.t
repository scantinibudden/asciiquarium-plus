use strict;
use warnings;
use Test::More;

open(my $fh, '<', 'asciiquarium') or die "asciiquarium: $!";
my $src = do { local $/; <$fh> };
close($fh);

my ($table) = $src =~ /my %decorations = \((.*?)\);/s;
my %decorations = $table =~ /(\w+)\s*=>\s*\\&(\w+)/g;
ok(scalar(keys %decorations) >= 4, 'decoration table parsed');

# every decoration's colour mask must sit exactly on its art
for my $name (sort keys %decorations) {
	my $sub = $decorations{$name};
	my ($body) = $src =~ /^sub \Q$sub\E \{\n(.*?)^\}$/ms;
	ok(defined($body), "$name: $sub exists") or next;

	my ($image, $mask) = $body =~ /= q\{\n(.*?)\n\};.*?= q\{\n(.*?)\n\};/s;
	ok(defined($image) && defined($mask), "$name: image and mask found") or next;

	my @image = split /\n/, $image;
	my @mask  = split /\n/, $mask;
	ok(@mask <= @image, "$name: mask is not taller than the image");

	my @problems;
	for my $row (0 .. $#mask) {
		my @m = split //, $mask[$row];
		my @i = split //, (defined($image[$row]) ? $image[$row] : '');
		for my $col (0 .. $#m) {
			next if($m[$col] eq ' ');
			push @problems, "row $row col $col: bad colour '$m[$col]'"
				unless($m[$col] =~ /^[rgybmcwkRGYBMCWK1-9]$/);
			push @problems, "row $row col $col: colour over empty space"
				if(!defined($i[$col]) or $i[$col] eq ' ');
		}
	}
	ok(!@problems, "$name: mask lines up with the image") or diag(join("\n", @problems));
}

# events rotate in the documented order
my ($events) = $src =~ /sub init_random_objects \{.*?return \((.*?)\);/s;
my @order = $events =~ /\\&add_(\w+)/g;
is_deeply(\@order,
	[qw(shark fishhook ship dolphins big_fish ducks monster swan whale)],
	'events rotate in the documented order');

done_testing();
