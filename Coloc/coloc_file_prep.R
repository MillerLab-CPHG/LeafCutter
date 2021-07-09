library(data.table)
library(stringr)
library(dplyr)
library(R.utils)
library(tidyr)

## Args command
args=commandArgs(T)
sqtl_file = args[1]
snps_file = args[2]
out_file = args[3]

### Process QTLtools output file.
## 1-Remove "." and non "rs" rsids.
d = fread(sqtl_file, header = F)
d_filtered = d[!(d$V8 == "."),]
d_filtered = d_filtered[grepl("rs", d_filtered$V8),]

## 2-Inner join filtered QTLtools results with snps_freq.txt.gz for REF, ALT, MAF
f = fread(snps_file, header = T)
f_filtered = data.frame(rsid = f$rsid, REF = f$ref, ALT = f$alt, MAF = f$ref_freq)
snp_join = inner_join(d_filtered, f_filtered, by = c("V8" = "rsid"))

## 3-Make a df with non-duplicate phenotypes for Coloc. 
write.table(snp_join, out_file, col.names = F, row.names = F, quote = F, sep = "\t")
gzip(out_file)
