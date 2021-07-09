#!/bin/bash

### Shell script to run biomart_annotate_coloc.R ###
### It annotates the summary dataset output by coloc ###

#Flags:

coloc_file_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/Coloc/finalrun_PCs_Age_Sex_nominal"

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0

for i in $(seq 2 22);
do
  	sbatch -A cphg-millerlab \
               -p parallel \
               -t 5:00:00 \
               --mem=50g \
               -N 4 \
               -n 20 \
               --wrap="Rscript biomart_annotate_coloc.R ${coloc_file_dir}/Coronary_Artery_chr${i}_nominal_coloc_summary.txt.gz \
                                                        ${coloc_file_dir}/Coronary_Artery_chr${i}_nominal_coloc_summary_annotated.txt"
done
