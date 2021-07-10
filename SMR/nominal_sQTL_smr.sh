#!/bin/bash

### Shell script to run SMR with nominal QTLtools results ###

#Flags:
bfile_dir="PATH_TO_PLINK_FILES"
gwas_summary_dir="PATH_TO_GWAS_SUM_STATS"
beqtl_summary_dir="PATH_TO_BEQTL_FILES"

for i in $(seq 1 22);
do
        sbatch -A cphg-millerlab \
               -p parallel \
               -t 3:00:00 \
               --mem=25g \
               -N 4 \
               -n 20 \
               --wrap="~/smr_Linux --bfile ${bfile_dir}/UVA_coronary_hg38_merged_imputed_filtered.plink \
                                   --gwas-summary ${gwas_summary_dir}/cad_gwas_smr.txt \
                                   --beqtl-summary ${beqtl_summary_dir}/Coronary_Artery_nominal_chr${i} \
                                   --out ${beqtl_summary_dir}/Coronary_Artery_nominal_chr${i}.smr \
                                   --diff-freq-prop 1 \
                                   --peqtl-smr 1e-5 \
                                   --thread-num 10"
done
