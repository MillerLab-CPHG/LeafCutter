library(data.table)
library(stringr)
library(dplyr)
library(Biobase)
library(R.utils)

# Args command
args = commandArgs(T)
epi_file = args[1]
esi_file = args[2]
snp_file = args[3]

### Update .epi file. (Adds geneID in column 5)
d = fread(epi_file, header = F)
temp1 = str_split_fixed(d$V2, ":", 5)
d$V5 = temp1[,5]

write.table(d, epi_file, col.names = F, row.names = F, quote = F, sep = "\t")



### Update .esi file. (Adds Ref, Alt, and Ref_MAF)
## 1-Join snps_freq_modified.txt.gz with .esi file to update
f = fread(snp_file, header = F)
t = fread(esi_file, header = F)
t$V5 = NULL
t$V6 = NULL
t$V7 = NULL
snp_join = inner_join(t, f, by = c("V2" = "V1"))

write.table(snp_join, esi_file, col.names = F, row.names = F, quote = F, sep = "\t")
