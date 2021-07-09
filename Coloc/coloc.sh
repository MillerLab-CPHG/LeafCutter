#!/bin/bash

### Shell script to run coloc with nominal QTLtools output ###
### It uses the output from coloc_file_processing.R and gwas cad data ###

#Flags:

coloc_file_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/Coloc/finalrun_PCs_Age_Sex_nominal"
gwas_file_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/GWAS_CAD_loci"

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0

for i in $(seq 1 22);
do 
        sbatch -A cphg-millerlab \
               -p parallel \
               -t 5:00:00 \
               --mem=25g \
               -N 4 \
               -n 20 \
               --wrap="Rscript coloc.R ${coloc_file_dir}/Coronary_Artery_chr${i}_sqtls_nominal_modified_for_coloc.txt.gz \
                                                         ${gwas_file_dir}/cad_gwas.txt.gz \
                                                         ${coloc_file_dir}/Coronary_Artery_chr${i}_nominal_coloc_summary.txt \
                                                         ${coloc_file_dir}/Coronary_Artery_chr${i}_nominal_coloc_results.txt"
done
