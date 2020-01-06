'''
Created on Nov 10, 2018

@author: user
'''
import re

class GoTerms(object):

    def __init__(self, record):
        fields = re.search(r'''
                           id:\s+(?P<id>.*?)\n
                           name:\s+(?P<name>.*?\n)
                           namespace:\s+(?P<namespace>.*?\n)
                           ''', record, re.X)
        #is_as = re.search(r'^is_a:\s+(.*?\n)', record, re.M)

        if fields:
            self.id = fields.group(1)
            self.name = fields.group(2)
            self.namespace = fields.group(3)
            self.is_as = re.findall(r'^is_a:\s+(.*?\n)', record, re.M)

        else:
            self.id = None

    def print_all(self):
        if self.id:
            self.go_fields = self.namespace + '\t' + self.name + '\t'
            for is_a in self.is_as:
                self.go_fields += is_a + '\t'
            print(self.id + '\t' + self.go_fields)

#split_records
def split_records(go_file):
    with open(go_file) as f:
        go_records = f.read()
        go_split_records = re.findall(r'\[Term\](.*?\n)\n', go_records, re.DOTALL)

        for go_record in go_split_records:
            go = GoTerms(go_record)
            go.print_all()

split_records('/scratch/go-basic.obo')



#create new_set class for set in order to write to
#output file with desired format since __str__
#returns a string suitable to end users
class new_set(set):
    def __str__(self):
        spaces = '\n\t\t'
        return spaces.join([str(i) for i in self])
    
output.write(protein_id + '\t' + str(go) + '\n\t\t' + str(new_set(terms)) + '\n')