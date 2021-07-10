library(data.table)
library(biomaRt)
library(R.utils)
library(stringr)
library(dplyr)

# Args command
args = commandArgs(T)
smr_file = args[1]
output_file = args[2]

smr = fread(smr_file, header = T)
temp5 = str_split_fixed(smr$Gene, "\\.", 2)
smr$gene_id = temp5[,1]
genes = data.frame(smr$gene_id)
genes = data.frame(gene_id = genes[!duplicated(genes$smr.gene_id),])

mart = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
gene_ann = getBM(c("ensembl_gene_id", "external_gene_name"), "ensembl_gene_id", genes$gene_id, mart)

smr_gene_join = left_join(smr, gene_ann, by = c("gene_id" = "ensembl_gene_id"))


write.table(smr_gene_join, output_file, col.names = T, row.names = F, quote = F, sep = "\t")
gzip(output_file)
