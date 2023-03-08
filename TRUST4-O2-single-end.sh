#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-01:59                         # Runtime in D-HH:MM format
#SBATCH -p priority                           # Partition to run in
#SBATCH --mem=16GB                          # Memory total in MB (for all cores)
#SBATCH -o hostname_%j.out                 # File to which STDOUT will be written, including job ID
#SBATCH -e hostname_%j.err                 # File to which STDERR will be written, including job ID
#SBATCH --mail-type=ALL                    # Type of email notification- BEGIN,END,FAIL,ALL

module load gcc/6.2.0
module load bowtie2/2.3.4.3

for library in SRR*
do
        echo $library
        cd $library

        # alignment against hg38
        bowtie2 -x ../../GRCh38/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index --very-sensitive -p 8 ${library}_1.fastq.gz -S tmp.sam

        # sort aligned reads
        samtools sort tmp.sam > tmp.sorted.sam

        # remove duplicates
        gatk MarkDuplicates -I tmp.sorted.sam -O ${library}.bam --REMOVE_DUPLICATES true --REMOVE_SEQUENCING_DUPLICATES true -M MarkDuplicates.metrics.txt

        # index file 
        samtools index ${library}.bam

        # run TRUST4
        /home/lp175/software/TRUST4/run-trust4 \
        -f /home/lp175/software/TRUST4/hg38_bcrtcr.fa \
        --ref /home/lp175/software/TRUST4/human_IMGT+C.fa \
        -b ${library}.bam \
        -o ${library}_TRUST4 \
        -t 8
        cd ..
done

# extract TCR only 
for library in SRR*
do
        echo $library
        cat $library/${library}_TRUST4_cdr3.out | grep TR > ./TCR/${library}_TRUST4_TCR_cdr3.out
done
