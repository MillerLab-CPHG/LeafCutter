#!/bin/bash

### Shell script to run SMR make-besd with nominal QTLtools results ###
### It runs every chr output file individually ###

#Flags:
nom_files_dir="PATH_TO_NOMINAL_FILES"

for i in $(seq 1 22);
do
	sbatch -A cphg-millerlab \
               -p parallel \
               -t 3:00:00 \
               --mem=25g \
               -N 4 \
               -n 20 \
               --wrap="~/smr_Linux --eqtl-summary ${nom_files_dir}/Coronary_Artery_chr${i}_sqtls_nominal_modified_for_SMR.txt.gz \
                                   --qtltools-nominal-format \
                                   --make-besd \
                                   --out ${nom_files_dir}/Coronary_Artery_nominal_chr${i}"
done
