#!/bin/bash

### Shell script to update missing info from .esi and .epi files ###

#Flags:
main_dir="PATH_TO_MAKE_BEQTL_OUTPUT_FILES"

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0

for i in $(seq 1 22);
do
        sbatch -A cphg-millerlab \
               -p parallel \
               -t 3:00:00 \
               --mem=25g \
               -N 4 \
               -n 20 \
               --wrap="Rscript nominal_sQTL_smr_update-besd.R ${main_dir}/Coronary_Artery_nominal_chr${i}.epi \
                                                              ${main_dir}/Coronary_Artery_nominal_chr${i}.esi \
                                                              ${main_dir}/chr${i}_snps_freq_modified.txt.gz"
done
