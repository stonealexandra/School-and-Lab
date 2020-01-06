#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

my $gene_to_GO_file = '/scratch/gene_association_subset.txt';
my $blast_file      = '/scratch/RNASeq/blastp.outfmt6';
my $diff_exp_file   = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';
my $GO_desc_file    = '/scratch/go-basic.obo';
my $report_file     = 'report3.txt';

open( GENE_TO_GO, '<', $gene_to_GO_file ) or die $!;

open( BLAST, '<', $blast_file ) or die $!;

open( DIFF_EXP, '<', $diff_exp_file ) or die $!;

open( GO_DESC, '<', $GO_desc_file ) or die $!;

open( REPORT, '>', $report_file ) or die $!;

my %gene_to_GO;

my %GO_to_description;

my %transcript_to_protein;

read_GO_desc();
read_blast();
read_gene_to_GO();
print_report();

close GENE_TO_GO;
close BLAST;
close DIFF_EXP;
close GO_DESC;
close REPORT;

sub read_blast {
	my $qseqid;
	my $protein_id;
	my $identity;
	while (<BLAST>) {
		chomp;

		if ( $_ =~
qr/^(.*?\w)\|(.*?\w)\t(.*?\w)\|(.*?\w)\|(.*?\w)\|(.*?\w)\.(.*?\w)\t(.*?\w)\t/m
		  )
		{
			$qseqid     = $1;
			$protein_id = $6;
			$identity   = $8;
			if ( $identity > 99 ) {
				if ( not exists $transcript_to_protein{$protein_id} ) {
					$transcript_to_protein{$protein_id} = $identity;
					$transcript_to_protein{$qseqid} = $protein_id;
				}

			}
		}
	}
}

sub read_gene_to_GO {
	while (<GENE_TO_GO>) {
		chomp;
		my ( $db, $protein_id, $objectSymbol, $qualifier, $goID ) =
		  split( "\t", $_ );
		$gene_to_GO{$protein_id}{$goID}++;

	}
}

sub read_GO_desc {
	local $/ = '[Term]';
	while (<GO_DESC>) {
		chomp;
		if ( $_ =~
m/((?:[a-z][a-z]+))([:])(\s+)(.*\w)(\n)((?:[a-z][a-z]+))([:])(\s+)(.*\w)/
		  )
		{
			my $goID = $4;
			my $name = $9;
			$GO_to_description{$goID} = $name;
		}
	}
}

sub print_report {
	while (<DIFF_EXP>) {
		chomp;
		my ( $qseqid, $sp_ds, $sp_hs, $sp_log, $sp_plat, $protein_id,
			$protein_description )
		  = split( "\t", $_ );
		$protein_id = $transcript_to_protein{$qseqid} // 'NA';
		my $goID = $gene_to_GO{$protein_id} // 'NA';
		my $counter = 0;
		foreach $goID ( sort keys %{ $gene_to_GO{$protein_id} } ) {
			my $name = $GO_to_description{$goID} // 'NA';
			$counter++;
			if ( $counter == 1 ) {
				$protein_description =
				  get_protein_info_from_blast_DB($protein_id);
				print REPORT $qseqid, "\t", $protein_id, "\t", $goID,
				  "\t", $sp_ds, "\t", $sp_hs, "\t",
				  $sp_log, "\t", $sp_plat,             "\t",
				  $name,   "\t", $protein_description, "\n";
			}
			else {
				print REPORT " ", "\t", " ", "\t", " ", "\t",
				  " ", "\t", " ", "\t", " ", "\t", $goID, "\t", $name, "\n";
			}

		}
	}
}

sub get_protein_info_from_blast_DB {
	my ($protein_id) = @_;
	my $db = '/blastDB/swissprot';
	my $exec =
	    'blastdbcmd -db '
	  . $db
	  . ' -entry '
	  . $protein_id
	  . ' -outfmt "%t" -target_only | ';

	open( SYSCALL, $exec ) or die "Can't open the SYSCALL ", $!;
	my $protein_description = 'NA';
	while (<SYSCALL>) {
		chomp;
		if ( $_ =~ /RecName:\s+(.*)/i ) {
			$protein_description = $1;
		}
	}
	close SYSCALL;
	return $protein_description;
}
