#!/bin/bash
#SBATCH -c 12                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-04:59                         # Runtime in D-HH:MM format
#SBATCH -p short                          # Partition to run in
#SBATCH --mem=64G                          # Memory total in MB (for all cores)
#SBATCH -o hostname_%j.cellsnp-lite.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e hostname_%j.cellsnp-lite.err                 # File to which STDERR will be written, including job ID
#SBATCH --mail-type=ALL                    # Type of email notification- BEGIN,END,FAIL,ALL

# run cellsnp-lite on output of cellranger scRNA-seq library
gunzip -c $1/outs/filtered_feature_bc_matrix/barcodes.tsv.gz | cat > $1/outs/filtered_feature_bc_matrix/barcodes.tsv

cellsnp-lite --genotype -R /home/lp175/snp_reference/genome1K.phase3.SNP_AF5e2.chr1toX.hg38.vcf.gz \
	-s $1/outs/possorted_genome_bam.bam -b $1/outs/filtered_feature_bc_matrix/barcodes.tsv \
	-O $1/outs/cellsnp -p 22 --minMAF 0.1 --minCOUNT 100 --gzip 
