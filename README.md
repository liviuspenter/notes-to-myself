# useful scripts 

## sratoolkit

download data from NCBI GEO on O2 [prefetch-O2.sh](scripts/prefetch-O2.sh)

## dbGap

upload data to dbGap from rc-stor15 with aspera [dbGap_aspera_rc-stor15.sh](scripts/dbGap_aspera_rc-stor15.sh)

## salmon 

gene quantification with salmon tools on paired-end data on O2 [salmon-paired-end-O2.sh](scripts/salmon-paired-end-O2.sh)

gene quantification with salmon tools on single-end data on O2 [salmon-single-end-O2.sh](scripts/salmon-single-end-O2.sh)

create TPM matrix from salmon tools output [generate-TPM.R](scripts/generate-TPM.R)

## TRUST4

run TRUST4 and extract TCR from single-end data on O2 with alignment [TRUST4-O2-single-end.sh](scripts/TRUST4-O2-single-end.sh)

run TRUST4 and extract TCR from paired-end data on O2 without alignment [TRUST4-O2-paired-end.sh](scripts/TRUST4-O2.sh)

## alignment

realign hg19 to hg38 on O2 [realign_hg38.sh](scripts/realign_hg38.sh)

quick hack to quantify single nucleotide polymorphisms or indels [primitive-pileup.py](scripts/primitive-pileup.py)

## mtDNA

loop over directories and perform bulk mtDNA calling using [mgatk](https://github.com/caleblareau/mgatk) [mgatk-bulk-loop.sh](scripts/mgatk-bulk-loop.sh)
