#!/usr/bin/python

import argparse
import pysam

parser = argparse.ArgumentParser()
parser.add_argument('--pos', type=str, required=True, help='position to pileup')
parser.add_argument('--indel',  required=False, help='find indel', action='store_true')
parser.add_argument('--bam', type=str, required=True, help='genome-aligned bam file for processing')
args = parser.parse_args()

chromosome = args.pos.split(':')[0]

if args.indel:
        position = int(args.pos.split(':')[1]) - 2
else:
        position = int(args.pos.split(':')[1]) - 1

coverage = {'A':0, 'T':0, 'C':0, 'G':0}
indels = {}

samfile = pysam.AlignmentFile(args.bam, 'rb',threads=1)
for pileupcolumn in samfile.pileup(chromosome,position,position+1,min_base_quality=10,max_depth=3000000):
        if pileupcolumn.pos==position:
                print("coverage at base %s = %s" % (pileupcolumn.pos, pileupcolumn.n))
                for pileupread in pileupcolumn.pileups:
                        if not pileupread.is_del and not pileupread.is_refskip:
                                coverage[pileupread.alignment.query_sequence[pileupread.query_position]] += 1

                                if pileupread.indel in indels.keys():
                                        indels[pileupread.indel]+=1
                                else:
                                        indels[pileupread.indel]=1

if args.indel:
        print (indels)
else:
        print (coverage)
