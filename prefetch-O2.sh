#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-11:59                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16GB                          # Memory total in MB (for all cores)
#SBATCH -o hostname_%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e hostname_%j.err                 # File to which STDERR will be written, including job ID
#SBATCH --mail-type=ALL                    # Type of email notification- BEGIN,END,FAIL,ALL

module load sratoolkit/2.10.7

### edit needed - insert the targets from GEO 
# pull data from GEO 
###
prefetch SRR13021191
prefetch SRR13021192
prefetch SRR13021193
prefetch SRR13021194
prefetch SRR13021195

# extract fastq files and compress
for library in SRR*
do
	echo $library
	cd $library
	fastq-dump --split-files ${library}.sra
	pigz *.fastq
	cd ..
done
