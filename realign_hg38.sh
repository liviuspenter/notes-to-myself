#!/bin/bash
#SBATCH -c 12                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-23:59                         # Runtime in D-HH:MM format
#SBATCH -p medium                           # Partition to run in
#SBATCH --mem=64G                          # Memory total in MB (for all cores)
#SBATCH -o hostname_%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e hostname_%j.err                 # File to which STDERR will be written, including job ID
#SBATCH --mail-type=ALL                    # Type of email notification- BEGIN,END,FAIL,ALL

module load gcc/6.2.0
module load bowtie2/2.3.4.3

mkdir hg38

for bam_file in *.bam
do
	library=`basename $bam_file .bam`
	echo $library

	# extract fastq files
	#samtools fastq -f 0x2 $bam_file -1 tmp1.fastq -2 tmp2.fastq -@ 12

	gatk SamToFastq --INPUT $bam_file --FASTQ tmp1.fastq --SECOND_END_FASTQ tmp2.fastq

	# alignment against hg38
	bowtie2 -x ../GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index --very-sensitive -p 12 -1 tmp1.fastq -2 tmp2.fastq -S tmp.sam

	# fix mates
	gatk FixMateInformation --INPUT tmp.sam --ADD_MATE_CIGAR true

	# sort aligned reads
	samtools sort tmp.sam -@ 12 > tmp.sorted.sam

	# remove duplicates
	gatk MarkDuplicates -I tmp.sorted.sam -O hg38/${library}.bam --REMOVE_DUPLICATES true --REMOVE_SEQUENCING_DUPLICATES true -M MarkDuplicates.metrics.txt

	cd hg38

	# index file 
	samtools index ${library}.bam

	cd ..

done
