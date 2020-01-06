#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

read_blast();

sub read_blast {
	my $blast_file = '/scratch/RNASeq/blastp.outfmt6';
	open( BLAST, '<', $blast_file ) or die $!;
	$_ = '';

	while ( my $transcript_to_protein = <BLAST> ) {
		chomp $transcript_to_protein;
		my $parsing_regex =
		  qr/^(.*?\w)\|(.*?\w)\t(.*?\w)\|(.*?\w)\|(.*?\w)\|(.*?\w)\|(.*?\w)\t
                (.*?\w)\t(.*?\w)\t(.*?\w)\t(.*?\w)\t/msx;

		if ( $transcript_to_protein =~ /$parsing_regex/ ) {
			print STDOUT $1, "\t", $2, "\t", $4, "\t", $6, "\t", $7, "\t", $8,
			  "\t", $9, "\t", $10, "\t", $11, "\n";

		}
		else {
			print STDERR $transcript_to_protein;
		}

	}
}
