class Blast:
    
    def __init__(self, transcript, sp_id, pident):
        self.transcript = transcript
        self.sp_id = sp_id
        self.pident = pident
    
class Matrix:
    
    def __init__(self, protein, sp_ds, sp_hs, sp_log, sp_plat):
        qseqid, sseqid, pident, *other_fields = blast_hit.rstrip('\n').split('\t')
        transcript = qseqid.split('|')[0]
        sp_id, sp_version = sseqid.split('|')[3].split('.')
        
        self.protein = protein
        self.sp_ds = sp_ds
        self.sp_hs = sp_hs
        self.sp_log = sp_log
        self.sp_plat = sp_plat
        
def parse_blast(blast_hit):
    '''Return transcript and SwissProt IDs without version number'''
    qseqid, sseqid, pident, *other_fields = blast_hit.rstrip('\n').split('\t')
    transcript = qseqid.split('|')[0]
    sp_id, sp_version = sseqid.split('|')[3].split('.')
    return (transcript, sp_id, pident)


