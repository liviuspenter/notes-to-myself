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

# run trust4
for library in SRR*
do
	echo $library
	cd $library
	/home/lp175/software/TRUST4/run-trust4 \
	-f /home/lp175/software/TRUST4/human_IMGT+C.fa \
	--ref /home/lp175/software/TRUST4/human_IMGT+C.fa \
	-1 ${library}_1.fastq.gz \
	-2 ${library}_2.fastq.gz \
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
