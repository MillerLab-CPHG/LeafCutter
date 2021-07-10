#!/bin/bash

### Shell script to filter QTLtools nominal results file ###

#Flags:
main_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/sQTL_mapping/QTLtools_runs/nominal_analyses/qtltools_finalrun_PCs_Age_Sex"

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0

for i in $(seq 1 22);
do
	sbatch -A cphg-millerlab \
		-p parallel \
		-t 3:00:00 \
		--mem=25g \
		-N 4 \
		-n 20 \
		--wrap="Rscript sqtl_filter.R ${main_dir}/Coronary_Artery_chr${i}_sqtls_nominal.txt.gz \
						${main_dir}/Coronary_Artery_chr${i}_sqtls_nominal_fdr5.txt"
done

