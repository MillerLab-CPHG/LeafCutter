library(data.table)
library(R.utils)
library(dplyr)
library(biomaRt)

## Args command
args=commandArgs(T)
coloc_file = args[1]
out_file = args[2]

df1_summary = fread(coloc_file, header = T)

#Run biomart to get gene names
mart = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
ann <- getBM(c("ensembl_gene_id", "external_gene_name", "chromosome_name", "start_position"), "ensembl_gene_id", df1_summary$ensembl_id, mart)
coloc_ann = left_join(df1_summary, ann, by = c("ensembl_id" = "ensembl_gene_id"))

write.table(coloc_ann, out_file, col.names = T, row.names = F, quote = F, sep = "\t")
gzip(out_file)
