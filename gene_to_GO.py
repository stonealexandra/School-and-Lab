'''
Created on Nov 1, 2018

@author: user
'''

import re

def parse_record(record):
    '''Parse record and return id and is_a'''
    fields = re.search(r'''
                    id:\s+(?P<id>.*?)\n
                    name:\s+(?P<name>.*?\n)
                    namespace:\s+(?P<namespace>.*?\n)
                    ''', record, re.X)

    id = fields.group('id')
    name = fields.group('name')
    namespace = fields.group('namespace')
    is_a = re.findall(r'^is_a:\s+(.*?)\s', record, re.M)
    return (id, is_a)

def split_file(input_file='/scratch/go-basic.obo'):
    '''Split GO terms file into individual records and return as a list.'''
    go_file = open(input_file)
    go_terms = go_file.read()
    go_file.close()
    split_terms = re.findall(r'\[Term\](.*?\n)\n', go_terms, re.DOTALL)
    return split_terms

def go_terms_info():
    ''''create dict of go_id and isas (child and parents)'''
    go_dict = {}
    go_terms = split_file()
    for term in go_terms:
        go_id, isas = parse_record(term)
        if go_id:
            go_dict[go_id] = isas
    return go_dict
#call the go_terms_info function to get dict
GO_dict = go_terms_info()

def get_parents_rec(term):
    '''create a list of parents'''
    #create a single list
    result = [term]
    #look up the parents of that list
    parents = GO_dict.get(term, [])
    for parent in parents:
        #add children to the list
        result.extend(get_parents_rec(parent))
    return result

def map_protein_to_go():
    '''map protein id to all its GO terms '''
    protein_dict = {}
    for line in protein:
        fields = line.rstrip('\n').split('\t')
        protein_id = fields[1]
        go_terms = fields[4]
        if protein_id not in protein_dict:
            protein_dict[protein_id] = []
        protein_dict[protein_id].append(go_terms)
    return protein_dict

with open('/scratch/gene_association_subset.txt') as protein, \
    open('gene_go.txt', 'w') as output:
    #call on the mapping function
    mapped_dict = map_protein_to_go()
    for protein_id, go_terms in sorted(mapped_dict.items()):
        #create a set of go_terms so they are not repeated
        set_go_terms = set(go_terms)
        #create a dict to hold child and parents
        parent_child_dict = {}
        for go in set_go_terms:
            terms = get_parents_rec(go)
            parent_child_dict[go] = terms
            output.write(protein_id + '\t' + str(go) + '\t' + str(set(terms)) + '\n')
        
        