library(data.table)
library(stringr)
library(dplyr)
library(Biobase)
library(R.utils)

# Args command
args = commandArgs(T)
sqtl_file = args[1]
snp_file = args[2]
sqtl_output = args[3]
snp_output = args[4]


### Process QTLtools output file. 
## 1-Remove "." and non "rs" rsids.
d = fread(sqtl_file, header = F)
d_filtered = d[!(d$V8 == "."),]
d_filtered = d_filtered[grepl("rs", d_filtered$V8),]

## 2-Inner join filtered QTLtools results with snps_freq.txt.gz for REF, ALT, MAF
f = fread(snp_file, header = T)
f_filtered = data.frame(rsid = f$rsid, REF = f$ref, ALT = f$alt, MAF = f$ref_freq)
snp_join = inner_join(d_filtered, f_filtered, by = c("V8" = "rsid"))

## 3-Make a 14-column df with non-duplicate phenotypes for SMR.
snp_join_filtered = snp_join[!duplicated(snp_join$V1),]
write.table(snp_join[,c(1:12,14,16)], sqtl_output, col.names = F, row.names = F, quote = F, sep = "\t")
gzip(sqtl_output)
snp_join_filtered2 = snp_join[!duplicated(snp_join$V8),]
write.table(snp_join_filtered2[,c(8,17:19)], snp_output, col.names = F, row.names = F, quote = F, sep = "\t")
gzip(snp_output)
