library(data.table)
library(R.utils)
library(stringr)

## Args command
args=commandArgs(T)
sqtl_file = args[1]
out_file = args[2]

df1 = fread(sqtl_file, header = F)
colnames(df1) = c("phe_id", "phe_chr", "phe_from", "phe_to", "phe_strand", "n_var_in_cis", "dist", "rsid", "var_chr", "var_from", "var_to", "npval", "r_squared", "slope", "slope_se", "best_hit")

df1$bh = p.adjust(df1$npval, method="fdr")
sig_df1 = df1[df1$bh <= 0.05,]
#sig_df1 =  df1[df1$npval < (0.05/nrow(df1)),]

write.table(sig_df1, out_file, col.names = F, row.names = F, quote = F, sep = "\t")
gzip(out_file)
