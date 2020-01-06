#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use GO;
use Data::Dumper;
my %long_GO_description;

my $GO_desc_file = '/scratch/go-basic.obo';

open( GO_DESC, '<', $GO_desc_file ) or die $!;

$_ = '';
local $/ = /\[Term]|\[Typedef]/;

while ( my $long_GO_desc = <GO_DESC> ) {
	chomp $long_GO_desc;
	my $parsing_regex = qr/((?:[a-z][a-z]+))([:])(\s+)(.*\w)(\n)
                                ((?:[a-z][a-z]+))([:])(\s+)(.*\w)(\n)
                                ((?:[a-z][a-z]+))([:])(\s+)(.*\w)(\n)
                                ((?:[a-z][a-z]+))([:])(\s+)(["])(.*\w)(\.)(["]) /mx;
	my $findAltId = qr/^alt_id:\s+(?<alt_id>.*?)\s+/msx;
	my $findIsa   = qr/^is_a:\s+(?<isa>.*?)\s+!/msx;
	if ( $long_GO_desc =~ /$parsing_regex/ ) {
		my $id        = $4;
		my $name      = $9;
		my $namespace = $14;
		my $def       = join( $19, $20, $21 );
		my $alt_ids   = ();
		while ( $long_GO_desc =~ /$findAltId/g ) {
			$alt_ids = $1;
			push( $alt_ids, $+{alt_id} );
		}
		if ($alt_ids) {
			say join( ",", $alt_ids );
		}
		my @isas = ();
		while ( $long_GO_desc =~ /$findIsa/g ) {
			push( @isas, $+{isa} );
		}
		if (@isas) {
			say join( ",", @isas );
		}
		my $go = GO->new(
			id        => $id,
			name      => $name,
			namespace => $namespace,
			def       => $def,
			alt_ids   => $alt_ids,
			is_as     => @isas
		);
		$long_GO_description{ $go->id() } = $go;
		say Dumper(%long_GO_description);
	}
}
