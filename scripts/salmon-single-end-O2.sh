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

module load salmon/1.8.0

for library in SRR*
do
	echo $library
	cd $library
	salmon quant -i /n/data2/dfci/medonc/cwu/livius/salmon_hg38/ \
	-l A \
	-r ${library}_1.fastq.gz \
	-p 8 \
	--validateMappings \
	-o ../quants/$library \
	-g /n/data2/dfci/medonc/cwu/livius/gencode.v42.annotation.gff3
	cd ..
done
