# ref: https://python.omics.wiki/biopython/examples/read-fasta
# modified from the origina script to write multiple output files insteal of a single one

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import os

file_in ='prot_seq_size_test_VRAM.fasta'
output_path = "./output"

for seq_record in SeqIO.parse(open(file_in, mode='r'), 'fasta'):
    # remove .id from .description record (remove all before first space)
    seq_record.description=' '.join(seq_record.description.split()[1:])
    # do something (print or edit seq_record)       
    print('SequenceID = '  + seq_record.id)
    print('Description = ' + seq_record.description + '\n')
    # write new fasta file
    file_out = f"{seq_record.id}.fasta"
    with open(os.path.join(output_path, file_out), 'w') as f_out:
        r=SeqIO.write(seq_record, f_out, 'fasta')
        if r!=1: print('Error while writing sequence:  ' + seq_record.id)