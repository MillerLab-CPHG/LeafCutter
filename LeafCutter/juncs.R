library(data.table)
library(stringr)

x1 = data.frame()
for (i in 1:9) {
	x2 = data.frame(address = paste0("\"/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/junc_files/gzipped_filtered_junc/UVA00",i,".junc.gz\","))
	x1 = rbind(x1, x2)
}

x3 = data.frame()
for (j in 10:99) {
	x4 = data.frame(address = paste0("\"/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/junc_files/gzipped_filtered_junc/UVA0",j,".junc.gz\","))
	x3 = rbind(x3, x4)
}

x5 = data.frame()
for (p in 100:176) {
	x6 = data.frame(address = paste0("\"/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/junc_files/gzipped_filtered_junc/UVA",p,".junc.gz\","))
	x5 = rbind(x5, x6)
}

x = rbind(x1, x3, x5)

x = x[-c(11,13,27,35,37,42,49,56,77,89:93,97,105,114,137,142,143,151,158,159,162,166,169,171:173),]

write.table(x, "juncfiles3.txt", col.names = F, row.names = F, quote = F)
