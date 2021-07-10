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
		--wrap="QTLtools cis --vcf /PATH_TO_VCF_FILE \
					--bed /PATH_TO_PHENOTYPE_DATA \
					--nominal 1 \
					--window 200000 \
					--std-err \
					--cov /PATH_TO_COVARIATE_FILE \
					--include-covariates /PATH_TO_FILE_OF_COVARIATES_TO_INCLUDE \
					--out /PATH_OUPUT_DIR/PREFIX\
					--region chr${j}"
done
