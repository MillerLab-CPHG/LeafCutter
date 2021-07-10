#!/bin/bash

### Shell script to run SMR with nominal QTLtools results ###

#Flags:
bfile_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/SMR/plink_files"
gwas_summary_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/GWAS_CAD_loci"
beqtl_summary_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/SMR/finalrun_PCs_Age_Sex_nominal"

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
