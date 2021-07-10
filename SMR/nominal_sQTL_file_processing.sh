#!/bin/bash

### Shell script to prepare nominal QTLtools output for SMR ###
### It process each chr file individually ###

#Flags:

nom_files_dir="PATH_TO_NOMINAL_FILES"
snp_file_dir="PATH_TO_GWAS_FILE"
out_dir="PATH_TO_OUTPUT_DIR"

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0

for i in $(seq 1 22);
do 
	sbatch -A cphg-millerlab \
               -p parallel \
               -t 2:00:00 \
               --mem=25g \
               -N 4 \
               -n 20 \
               --wrap="Rscript nominal_file_processing.R ${nom_files_dir}/Coronary_Artery_chr${i}_sqtls_nominal.txt.gz \
                                                         ${snp_file_dir}/snps_freq.txt.gz \
                                                         ${out_dir}/Coronary_Artery_chr${i}_sqtls_nominal_modified_for_SMR.txt \
                                                         ${out_dir}/chr${i}_snps_freq_modified.txt "
done

