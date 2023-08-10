#!/bin/bash

# run cellsnp-lite on multiple libraries 
# need to edit "SRR*" 

for library in SRR*
do
	sbatch ./cellsnp-lite.sh $library
done
