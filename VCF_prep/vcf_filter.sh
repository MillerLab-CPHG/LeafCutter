#!/bin/bash

#prog="vcftools/0.1.16"
vcfdir="PATH_TO_VCF_FILE"
allchrs="--chr chr1 --chr chr2 --chr chr3 --chr chr4 --chr chr5 --chr chr6 --chr chr7 --chr chr8 --chr chr9 --chr chr10 --chr chr11 --chr chr12 --chr chr13 --chr chr14 --chr chr15 --chr chr16 --chr chr17 --chr chr18 --chr chr19 --chr chr20 --chr chr21 --chr chr22"

module load vcftools/0.1.16

sbatch -A "Allocation" \
	-N 2 \
	-n 20 \
	-t 5:00:00 \
	--mem=50g \
	-p parallel \
	--wrap="vcftools --gzvcf ${vcfdir} \
			--recode \
			--remove ./filtered_samples.txt \
			--out ./UVA_coronary_hg38_merged_imputed_filtered \
			--min-alleles 2 \
			--max-alleles 2 \
			--maf 0.01 \
			--remove-indels ${allchrs}"
