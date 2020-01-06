'''
Created on Dec 7, 2018

@author: user
'''
class Blast(object):
    '''Blast class with transcript ID, SwissProt ID (without
    the version number, and percent identity'''

    def __init__(self, line):
        '''The constructor for the Blast class'''

        self.all_fields = line.rstrip("\n").split("\t")
        self.transcript, self.isoform = self.all_fields[0].split("|")
        self.sseqid = self.all_fields[1].replace('.','|').split("|")
        self.pident = self.all_fields[2]
        self.sp_id = self.sseqid[3]

    #Will return sp_id as a string instead of object location
    def __str__(self):
        return self.sp_id

class Matrix(object):
    '''Matrix class with protein, diauxic shift, heat shock,
    plateau phase, logarithmic growth'''

    def __init__(self, line):
        ''''The constructor for the Matrix class'''

        self.protein, self.sp_ds, self.sp_hs, self.sp_log, \
        self.sp_plat = line.rstrip("\n").split("\t")
        
        #Transcript to protein lookup
        if self.protein in transcript_to_protein:
            self.protein = transcript_to_protein[self.protein]

#Function that will accept a tuple and return it as a tab
#separated string
def tuple_to_tab_sep(tuple):
    return '\t'.join(str(x) for x in tuple)

#Function that will accept a BLAST object and return if the
#percent identity is greater than 95
def filter_by_pident(x):
        iter_blast = map(Blast, blast_file.readlines())
        return(x for x in iter_blast if Blast.pident() > 95)

#opent matrix and blast files
    matrix_file = open('/scratch/RNASeq/diffExpr.P1e-3_C2.matrix', 'r')
blast_file = open('/scratch/RNASeq/blastp.outfmt6', 'r')

#use map to iterate over Blast file
iter_blast = map(Blast, blast_file.readlines())

#use filter to only select elements that meet the
#filter_by_pident() condition
pident_filter = filter(filter_by_pident, iter_blast)

#use blast_filter to load BLAST objects into dict
transcript_to_protein = {x.transcript:x for x in pident_filter}

#use map to iterate over Matrix file
iter_matrix = map(Matrix, matrix_file.readlines())

#print to output file
with open('blast_to_matrix.txt', 'w') as output:
    for matrix in iter_matrix:
        output.write(tuple_to_tab_sep((matrix.protein, matrix.sp_ds, \
        matrix.sp_hs, matrix.sp_log, matrix.sp_plat, "\n")))

#close files
blast_file.close()
matrix_file.close()