#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use GO;
use Data::Dumper;

#hash to store Go objects
my %GO_terms;

#instantiate one go object
my $go = GO->new (id => 'GO:000001', name => 'mitochondrion inheritance', namespace => 'biological_process',
	def =>
'"The maintenance of the structure and integrity of the mitochondrial genome; includes replication and segregation
 of the mitochondrial chromosome." [GOC:ai, GOC:vw]',
	is_as =>	  'GO:0007005 ! mitochondrion organization');

#add object to hash with its id attribute as the key and the entire object as the value
$GO_terms{$go->id()} = $go;

say Dumper(%GO_terms);

