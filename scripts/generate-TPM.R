library(biomaRt)
library(tximport)
library(GenomicFeatures)

# output from salmon
files <- list.files(path = './quants/', pattern = 'SRR')
files_import <- paste0('./quants/', files, "/quant.sf")

# mapping of transcripts to genes
txdb <- makeTxDbFromGFF("~/software/GRCh38/gencode.v40.annotation.gtf.gz")
k <- keys(txdb, keytype = "TXNAME")
tx2gene <- ensembldb::select(txdb, k, "GENEID", "TXNAME")

# read salmon output
mat_gse <- tximport(files_import,
                    type = "salmon",
                    tx2gene = tx2gene,
                    ignoreAfterBar = TRUE)

TPM.mat = as.data.frame(mat_gse$abundance)
colnames(TPM.mat) = samples$Run

# get gene names
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
genes = rownames(TPM.mat)
genes = stringr::str_split_fixed(genes, pattern = '\\.', n=2)[,1]
gene_IDs <- getBM(filters= "ensembl_gene_id", attributes= c("ensembl_gene_id","hgnc_symbol"),
                  values = genes, mart= mart)
rownames(gene_IDs) = gene_IDs$ensembl_gene_id

TPM.mat$ensembl_gene_id = rownames(TPM.mat)
TPM.mat$gene = gene_IDs[genes, 'hgnc_symbol']
TPM.mat = TPM.mat[, c('ensembl_gene_id', 'gene', samples$Run)]

write.csv2(TPM.mat, file = './TPM.csv', quote = F)
