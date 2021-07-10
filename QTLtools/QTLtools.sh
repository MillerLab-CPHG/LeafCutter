#!/bin/bash

#### UVA-CPHG MILLER LAB'S QTLTOOLS PIPELINE ####

#Load qtltools module
module load gcc/7.1.0 qtltools/1.3.1

for j in $(seq 1 22); 
do
	sbatch -A cphg-millerlab \
		-p parallel \
		-t 10:00:00 \
		--mem=25g \
		-N 4 \
		-n 20 \
		--wrap="QTLtools cis --vcf /project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/PCA/UVA_coronary_hg38_merged_imputed_filtered.vcf.gz \
					--bed /project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/sQTL_mapping/Coronary_Artery_sQTL_finalrun/Coronary_Artery.leafcutter.modified.bed.gz \
					--nominal 1 \
					--window 200000 \
					--std-err \
					--cov /project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/sQTL_mapping/Coronary_Artery_sQTL_finalrun/covariates/Coronary_Artery.combined_covariates.txt \
					--include-covariates /project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/sQTL_mapping/QTLtools_runs/nominal_analyses/qtltools_finalrun_PCs_Age_Sex/covariates.txt \
					--out /project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/sQTL_mapping/QTLtools_runs/nominal_analyses/qtltools_finalrun_PCs_Age_Sex/Coronary_Artery_chr${j}_sqtls_nominal.txt.gz \
					--region chr${j}"
done
