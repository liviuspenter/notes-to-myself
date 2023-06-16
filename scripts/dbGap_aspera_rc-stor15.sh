#!/bin/bash
########################################################
# transfer data to dbGap from rc-stor15.dfci.harvard.edu 
########################################################

# step1:
# download version of aspera compatible with glibc on rc-stor15 from https://www.ibm.com/aspera/connect/
# ibm-aspera-connect-3.11.2.63-linux-g2.12-64.tar.gz
# 
# step2: 
# install aspera connect locally 
# 
# step 3: 
# include ascp executable (.aspera/connect/bin/ascp) in $PATH 
# 
# step4: 
# make sure aspera license is found (needs to be in $HOME/etc/ it seems) 
# ascp -A 
#
# step5: 
# dbGap upload

# export ASPERA_SCP_PASS (XXX is communicated by dbGap curator)
export ASPERA_SCP_PASS=XXX

# directory fastq contains fastq files to be uploaded
ascp -i $HOME/.aspera/connect/etc/aspera_tokenauth_id_rsa -Q -l 1000m -k 1 fastq asp-dbgap@gap-submit.ncbi.nlm.nih.gov:protected

## alternative solution:
## for lots of files this will fail so it's necessary to transfer files using a loop 
#for file in *.gz
#do
#	ascp -i $HOME/.aspera/connect/etc/aspera_tokenauth_id_rsa -Q -l 1000m -k 1 $file asp-dbgap@gap-submit.ncbi.nlm.nih.gov:protected
#done
