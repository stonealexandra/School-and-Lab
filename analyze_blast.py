'''
Created on Oct 17, 2018

@author: Alexandra Stone
'''

output = open("blast_analysis.txt", "w")


def get_match(blast_file):
    for line in blast_file:
        replace_lines = line.replace("|", "\t")
        split_lines = replace_lines.split('\t')
        transcriptID = split_lines[0]
        isoform = split_lines[1]
        swissProtID = split_lines[5]
        percentIdentical = split_lines[7]
        if float(percentIdentical) == 100.00:
            output.write(percentIdentical + "\t" + transcriptID + " is a perfect match for " + swissProtID + "\n")
        elif 100.00 > float(percentIdentical) > 75.00:
            output.write(percentIdentical + "\t" + transcriptID + " is a good match for " + swissProtID + "\n")
        elif 75.00 > float(percentIdentical) > 50.00:
            output.write(percentIdentical + "\t" + transcriptID + " is a fair match for " + swissProtID + "\n")
        else:
            output.write(percentIdentical + "\t" + transcriptID + " is a bad match for " + swissProtID + "\n")


with open('/scratch/RNASeq/blastp.outfmt6') as f:
    get_match(f)



output.close()
