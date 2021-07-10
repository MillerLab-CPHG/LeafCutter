### The purpose of this script is generating PCs for VCF files using SNPRelate BioConductor package
### Code adapted from https://github.com/zhengxwen/SNPRelate
### If package not installed:

#if (!requireNamespace("BiocManager", quietly=TRUE))
#  install.packages("BiocManager")
#	BiocManager::install("SNPRelate")
# 	BiocManager::install("gdsfmt")
#install.packages("data.table", type = "source", repos = "https://Rdatatable.gitlab.io/data.table")

library(SNPRelate)
library(gdsfmt)
library(data.table)

##VCF file name to read in for GDS filetype conversion: 
vcf.fn <- "PATH_TO_VCF_FILE"

##Convert to GDS using:
snpgdsVCF2GDS(vcf.fn, paste0("gds_QTL_", Sys.Date()), method="biallelic.only")

##Check out the fancy file you've made:
snpgdsSummary(paste0("gds_QTL_", Sys.Date()))

##Get rid of all those totally lame SNPs in LD with each other because that will definitely mess up your PCs in a sample size this small. Start by opening the file:
genofile <- snpgdsOpen(paste0("gds_QTL_", Sys.Date()))

##Next, hit up some sweet LD pruning using whatever parameters you like. 
snpsforpca <- snpgdsLDpruning(genofile, slide.max.bp=500000, remove.monosnp=T, ld.threshold=0.2, autosome.only=T, method="corr")
names(snpsforpca)
head(snpsforpca$chr1)
pcasnp.id <- unlist(unname(snpsforpca))
head(pcasnp.id)

##Then run the actual PCA:
pca <- snpgdsPCA(genofile, snp.id=pcasnp.id, num.thread=4)

### Add in population information
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id")) 
pcaout <- as.data.frame(pca$eigenvect)
new <- t(pcaout)
colnames(new) <- sample.id

write.table(new, "PATH_TO_OUTPUT_DIR/NAME_OF_OUPUT_FILE", sep="\t", row.names=T, col.names=T, quote=F)

