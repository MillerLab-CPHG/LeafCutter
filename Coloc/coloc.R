library(coloc)
library(data.table)
library(stringr)
library(dplyr)
library(Biobase)
library(R.utils)
library(tidyr)
library(biomaRt)

## Args command
args=commandArgs(T)
coloc_file = args[1]
gwas_file = args[2]
out_file1 = args[3]
out_file2 = args[4]

## Run coloc.signals
x = fread(coloc_file, header = F)
temp1 = str_split_fixed(x$V1, ":", 5)
temp2 = str_split_fixed(temp1[,5], "\\.", 2)
x2 = data.frame(pid = x$V1, chr = x$V2, rsid = x$V8, MAF = x$V19, b = x$V14, se = x$V15, pval = x$V12, gene_id = temp2[,1]) %>% distinct()
x2$varbeta = x2$se^2
x2 = x2[order(x2$pval),]

y = fread(gwas_file, header = T)
y = y[order(y$chr),]

x3 = semi_join(x2, y, by = c("rsid" = "snp"))
gene_list = data.frame(gene_id = x3$gene_id) %>% distinct()

df1_summary = data.frame()
df2_summary = data.frame()
df1_results = data.frame()
df2_results = data.frame()
for (i in 1:length(gene_list$gene_id)) {
  qtl_snps = x3[x3$gene_id == gene_list$gene_id[i],]
  qtl_snps = qtl_snps[order(qtl_snps$pval),]
  qtl_snps = qtl_snps[!duplicated(qtl_snps$rsid),]
  gwas_snps = semi_join(y, qtl_snps, by = c("snp" = "rsid"))
  
  p = coloc.signals(
    dataset1 = list(pvalues = gwas_snps$pval, snp = gwas_snps$snp, N = 296525, type = "cc", s = 0.12, MAF = gwas_snps$MAF, beta = gwas_snps$beta, varbeta = gwas_snps$varbeta),
    dataset2 = list(pvalues = qtl_snps$pval, snp = qtl_snps$rsid, type = "quant", MAF = qtl_snps$MAF, N = 147, beta = qtl_snps$b, varbeta = qtl_snps$varbeta),
    method = c("single"),
    mode = c("iterative"),
    p1 = 1e-04,
    p2 = 1e-04,
    p12= 1e-05,
    maxhits = 3)
  
  df2_summary = data.frame(p$summary, ensembl_id = gene_list$gene_id[i])
  df1_summary = rbind(df1_summary, df2_summary)
  
  df2_results = data.frame(p$results, ensembl_id = gene_list$gene_id[i])
  df1_results = rbind(df1_results, df2_results)
}

write.table(df1_summary, out_file1, col.names = T, row.names = F, quote = F, sep = "\t")
gzip(out_file1)

write.table(df1_results, out_file2, col.names = T, row.names = F, quote = F, sep = "\t")
gzip(out_file2)
